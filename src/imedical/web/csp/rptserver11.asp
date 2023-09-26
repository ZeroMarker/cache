<%@ Language=VBScript %>
<%
' Copyright © 1997-2002 Crystal Decisions, Inc.

Option Explicit

'Create an instance of the object factory.  It is used to create
'report objects more efficiently.
Dim objectFactory
Set objectFactory = Server.CreateObject("CrystalReports11.ObjectFactory.1")

'Check to see if the report has been opened
If Not IsObject(Session("oClientDoc")) Then
	Dim clientDocument
	Set clientDocument = objectFactory.CreateObject("CrystalClientDoc.ReportClientDocument")
	Call CheckForError

	'Store the client document in the session for subsequent requests
	Set Session("oClientDoc") = clientDocument

	'Support passing the report name in the session or in the URL
	Dim reportName
	reportName = Session("ReportName")

	If reportName = "" Then
		reportName = Request.QueryString("rpt")
	End If

	If reportName = "" Then
		reportName = Request.QueryString("ReportName")
	End If

	if reportName = "" then
		reportName = Request.Cookies("reportPreview")("ReportName")
	end if

'	SetEMFError 1, "rptName = " + reportName + " Qry: " + Request.QueryString
	If reportName = "" Then
		SetEMFError 1, "A report name was not specified"
		Session.Abandon
		Response.End
	End If

	'Open the report
	clientDocument.Open(reportname)
	Call CheckForError
End if

' Handle the command from the viewer
Dim command
command = UCase(GetArgument("cmd"))

Select Case command
	Case "GET_PG"
		Call GetPage
	Case "GET_TTL"
		Call GetTotaller
	Case "NAV"
		Call Navigate
	Case "CHRT_DD"
		DrillGraph
	Case "GET_LPG"
		Call GetLastPage
	Case "SRCH"
		Call SearchText
	Case "MAP_DD"
		Call DrillMap
	Case "RFSH"
		Call Refresh
	Case "EXPORT"
		Call Export
	Case "BSRCH"
		Call BooleanSearch
End Select

'Get Page
Sub GetPage()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.PageRequestContext")
	requestContext.PageNumber = GetPageNumber()

	requestContext.RequestContext = CreateBaseContext()

	On Error Resume Next

	Dim EPF
	EPF = Session("oClientDoc").ReportSource.GetPage(requestContext)

	If LenB(EPF) > 0 Then
		Response.ContentType = "application/x-epf" 'EPF MIME Type
		Response.AddHeader "CONTENT-LENGTH", LenB(EPF)
		Response.BinaryWrite EPF
	Else
		SetEMFError 1, "Unable to generate page."
	End If
End Sub

'Get Totaller
Sub GetTotaller()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.TotallerRequestContext")

	requestContext.RequestContext = CreateBaseContext()

	Dim groupPath
	Set groupPath = objectFactory.CreateObject("CrystalReports.GroupPath")

	Dim path
	path = UCase(GetArgument("TTL_INFO")) 'Used to indicate the group path of the totaller request.

	If path <> "" Then
		groupPath.FromString path
	End If

	requestContext.RootGroupPath = groupPath

	On Error Resume Next

	Dim ETF
	ETF = Session("oClientDoc").ReportSource.GetTotaller(requestContext)

	If LenB(ETF) > 0 Then
		Response.ContentType = "application/x-etf" 'ETF MIME Type
		Response.AddHeader "CONTENT-LENGTH", LenB(ETF)
		Response.BinaryWrite ETF
	Else
		SetEMFError 1, "Unable to generate totaller."
	End If
End Sub

'Navigate
Sub Navigate()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.FindGroupRequestContext")

	requestContext.RequestContext = CreateBaseContext()

	Dim groupPath
	Set groupPath = objectFactory.CreateObject("CrystalReports.GroupPath")

	Dim path
	path = UCase(GetArgument("GRP"))

	If path <> "" Then
		groupPath.FromString path
	End If

	requestContext.GroupPath = groupPath

	Dim pageNumber
	pageNumber = Session("oClientDoc").ReportSource.FindGroup(requestContext)

	SetEMFPageNumber pageNumber
End Sub

