<%
Option Explicit
Response.ExpiresAbsolute = Now() - 1
' Log 58231 - AI - 08-02-2006 : Comment out a particular code value, so accented characters can also be used.
'Session.CodePage = 65001   ' Set to Unicode
%>
<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">

<%
'===================================================================
' WORKING WITH RAS AND ASP TO PASS DISCRETE PARAMETERS
'===================================================================
' This line creates a string variable called reportName that we will use to pass
' the Crystal Report file name (.rpt file) to the OpenReport method
Dim theReportName,Path,repPath,scrPath,ReportManagerDSN,ConfigManagerDSN
theReportName = Request.QueryString("report")
scrPath = Request.QueryString("PathToScripts")
repPath = Request.QueryString("PathToReports")
ReportManagerDSN = Request.QueryString("reportmanagerdsn")
ConfigManagerDSN = Request.QueryString("configmanagerdsn")
'
'============================================================================
' CREATE THE REPORT CLIENT DOCUMENT OBJECT AND OPEN THE REPORT
'============================================================================
' Use the Object Factory object to create other RAS objects (useful for versioning changes)
Dim objFactory,RptAppSession
Dim oDBInfo,pbLevel1,pbLevel2,Tables,table,NewTable,subReportnames,subName,subTables,subTable,newSubTable

Set objFactory = CreateObject("CrystalReports.ObjectFactory")

'Response.Write "scrPath=" & scrPath & "<BR>"
'Response.Write "repPath=" & repPath & "<BR>"
'Response.Write "ReportManagerDSN=" & ReportManagerDSN & "<BR>"
'Response.Write "ConfigManagerDSN=" & ConfigManagerDSN & "<BR>"
'Response.End

'Create the ReportAppSession which allows communication to the Report Application Server
Set RptAppSession = ObjFactory.CreateObject("CrystalReports.ReportAppSession")
If Err.Number <> 0 Then
	Response.Write "Failed to create CrystalReports.ReportAppSession."
	Response.Write "Error message: " & Err.Description
	Err.Clear
End If

' Initialize the Report Application Session
RptAppSession.Initialize
If Err.Number <> 0 Then
	Response.Write "Failed to initialize ReportAppSession."
	Response.Write "Error message: " & Err.Description
	Err.Clear
End If

'Create a new ReportClientDocument object
Set Session("oClientDoc") = objFactory.CreateObject("CrystalClientDoc.ReportClientDocument")

'Specify the RAS Server (computer name or IP address) to use (If SDK and RAS Service are running on seperate machines)
Session("oClientDoc").ReportAppServer = "127.0.0.1"

'Open the report object to initialize the ReportClientDocument
'Session("oClientDoc").Open path & theReportName
'Try and get Reports folder...
Path=""
Dim DirMgr,crDirectoryItemTypeFolder,crDirectoryItemTypeReport
crDirectoryItemTypeFolder=1
crDirectoryItemTypeReport=1
Set DirMgr = rptAppSession.CreateService("CrystalReports.ConnectionDirManager")
'Open the ConnectionDirManager to get reports folder from the crystal configuration manager.
'In crystal configuration manager, * = c:\
DirMgr.open crDirectoryItemTypeFolder + crDirectoryItemTypeReport
Dim Item
For Each Item In DirMgr.GetRoots
	Path=Item.Name
	Exit For
Next
DirMgr.Close

'Response.Write "Path1=" & path & "<BR>"

If Path="c:\" Then Path=repPath
If Right(Path,1)<>"\" Then Path=Path & "\"

'Response.Write "Path2=" & path & "<BR>"
'Response.Write "Path3=" & path & "\" & theReportName & "<BR>"
'Response.End


'Path=""
If Path="c:\" Or Path="" Then

	Response.Write "Report(s) not found <BR><BR>"
	Response.Write "Please set Path to REPORTS folder in Crystal Configuration Manager or set Path to Reports in Configuration Manager <BR><BR>"

