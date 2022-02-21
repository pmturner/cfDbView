<cfoutput>
<div class="row">
	<div class="col-lg">
		<section id="detail">
			<div class="pb-2 mt-4 mb-2 border-bottom">
                <div class="row">
                    <div class="col-8">
				        <h2>Table Detail for #rc.table#</h2>
                    </div>
                    <div class="col-4">
                        <span class="float-right mt-2">
                            <a href="#event.buildLink('overview')#/#rc.name#">#rc.name#</a>
                        </span>
                    </div>
                </div>
			</div>

            <div>
                <ul>
                    <li><a href="##cinfo">Column Information</a></li>
                    <cfloop collection="#prc.statements#" item="key">
                        <li><a href="###key#">#prc.statements[key].name#</a></li>
                    </cfloop>
                </ul>
            </div>

            <div id="cinfo" class="mt-3">
                <h3 class="border-bottom">Column Information</h3>
                <cfinclude template="./_includes/columnInfo.cfm" />
            </div>
            <cfloop collection="#prc.statements#" item="key">
                <div id="#key#" class="mt-3">
                    <h3 class="border-bottom">#prc.statements[key].name#</h3>
                    <textarea disabled="true" class="w-100" rows="10"><cfsilent>
                        </cfsilent>#prc.statements[key].output#
                    </textarea>
                </div>
            </cfloop>
		</section>
	</div>
</div>
</cfoutput>
