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
            <cfloop array="#prc.tableDetail#" index="detail">
                <tr>
                    <td>
                        <cfif detail.key EQ "PRI">
                            <i class="bi bi-key"></i>
                        </cfif>
                        #detail.Field#
                    </td>
                    <td>#detail.Type#</td>
                    <td>#detail.Null#</td>
                    <td>
                        <cfif detail.key EQ "UNI">
                            Unique Key
                        </cfif>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>

</cfoutput>