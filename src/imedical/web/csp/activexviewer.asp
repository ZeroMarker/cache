<%
' Copyright © 1997-2003 Crystal Decisions, Inc.
'
'This file contains the HTML code to instantiate the Crystal ActiveX Report Viewer.
'                                                                     
'You will notice that the Report Name parameter references the rptserver.asp file.
'This is because the report pages are actually created by rptserver.asp.
'Rptserver.asp accesses session("oClientDoc") to create the report pages 
'that will be rendered by the ActiveX Viewer.
'
%>
<HTML>
<HEAD>
<TITLE>Crystal ActiveX Report Viewer</TITLE>
</HEAD>
<BODY BGCOLOR=C6C6C6 onunload="CallDestroy()" topmargin=0 leftmargin=0>

<OBJECT ID="CRViewer"
	CLASSID="CLSID:A1B8A30B-8AAA-4a3e-8869-1DA509E8A011"
	WIDTH=100% HEIGHT=99%
	CODEBASE="/crystalreportviewers10/ActiveXControls/ActiveXViewer.cab#Version=10,0,0,280" VIEWASTEXT>
<PARAM NAME="EnableRefreshButton" VALUE=0>
<PARAM NAME="EnableGroupTree" VALUE=0>
<PARAM NAME="DisplayGroupTree" VALUE=0>
<PARAM NAME="EnablePrintButton" VALUE=1>
<PARAM NAME="EnableExportButton" VALUE=1>
<PARAM NAME="EnableDrillDown" VALUE=1>
<PARAM NAME="EnableSearchControl" VALUE=1>
<PARAM NAME="EnableAnimationControl" VALUE=1>
<PARAM NAME="EnableZoomControl" VALUE=1>
<PARAM NAME="EnableSelectExpertButton" VALUE=0>
</OBJECT>

<SCRIPT LANGUAGE="VBScript">
<!--
Sub Window_Onload
	On Error Resume Next
	Dim webBroker
	Set webBroker = CreateObject("CrystalReports10.WebReportBroker.1")
	If ScriptEngineMajorVersion < 2 Then
		window.alert "IE 3.02 users need to get the latest version of VBScript or install IE 4.01 SP1 or newer. Users of Windows 95 additionally need DCOM95.  These files are available at Microsoft's web site."
	else
		Dim webSource
		Set webSource = CreateObject("CrystalReports10.WebReportSource.1")
		webSource.ReportSource = webBroker
		webSource.URL = "rptserver.asp"
		webSource.PromptOnRefresh = True
		CRViewer.ReportSource = webSource
	End If
	CRViewer.ViewReport
	'window.open("Cleanup.asp" & v)
End Sub
-->
</SCRIPT>

<script language="javascript">
function CallDestroy()
{
	window.open("Cleanup.asp");
}
</script>

<OBJECT ID="ReportSource"
	CLASSID="CLSID:6045C5E3-3653-4262-9E3E-0DA3A22A2C1D"
	HEIGHT=1% WIDTH=1%
    CODEBASE="/crystalreportviewers10/ActiveXControls/ActiveXViewer.cab#Version=10,0,0,280">
</OBJECT>
<OBJECT ID="ViewHelp"
	CLASSID="CLSID:7D136085-0A9A-42e8-BE96-428C8D73DCE7"
	HEIGHT=1% WIDTH=1%
    CODEBASE="/crystalreportviewers10/ActiveXControls/ActiveXViewer.cab#Version=10,0,0,280">
</OBJECT>
<div>
<!-- This empty div prevents IE from showing a bunch of empty space for the controls above. -->
</div>

</BODY>
</HTML>