'Drill Graph
Sub DrillGraph()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.DrillDownRequestContext")

	Dim pageRequestContext
	Set pageRequestContext = objectFactory.CreateObject("CrystalReports.PageRequestContext")
	pageRequestContext.PageNumber = GetPageNumber()

	requestContext.PageRequestContext = pageRequestContext

	pageRequestContext.RequestContext = CreateBaseContext()

	Dim COORD
	COORD = UCase(GetArgument("COORD"))	' these are the coordinates on the graph to process
	Dim XPosition, YPosition
	Call GetDrillDownCoordinates(COORD, XPosition, YPosition)

	requestContext.XPosition = XPosition
	requestContext.YPosition = YPosition

	On Error Resume Next

	Dim totallerNodeID
	Set totallerNodeID = Session("oClientDoc").ReportSource.DrillGraph(requestContext)

	If IsObject(totallerNodeID) Then
		Dim groupName, groupPath
		groupName = totallerNodeID.GroupName
		groupPath = totallerNodeID.GroupPath.ToString

		SetEMFGroupInfo groupName, groupPath
	Else
		Err.Clear
		SetEMFError 40, "Drill down not possible."
	End If
End Sub

'Drill Map
Sub DrillMap()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.DrillDownRequestContext")

	Dim pageRequestContext
	Set pageRequestContext = objectFactory.CreateObject("CrystalReports.PageRequestContext")
	pageRequestContext.PageNumber = GetPageNumber()

	requestContext.PageRequestContext = pageRequestContext

	pageRequestContext.RequestContext = CreateBaseContext()

	Dim COORD
	COORD = UCase(GetArgument("COORD"))	' these are the coordinates on the graph to process
	Dim XPosition, YPosition
	Call GetDrillDownCoordinates(COORD, XPosition, YPosition)

	requestContext.XPosition = XPosition
	requestContext.YPosition = YPosition

	On Error Resume Next

	Dim totallerNodeID
	Set totallerNodeID = Session("oClientDoc").ReportSource.DrillMap(requestContext)

	If IsObject(totallerNodeID) Then
		Dim groupName, groupPath
		groupName = totallerNodeID.GroupName
		groupPath = totallerNodeID.GroupPath.ToString

		SetEMFGroupInfo groupName, groupPath
	Else
		Err.Clear
		SetEMFError 40, "Drill down not possible."
	End If
End Sub

'Get Last Page
Sub GetLastPage()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.RequestContext")

	Set requestContext = CreateBaseContext()

	Dim pageNumber
	pageNumber = Session("oClientDoc").ReportSource.GetLastPageNumber(requestContext)

	SetEMFPageNumber pageNumber
End Sub

'Search Text
Sub SearchText()
	Dim requestContext
	Set requestContext = objectFactory.CreateObject("CrystalReports.FindTextRequestContext")

	Dim pageRequestContext
	Set pageRequestContext = objectFactory.CreateObject("CrystalReports.PageRequestContext")
	pageRequestContext.PageNumber = GetPageNumber()

	requestContext.PageRequestContext = pageRequestContext

	pageRequestContext.RequestContext = CreateBaseContext()

	requestContext.Text = DecodeUTF8(GetArgument("TEXT"))

	Dim searchDirection
	searchDirection = GetArgument("DIR")
	If UCase(searchDirection) = "FOR" Then
		requestContext.SearchDirection = 0
	Else
		requestContext.SearchDirection = 1
	End If

	Dim pageNumber
	pageNumber = Session("oClientDoc").ReportSource.FindText(requestContext)

	if pageNumber > 0 Then
		SetEMFPageNumber pageNumber
	Else
		SetEMFError 33, "The specified text, '" & requestContext.Text & "' was not found in the report."
	End If
End Sub

'Refresh
Sub Refresh()
	Session("oClientDoc").ReportSource.Refresh

	'The Java Viewer expects an EPF back containing page 1.
	'The ActiveX Viewer expects an EMF back.
	Dim viewer
	viewer = UCase(GetArgument("VIEWER"))	' This is the viewer that is calling the server

	If viewer = "JAVA" Then
		Call GetPage
	Else
		SetEMFError 0, ""
	End If
End Sub

