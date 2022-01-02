component accessors="true" singleton {

	property name="utilService" inject="utilService";
	property name="dbGateway" inject="dbGateway";

    public query function getTables(required string type, required string name) {
        var output = queryNew("");

        switch(arguments.type) {
            case "MySQL":
            case "Other":
                output = dbGateway.getMySqlTables(arguments.name);
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
                , "type": column.type
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