<cfoutput>
    <cfset tab = prc.tab />
    <cfset nl = prc.nl />
    <cfset gateway = left(rc.table, 3) EQ "tbl" ? right(rc.table, len(rc.table) - 3) & "Gateway": rc.table & "Gateway" />
        public numeric function save(
            #tab##tab#numeric #prc.primaryDetail.field#=#prc.primaryDetail.default#
            <cfloop array="#prc.columnDetail#" index="column">
                #tab##tab#required #column.simpleType# #column.field#=#column.default#
            </cfloop>
            #tab#) {
            #tab##tab#local.qLoad = #gateway#.load(arguments.#prc.primaryDetail.field#);
            #nl#
            #tab##tab#if (local.qLoad.#prc.primaryDetail.field#) {
                #tab##tab##tab##gateway#.update(
                    <cfset counter = 1 />
                    <cfloop array="#prc.columnDetail#" index="column">
                        #tab##tab##tab##tab#<cfif counter NEQ 1>, </cfif>#column.field#=arguments.#column.field#<cfif counter EQ arrayLen(prc.columnDetail)>);</cfif>
                        <cfset counter++ />
                    </cfloop>
                #tab##tab##tab#local.Id = local.qLoad.#prc.primaryDetail.field#;
            #tab##tab#} else {
                #tab##tab##tab#local.Id = #gateway#.insert(
                    <cfset counter = 1 />
                    <cfloop array="#prc.remainderDetail#" index="column">
                        #tab##tab##tab##tab#<cfif counter NEQ 1>, </cfif>#column.field#=arguments.#column.field#<cfif counter EQ arrayLen(prc.remainderDetail)>);</cfif>
                        <cfset counter++ />
                    </cfloop>
            #tab##tab#}
            #nl#
            #tab# return local.Id;
        }
</cfoutput>