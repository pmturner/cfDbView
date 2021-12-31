component extends="coldbox.system.EventHandler" {

	property name="adminService" inject="AdminService";
	property name="dbService" inject="DBService";

	function index(event, rc, prc) {
		param rc.name = "";

		prc.datasource = adminService.getDatasource(rc.name);
        prc.qTables = dbService.getTables(type=prc.datasource.dbdriver, name=rc.name);

		event.setView( "datasource/index" );
	}

	function detail(event, rc, prc) {
		param rc.name = "";
		param rc.table = "";

		prc.tab = "&nbsp;&nbsp;&nbsp;&nbsp;";
		prc.nl = "&##13;";

		prc.datasource = adminService.getDatasource(rc.name);
		prc.tableDetail = dbService.getTableDetail(
			driver=prc.datasource.dbdriver
			, source=prc.datasource.name
			, table=rc.table);

		prc.columnDetail = dbService.getColumnDetail(prc.tableDetail, "all");
		prc.primaryDetail = dbService.getColumnDetail(prc.tableDetail, "primary")[1];
		prc.remainderDetail = dbService.getColumnDetail(prc.tableDetail, "remainder");
	}
}
