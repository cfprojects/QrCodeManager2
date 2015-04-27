<!DOCTYPE html>
<html>
<head>
<title>Create QR Code</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; Create</div>
<h1>Create QR Code</h1>
<cfif not structKeyExists(form,"fieldnames")>
	<cfform method="POST" name="frmEntry">
	<table cellpadding="4">
	<tr>
		<td align="right"><b><span class="red">*</span>Full Web Address:</b></td>
		<td><cfinput type="Text" size="60" name="url" maxlength="200" required="Yes" message="Please enter the web address to go to" validate="url"></td></tr>
	<tr>
		<td align="right"><b><span class="red">*</span>Title:</b></td>
		<td><cfinput type="Text" size="60" name="title" maxlength="100" required="Yes" message="Please enter a title for this code"></td></tr>
	<tr>
		<td align="right" valign="top"><b>Description,<br>Notes,<br>Location:</b></td>
		<td><cftextarea name="description" rows="5" cols="60"></cftextarea></td></tr>
	<tr>
		<td align="right"><b>Start Date:</b></td>
		<td><cfinput name="startDate" type="datefield" size="10"></td></tr>
	<tr>
		<td align="right"><b>End Date:</b></td>
		<td><cfinput name="endDate" type="datefield" size="10"></td></tr>
	<tr>
		<td align="right"><b><span class="red">*</span>Pixels:</b></td>
		<td><cfinput type="Text" size="4" name="pixels" value="120" required="Yes" message="Please enter the number of pixels for the qr code image" validate="integer"> 120 pixels ~ 1 inch, 400 pixels ~ 3 inches</td></tr>
	</table>
	<p><b>NOTE:</b> creating a new QR code here also <b>adds another entry into the database</b>. If you've already created a QR code for this web address, <a href="list.cfm">list your entries</a> and edit the existing one, unless you want to create a different code to the same web page for different locations or purposes (e.g. one for magazine A and one for magazine B to track the effectiveness of each).</p>
	<p><input type="submit" value="Create QR Code"></p>	
	
	</cfform>
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
	<!--- Create QR Code using ZXING library. Code obtained from http://cfsearching.blogspot.com/2010/04/coldfusion-zxing-read-write-qrcode.html --->
	<!--- create java loader object --->
	<cfset paths = [] />
	<cfset arrayAppend(paths, expandPath('zxing/core.jar')) />
	<cfset arrayAppend(paths, expandPath('zxing/javase.jar')) />
	<cfset loader = createObject("component", "javaloader.JavaLoader").init( paths ) />
	<!--- Get unique id for database entry --->
	<cfset theId = dateformat(now(),"yymmdd") & timeformat(now(),"HHmmss")>
	<cfset theUrl = "#application.publicUrl#?#theId#" />
	<!--- initialize writer and create a new barcode matrix --->
	<cfset BarcodeFormat = loader.create("com.google.zxing.BarcodeFormat") />
	<cfset writer = loader.create("com.google.zxing.qrcode.QRCodeWriter").init() />
	<cfset bitMatrix = writer.encode( theUrl, BarcodeFormat.QR_CODE, form.pixels, form.pixels )>
	<!--- render the matrix as a bufferedimage --->
	<cfset converter = loader.create("com.google.zxing.client.j2se.MatrixToImageWriter")>
	<cfset buff = converter.toBufferedImage( bitMatrix ) />
	<!--- convert it to a CF compatible image --->
	<cfset img = ImageNew( buff ) />
	<!--- Save data to database --->
	<cfquery datasource="#application.dsn#">
		insert into qrCode (id, url, title, description,
			<cfif len(trim(form.startDate)) gt 0>
				start_date,
			</cfif>
			<cfif len(trim(form.endDate)) gt 0>
				end_date,
			</cfif>
			create_date)
		values (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#theId#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.url#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.title#">,
			<cfqueryparam cfsqltype="CF_SQL_LONGVARCHAR" value="#form.description#">,
			<cfif len(trim(form.startDate)) gt 0>
				<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#start_date#">,
			</cfif>
			<cfif len(trim(form.endDate)) gt 0>
				<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#end_date#">,
			</cfif>
			<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">)
	</cfquery>
		<p>Your QR Code and the URL for it are shown below:</p>
    <cfoutput><a href="#theUrl#" target="_blank">#theUrl#</a></cfoutput>
    <div>
    <cfimage action="writeToBrowser" source="#img#" format="png">
    </div>
		<p>To save this code, right-click on it and choose "Save image as" then save the .png file to your computer. You can then print or paste the image into a document as desired. You may resize it in whatever program you chose, just be sure to drag by the handles, or hold the shift key down to keep it in proper proportion.</p>
		<p>This QR code links to a page on the public website. Once the code is scanned, they are directed to this page, which records their access, then sends them to the desired web page.</p>
		<p><cfoutput><a href="regenerate.cfm?id=#theId#">Re-generate QR Code</a></cfoutput></p>
</cfif>
</body>
</html>