'Export
Sub Export()
	Dim exportOptions
	Set exportOptions = objectFactory.CreateObject("CrystalReports.ExportOptions")

	'Determine the export format
	Dim fmt
	fmt = UCase(GetArgument("EXPORT_FMT")) ' Used to specify export format and type.

	Dim charIndex
	charIndex = findChar(fmt, ":")

	If charIndex > 0 Then
		Dim exportType
		Dim exportDLLName

		exportType = Mid(fmt, charIndex + 1)
		exportDLLName = UCase(Mid(fmt, 1, charIndex - 1))

		Dim startPage, endPage

		Select Case exportDLLName
			Case "U2FCR"
				exportOptions.ExportFormatType = 0 ' Crystal Reports
				Response.ContentType = "application/x-rpt"
			Case "CRXF_XLS"
				Response.ContentType = "application/vnd.ms-excel"
				If exportType = "10" Then
					exportOptions.ExportFormatType = 6 ' Microsoft Excel Data Dump
				Else
					exportOptions.ExportFormatType = 2 ' Microsoft Excel
				End If

				GetExportPageRange startPage, endPage
				If startPage > 0 Then
					Dim ExcelExportOptions
					Set ExcelExportOptions = objectFactory.CreateObject("CrystalReports.ExcelExportFormatOptions")
					ExcelExportOptions.StartPageNumber = startPage
					ExcelExportOptions.EndPageNumber = endPage

					exportOptions.FormatOptions = ExcelExportOptions
				End If
			Case "CRXF_WORDW"
					exportOptions.ExportFormatType = 1 'Microsoft Word
					Response.ContentType = "application/msword"

				GetExportPageRange startPage, endPage
				If startPage > 0 Then
					Dim WordExportOptions
					Set WordExportOptions = objectFactory.CreateObject("CrystalReports.RTFWordExportFormatOptions")
					WordExportOptions.StartPageNumber = startPage
					WordExportOptions.EndPageNumber = endPage

					exportOptions.FormatOptions = WordExportOptions
				End If
			Case "CRXF_RTF"
				exportOptions.ExportFormatType = 3 'RTF
				Response.ContentType = "application/rtf"

				GetExportPageRange startPage, endPage
				If startPage > 0 Then
					Dim RTFExportOptions
					Set RTFExportOptions = objectFactory.CreateObject("CrystalReports.RTFWordExportFormatOptions")
					RTFExportOptions.StartPageNumber = startPage
					RTFExportOptions.EndPageNumber = endPage

					exportOptions.FormatOptions = RTFExportOptions
				End If
			Case "CRXF_PDF"
				exportOptions.ExportFormatType = 5 ' Adobe Acrobat (PDF)
				Response.ContentType = "application/pdf"

				GetExportPageRange startPage, endPage
				If startPage > 0 Then
					Dim PDFExportOptions
					Set PDFExportOptions = objectFactory.CreateObject("CrystalReports.PDFExportFormatOptions")
					PDFExportOptions.StartPageNumber = startPage
					PDFExportOptions.EndPageNumber = endPage

					exportOptions.FormatOptions = PDFExportOptions
				End If

			'Older Export DLL Names:
			Case "U2FWORDW"
				exportOptions.ExportFormatType = 1 'Microsoft Word
				Response.ContentType = "application/msword"
			Case "U2FRTF"
				exportOptions.ExportFormatType = 3 'RTF
				Response.ContentType = "application/rtf"
			Case "U2FXLS"
				exportOptions.ExportFormatType = 2 ' Microsoft Excel
				Response.ContentType = "application/vnd.ms-excel"
			Case "U2FPDF"
				exportOptions.ExportFormatType = 5 ' Adobe Acrobat (PDF)
				Response.ContentType = "application/pdf"
			Case Else
				SetEMFError 1, "Unknown Export Format"
				Exit Sub
		End Select
	Else
		SetEMFError 1, "Unknown Export Format"
		Exit Sub
	End If

	Dim requestContext
	Set requestContext = CreateBaseContext()

	On Error Resume Next

	Dim exportContent
	exportContent = Session("oClientDoc").ReportSource.Export(exportOptions, requestContext)

	If LenB(exportContent) > 0 Then
		Response.AddHeader "CONTENT-LENGTH", LenB(exportContent)
		Response.BinaryWrite exportContent
	Else
		SetEMFError 1, "Export failed."
	End If
End Sub

'Boolean Search
Sub BooleanSearch()
	SetEMFError 1, "This feature is not supported."
End Sub


