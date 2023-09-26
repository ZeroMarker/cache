<%

Dim ClientDoc, ObjFactory, RptAppSession
Set ObjFactory = CreateObject("CrystalReports10.ObjectFactory.1")

Call BrowseRASHomeFolder()

Function BrowseRASHomeFolder()

    Dim DirMgr
    Set rptAppSession = objFactory.CreateObject("CrystalReports.ReportAppSession")
    rptAppSession.Initialize

    Set DirMgr = rptAppSession.CreateService("CrystalReports.ConnectionDirManager")

    'Open the ConnectionDirManager to browse reports and folders.
    DirMgr.open crDirectoryItemTypeFolder + crDirectoryItemTypeReport
	Dim Item
	For Each Item In DirMgr.GetRoots
		Response.Write Item.Name & "<BR>"
		Exit For	
	Next
	'Resonse.Write .Name
    'Start printing the tree.
    'PrintFolderItems DirMgr.GetRoots, DirMgr
    DirMgr.Close

End Function


'Given a DirectoryItems collection, print each item. If the item is a folder,
'print it's children.
Function PrintFolderItems(DirItems, DirMgr)

    Dim Item
    'Print all item names in this directory.
    For Each Item In DirItems
        Response.Write Item.Name & "<BR>"

        'If one of the items is a directory, print everything in that directory as well.
        If Not Item.IsLeaf Then
            PrintFolderItems DirMgr.GetChildren(Item), DirMgr
        End If
    Next
End Function



%>