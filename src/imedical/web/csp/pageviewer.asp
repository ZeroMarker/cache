<%@CodePage=65001%>
<% 

Option Explicit
Response.ContentType = "text/html; charset=utf-8"

Dim objectFactory
Set objectFactory = CreateObject("CrystalReports10.ObjectFactory.1")

Response.ExpiresAbsolute = Now() - 1
           
Dim viewer
Set viewer = objectFactory.CreateObject("CrystalReports.CrystalReportViewer")  
viewer.Name = "page"
viewer.IsOwnForm = true              
viewer.IsOwnPage = true

Dim theReportName

theReportName = Request.QueryString("ReportName")
Response.Write theReportName
'viewer.URI = "pageViewer.asp?ReportName=" + Server.URLEncode(theReportName)
viewer.ReportSource = Session("oClientDoc").ReportSource

'Response.Write Server.URLEncode("\\Goanna\Developer\W650DEV\CUSTOM\TRAKDEV\REPORTS\showparamsv10.rpt")
'if theReportName <> "" then viewer.ReportSource = "\\Goanna\Developer\W650DEV\CUSTOM\TRAKDEV\REPORTS\showparamsv10.rpt"
viewer.ProcessHttpRequest Request, Response, Session

%>
