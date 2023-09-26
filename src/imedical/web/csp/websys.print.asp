<HTML>
<HEAD>
<%@ Language=VBScript %>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<TITLE></TITLE>
</HEAD>
<BODY>
<%
set factory = CreateObject("ScriptX.Factory")
factory.printing.printer = Request.QueryString("printer") '"\\SIMON\HPLASERJ"
factory.printing.PrintHTML Request.QueryString("url") '"http://128.230.0.22/etrak/csp/websys.testpage.csp" 'etrak/custom/ARMC/reports/Radiology Form.rpt?prompt0=1234&init=html_page"

Response.Write "Report Printed to: "
Response.Flush

set factory = nothing

%>
'perhaps we could show the params here....
</BODY>
</HTML>
