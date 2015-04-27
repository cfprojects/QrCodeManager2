<!DOCTYPE html>
<cfif not structKeyExists(url,"id")>
	<cflocation url="index.cfm" addtoken="No">
</cfif>
<html>
<head>
<title>Re-Generate QR Code</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; <a href="javascript:history.go(-1)">Back</a> &gt; Re-Generate</div>
<h1>Re-Generate QR Code</h1>
<cfif not structKeyExists(form,"fieldnames")>
	<cfform action="regenerate.cfm?id=#url.id#" method="POST">
	<p><b><span class="red">*</span>Pixels:</b> <cfinput type="Text" size="4" name="pixels" value="120" required="Yes" message="Please enter the number of pixels for the qr code image" validate="integer"> 120 pixels ~ 1 inch, 400 pixels ~ 3 inches</p>
	<p><input type="submit" value="Re-Generate QR Code"></p>
	</cfform>
<cfelse>
	<!--- Create QR Code using ZXING library. Code obtained from http://cfsearching.blogspot.com/2010/04/coldfusion-zxing-read-write-qrcode.html --->
	<!--- create java loader object --->
	<cfset paths = [] />
	<cfset arrayAppend(paths, expandPath('zxing/core.jar')) />
	<cfset arrayAppend(paths, expandPath('zxing/javase.jar')) />
	<cfset loader = createObject("component", "javaloader.JavaLoader").init( paths ) />
	<!--- Get unique id for database entry --->
	<cfset theUrl = "#application.publicUrl#?#url.id#" />
	<!--- initialize writer and create a new barcode matrix --->
	<cfset BarcodeFormat = loader.create("com.google.zxing.BarcodeFormat") />
	<cfset writer = loader.create("com.google.zxing.qrcode.QRCodeWriter").init() />
	<cfset bitMatrix = writer.encode( theUrl, BarcodeFormat.QR_CODE, form.pixels, form.pixels )>
	<!--- render the matrix as a bufferedimage --->
	<cfset converter = loader.create("com.google.zxing.client.j2se.MatrixToImageWriter")>
	<cfset buff = converter.toBufferedImage( bitMatrix ) />
	<!--- convert it to a CF compatible image --->
	<cfset img = ImageNew( buff ) />
	<div>
	<cfimage action="writeToBrowser" source="#img#" format="png">
	</div>
	<p>To save this code, right-click on it and choose "Save image as" then save the .png file to your computer. You can then print or paste the image into a document as desired. You may resize it in whatever program you chose, just be sure to drag by the handles, or hold the shift key down to keep it in proper proportion.</p>
	<p><cfoutput><a href="regenerate.cfm?id=#url.id#">Re-generate QR Code</a></cfoutput></p>
</cfif>
</body>
</html>
