<!DOCTYPE html>
<cfquery name="qryCodes" datasource="#application.dsn#">
	select id, url, title, create_date
	from qrCode
	order by title
</cfquery>
<html>
<head>
<title>List QR Codes</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; List</div>
<h1>List QR Codes</h1>
<cfif qryCodes.recordcount gt 0>
	<table cellspacing="0" class="stdtable">
	<tr>
		<th>Created</th>
		<th>Title</th>
		<th>Functions</th></tr>
	<cfoutput query="qryCodes">
	<tr>
		<td>#dateformat(create_date,"mm/dd/yyyy")#</td>
		<td><a href="#url#" target="_blank" title="click to open URL">#title#</a></td>
		<td nowrap><a href="edit.cfm?id=#id#">Edit</a> | <a href="regenerate.cfm?id=#id#">Re-Generate</a> | <a href="report_detail.cfm?cfgridkey=#id#">Stats</a></td></tr>
	</cfoutput>
	</table>
<cfelse>
	<p>There are no QR Codes</p>
</cfif>
</body>
</html>