Sub GetExportPageRange(ByRef startPage, ByRef endPage)
	Dim exportOptions
	exportOptions = GetArgument("export_opt")

	startPage = 0
	endPage = 0

	If exportOptions = "" Then
		Exit Sub
	End If

	'The export_opt value is formatted as follows:
	'[n-m]  page n to m
	'(-n]   first page to n
	'[n-)	page n to the end
	'(-)    all pages

	Dim i, dashIndex
	dashIndex = findChar(exportOptions, "-")
	If	dashIndex = -1 Then
		Exit Sub
	End If

	'Check for a starting page
	i = findChar(exportOptions, "[")
	If i <> -1 Then
		startPage = Mid(exportOptions, i + 1, dashIndex - i - 1)
	Else
		startPage = 1
	End If

	'Check for an ending page
	i = findChar(exportOptions, "]")
	If i <> -1 Then
		endPage = Mid(exportOptions, dashIndex + 1, i - dashIndex - 1)
	Else
		endPage = -1
	End If
End Sub

Function CreateBaseContext()
	Dim baseContext
	Set baseContext = objectFactory.CreateObject("CrystalReports.RequestContext")

	'Handle the branch information
	Dim branches
	branches = UCase(GetArgument("BRCH"))	' the branch is a mechanism to determine the drill down level.
	If branches <> "" Then
		Dim groupPath
		Set groupPath = objectFactory.CreateObject("CrystalReports.GroupPath")

		groupPath.FromString branches

		Dim totallerNodeID
		Set totallerNodeID = objectFactory.CreateObject("CrystalReports.TotallerNodeID")
		totallerNodeID.GroupPath = groupPath

		baseContext.TotallerNodeID = totallerNodeID
	End If

	'Handle the subreport context
	Dim subrpt
	subrpt = DecodeUTF8(GetArgument("SUBRPT")) ' The Out of Place Subreport coordinates.

	If subrpt <> "" Then
		Dim charIndexVal, tmpCharIndexVal
		Dim tmpStr
		Dim OOPSSeqNo	'holds the page's OOPS sequence number
		Dim SubName	'holds the subreport name
		Dim subCoords 'holds the coordinates of the OOPS in the main report
		Dim mainRptPageNumber 'holds the page number for the main report in the subrpt parameter
		Dim XPosition, YPosition
		Dim subreportGroupPath 'holds the group path for the main report in subrpt parameter

		' Obtain the subreport sequence number
		charIndexVal = findChar(subrpt, ":")
		If charIndexVal > 1 Then
			OOPSSeqNo = Mid(subrpt, 1, charIndexVal - 1)
		End If
		' Obtain the subreport's name
		tmpStr = Mid(subrpt, charIndexVal + 1)
		charIndexVal = findChar(tmpStr, ":")
		If charIndexVal > 1 Then
			SubName = Mid(tmpStr, 1, charIndexVal - 1)
		End If
		tmpStr = Mid(tmpStr, charIndexVal + 1)
		charIndexVal = findChar(tmpStr, ":")
		' Obtain the group path for the Out of Place Subreport
		If charIndexVal > 1 Then
			subreportGroupPath = Mid(tmpStr, 1, charIndexVal - 1)
		End If
		'Obtain the main report page number after the fourth : character
		tmpStr = Mid(tmpStr,charIndexVal + 1)
		'Get the location of the fourth : seperator
		charIndexVal = findChar(tmpStr, ":")
		mainRptPageNumber = Mid(tmpStr, 1, charIndexVal - 1)
		'Get the coordinates portion of the SUBRPT parameter
		subCoords = Mid(tmpStr, charIndexVal + 1)
		Call GetDrillDownCoordinates(subCoords, XPosition, YPosition)

		'Create the subreport context object and set the values into it
		Dim subreportContext
		Set subreportContext = objectFactory.CreateObject("CrystalReports.SubreportRequestContext")

		subreportContext.SubreportName = SubName
		subreportContext.PageNumber = mainRptPageNumber
		subreportContext.XPosition = XPosition
		subreportContext.YPosition = YPosition

		If subreportGroupPath <> "" Then
			Dim subrptGroupPath
			Set subrptGroupPath = objectFactory.CreateObject("CrystalReports.GroupPath")

			subrptGroupPath.FromString subreportGroupPath

			Dim subrptTotallerNodeID
			Set subrptTotallerNodeID = objectFactory.CreateObject("CrystalReports.TotallerNodeID")
			subrptTotallerNodeID.GroupPath = subrptGroupPath

			subreportContext.TotallerNodeID = subrptTotallerNodeID
		End If

		baseContext.SubreportRequestContext = subreportContext
	End If

	'Handle any Selection Formula
	Dim sf
	sf = GetArgument("sf")
	If sf <> "" Then
		Dim reportStateInfo
		Set reportStateInfo = objectFactory.CreateObject("CrystalReports.ReportStateInfo")
		reportStateInfo.SelectionFormula = sf

		baseContext.ReportStateInfo = reportStateInfo
	End If

	Set CreateBaseContext = baseContext
