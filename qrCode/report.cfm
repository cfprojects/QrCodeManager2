<!DOCTYPE html>

<cfquery name="qryCodes" datasource="#application.dsn#">
	select c.id, c.title, count(l.id) as theCount
	from qrLog l, qrCode c
	where c.id = l.id
	group by c.id, c.title
	order by c.id, c.title
</cfquery>
<html>
<head>
<title>QR Code Accesses</title>
<meta charset="utf-8">
<link rel="stylesheet" href="qrcode.css">
</head>
<body>
<div id="path">&gt; <a href="index.cfm">QR Code Manager</a> &gt; Report</div><div id="bodycontent">
<h1>QR Code Accesses</h1>
<br>
<p>Click on row for detail.</p>
<br>
<cfform name="gridform" method="POST" action="report_detail.cfm">
   
   <cfgrid
      name="reportGrid"
      format="HTML"
      query="qryCodes"
      collapsible="false"
      selectmode="row"
      insert="false"
      width="600"
			href="report_detail.cfm"
			hrefkey="id"
			appendkey="true"
			stripeRows="true"
>
      
         <cfgridcolumn name="title" header="Title" width="300" />
         <cfgridcolumn name="theCount" header="Access Count" width="100" dataalign="RIGHT" />
         <cfgridcolumn name="id" display="No" />
   </cfgrid>
</cfform>
</body>
</html>
