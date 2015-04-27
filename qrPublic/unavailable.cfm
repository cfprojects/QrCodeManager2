<!DOCTYPE html>
<html>
<head>
<title>Site Not Available</title>
<meta charset="utf-8">
</head>
<body>
<cfparam name="url.stat" default="0">
<cfswitch expression="#url.stat#">
<cfcase value="0">
	<p><b>Sorry, the QR Code you've scanned is unavailable at this time.</b></p>
</cfcase>
<cfcase value="1">
	<p><b>Sorry, the QR Code you've scanned is not yet active.</b></p>
</cfcase>
<cfcase value="2">
	<p><b>Sorry, the QR Code you've scanned has expired.</b></p>
</cfcase>
</cfswitch>
</body>
</html>
