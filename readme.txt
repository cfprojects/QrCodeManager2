QR Code Manager System

This application creates, manages, and tracks usage of QR codes that link to
a web page. It requires ColdFusion version 8 or higher. It consists of two parts:

1. QR Code Manager (qrcode folder) - application to create and manage QR codes.
   This folder can be located on an internal or external website.
2. QR Code Redirector (qrpublic folder) - application that logs access and redirects
   to desired web page. This folder MUST be located on a publicly accessible website.

The QR Code Manager includes two open source libraries in the qrcode folder:
1. Java Loader (javaloader folder) - to dynamically load java libraries for ColdFusion
   http://javaloader.riaforge.org/
2. ZXing (zxing folder) - java barcode image processing library
   http://code.google.com/p/zxing/
   
Installation

1. Create database accessible by both parts. Scripts for MS SQL and MySQL are included in
   package root directory like this readme file.
2. Create CF datasource for both parts to created database.
3. Change Application.cfc in both parts and set the following application variables to your
   desired values:

	<cfset application.dsn = "qrcode"> - set to datasource name created above
	<cfset application.errorEmail = "error@domain.com"> - email address to receive any errors
	<cfset application.publicUrl = "http://domain.com/qrpublic/index.cfm">   - domain and path
	   to publicly accessible redirector
	   
Usage

Access the index.cfm file in the qrcode folder to create a QR code. Input form asks for web page
the QR code points to, a title of the page, an optional description, location or note about the
code, an optional start and/or stop date for the code to be active, and the number of pixels
for the QR code image. On submit, the code is added to the database and the QR code image is
created and displayed as a .png image along with link to public redirector to test. Use this
QR code image wherever you want people to see it (signs, documents, posters, ads, etc.).

The QR code will link to your public QR code redirector site and include a URL parameter to the
id generated for the code (based on current date and time). 

Example: http://domain.com/qrpublic/index.cfm?id=111017143000

The access will be logged in the qrlog table, then the user will be redirected to the proper
url.

This index.cfm page also allows you to edit or delete an existing QR code along with access
statistics on its usage.

The qrlog table stores the IP address of the calling user. Code has been included, but commented
out, in the qrpublic/index.cfm page to call an ip domain name resolver active at the time of
this writing. Uncomment and test as desired.

