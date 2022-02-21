<cfoutput>

    <table class="table table-striped table-hover table-sm">
        <thead class="thead-dark">
            <tr>
                <th scope="col">Field Name</th>
                <th scope="col">Type</th>
                <th scope="col">Allows Null</th>
                <th scope="col">Other</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#prc.columnDetail#" index="column">
                <tr>
                    <td>
                        <cfif column.key EQ "PRI">
                            <i class="bi bi-key"></i>
                        </cfif>
                        #column.field#
                    </td>
                    <td>#column.type#</td>
                    <td>#yesNoFormat(column.isNull)#</td>
                    <td>
                        <cfif column.key EQ "UNI">
                            Unique Key
                        </cfif>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>

</cfoutput>