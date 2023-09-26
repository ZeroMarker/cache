<%

' Get QS variables
' This will print a document using word to the specified printer
'*****************************************************************************
' Interface definition
'*****************************************************************************
printer	= request.querystring("printer") 'Printer - \\SERVER\PRINTER
filename	= request.querystring("filename") 'e.g. c:\temp\fred.rtf (anything supported by word)
tdebug	= request.querystring("tdebug") '1 - enable tdebugging info and disable print
'*****************************************************************************
server.ScriptTimeout = 600 ' seconds

if tdebug=1 then
	response.Write "<HR><b>Print parameters</b><BR><BR>"
	response.Write "printer	= " & printer & "<BR>"
	response.Write "filename	= " & filename & "<BR>"
	response.Write "tdebug	= " & tdebug & "<BR>"
	response.Flush
end if

If Not IsObject (wrdApp) Then
	set wrdApp = server.CreateObject("Word.Application")
end if
wrdApp.DisplayAlerts = 0 'wdAlertsNone

'Set wrdDoc = wrdApp.Documents.Open(filename, False, True)
Set wrdDoc = wrdApp.Documents.Open(filename, False, True)

'Print the report
if tdebug=1 then
	response.Write "<HR>* PRINT NOT ENABLED IN tdebug MODE *" & "<BR>"
	response.Flush
else
	response.Write "milestone1" & "<BR>"
	response.Flush
	if printer<>"" then	
		response.Write "milestone2" & "<BR>"
		response.Flush
		sCurrPrinter = wrdApp.ActivePrinter
		wrdApp.ActivePrinter = printer
		wrdDoc.PrintOut 0
	    sCurrPrinter = wrdApp.ActivePrinter
	end if
	response.Write rpt & " printed to " & printer & "<BR>"
	response.Flush
end if
wrdApp.Quit(0)	'SA: 0=wdDoNotSaveChanges - prevents prompts to save which seem to leave WINWORD.EXE instances open on the server
set wrdDoc=nothing
set wrdApp=nothing
%>
