<%@ Language=VBScript %>
<%Option Explicit%>

<%
Function RegKey(sKey)
	Dim Sh
	Set Sh = CreateObject("WScript.Shell")
	On Error Resume Next
	RegKey = 0
	ret = Sh.RegRead(sKey)
	If Err.Number = 0 Then
		RegKey = 1
	ElseIf CBool(Instr(Err.Description,"Unable")) Then
		RegKey = 1
	End If
	Err.Clear: On Error Goto 0
End Function

if RegKey("HKEY_CLASSES_ROOT\ChartFX.ASP.Server\CurVer")=1 then
	Server.Transfer "epr.emrgraph.62.asp"
Else
	Server.Transfer "epr.emrgraph.55.asp"
End If

%>


