dim crystalversion
crystalversion="Not Installed"
if IsRegKey("HKLM\Software\Crystal Decisions\10.0\Crystal Reports")=1 then
	crystalversion="10"
end if
if IsRegKey("HKLM\Software\Business Objects\Suite 11.0\Enterprise")=1 then
	crystalversion="11"
end if
if IsRegKey("HKLM\Software\Business Objects\Suite 11.5\Enterprise")=1 then
	crystalversion="115"
end if

crystalversion="Crystal Version Installed: " + crystalversion

WScript.Echo crystalversion

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
