component accessors="true" singleton {

	property name="luceeAdminPassword" inject="coldbox:setting:luceeAdminPassword";

    public query function getDatasources() {
        local.admin = new Administrator("server", luceeAdminPassword);
        local.datasources = local.admin.getDatasources(luceeAdminPassword);
		return local.datasources;
    }

    public struct function getDatasource(required string name) {
        local.admin = new Administrator("server", luceeAdminPassword);
        local.datasource = local.admin.getDatasource(arguments.name);
		return local.datasource;
    }

}