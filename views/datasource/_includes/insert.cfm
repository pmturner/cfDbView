<cfoutput>
    <cfset tab = prc.tab />
    &lt;cffunction name="insert" returntype="numeric" output="false"&gt;
        <cfloop array="#prc.remainderDetail#" index="column">
            #tab#&lt;cfargument name="#column.field#" type="#column.simpleType#" required="true" /&gt;
        </cfloop>
        #prc.nl#
        #tab#&lt;cfquery name="local.qInsert" datasource="#prc.datasource.name#"&gt;
            #tab##tab#INSERT INTO #prc.datasource.name#.#rc.table# (
                <cfset counter = 1 />
                <cfloop array="#prc.remainderDetail#" index="column">
                    #tab##tab##tab#<cfif counter NEQ 1>, </cfif>#column.field#
                    <cfset counter++ />
                </cfloop>
            #tab##tab#) VALUES (
                <cfset counter = 1 />
                <cfloop array="#prc.remainderDetail#" index="column">
                    #tab##tab##tab#<cfif counter NEQ 1>, </cfif>&lt;cfqueryparam cfsqltype="#column.cfsqltype#" value="##arguments.#column.field###" /&gt;
                    <cfset counter++ />
                </cfloop>
            #tab##tab#)
        #tab#&lt;/cfquery&gt;
        #prc.nl#
    &lt;cfreturn local.qInsert.generatedKey /&gt;
    &lt;/cffunction&gt;
</cfoutput>