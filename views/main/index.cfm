<cfoutput>
<div class="row">
	<div class="col-lg">

		<section id="datasources">
			<div class="pb-2 mt-4 mb-2 border-bottom">
				<h2>Datasources</h2>
			</div>

			<ul>
				<cfloop query="#prc.qDatasources#">
					<li>
						<a href="#event.buildLink("overview")#/#prc.qDatasources.name#">
							#prc.qDatasources.name#
						</a>
					</li>
				</cfloop>
			</ul>
		</section>

	</div>

</div>
</cfoutput>
