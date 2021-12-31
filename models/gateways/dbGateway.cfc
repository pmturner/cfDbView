<cfcomponent accessors="true" singleton>

    <cffunction name="getMySqlTables" returntype="query" output="false">
        <cfargument name="name" type="string" required="true" />

        <cfquery datasource="#arguments.name#" name="local.qTables">
            SHOW TABLES;
        </cfquery>

    <cfreturn local.qTables />
    </cffunction>

    <cffunction name="getMySqlTableDetail" returntype="query">
        <cfargument name="source" type="string" required="true" />
        <cfargument name="table" type="string" required="true" />

        <cfquery datasource="#arguments.source#" name="local.qTable">
            DESCRIBE #arguments.table#;
        </cfquery>

    <cfreturn local.qTable />

    </cffunction>

</cfcomponent>