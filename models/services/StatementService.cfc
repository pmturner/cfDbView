component accessors="true" singleton {

	property name="utilService" inject="utilService";
	property name="tab" inject="coldbox:setting:tab";
	property name="nl" inject="coldbox:setting:nl";

	public struct function getStatementsByType(
		required string type
		, required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail) {
		var output = {};

		switch(arguments.type) {
			case "aws-dynamodb":
				output = [
					"service": {
						"order": 1
						, "name": "Generic AWS Service"
						, "output": generateAwsService()
					}
				];
				break;
			case "mysql":
			default:
				output = [
					"service": {
						"order": 1
						, "name": "Generic Service Script"
						, "output": generateService(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"gateway": {
						"order": 2
						, "name": "Generic Gateway Script"
						, "output": generateGateway(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"validation": {
						"order": 2
						, "name": "Generic Validation Call"
						, "output": generateValidationCall(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"create":  {
						"order": 3
						, "name": "Create Table"
						, "output": generateCreate(arguments.table, arguments.columnDetail)
					},
					"selectAll":  {
						"order": 4
						, "name": "Select All"
						, "output": generateSelectAll(arguments.datasource, arguments.table, arguments.columnDetail)
					},
					"select": {
						"order": 5
						, "name": "Select"
						, "output": generateSelect(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail)
					},
					"insert": {
						"order": 6
						, "name": "Insert"
						, "output": generateInsert(
							arguments.datasource
							, arguments.table
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"update": {
						"order": 7
						, "name": "Update"
						, "output": generateUpdate(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"init": {
						"order": 8
						, "name": "Init Script"
						, "output": generateInit(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail)
					},
					"saveDetailed": {
						"order": 9
						, "name": "Detailed Script Save"
						, "output": generateSave(
							arguments.datasource
							, arguments.table
							, arguments.columnDetail
							, arguments.primaryDetail
							, arguments.remainderDetail)
					},
					"form": {
						"order": 10
						, "name": "HTML Form"
						, "output": generateForm(arguments.remainderDetail)
					},
					"table": {
						"order": 11
						, "name": "HTML Table"
						, "output": generateTable(arguments.columnDetail)
					},
					"entity": {
						"order": 12
						, "name": "CommandBox Entity"
						, "output": generateEntity(
							arguments.table
							, arguments.primaryDetail
							, arguments.remainderDetail)
					}
				];
				break;
		}

		return output;
	}

	private string function generateCreate(required string table, required array columnDetail) {
		var pKey = "";
		var uqKey = [];
		var counter = 1;
		var output = "";

		output = "CREATE TABLE `#arguments.table#` (";

		for (var column in arguments.columnDetail) {
			local.null = column.isNull ? "NULL" : "NOT NULL";
			local.default = len(column.default) ? " DEFAULT " & column.default : " DEFAULT ''";
        	local.extra = len(column.extra) ? " " & ucase(column.extra) : "";

			if (column.key EQ "PRI") {
				pKey = column.field;
			}
			if (column.key EQ "UNI") {
				arrayAppend(uqKey, column.field);
			}
			if (column.key EQ "PRI" OR column.isNull NEQ "NO") {
				local.default = "";
			}

			output &= "#nl##tab#`#column.field#` #column.type# #local.null##local.extra##local.default#,";

			counter++;
		}

	    output &= "#nl##tab#PRIMARY KEY (`#pKey#`)";
		if (arrayLen(uqKey)) {
			output &= ",";
		}

		counter = 1;

		for (var key in uqKey) {
        	output &= "#nl##tab#UNIQUE KEY `Uidx_#arguments.table#_#key#` (`#key#`)";
			if (counter != arraylen(uqKey)) {
				output &= ",";
			}
			counter++;
		}

		output &= "#nl#);"

		return output;
	}

	private string function generateSelectAll(
		required struct datasource
		, required string table
		, required array columnDetail
		, boolean doubleTab=false) {

		var output = "";
		var counter = 1;
		local.tab = tab;
		if (arguments.doubleTab) {
			local.tab = tab & tab;
		}

		output &= '<cffunction name="loadAll" returntype="array" output="false">';
		output &= '#nl##tab#<cfquery name="local.qLoadAll" returntype="array">';
        output &= '#nl##tab##chr(9)#SELECT';
		for (var column in arguments.columnDetail) {
			output &= '#nl##tab##chr(9)##chr(9)#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field#';
			counter++;

		}
		output &= '#nl##tab##chr(9)#FROM';
		output &= '#nl##tab##chr(9)##chr(9)##arguments.table#;';
        output &= '#nl##tab#</cfquery>';
        output &= '#nl##nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '<cfreturn local.qLoadAll />#nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '</cffunction>';

		return output;
	}

	private string function generateSelect(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, boolean doubleTab=false) {

		var output = "";
		var counter = 1;
		local.tab = tab;
		if (arguments.doubleTab) {
			local.tab = tab & tab;
		}

		output &= '&lt;cffunction name="load" returntype="query" output="false"&gt;';
        output &= '#nl##tab#&lt;cfargument name="#arguments.primaryDetail.field#" type="#arguments.primaryDetail.simpleType#" required="true" /&gt;';
		output &= '#nl##nl##tab#&lt;cfquery name="local.qLoad"&gt;';
        output &= '#nl##tab##chr(9)#SELECT';
		for (var column in arguments.columnDetail) {
			output &= '#nl##tab##chr(9)##chr(9)#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field#';
			counter++;

		}
		output &= '#nl##tab##chr(9)#FROM';
		output &= '#nl##tab##tab##chr(9)##arguments.table#';
		output &= '#nl##tab##chr(9)#WHERE';
		output &= '#nl##tab##tab##chr(9)##arguments.primaryDetail.field# = <cfqueryparam cfsqltype="#arguments.primaryDetail.cfsqltype#" value="##arguments.#arguments.primaryDetail.field###" />;';
        output &= '#nl##tab#&lt;/cfquery&gt;';

        output &= '#nl##nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '&lt;cfreturn local.qLoad /&gt;#nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '&lt;/cffunction&gt;';

		return output;
	}

	private string function generateInsert(
		required struct datasource
		, required string table
		, required struct primaryDetail
		, required array remainderDetail
		, boolean doubleTab=false) {

		var output = "";
		var counter = 1;
		var objName = "q#primaryDetail.field#";
		if (right(objName, 2) == "ID") {
			objName = left(objName, len(objName) - 2);
		}
		local.tab = tab;
		if (arguments.doubleTab) {
			local.tab = tab & tab;
		}

		output &= '&lt;cffunction name="insertRecord" returntype="numeric" output="false"&gt;';
		output &= '#nl##tab#&lt;cfargument name="#objName#" type="any" required="true" /&gt;';
		output &= '#nl##nl##tab#&lt;cfquery result="local.qInsert" datasource="#arguments.datasource.name#"&gt;';
        output &= '#nl##tab##chr(9)#INSERT INTO #arguments.table# (';

		for (var column in arguments.remainderDetail) {
			output &= '#nl##tab##chr(9)##chr(9)#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field#';
			counter++;
		}

		output &= '#nl##tab##chr(9)#) VALUES (';
		counter = 1;
		for (var column in arguments.remainderDetail) {
			output &= '#nl##tab##chr(9)##chr(9)#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '&lt;cfqueryparam cfsqltype="#column.cfsqltype#" value="##arguments.#objName#.#column.field###"';

			if (findNoCase("varchar", column.type)) {
				local.max = replace(replaceNoCase(column.type, "varchar(", ""), ")", "");
				output &= ' maxlength="#local.max#" /&gt;';
			} else {
				output &= ' /&gt;';
			}

			counter++;
		}

		output &= '#nl##tab##chr(9)#);';
        output &= '#nl##tab#&lt;/cfquery&gt;';
		output &= '#nl##nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '&lt;cfreturn local.qInsert.generatedKey /&gt;#nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
    	output &= '&lt;/cffunction&gt;';

		return output;
	}

	private string function generateUpdate(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail
		, boolean doubleTab=false) {

		var output = "";
		var counter = 1;
		var objName = "q#primaryDetail.field#";
		if (right(objName, 2) == "ID") {
			objName = left(objName, len(objName) - 2);
		}
		local.tab = tab;
		if (arguments.doubleTab) {
			local.tab = tab & tab;
		}

		output &= '&lt;cffunction name="updateRecord" returntype="numeric" output="false"&gt;';
		output &= '#nl##local.tab#&lt;cfargument name="#objName#" type="any" required="true" /&gt;';

		output &= '#nl##nl##local.tab#&lt;cfquery name="local.qInsert" datasource="#arguments.datasource.name#"&gt;';
        output &= '#nl##local.tab#';
		if (!arguments.doubleTab) {
			output &= local.tab;
		} else {
			output &= chr(9);
		}
		output &= 'UPDATE #arguments.table#';
		output &= '#nl##local.tab#';
		if (!arguments.doubleTab) {
			output &= local.tab;
		} else {
			output &= chr(9);
		}
        output &= 'SET';

		for (var column in arguments.remainderDetail) {
			output &= '#nl##local.tab##local.tab#';
			if (!arguments.doubleTab) {
				output &= local.tab;
			}
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field# = &lt;cfqueryparam cfsqltype="#column.cfsqltype#" value="##arguments.#objName#.#column.field###"';

			if (findNoCase("varchar", column.type)) {
				local.max = replace(replaceNoCase(column.type, "varchar(", ""), ")", "");
				output &= ' maxlength="#local.max#" /&gt;';
			} else {
				output &= ' /&gt;';
			}

			counter++;
		}

		output &= '#nl##tab##chr(9)#'
		output &= 'WHERE';
        output &= '#nl##local.tab#';
		if (!arguments.doubleTab) {
			output &= local.tab;
		}
		output &= '#local.tab##arguments.primaryDetail.field# = &lt;cfqueryparam cfsqltype="#arguments.primaryDetail.cfsqltype#" value="##arguments.#arguments.primaryDetail.field###" /&gt;;';
        output &= '#nl##local.tab#&lt;/cfquery&gt;';
	    output &= '#nl##nl#';
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '&lt;cfreturn arguments.#arguments.primaryDetail.field# /&gt;';
    	output &= '#nl#'
		if (arguments.doubleTab) {
			output &= chr(9);
		}
		output &= '&lt;/cffunction&gt;';

		return output;
	}

	private string function generateInit(
		required struct datasource
		, required string table
		, required array columnDetail
		, boolean doubleTab=false) {

		var output = "";
		var counter = 1;
		var service = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Service": arguments.table & "Service";
		local.tab = tab;
		if (arguments.doubleTab) {
			local.tab = tab & tab;
		}

		output &= 'public query function buildInit() {';
        output &= '#nl##local.tab#var qInit = load(0);';
		output &= '#nl##nl##local.tab#queryAddRow(qInit, {';

		for (var column in arguments.columnDetail) {
			output &= '#nl##local.tab#';
			if (!arguments.doubleTab) {
				output &= local.tab;
			} else {
				output &= chr(9);
			}
			if (counter != 1) {
				output &= ', ';
			}
			output &= '"#column.field#"=#column.default#';
			counter++;
		}

		output &= '#nl##local.tab#});';
		output &= '#nl##nl##local.tab#return qInit;';
		output &= '#nl#';
		if (arguments.doubleTab) {
			output&= '#chr(9)#';
		}
		output &= '}';

		return output;
	}

	private string function generateService(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail) {

		var output = "";
		var counter = 1;
		var service = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Service": arguments.table & "Service";
		var gateway = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Gateway": arguments.table & "Gateway";
		var objName = "q#primaryDetail.field#";
		if (right(objName, 2) == "ID") {
			objName = left(objName, len(objName) - 2);
		}

		output &= 'component accessors="true" singleton {';
		output &= '#nl##tab#property name="#gateway#" inject="#ucFirst(gateway)#";';

		output &= '#nl##nl##tab#remote query function load(required numeric #primaryDetail.field#) {';
        output &= '#nl##tab##tab#return #gateway#.load(arguments.#primaryDetail.field#);';
        output &= '#nl##tab#}';

		output &= '#nl##nl##tab#remote array function loadAll() {';
        output &= '#nl##tab##tab#return #gateway#.loadAll();';
        output &= '#nl##tab#}';

		output &= '#nl##nl##tab#remote numeric function save(required query #objName#) {';
        output &= '#nl##tab##tab#if (val(arguments.#objName#.#primaryDetail.field#)) {';
        output &= '#nl##tab##tab##tab#return #gateway#.updateRecord(arguments.#objName#);';
        output &= '#nl##tab##tab#} else {';
        output &= '#nl##tab##tab##tab#return #gateway#.insertRecord(arguments.#objName#);';
        output &= '#nl##tab##tab#}';
        output &= '#nl##tab#}';

		output &= '#nl##nl##tab##generateInit(arguments.datasource, arguments.table, arguments.columnDetail, true)#';

		output &= '#nl##nl##tab#remote query function populate(required numeric #primaryDetail.field#, required struct data) {';
        output &= '#nl##tab##tab#local.#objName# = load(arguments.#primaryDetail.field#);#nl#';
        output &= '#nl##tab##tab#if (local.#objName#.recordCount != 1) {';
        output &= '#nl##tab##tab##tab#local.#objName# = buildInit();';
        output &= '#nl##tab##tab#}#nl#';

		output &= '#nl##tab##tab#for (var column in local.#objName#.columnList) {';
		output &= '#nl##tab##tab##tab#if (column == "#ucase(primaryDetail.field)#") {';
		output &= '#nl##tab##tab##tab##tab#continue;';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##tab##tab##tab#querySetCell(local.#objName#, column, structKeyExists(arguments.data, column) ? arguments.data[column] : local.#objName#[column]);';
		output &= '#nl##tab##tab#}';

		output &= '#nl##nl##tab##tab#return local.#objName#;';
        output &= '#nl##tab#}';
        output &= '#nl#}';

		return output;
	}

	private string function generateGateway(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail) {

		var output = "";
		var counter = 1;
		var service = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Service": arguments.table & "Service";
		var gateway = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Gateway": arguments.table & "Gateway";
		var objName = "q#primaryDetail.field#";
		if (right(objName, 2) == "ID") {
			objName = left(objName, len(objName) - 2);
		}

		output &= '&lt;cfcomponent accessors="true" singleton&gt;';

		output &= '#nl##nl##tab##generateSelect(arguments.datasource, arguments.table, arguments.columnDetail, arguments.primaryDetail, true)#';
		output &= '#nl##nl##tab##generateSelectAll(arguments.datasource, arguments.table, arguments.columnDetail, true)#';
		output &= '#nl##nl##tab##generateUpdate(arguments.datasource, arguments.table, arguments.columnDetail, arguments.primaryDetail, arguments.remainderDetail, true)#';
		output &= '#nl##nl##tab##generateInsert(arguments.datasource, arguments.table, arguments.primaryDetail, arguments.remainderDetail, true)#';

        output &= '#nl#&lt;/cfcomponent&gt;';

		return output;
	}

	private string function generateSave(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail) {

		var output = "";
		var counter = 1;
		var gateway = left(arguments.table, 3) == "tbl" ? right(arguments.table, len(arguments.table) - 3) & "Gateway": arguments.table & "Gateway";

		output &= 'public numeric function save(';

		for (var column in arguments.columnDetail) {
			output &= '#nl##tab#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= 'required #column.simpleType# #column.field#=#column.default#';
			counter++;
		}

		output &= ') {';
        output &= '#nl##nl##tab##tab#local.qLoad = #gateway#.load(arguments.#arguments.primaryDetail.field#);';
        output &= '#nl##nl##tab##tab#if (local.qLoad.#arguments.primaryDetail.field#) {';
        output &= '#nl##tab##tab##tab##gateway#.update(';

		counter = 1
		for (var column in arguments.columnDetail) {
			output &= '#nl##tab##tab##tab##tab#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field#=arguments.#column.field#';
			if (counter == arrayLen(arguments.columnDetail)) {
				output &= ');';
			}
			counter++;
		}

		output &= '#nl##tab##tab##tab#local.Id = local.qLoad.#arguments.primaryDetail.field#;';
        output &= '#nl##tab##tab#} else {';
        output &= '#nl##tab##tab##tab#local.Id = #gateway#.insert(';

		counter = 1;
		for (var column in arguments.remainderDetail) {
			output &= '#nl##tab##tab##tab##tab#';
			if (counter != 1) {
				output &= ', ';
			}
			output &= '#column.field#=arguments.#column.field#';
			if (counter == arrayLen(arguments.remainderDetail)) {
				output &= ');';
			}
			counter++;
		}

		output &= '#nl##tab##tab#};#nl##nl##tab#return local.Id;';
	    output &= '#nl#}';

		return output;
	}

	private string function generateForm(required array remainderDetail) {
		var output = "";

		output &= '&lt;form&gt;';

		for (var column in arguments.remainderDetail) {
			output &= '#nl##tab#&lt;div class="form-group row"&gt;';
			output &= '#nl##tab##tab#&lt;label for="#column.field#" class="col-2 col-form-label"&gt;';
            output &= '#nl##tab##tab##tab##column.friendlyName#';
            output &= '#nl##tab##tab#&lt;/label&gt;';
			output &= '#nl##tab##tab#&lt;div class="col-10"&gt;';

			if (column.fieldType == "textarea") {
				output &= '#nl##tab##tab##tab#&lt;textarea class="form-control" id="input#column.field#"&gt;&lt;/textarea&gt;';
			} else {
				output &= '#nl##tab##tab##tab#&lt;input type="#column.fieldType#" class="form-control" id="input#column.field#" placeholder="#column.friendlyName#" /&gt;';
			}

			output &='#nl##tab##tab#&lt;/div&gt;';
            output &= '#nl##tab#&lt;/div&gt;';
		}

		output &= '#nl#&lt;/form&gt;';

		return output;
	}

	private string function generateTable(required array columnDetail) {
		var output = "";

		output &= '&lt;table class="table table-striped table-hover table-sm"&gt;';
        output &= '#nl##tab#&lt;thead class="thead-dark"&gt;';
        output &= '#nl##tab##tab#&lt;tr&gt;';

		for (var column in arguments.columnDetail) {
			output &= '#nl##tab##tab##tab#&lt;td&gt;#column.friendlyName#&lt;/td&gt;';
		}

		output &= '#nl##tab##tab#&lt;/tr&gt;';
        output &= '#nl##tab#&lt;/thead&gt;#nl##tab#&lt;tbody&gt;';
        output &= '#nl##tab##tab#&lt;cfloop array="##arrayVar##" index="indexVar"&gt;';
        output &= '#nl##tab##tab##tab#&lt;tr&gt;';

		for (var column in arguments.columnDetail) {
			output &= '#nl##tab##tab##tab##tab#&lt;td&gt;##indexVar.#column.field###&lt;/td&gt;';
		}

		output &= '#nl##tab##tab##tab#&lt;/tr&gt;#nl##tab##tab#&lt;/cfloop&gt;';
        output &= '#nl##tab#&lt;/tbody&gt;#nl#&lt;/table&gt;';

		return output;
	}

	private string function generateEntity(
		required string table
		, required struct primaryDetail
		, required array remainderDetail) {

		var output = "";
		var entity = left(arguments.table, 3) EQ "tbl" ? right(arguments.table, len(arguments.table) - 3) : arguments.table;

		if (findNoCase("id", arguments.primaryDetail.field)) {
	        entity = left(arguments.primaryDetail.field, len(arguments.primaryDetail.field)-2);
		}

    	var properties = "";
    	var counter = 1;
		for (var column in arguments.remainderDetail) {
			properties &= column.field;
			if (column.simpleType != "string") {
				properties &= ":#column.simpleType#";
			}
			if (counter != arrayLen(arguments.remainderDetail)) {
				properties &= ",";
			}

			counter++;
		}

    	output &= 'coldbox create orm-entity --activeEntity entityName=#ucFirst(entity)# table=#arguments.table# primaryKey=#arguments.primaryDetail.field# properties=#properties#';

		return output;
	}

	private string function generateAwsService() {
		var output = "";

		output &= 'component accessors="true" singleton {';

		output &= '#nl##nl##tab#property name="aws" inject="aws@awscfml";';

		output &= '#nl##nl##tab#public string function getFullTableName(required string name) {';
        output &= '#nl##tab##tab#var tableName = "";';
		output &= '#nl##nl##tab##tab#local.preffyTables = aws.dynamodb.listTables();';
		output &= '#nl##nl##tab##tab#for (var table in local.preffyTables.data.tableNames) {';
		output &= '#nl##tab##tab##tab#if (findNoCase(arguments.name, table)) {';
		output &= '#nl##tab##tab##tab##tab#local.tableName = table;';
		output &= '#nl##tab##tab##tab##tab#break;';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##tab##tab#}';
		output &= '#nl##nl##tab##tab#return tableName;';
		output &= '#nl##tab#}';

		output &= '#nl##nl##tab#public array function scanTableWithFilter(';
		output &= '#nl##tab##tab#required string tableName';
		output &= '#nl##tab##tab#, string filter=""';
		output &= '#nl##tab##tab#, struct names={}';
		output &= '#nl##tab##tab#, struct values={}) {';
		output &= '#nl##nl##tab##tab#var results = [];';
		output &= '#nl##nl##tab##tab#local.keysRemain = true;';
		output &= '#nl##tab##tab#local.nextKey = {};';
		output &= '#nl##tab##tab#while(local.keysRemain) {';
		output &= '#nl##tab##tab##tab#local.scanResults = aws.dynamodb.scan(';
		output &= '#nl##tab##tab##tab##tab#tableName=arguments.tableName';
		output &= '#nl##tab##tab##tab##tab#, filterExpression=arguments.filter';
		output &= '#nl##tab##tab##tab##tab#, expressionAttributeNames=arguments.names';
		output &= '#nl##tab##tab##tab##tab#, expressionAttributeValues=arguments.values';
		output &= '#nl##tab##tab##tab##tab#, exclusiveStartKey = local.nextKey);';
		output &= '#nl##nl##tab##tab##tab#if (arrayLen(local.scanResults.data.items)) {';
		output &= '#nl##tab##tab##tab##tab#for (var item in local.scanResults.data.items) {';
		output &= '#nl##tab##tab##tab##tab##tab#arrayAppend(results, item);';
		output &= '#nl##tab##tab##tab##tab#}';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##nl##tab##tab##tab#if (structKeyExists(local.scanResults.data, "lastEvaluatedKey")) {';
		output &= '#nl##tab##tab##tab##tab#local.nextKey = local.scanResults.data.lastEvaluatedKey;';
		output &= '#nl##tab##tab##tab#} else {';
		output &= '#nl##tab##tab##tab##tab#local.keysRemain = false;';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##tab##tab#}';
		output &= '#nl##nl##tab##tab#return results;';
		output &= '#nl##tab#}';

		output &= '#nl##nl##tab#public array function queryTableWithFilter(';
		output &= '#nl##tab##tab#required string tableName';
		output &= '#nl##tab##tab#, string indexName=""';
		output &= '#nl##tab##tab#, string keyCondition=""';
		output &= '#nl##tab##tab#, string filter=""';
		output &= '#nl##tab##tab#, struct names={}';
		output &= '#nl##tab##tab#, struct values={}) {';
		output &= '#nl##nl##tab##tab#var results = [];';
		output &= '#nl##nl##tab##tab#local.keysRemain = true;';
		output &= '#nl##tab##tab#local.nextKey = {};';
		output &= '#nl##tab##tab#while(local.keysRemain) {';
		output &= '#nl##tab##tab##tab#local.queryResults = aws.dynamodb.query(';
		output &= '#nl##tab##tab##tab##tab#tableName=arguments.tableName';
		output &= '#nl##tab##tab##tab##tab#, indexName=arguments.indexName';
		output &= '#nl##tab##tab##tab##tab#, keyConditionExpression=arguments.keyCondition';
		output &= '#nl##tab##tab##tab##tab#, expressionAttributeNames=arguments.names';
		output &= '#nl##tab##tab##tab##tab#, expressionAttributeValues=arguments.values';
		output &= '#nl##tab##tab##tab##tab#, exclusiveStartKey = local.nextKey);';
		output &= '#nl##nl##tab##tab##tab#if (arrayLen(local.queryResults.data.items)) {';
		output &= '#nl##tab##tab##tab##tab#for (var item in local.queryResults.data.items) {';
		output &= '#nl##tab##tab##tab##tab##tab#arrayAppend(results, item);';
		output &= '#nl##tab##tab##tab##tab#}';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##nl##tab##tab##tab#if (structKeyExists(local.queryResults.data, "lastEvaluatedKey")) {';
		output &= '#nl##tab##tab##tab##tab#local.nextKey = local.queryResults.data.lastEvaluatedKey;';
		output &= '#nl##tab##tab##tab#} else {';
		output &= '#nl##tab##tab##tab##tab#local.keysRemain = false;';
		output &= '#nl##tab##tab##tab#}';
		output &= '#nl##tab##tab#}';
		output &= '#nl##nl##tab##tab#return results;';
		output &= '#nl##nl##tab#}';

		output &= '#nl##nl##tab#public void function putItemInTable(required string tableName, required struct item) {';
		output &= '#nl##tab##tab#aws.dynamodb.putItem(';
		output &= '#nl##tab##tab##tab#TableName: arguments.tableName';
		output &= '#nl##tab##tab##tab#, Item: arguments.item);';
		output &= '#nl##nl##tab##tab#return;';
		output &= '#nl##tab#}';
		output &= '#nl#}';

		return output;
	}

	private string function generateValidationCall(
		required struct datasource
		, required string table
		, required array columnDetail
		, required struct primaryDetail
		, required array remainderDetail) {

		output = "var errors = validationService.validatePayload([";

		for (var column in remainderDetail) {
			output &= '#nl##tab#';
			if (column.field != remainderDetail[1].field) {
				output &= ', ';
			}
			output &= '{"name":"#column.field#", "friendlyName": "#utilService.spaceByCase(column.field)#", "type": "#column.fieldType#", "value": rc.#column.field#, "required": false}';
		}

		output &= '#nl#]);';

		return output;
	}
}