Else
	If Trim(Path)<>"" Then
		' Open the report object to initialize the ReportClientDocument
		'Session("oClientDoc").Open path & "\" & theReportName
		'Response.Write "Path3=" & path & "\" & theReportName & "<BR>"
		Session("oClientDoc").Open path & theReportName
	Else
		' This "While/Wend" loop is used to determine the physical path (eg: C:\) to the
		' Crystal Report .rpt by translating the URL virtual path (eg: http://Domain/Dir)
		Dim iLen
		path = Request.ServerVariables("PATH_TRANSLATED")
		While (Right(path, 1) <> "\" And Len(path) <> 0)
			iLen = Len(path) - 1
			path = Left(path, iLen)
		Wend
		' Open the report object to initialize the ReportClientDocument
		Session("oClientDoc").Open path & theReportName
	End If
	'Response.Write("Number of parameter fields: " & Session("oClientDoc").DataDefinition.ParameterFields.Count)

	'==================================================================
	' WORKING WITH DISCRETE PARAMETERS
	'==================================================================

	'This subroutine is called each time you have to pass a value to a Crystal Report parameter
	Sub PassParameter(intParamIndex, ParamValue)

	    Dim ParamIndex, objParam, objNewParam

	    'Determine the index position of the parameter in the report
	    'ParamIndex = Session("oClientDoc").DataDefinition.ParameterFields.Find(strParamName, 0)

	    'Paramater index is passed in directly. Order of parameters in TrakCare must match
	    'order in the crystal report
	    ParamIndex = intParamIndex

	    'Get parameter in the report at the position ParamIndex
	    Set objParam = Session("oClientDoc").DataDefinition.ParameterFields.Item(ParamIndex)

	    'Clone the parameter object so we can modify it
	    Set objNewParam = objParam.Clone

	    'Add parameter field value to this object
	    objNewParam.CurrentValues.Add ParamValue

	    'Insert the modified parameter back into the report
	    Session("oClientDoc").DataDefController.ParameterFieldController.Modify ParamIndex, objNewParam

	End Sub

	' The included sample report has a parameter for each type of value in Crystal Reports
	' Pass the parameter values by name to the report - the subroutine expects
	' the following arguments: Parameter Name, Parameter Value
	' The subroutine also works for multi-value discrete parameters
	'PassParameter "P1", "12"
	Dim ParamString
	Dim count, intParamCount
	ParamString=""
	intParamCount = Session("oClientDoc").DataDefinition.ParameterFields.Count
	For count = 0 to intParamCount - 1
	    Dim tempParam
	    'tempParam = Request.QueryString("promptex-prompt" & count)
	    tempParam = Request.QueryString("prompt" & count)
'response.write tempParam
	    If tempParam <> "" Then
	        Dim intPosFound
	        intPosFound = InStr(tempParam, "Date(")
	        If intPosFound > 0 Then
				Dim intEndBracket, strDate
	            intEndBracket = InStr(intPosFound, tempParam, ")")
	            strDate = Mid(tempParam, intPosFound + 5, Len(tempParam) - (Len(tempParam) - intEndBracket + 1) - intPosFound - 4)
	            tempParam = CDate(strDate)
	        End If

		' ANDYR FIX FOR TIME PARAMETERS LOG 51464
		intPosFound = InStr(tempParam, "Time(")
	        If intPosFound > 0 Then
		    Dim strTime, strHH, strMM, strSS, strAMPM, intHH
	            strSS = "00"
		    strAMPM = "AM"
	'response.write strHH
		    strHH = Mid(tempParam,intPosFound + 5,2)
		    intHH=Cint(strHH)
		    strMM = Mid(tempParam,intPosFound + 8,2)
		    if intHH>12 Then
			strAMPM="PM"
			intHH = intHH-12
		    End If
		    strTime=Cstr(intHH) & ":" & strMM & ":" & strSS & " " & strAMPM
	'response.write strTime
	            tempParam = CDate(strTime)
	        End If

	        ParamString=ParamString & "&prompt" & count & "=" & tempParam
	        PassParameter count, tempParam
	    Else
	        PassParameter count, ""
	    End If
	Next

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------
'JOHN P - Log 51261 - 31/08/2005

'Get the connection information from the report document for the first table in the collection
err.clear
if Session("oClientDoc").DatabaseController.GetConnectionInfos().Count>0 then

  Set oDBInfo = Session("oClientDoc").DatabaseController.GetConnectionInfos().Item(0)
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  'Get the connection info attributes
  err.clear
  Set pbLevel1 = oDBInfo.Attributes
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  'This 'first level' property bag will be used to define the basic database info for the report
  err.clear
  'pbLevel1.Item("QE_ServerDescription") = "127.0.0.1"
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  err.clear
  '.Item("Database Name") = "127.0.0.1"
  if ReportManagerDSN <> "" then
      pbLevel1.Item("Server Name") = ReportManagerDSN
      pbLevel1.Item("Server Type") = "ODBC - " & ReportManagerDSN
  elseif ConfigManagerDSN <> "" then
      pbLevel1.Item("Server Name") = ConfigManagerDSN
      pbLevel1.Item("Server Type") = "ODBC - " & ConfigManagerDSN
  end if

  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  'This 'second level' property bag contains info that is specific to the type of db connection
  'in this case, it will contain our OLE DB specific information
  err.clear
  Set pbLevel2 = pbLevel1.item("QE_LogonProperties")
  if ReportManagerDSN <> "" then
      pbLevel2.Item("DSN") = ReportManagerDSN
  elseif ConfigManagerDSN <> "" then
      pbLevel2.Item("DSN") = ConfigManagerDSN
  end if
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  'Attaching the QE specific properties to the 'level 1' property bag
  err.clear
  pbLevel1.Item("QE_LogonProperties") = pbLevel2
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  'Add thew new property bag info to the connection object (and set the username/password)
  err.clear
  oDBInfo.Attributes = pbLevel1
  'oDBInfo.UserName = "username"
  'oDBInfo.Password = "password"
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  '===============================================================
  ' CHANGING THE MAIN REPORT DATABASE INFO
  '===============================================================

  'Get the collection of tables in the main report
  err.clear
  Set Tables = Session("oClientDoc").DataDefController.Database.Tables
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  For Each table in Tables

      'clone the table object
      err.clear
      Set newTable = Table.Clone
      if err.number <> 0 then
          Response.Write "Error message: " & Err.Description
      end if

      'set the table's connectionInfo to the current connection info
      err.clear
      newTable.ConnectionInfo = oDBInfo
      if err.number <> 0 then
          Response.Write "Error message: " & Err.Description
      end if

      'set the table object qualified name to include the new database name
      'i.e. original = 'db1.dbo.myTable', new = 'db2.dbo.myTable'
      'err.clear
      'newTable.QualifiedName = Database & ".dbo." & Table.Name
      'if err.number <> 0 then
      '    Response.Write "Error message: " & Err.Description
      'end if

      'put this newly modified table object back into the report client doc
      err.clear
      Session("oClientDoc").DatabaseController.SetTableLocation table, newTable
      if err.number <> 0 then
          Response.Write "Error message: " & Err.Description
      end if

  Next

  '===============================================================
  ' CHANGING THE DATABASE FOR ALL SUBREPORTS
  '===============================================================

  'get a collection of subreport names
  err.clear
  Set subReportNames = Session("oClientDoc").SubReportController.QuerySubreportNames
  if err.number <> 0 then
      Response.Write "Error message: " & Err.Description
  end if

  For each subName in subReportnames

    'we can't reference a subreport table object directly, so we get the collection of tables first
    err.clear
    Set subTables = Session("oClientDoc").SubReportController.GetSubreportDatabase(subName).Tables
    if err.number <> 0 then
        Response.Write "Error message: " & Err.Description
    end if

    For each subTable in subTables

        'clone the subreport table object
        err.clear
        Set newSubTable = subTable.Clone
        if err.number <> 0 then
            Response.Write "Error message: " & Err.Description
        end if

        'set the subreport table's connectionInfo to the current connection info
        err.clear
        newSubTable.ConnectionInfo = oDBInfo
        if err.number <> 0 then
            Response.Write "Error message: " & Err.Description
        end if

        'set the table object qualified name to include the new database name
        'i.e. original = 'db1.dbo.myTable', new = 'db2.dbo.myTable'
        'err.clear
        'newSubTable.QualifiedName = Database & ".dbo." & subTable.Name
        'if err.number <> 0 then
        '    Response.Write "Error message: " & Err.Description
        'end if

        'put this newly modified table object back into the report client doc
        err.clear
        Session("oClientDoc").SubReportController.SetTableLocation subName, subTable, newSubTable
        if err.number <> 0 then
            Response.Write "Error message: " & Err.Description
        end if

    Next
  Next
end if
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------

'** Code added to check Crystal Version based on registry, and then call the appropriate ActiveX viewer based in this AR 18/7/07 **
Dim crystalversion
'default is version 10
crystalversion="10"

'check registry for installed version of crystal/business object enterprise - update if more recent than version 10

if IsRegKey("HKLM\Software\Business Objects\Suite 11.0\Enterprise")=1 then
	crystalversion="11"
end if
if IsRegKey("HKLM\Software\Business Objects\Suite 11.5\Enterprise")=1 then
	crystalversion="115"
end if


	if (theReportName = "") then
		theReportName = Request.Cookies("reportPreview")("ReportName")
	end if

	if (theReportName = "") then
		Response.Write "<p><font FACE='Verdana, Arial, Helvetica' SIZE='3'>Please select a report to preview</font>"
		Response.Write "<p><font FACE='Verdana, Arial, Helvetica' SIZE='1'>" + vbCrLf
		Response.Write "Parameters and Database logons must be set before previewing a report using ActiveX or Java Plugin viewers." + vbCrLf
		Response.Write "</font>" + vbCrLf
	else
		Dim m_Viewer, qryString
		' init - viewertype
		m_Viewer = Request.QueryString("init")
		'Response.Write "m_Viewer=" & m_Viewer & "<BR>"
		'set actx viewer as default
		If m_Viewer="" Then m_Viewer="actx"

		Response.Cookies("reportPreview").Expires = DateAdd("yyyy", 1, Now)	' Expire one year from now
		Response.Cookies("reportPreview")("ReportName") = theReportName

		' To pass parameters...
		qryString = "?ReportName=" + Server.URLEncode(theReportName) & ParamString
		'only 3 viewr types support
		if (m_Viewer = "html_page") then
			Response.Redirect "pageviewer.asp" + qryString
		elseif (m_Viewer = "actx") Then
			Response.Redirect "activexviewer" + crystalversion + ".asp" + qryString
		elseif (m_Viewer = "java_plugin") then
			Response.Redirect "javapluginviewer.asp" + qryString
		else
		end if
	end if
End IF


Function IsRegKey(sKey)
	Dim Sh
	Set Sh = CreateObject("WScript.Shell")
	On Error Resume Next
	IsRegKey = 0
	ret = Sh.RegRead(sKey)
	If Err.Number = 0 Then
		IsRegKey = 1
	ElseIf CBool(Instr(Err.Description,"Unable")) Then
		IsRegKey = 1
	End If
	Err.Clear: On Error Goto 0
End Function

%>
<script language="Javascript">
	this.window.focus();
</script>


