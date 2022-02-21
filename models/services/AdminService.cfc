component accessors="true" singleton {

	property name="luceeAdminPassword" inject="coldbox:setting:luceeAdminPassword";
	property name="aws" inject="aws@awscfml";

    public query function getDatasources() {
        local.admin = new Administrator("server", luceeAdminPassword);
        local.qDatasources = local.admin.getDatasources(luceeAdminPassword);
		return local.qDatasources;
    }

    public struct function getDatasource(required string name) {
        switch(arguments.name) {
            case "aws-dynamodb":
                local.dynamoDb = aws.dynamodb.listTables();
                local.datasource = {
                    "name": "aws-dynamodb"
                    , "host": local.dynamoDb.host
                    , "database": "dynamodb"
                    , "dbdriver": "aws-dynamodb"
                };
                break;
            default:
                local.admin = new Administrator("server", luceeAdminPassword);
                local.datasource = local.admin.getDatasource(arguments.name);
                break;
        }

		return local.datasource;
    }

}