<cfoutput>
    <cfset tab = prc.tab />
    <cfset pKey = "" />
    <cfset uqKey = [] />
    <cfset counter = 1 />

    CREATE TABLE '#rc.table#' (
    <cfloop array="#prc.tableDetail#" index="column">
        <cfset local.null = column.null == "NO" ? "NOT NULL" : "NULL" />
        <cfset local.default = len(column.default) ? " DEFAULT " & column.default : " DEFAULT ''" />
        <cfset local.extra = len(column.extra) ? " " & ucase(column.extra) : "" />

        <cfif column.key EQ "PRI">
            <cfset pKey = column.field />
        </cfif>
        <cfif column.key EQ "UNI">
            <cfset arrayAppend(uqKey, column.field) />
        </cfif>
        <cfif column.key EQ "PRI" OR column.null NEQ "NO">
            <cfset local.default = "" />
        </cfif>
        #tab#<cfif counter NEQ 1>, </cfif>#column.field# #column.type# #local.null##local.extra##local.default#
        <cfset counter++ />
    </cfloop>
    #tab#, PRIMARY KEY ('#pKey#')
    <cfloop array="#uqKey#" index="key">
        #tab#, UNIQUE KEY 'Uidx_#rc.table#_#key#' ('#key#')
    </cfloop>
    );

</cfoutput>