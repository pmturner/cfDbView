<cfoutput>
<div class="row">
	<div class="col-lg">

		<section id="tables">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				<h2>Tables in #rc.name#</h2>
			</div>

			<ul>
				<cfset tableNameKey = "Tables_in_#rc.name#" />
				<cfloop query="#prc.qTables#">
					<li>
						<a href="#event.buildLink("detail")#/#rc.name#/#prc.qTables[tableNameKey]#">
							#prc.qTables[tableNameKey]#
						</a>
					</li>
				</cfloop>
			</ul>
		</section>

	</div>

</div>
</cfoutput>