End Function

Function GetPageNumber()
	Dim pageNumber
	pageNumber = UCase(GetArgument("page"))

	' Check to make sure there is a page requested, if not use 1 as a default
	If pageNumber <> "" And NOT IsNumeric(pageNumber) Then
		pageNumber = "1"
	End If

	GetPageNumber = pageNumber
End Function

' Helper function to parse coordinates passed by viewers and place into independent variables.
Sub GetDrillDownCoordinates(ByVal strParam, ByRef xCoord, ByRef yCoord)
	Dim liStringLength
	Dim lbDone
	Dim lsBuf
	Dim x

	liStringLength = Len(strParam)
	lbDone = FALSE
	lsBuf = ""
	xCoord = ""
	yCoord = ""
	For x = 1 To liStringLength
		lsBuf = Mid(strParam, x, 1)

		'ignore this character
		If lsBuf = "-" Then
			lsBuf = ""
			lbDone = True
		End if

		If lbDone Then
			yCoord = yCoord + lsBuf
		Else
			xCoord = xCoord + lsBuf
		End If
	Next
End Sub

'  Helper function that returns the index of the character in the given string.
Function findChar(findStr, charToFind)
	Dim lenStr
	Dim result
	Dim charCounter
	Dim tmpChar

	lenStr = Len(findStr)
	result = -1

	If lenStr > 0 Then
		charCounter = 1
		Do While(charCounter <= lenStr)
			tmpChar = Mid(findStr,charCounter,1)
			If(tmpChar = charToFind) Then
				result = charCounter
				Exit Do
			End If
			charCounter = charCounter + 1
		Loop
	End If

	findChar = result
End Function

Sub CheckForEMFHandler()
	'  The oEMF object is a helper object to create EMFs (Ecapsulated Messages) for the viewers.
	'  The viewers use EMFs to display errors and navigate to specific pages of the report.
	'  EMFGEN version 2 is required because it implements the SendBranchesStringEMF method.
	If Not IsObject(Session("oEMF")) Then
	   Set Session("oEMF") = Server.CreateObject("CrystalReports.EMFGen")
	   Call CheckForError
	End if
End Sub

Sub SetEMFError(errorCode, errorMessage)
	CheckForEMFHandler

	Response.ContentType = "application/x-emf" 'EMF MIME Type
	Session("oEMF").SendErrorMsg errorCode, errorMessage
End Sub

Sub SetEMFPageNumber(n)
	CheckForEMFHandler

	Response.ContentType = "application/x-emf" 'EMF MIME Type
	Session("oEMF").SendPageNumberRecord n
End Sub

Sub SetEMFGroupInfo(groupName, groupPath)
	CheckForEMFHandler

	Response.ContentType = "application/x-emf" 'EMF MIME Type
	Session("oEMF").GroupName = groupName
	Session("oEMF").SendBranchesStringEMF groupPath
End Sub

Sub CheckForError()
	If Err.Number <> 0 Then
		SetEMFError 1, "Error Occured on Server. " & Err.Number  & " : " & Err.Description
		Response.End
	End if
End Sub

Function DecodeUTF8(ByRef s)
	If s <> "" Then
		CheckForEMFHandler

		DecodeUTF8 = UCase(session("oEMF").DecodeUTF8String(s))
	Else
		DecodeUTF8 = s
	End If
End Function

Function GetArgument(argumentName)
	'Preference goes to the Form first, since POST data is the preferred method
	'of transmitting variable-length data

	Dim t
	t = Request.Form(argumentName)

	If t = "" Then
		t = Request.QueryString(argumentName)
	End If

	GetArgument = t
End Function

%>