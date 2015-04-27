<!DOCTYPE html>
<cfquery name="qryLog" datasource="#application.dsn#">
	select log_date, ip, user_agent
	from qrLog
	where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.cfgridkey#">
	order by log_date desc
</cfquery>
<html>
<head>
<title>QR Code Detail Access</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; <a href="javascript:history.go(-1)">Back</a> &gt; Detail</div>
<h1>QR Code Detail Access</h1>
<table cellspacing="0" class="stdtable">
<tr>
	<th>Date</th>
	<th>From</th>
	<th>Device</th></tr>
<cfoutput query="qryLog">
<tr>
	<td>#dateformat(log_date,"mm/dd/yyyy")#<br>#timeformat(log_date,"short")#</td>
	<td>#ip#</td>
	<td>#user_agent#</td></tr>
</cfoutput>
</table>
</body>
</html>
