<%
' Copyright © 1997-2002 Crystal Decisions, Inc.
%>
<HTML>
<HEAD>
<TITLE>Session Cleanup</Title>
</HEAD>
<BODY Onload="CallClose();">
<%
'This page is used to clean up any objects remaining in a
'a user's session.  This page is called by a new browser window that is launched when
'a user closes a browser window containing a Crystal Reports viewer.
'
'It causes a brief flash while this page is displayed.  This is necessary
'in order to reclaim resources and maintain licence counts.
'
'You want to make sure that you clean up any instances of the 
'objects for 2 reasons:
'1) Licensing
'2) Resources

'This function takes an object (by reference rather than by value) and destroys it.
'If the object was destroyed we return true otherwise we return false.
Function DestroyObjects(ByRef ObjectToDestroy)
  If isobject(ObjectToDestroy) Then
    Set ObjectToDestroy = Nothing
    DestroyObjects = True
  Else
    DestroyObjects = False
  End If
End Function

If DestroyObjects(Session("oClientDoc")) Then
  Response.Write("Session data released" & "<BR>")
Else
  Response.Write("Session data could not be released" & "<BR>")
End If

DestroyObjects(Session("oEMF"))

%>
<SCRIPT LANGUAGE="Javascript">

function CallClose()
{
	window.close();
}
</SCRIPT>
</BODY>
</HTML>
<%
'The javascript code is used to close the newly opened browser window once the page has run
Session.Abandon
Response.End
'These last two lines terminate that user's active session and flushes html to the browser.
%>
