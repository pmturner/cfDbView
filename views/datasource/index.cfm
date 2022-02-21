<cfoutput>
<div class="row">
	<div class="col-lg">

		<section id="tables">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				<h2>Tables in #rc.name#</h2>
			</div>
			<ul>
				<cfloop array="#prc.tables#" index="table">
					<li>
						<a href="#event.buildLink("detail")#/#rc.name#/#table[prc.tableNameKey]#">
							#table[prc.tableNameKey]#
						</a>
					</li>
				</cfloop>
			</ul>
		</section>

	</div>

</div>
</cfoutput>
