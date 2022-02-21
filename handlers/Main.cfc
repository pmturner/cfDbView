component extends="coldbox.system.EventHandler" {

	property name="adminService" inject="AdminService";
	property name="aws" inject="aws@awscfml";

	/**
	 * Default Action
	 */
	function index( event, rc, prc ) {
		try {
			prc.qDatasources = adminService.getDatasources();
			local.dynamoDb = aws.dynamodb.listTables();

			queryAddRow(prc.qDatasources, {
				name='aws-dynamodb'
				, host=local.dynamoDb.host
				, database='dynamodb'});

			querySort(prc.qDatasources, function(rowA, rowB) {
				return compare(rowA.name, rowB.name);
			});
		} catch (any e) {
			// writeDump(e);abort;
		}

		event.setView( "main/index" );
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit( event, rc, prc ) {
	}

	function onRequestStart( event, rc, prc ) {
	}

	function onRequestEnd( event, rc, prc ) {
	}

	function onSessionStart( event, rc, prc ) {
	}

	function onSessionEnd( event, rc, prc ) {
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function onException( event, rc, prc ) {
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
