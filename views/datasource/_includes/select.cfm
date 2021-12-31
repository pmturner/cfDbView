<cfoutput>
    <cfset tab = prc.tab />
    <cfset counter = 1 />
    &lt;cffunction name="loadAll" returntype="query" output="false"&gt;
        #tab#&lt;cfargument name="#prc.primaryDetail.field#" type="#prc.primaryDetail.simpleType#" required="true" /&gt;
        #prc.nl#
        #tab#&lt;cfquery name="local.qLoadAll"&gt;
            #tab##tab#SELECT
            <cfloop array="#prc.columnDetail#" index="column">
                #tab##tab##tab#<cfif counter NEQ 1>, </cfif>#column.field#
                <cfset counter++ />
            </cfloop>
            #tab##tab#FROM
                #tab##tab##tab##prc.datasource.name#.#rc.table#;
            #tab##tab#WHERE
                #tab##tab##tab##prc.primaryDetail.field# = &lt;cfqueryparam cfsqltype="#prc.primaryDetail.cfsqltype#" value="##arguments.#prc.primaryDetail.field###" /&gt;
        #tab#&lt;/cfquery&gt;
        #prc.nl#
    &lt;cfreturn local.qLoadAll /&gt;
    &lt;/cffunction&gt;
</cfoutput>