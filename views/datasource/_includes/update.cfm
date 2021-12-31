<cfoutput>
    <cfset tab = prc.tab />
    &lt;cffunction name="update" returntype="void" output="false"&gt;
        <cfloop array="#prc.columnDetail#" index="column">
            #tab#&lt;cfargument name="#column.field#" type="#column.simpleType#" required="true" /&gt;
        </cfloop>
        #prc.nl#
        #tab#&lt;cfquery name="local.qInsert" datasource="#prc.datasource.name#"&gt;
            #tab##tab#UPDATE #prc.datasource.name#.#rc.table#
            #tab##tab#SET
                <cfset counter = 1 />
                <cfloop array="#prc.remainderDetail#" index="column">
                    #tab##tab##tab#<cfif counter NEQ 1>, </cfif>#column.field# = &lt;cfqueryparam cfsqltype="#column.cfsqltype#" value="##arguments.#column.field###" /&gt;
                    <cfset counter++ />
                </cfloop>
            #tab##tab#WHERE
            #tab##tab##tab##prc.primaryDetail.field# = &lt;cfqueryparam cfsqltype="#prc.primaryDetail.cfsqltype#" value="##arguments.#prc.primaryDetail.field###" /&gt;
        #tab#&lt;/cfquery&gt;
        #prc.nl#
    &lt;cfreturn local.qInsert.generatedKey /&gt;
    &lt;/cffunction&gt;
</cfoutput>