<!--- check that query string with ID exists --->
<cfif len(trim(cgi.query_string)) eq 0>
	It appears this link is in error. Missing the Code ID.
	<cfabort>
</cfif>
<cfquery name="qryCode" datasource="#application.dsn#">
	select url, title, start_date, end_date
	from qrCode
	where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<!--- check that ID exists in database --->
<cfif qryCode.recordCount eq 0>
	It appears this link is in error. Code ID is invalid.
	<cfabort>
</cfif>
<!--- check that we're between start date and end date --->
<cfif len(qryCode.start_date) gt 0 and qryCode.start_date gt now()>
	<cflocation url="unavailable.cfm?stat=1" addtoken="No">
</cfif>
<cfif len(qryCode.end_date) gt 0 and qryCode.end_date lt now()>
	<cflocation url="unavailable.cfm?stat=2" addtoken="No">
</cfif>

<cfset domain = cgi.remote_addr>

<!--- The following code, as of 10/16/2011, will call website to resolve IP address to host domain.
		Test yourself to see if still valid or replace with working resolver as desired.
 --->
<!--- 
<cfhttp url="http://psacake.com/web/eg.asp" method="POST">
	<cfhttpparam name="queryinput" type="FORMFIELD" value="#cgi.remote_addr#">
</cfhttp>
<cfset ipInfo = xmlParse(cfhttp.fileContent)>
<cfset domain = ipInfo.net.orgRef.xmlAttributes.name>
--->

<!--- Log access --->
<cfquery datasource="#application.dsn#">
	insert into qrLog (id, log_date, ip, user_agent)
	values (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cgi.query_string#">,
		<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">,
		<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#domain#">,
		<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#left(cgi.http_user_agent,400)#">)
</cfquery>

<!--- send to desired url --->
<cflocation url="#qryCode.url#" addtoken="No">

