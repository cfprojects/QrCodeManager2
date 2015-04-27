<!DOCTYPE html>
<cfif not structKeyExists(url,"id")><cflocation url="list.cfm" addtoken="No"></cfif>
<cfif structKeyExists(form,"delete")>
	<cfquery datasource="#application.dsn#">
		delete from qrLog
		where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.id#">
	</cfquery>
	<cfquery datasource="#application.dsn#">
		delete from qrCode
		where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.id#">
	</cfquery>
	<cflocation url="list.cfm" addtoken="No">
</cfif>

<html>
<head>
<title>Edit QR Code</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
<script type="text/javascript">
function verifyDelete() {
	if (confirm("Do you really want to delete this QR Code and all its statistics?"))
			return true
		else
			return false;
	}
</script>
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; <a href="list.cfm">List</a> &gt; Edit</div>
<h1>Edit QR Code</h1>
<cfif not structKeyExists(form,"fieldnames")>
	<cfquery name="qryCode" datasource="#application.dsn#">
		select url, title, description, start_date, end_date
		from qrCode
		where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.id#">
	</cfquery>
	<cfform method="POST" name="frmEntry">
	<cfoutput>
	<table cellpadding="4">
	<tr>
		<td align="right"><b><span class="red">*</span>Full Web Address:</b></td>
		<td><a href="#qryCode.url#" target="_blank">#qryCode.url#</a></td></tr>
	<tr>
		<td align="right"><b><span class="red">*</span>Title:</b></td>
		<td><cfinput type="Text" size="60" name="title" maxlength="100" required="Yes" message="Please enter a title for this code" value="#qryCode.title#"></td></tr>
	<tr>
		<td align="right" valign="top"><b>Description,<br>Notes,<br>Location:</b></td>
		<td><cftextarea name="description" rows="5" cols="60">#qryCode.description#</cftextarea></td></tr>
	<tr>
		<td align="right"><b>Start Date:</b></td>
		<cfif len(qryCode.start_date)>
			<td><cfinput name="startDate" type="datefield" size="10" value="#dateFormat(qryCode.start_date,'mm/dd/yyyy')#"></td></tr>
		<cfelse>
			<td><cfinput name="startDate" type="datefield" size="10"></td></tr>
		</cfif>
	<tr>
		<td align="right"><b>End Date:</b></td>
		<cfif len(qryCode.end_date)>
			<td><cfinput name="endDate" type="datefield" size="10" value="#dateFormat(qryCode.end_date,'mm/dd/yyyy')#"></td></tr>
		<cfelse>
			<td><cfinput name="endDate" type="datefield" size="10"></td></tr>
		</cfif>
	</table>
	<input type="Hidden" name="id" value="#url.id#">
	</cfoutput>
	<p><input type="submit" value="Update QR Code"></p>
	</cfform>
	<form method="POST" onsubmit="return verifyDelete()">
	<input type="submit" value="Delete QR Code" name="delete">
	<cfoutput>
	<input type="hidden" name="id" value="#url.id#">
	</cfoutput>
	</form>
<cfelse>
	<!--- Validate dates --->
	<cfif len(trim(form.startDate)) gt 0>
		<cfif not isValid("date",form.startDate)>
			<script type="text/javascript">
				alert("The start date is not a valid date");
				history.go(-1);
			</script>
			<p>The start date is not a valid date</p>
			<cfabort>
		</cfif>
		<cfset start_date = createodbcdate(form.startDate)>
	</cfif>
	<cfif len(trim(form.endDate)) gt 0>
		<cfif not isValid("date",form.endDate)>
			<script type="text/javascript">
				alert("The end date is not a valid date");
				history.go(-1);
			</script>
			<p>The end date is not a valid date</p>
			<cfabort>
		</cfif>
	  <cfset end_date = createodbcdate(form.endDate)>
	</cfif>
	<cfif len(trim(form.startDate)) gt 0 and len(trim(form.endDate)) gt 0>
		<cfif end_date lt start_date>
			<script type="text/javascript">
				alert("The end date is sooner than the start date");
				history.go(-1);
			</script>
			<p>The end date is sooner than the start date</p>
			<cfabort>
		</cfif>
	</cfif>
	<!--- Save data to database --->
	<cfquery datasource="#application.dsn#">
		update qrCode set title = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.title#">,
			description = <cfqueryparam cfsqltype="CF_SQL_LONGVARCHAR" value="#form.description#">
			<cfif len(trim(form.startDate)) gt 0>
				,start_date = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#start_date#">
			<cfelse>
				,start_date = NULL
			</cfif>
			<cfif len(trim(form.endDate)) gt 0>
				,end_date = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#end_date#">
			<cfelse>
				,end_date = NULL
			</cfif>
		where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.id#">
	</cfquery>
	<cflocation url="list.cfm" addtoken="No">
</cfif>
</body>
</html>
