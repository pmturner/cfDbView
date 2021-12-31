<cfoutput>
    <cfset tab = prc.tab />
    &lt;table class="table table-striped table-hover table-sm"&gt;
        #tab##tab#&lt;thead class="thead-dark"&gt;
            #tab##tab##tab#&lt;tr&gt;
            <cfloop array="#prc.columnDetail#" index="column">
                #tab##tab##tab##tab#&lt;td&gt;#column.friendlyName#&lt;/td&gt;
            </cfloop>
            #tab##tab##tab#&lt;/tr&gt;
        #tab##tab#&lt;/thead&gt;
        #tab##tab#&lt;tbody&gt;
        #tab##tab##tab#&lt;cfloop array="##arrayVar##" index="indexVar"&gt;
            #tab##tab##tab##tab#&lt;tr&gt;
            <cfloop array="#prc.columnDetail#" index="column">
                #tab##tab##tab##tab##tab#&lt;td&gt;##indexVar.#column.field###&lt;/td&gt;
            </cfloop>
            #tab##tab##tab##tab#&lt;/tr&gt;
        #tab##tab##tab#&lt;/cfloop&gt;
        #tab##tab#&lt;/tbody&gt;
    &lt;/table&gt;
</cfoutput>