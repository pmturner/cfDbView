component extends="coldbox.system.EventHandler" {

	property name="adminService" inject="AdminService";
	property name="DBService" inject="DBService";
	property name="utilService" inject="UtilService";
	property name="statementService" inject="StatementService";

	function index(event, rc, prc) {
		param rc.name = "";

		prc.datasource = adminService.getDatasource(rc.name);
		local.tableInfo = dbService.getTables(rc.name, prc.datasource.dbdriver);
		prc.tables = local.tableInfo.tables;
		prc.tableNameKey = local.tableInfo.key;

		event.setView( "datasource/index" );
	}

	function detail(event, rc, prc) {
		param rc.name = "";
		param rc.table = "";

		prc.tab = chr(9);
		prc.nl = chr(13);

		prc.datasource = adminService.getDatasource(rc.name);
		prc.driverType = prc.datasource.dbdriver;

		prc.tableDetail = dbService.getTableDetail(
			driver=prc.datasource.dbdriver
			, source=prc.datasource.name
			, table=rc.table);

		prc.columnDetail = dbService.getColumnDetail(prc.tableDetail, "all");
		prc.primaryDetail = dbService.getColumnDetail(prc.tableDetail, "primary")[1];
		prc.remainderDetail = dbService.getColumnDetail(prc.tableDetail, "remainder");

		prc.statements = statementService.getStatementsByType(
			type=prc.driverType
			, datasource=prc.datasource
			, table=rc.table
			, columnDetail=prc.columnDetail
			, primaryDetail=prc.primaryDetail
			, remainderDetail=prc.remainderDetail);
	}
}
