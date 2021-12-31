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
                    <li><a href="##create">Create Table</a></li>
                    <li><a href="##selectAll">Select All</a></li>
                    <li><a href="##select">Select by Primary</a></li>
                    <li><a href="##insert">Insert</a></li>
                    <li><a href="##update">Update</a></li>
                    <li><a href="##table">Table View</a></li>
                    <li><a href="##form">Form View</a></li>
                    <li><a href="##model">ColdBox Model</a></li>
                    <li><a href="##service">ColdBox Service</a></li>
                    <li><a href="##gateway">ColdBox Gateway</a></li>
                </ul>
            </div>

            <div id="cinfo" class="mt-3">
                <h3 class="border-bottom">Column Information</h3>
                <cfinclude template="./_includes/columnInfo.cfm" />
            </div>
            <div id="create" class="mt-3">
                <h3 class="border-bottom">Create</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/create.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="selectAll" class="mt-3">
                <h3 class="border-bottom">Select All</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/selectAll.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="select" class="mt-3">
                <h3 class="border-bottom">Select by Primary</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/select.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="insert" class="mt-3">
                <h3 class="border-bottom">Insert</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/insert.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="update" class="mt-3">
                <h3 class="border-bottom">Update</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/update.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="table" class="mt-3">
                <h3 class="border-bottom">Table View</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/table.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="form" class="mt-3">
                <h3 class="border-bottom">Form View</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/form.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="model" class="mt-3">
                <h3 class="border-bottom">ColdBox Model</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/model.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="service" class="mt-3">
                <h3 class="border-bottom">ColdBox Service</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/service.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
            <div id="gateway" class="mt-3">
                <h3 class="border-bottom">ColdBox Gateway</h3>
                <cfprocessingdirective suppressWhitespace="true">
                    <textarea disabled="true" class="w-100" rows="10">
                        <cfinclude template="./_includes/gateway.cfm">
                    </textarea>
                </cfprocessingdirective>
            </div>
		</section>
	</div>
</div>
</cfoutput>
