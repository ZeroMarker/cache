<%

' Get QS variables
'*****************************************************************************
' Interface definition
'*****************************************************************************
rpt		= request.querystring("rpt") 'The report name (excluding .rpt)
site	= request.querystring("site") 'Site code - from websys.Configuration
printer	= request.querystring("printer") 'Printer - \\SERVER\PRINTER
saveas	= request.querystring("saveas") 'e.g. c:\temp\fred.rtf (for now only rtf
'Page layout info - lanscape etc etc
'prompt0-prompt99 ' Report specific parameters 
'viewer = request.querystring("init") 'Viewer - not applicable to printing
tdebug	= request.querystring("tdebug") '1 - enable tdebugging info and disable print
'*****************************************************************************
server.ScriptTimeout = 600 ' seconds

if tdebug=1 then
	response.Write "<HR><b>Print parameters</b><BR><BR>"
	response.Write "rpt		= " & rpt & "<BR>"
	response.Write "site	= " & site & "<BR>"
	response.Write "printer	= " & printer & "<BR>"
	response.Write "saveas	= " & saveas & "<BR>"
	response.Write "tdebug	= " & tdebug & "<BR>"
	response.Flush
end if

'build full path for report

'beware - this uses the length of the asp file name and assumes a standard structure.
'remove \csp\websys.print.csp
'add on the report info
rpttoview = MID(request.ServerVariables("PATH_TRANSLATED"), 1, (LEN(request.ServerVariables("PATH_TRANSLATED"))-24))

if tdebug=1 then
	response.Write "<HR><b>Report Info</b><BR><BR>"
	response.Write rpttoview & "<BR>"
	response.Flush
end if
	
rpttoview = rpttoview & "\custom\" & site & "\reports\" &  rpt & ".rpt"
' build path to MDB

if tdebug=1 then
	response.Write "*" & rpttoview & "*" & "<BR>"
	response.Flush
end if

' Only create the Crystal Application Object on first time through
If Not IsObject ( session ("oApp")) Then
Set session ("oApp") = Server.CreateObject("Crystal.CRPE.Application")
End If

' Turn off all Error Message dialogs
Set oGlobalOptions = Session ("oApp").Options
oGlobalOptions.MorePrintEngineErrorMessages = 0

' Open the report
If IsObject(session("oRpt")) then
	Set session("oRpt") = nothing
End if   
Set session("oRpt") = session("oApp").OpenReport(rpttoview,1)
'Set session("oRpt") = session("oApp").OpenReport("C:\ETrak\CUSTOM\ARMC\REPORTS\ctsex.rpt",1)

' Turn off sepecific report error messages
Set oRptOptions = Session("oRpt").Options
oRptOptions.MorePrintEngineErrorMessages = 0

cnt=0
response.Write "<HR><b>Report parameters</b><BR><BR>"
For Each param In Session("oRpt").ParameterFields
	'Keep the param name in line with crystal web report server
	prm=Request.QueryString("Prompt" & cnt)
	
	if tdebug=1 then
		response.Write cnt & " " & param.ParameterFieldName & " = " & prm  _
		 & " kind= " & param.kind _
		 & " needs= " & param.needsCurrentValue _
		 & " valuetype=" & param.ValueType & "<BR>"
		response.Flush
	end if
	'
	' Params used in linked reports do not need a value
	if param.needsCurrentValue then
		'Number
		If param.ValueType = 7 then 
			param.SetCurrentValue clng(prm)
		else ' we probably have to do something more clever for dates (ValueType=12)
			param.SetCurrentValue cstr(prm)
		end if
	end if
    cnt=cnt+1
Next

'printer driver, printer name, printer port
if printer<>"" then
	Set oPrint = Server.CreateObject("TRAK_PRINT.Printers")
	Set oPrinters=oPrint.GetAll()

	for each oPrinter in oPrinters
		if tdebug=1 then Response.Write oPrinter.DriverName & "; " & oPrinter.DeviceName & "; " & oPrinter.Port
		if ucase(oPrinter.DeviceName)=ucase(printer) then
			Session("oRpt").SelectPrinter oPrinter.DriverName, oPrinter.DeviceName, oPrinter.Port
			if tdebug=1 then Response.Write " ***"
		end if
		if tdebug=1 then Response.Write "<BR>"
	next
	set oPrinters=nothing
	set oPrint=nothing
end if
Set pagesetup = Session("oRpt").pagesetup
    
'pagesetup.PaperOrientation = 2
    
' Opening the page engine will cause the data to be read
Set pageengine = Session("oRpt").pageengine

'Print the report
if tdebug=1 then
	response.Write "<HR>* PRINT NOT ENABLED IN tdebug MODE *" & "<BR>"
	response.Flush
else
	if printer<>"" then	
		Session("oRpt").PrintOut false
	end if
	response.Write rpt & " printed to " & printer & "<BR>"
	response.Flush
end if

'Save the report as an rtf
if saveas<>"" then
	set Session("oExport") = Session("oRpt").ExportOptions
	Session("oExport").DiskFileName = saveas
	Session("oExport").UseReportDateFormat = True
	Session("oExport").UseReportNumberFormat = True
	Session("oExport").FormatType = 4 'rtf
	Session("oExport").DestinationType = 1
	Session("oRpt").Export(False)
	response.Write rpt & " saved as " & saveas & "<BR>"
	response.Flush
end if
'
%>

