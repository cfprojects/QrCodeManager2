<cfcomponent output="false" hint="ColdFusion Application.cfc File">

	<!--- ColdFusion Application variables --->
	<cfset this.name = hash(getCurrentTemplatePath())>

	<!--- ColdFusion Application Methods --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfset application.dsn = "qrcode">
		<cfset application.errorEmail = "error@domain.com">
		<cfreturn true>
	</cffunction>

	<cffunction name="onError" returnType="void" output="false">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
	    <cfif Find("coldfusion.filter.FormValidationException", Arguments.Exception.StackTrace)>
	        <cfthrow object="#exception#">
	    <cfelse>
		<cfset var errorcontent = "">
			
			<cfsavecontent variable="errorcontent">
			<cfoutput>
				An error has been encountered at http://#cgi.server_name##cgi.script_name#?#cgi.query_string#<br />
				Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#<br />
				<cfdump var="#arguments.exception#" label="Error">
				<cfdump var="#form#" label="Form">
				<cfdump var="#url#" label="URL">
			</cfoutput>
			</cfsavecontent>
			
			<cfmail to="#application.errorEmail#" from="#application.errorEmail#" subject="ERROR: #arguments.exception.message# at ApplicationName" type="html">
				#errorcontent#
			</cfmail>
		</cfif>
		<cflocation url="error.html" addToken="false">
	</cffunction>

</cfcomponent>
