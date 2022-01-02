<cfoutput>
    <cfset tab = prc.tab />

    <cfset entity = left(rc.table, 3) EQ "tbl" ? right(rc.table, len(rc.table) - 3) : rc.table />
    <cfif findNoCase("id", prc.primaryDetail.field)>
        <cfset entity = left(prc.primaryDetail.field, len(prc.primaryDetail.field)-2) />
    </cfif>

    <cfset properties = "" />
    <cfset counter = 1 />
    <cfloop array="#prc.remainderDetail#" index="column">
        <cfset properties &= column.field />
        <cfif column.simpleType NEQ "string">
            <cfset properties &= ":#column.simpleType#" />
        </cfif>
        <cfif counter NEQ arrayLen(prc.remainderDetail)>
            <cfset properties &= "," />
        </cfif>
        <cfset counter++ />
    </cfloop>

    coldbox create orm-entity
    #tab#entityName=#ucFirst(entity)#
    #tab#table=#rc.table#
    #tab#primaryKey=#prc.primaryDetail.field#
    #tab#properties=#properties#
</cfoutput>