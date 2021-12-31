<cfoutput>
    <cfset tab = prc.tab />
    &lt;form&gt;
        <cfloop array="#prc.remainderDetail#" index="column">
            #tab#&lt;div class="form-group row"&gt;
                #tab##tab#&lt;label for="#column.field#" class="col-sm-2 col-form-label"&gt;
                    #tab##tab##tab##column.friendlyName#
                #tab##tab#&lt;/label&gt;
                #tab##tab#&lt;div class="col-sm-10"&gt;
                    <cfif column.fieldType EQ "textarea">
                        #tab##tab##tab#&lt;textarea class="form-control" id="input#column.field#"&gt;&lt;/textarea&gt;
                    <cfelse>
                        #tab##tab##tab#&lt;input type="#column.fieldType#" class="form-control" id="input#column.field#" placeholder="#column.friendlyName#" /&gt;
                    </cfif>
                #tab##tab#&lt;/div&gt;
            #tab#&lt;/div&gt;
        </cfloop>
    &lt;/form&gt;
</cfoutput>