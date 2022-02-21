component accessors="true" singleton {

	property name="utilService" inject="utilService";
	property name="dbGateway" inject="dbGateway";
    property name="aws" inject="aws@awscfml";

    public struct function getTables(required string name, required string type) {
        var output = {};

        switch(arguments.type) {
            case "aws-dynamodb":
                local.tableInfo = aws.dynamodb.listTables();
                local.tables = local.tableInfo.data.tableNames;

                output.key = "name";
                output.tables = [];
                for (var table in local.tables) {
                    var tableStruct = {
                        "name": table
                    };
                    arrayAppend(output.tables, tableStruct);
                }

                break;
            case "MySQL":
            case "Other":
                local.qResults = dbGateway.getMySqlTables(arguments.name);
                output.tables = utilService.queryToArray(local.qResults);
                output.key = "Tables_in_#arguments.name#"

                break;
            default:
                break;
        }

		return output;
    }

    public array function getTableDetail(
        required string driver
        , required string source
        , required string table) {
        var output = [];

        switch(arguments.driver) {
            case "aws-dynamodb":
                local.tableInfo = aws.dynamodb.describeTable(arguments.table);
                local.tableScan = aws.dynamodb.scan(tableName=arguments.table);
                local.tableFieldSample = local.tableScan.data.items[1];
                local.pKeys = local.tableInfo.data.table.attributeDefinitions;
                local.sKeys = [];

                local.keysRemain = true;
                local.nextKey = {};
                local.payments = [];
                while(local.keysRemain) {
                    local.preffyPayments = aws.dynamodb.scan(
                        tableName=arguments.table
                        , exclusiveStartKey = local.nextKey);

                    if (arrayLen(local.preffyPayments.data.items)) {
                        for (var item in local.preffyPayments.data.items) {
                            arrayAppend(local.payments, item);
                        }
                    }

                    if (structKeyExists(local.preffyPayments.data, "lastEvaluatedKey")) {
                        local.nextKey = local.preffyPayments.data.lastEvaluatedKey;
                    } else {
                        local.keysRemain = false;
                    }
                }

                if (structKeyExists(local.tableInfo.data.table, "globalSecondaryIndexes") && arrayLen(local.tableInfo.data.table.globalSecondaryIndexes)) {
                    for (var secondaryIndex in local.tableInfo.data.table.globalSecondaryIndexes) {
                        if (arrayLen(secondaryIndex.keySchema)) {
                            for (var sKey in secondaryIndex.keySchema) {
                                arrayAppend(local.sKeys, sKey);
                                for (var i = 1; i <= arrayLen(local.pKeys); i++) {
                                    if (local.pKeys[i].attributeName == sKey.attributeName) {
                                        arrayDeleteAt(local.pKeys, i);
                                    }
                                }
                            }
                        }
                    }
                }

                for (var fieldKey in local.tableFieldSample) {
                    //Setting default to empty here since it should be applied as part of column details
                    local.default = "";
                    //DynamoDB does not auto increment primary keys
                    local.extra = "";
                    for (var sKey in local.sKeys) {
                        if (fieldKey == sKey.attributeName) {
                            local.extra = "Secondary Key";
                        }
                    }
                    local.key = "";
                    if (fieldKey == local.pKeys[1].attributeName) {
                        local.key = "PRI";
                    }
                    local.type = utilService.determineType(local.tableFieldSample[fieldKey]);

                    local.fieldStruct = {
                        "default": local.default
                        , "extra": local.extra
                        , "field": fieldKey
                        , "key": local.key
                        , "null": "NO"
                        , "type": local.type
                    };

                    arrayAppend(output, local.fieldStruct);
                }
                break;
            case "MySQL":
            case "Other":
                local.qDetail = dbGateway.getMySqlTableDetail(arguments.source, arguments.table);
                output = utilService.queryToArray(local.qDetail);
                break;
            default:
                break;
        }

		return output;
    }

    public array function getColumnDetail(required array tableDetail, required string type) {
        var output = [];

        for (var column in arguments.tableDetail) {
            if (arguments.type != "all") {
                if (column.key != "PRI" && arguments.type == "primary") {
                    continue;
                }
                if (column.key == "PRI" && arguments.type == "remainder") {
                    continue;
                }
            }

            local.cfsqltype = "CF_SQL_VARCHAR";
            local.fieldType = "text";
            local.simpleType = "string";
            local.default = '''''';
            if (findNoCase("bit", column.type)) {
                local.fieldType = "checkbox";
            }
            if (findNoCase("date", column.type)) {
                local.cfsqltype = "CF_SQL_DATE";
            }
            if (findNoCase("datetime", column.type)) {
                local.cfsqltype = "CF_SQL_TIMESTAMP";
            }
            if (findNoCase("int", column.type)) {
                local.cfsqltype = "CF_SQL_INTEGER";
                local.simpleType = "numeric";
                local.default = 0;
            }
            if (findNoCase("decimal", column.type)) {
                local.cfsqltype = "CF_SQL_DECIMAL";
                local.simpleType = "numeric";
                local.default = 0;
            }
            if (findNoCase("float", column.type)) {
                local.cfsqltype = "CF_SQL_FLOAT";
                local.simpleType = "numeric";
                local.default = 0;
            }
            if (findNoCase("tinyint", column.type)) {
                local.cfsqltype = "CF_SQL_TINYINT";
                local.simpleType = "numeric";
                local.default = 0;
            }
            if (findNoCase("varchar", column.type) && findNoCase("000", column.type)) {
                local.fieldType = "textarea";
            }

            local.friendlyName = "";
            local.wasPreviousUppercase = true;
            local.nameArray = listToArray(column.field, "");
            for (var letter in nameArray) {
                if (asc(letter) >= 65 && asc(letter) <= 90) {
                    if (local.wasPreviousUppercase) {
                        local.friendlyName &= letter;
                    } else {
                        local.friendlyName &= " " & letter;
                    }
                    local.wasPreviousUppercase = true;
                } else {
                    local.friendlyName &= letter;
                    local.wasPreviousUppercase = false;
                }
            }

            var outputStruct = {
                "field": column.field
                , "fieldType": local.fieldType
                , "isNull": column.null == "NO" ? false : true
                , "default": local.default
                , "type": uCase(column.type)
                , "key": column.key
                , "extra": column.extra
                , "simpleType": local.simpleType
                , "cfsqltype": local.cfsqltype
                , "friendlyName": trim(local.friendlyName)
            };

            arrayAppend(output, outputStruct);
        }

        return output;
    }

}