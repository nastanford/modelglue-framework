<cfcomponent output="false">

<!--- Application settings --->
<cfset this.name = "NewScaffolding" />
<cfset this.sessionManagement = true />
<cfset this.sessionTimeout = createTimeSpan(0,0,30,0) />
<cfset this.ormenabled = true />
<cfset this.datasource = "NewScaffolding" />
<cfset this.ormsettings = {dbcreate="dropcreate",logSQL=true,sqlscript="loadScript.sql",flushatrequestend=false,dialect="MySQLwithInnoDB"} />
<cfset this.mappings = createMappings() />

<cffunction name="onSessionStart"  output="false">
	<!--- Not sure anyone'll ever need this...
	<cfset invokeSessionEvent("modelglue.onSessionStartPreRequest", session, application) />
	--->
	<!--- Set flag letting MG know it needs to broadcast onSessionStart before onRequestStart --->
	<cfset request._modelglue.bootstrap.sessionStart = true />
</cffunction>

<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionScope" type="struct" required="true">
	<cfargument name="appScope" 	type="struct" required="false">

	<cfset invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, arguments.appScope) />

</cffunction>

<cffunction name="invokeSessionEvent" output="false" access="private">
	<cfargument name="eventName" />
	<cfargument name="sessionScope" />
	<cfargument name="appScope" />

	<cfset var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(arguments.appScope) />
	<cfset var values = structNew() />
	<cfset var i = "" />

	<cfset values.sessionScope = arguments.sessionScope />

	<cfloop from="1" to="#arrayLen(mgInstances)#" index="i">
		<cfset mgInstances[i].executeEvent(arguments.eventName, values) />
	</cfloop>
</cffunction>

<cffunction name="createMappings" access="private" output="false" returntype="struct">
	<cfset var mappings = StructNew()>
	<cfset var i = "">
	<cfset mappings["/"] = GetDirectoryFromPath(GetCurrentTemplatePath()) />
	<cfloop index="i" list="views,beans" delimiters=",">
		<cfset mappings["/" & i] = GetDirectoryFromPath(GetCurrentTemplatePath()) & i />
	</cfloop>
	<cfset mappings["/modelglueextensions"] = GetDirectoryFromPath(GetCurrentTemplatePath()) & "../../modelglueextensions" />
	<cfreturn mappings>
</cffunction>


</cfcomponent>