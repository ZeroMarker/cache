Class web.EPVisitTestSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetARCIMFromTestSetCode(ExtCode As %String, RecLoc As %String) As %String
{
}

ClassMethod GetLabStatusCode(OrderID As %String = "") As %String
{
}

/*
ClassMethod GetDirectories(StartDir As %String, ByRef dirArr)
{
 ; Log 64171 YC - GetDirectories was called from GetLabResultType - quite certain it is not used anymore
 ; Let's comment it out and see if anything falls over (03/07/2007)
 ;
 n (StartDir, dirArr)
 i StartDir="" q
 k dirArr 

  // old stuff - doesn't work on unix...
 ; search for all files/dirs under the lab directory
 ;s file=$ZSE(StartDir_"*")
 ;f x=1:1 q:file=""  d
 ;. s dirname=$p(file,"\",$l(file,"\")) 
 ;. ; make sure dirname is a directory (no ".") and dirname is a number (date)
 ;. i (dirname'["."),+dirname'=0,file'=0 d
 ;. . q:$l(dirname)>8
 ;. . ; pad right with zeros if dirname is less than 8 chars
 ;. . s child="00000000",$e(child,1,$l(dirname))=dirname
 ;. . ; build array of directory names
 ;. . s dirArr(child)=dirname
 ;. . ; get next file/dir in the directory
 ;. s file=$ZSE("")
 
 
 ; This logic works for BOTH Windows AND Unix.
 ; Log 59596 - AI - 12-07-2006 : Debugging and Unix logic.
 i $d(^ZAGI("debug")) s ^ZAGI("GetDirectories","01")=$g(StartDir)
 s rs=##class(%ResultSet).%New("%File:FileSet") q:'rs
 ; get ALL directories
 d rs.Execute(StartDir,"*","",1)
 f  q:'rs.Next()  d
 . ; ONLY directories
 . q:rs.GetDataByName("Type")'="D"
 . s dirname=rs.GetDataByName("ItemName")
 . ; only directory names of 1-8 chars
 . q:dirname'?1.8N
 . ; pad right with zeros if dirname is less than 8 chars
 . s child="00000000",$e(child,1,$l(dirname))=dirname
 . ; build array of directory names
 . s dirArr(child)=dirname
 . i $d(^ZAGI("debug")) s ^ZAGI("GetDirectories","02",child)=$g(dirname)
 
 q
}
*/
/// Log 59596 - AI - 23-06-2006 : LocationExtension is any subdirectory(ies) under the "Lab Word Results" Virtual Directory.
///                             : Change a lot of this method. Debugging, Unix and Windows, etc.
ClassMethod GetLabResultType(TestSet As %String, ByRef LabResultLocation As %String, LabEpisodeNo As %String = "", labcounter As %String = "", ByRef LocationExtension As %String, ByRef Slash As %String) As %String
{
}

ClassMethod FindCollectReceiptDateTime(OrderID As %String, ByRef CollectDate As %Date, ByRef CollectTime As %Time, ByRef ReceiptDate As %Date, ByRef ReceiptTime As %Time) As %String
{
}

ClassMethod CheckForSetActions(orderids As %Library.String = "", labepisodeno As %Library.String = "", age As %Library.String = "", sex As %Library.String = "", collectdate As %Library.String = "", collecttime As %Library.String = "", receivedate As %Library.String = "", receivetime As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DisplayPreviousResultsButton() As %Library.String
{
}

ClassMethod DisplaySensitivitiesButton() As %Library.String
{
}

ClassMethod GetARCIMFromExtCode(ExtCode As %Library.String) As %Library.String
{
}

ClassMethod GetPatientBloodType(PatientID As %Library.String = "") As %Library.String
{
}

/// Log 37767 - AI - 31-10-2003 : Created method to return the test set's comments, given the OrderItemID.
/// 				 Called from both OEOrdItem.TabularResultsEMR and EPVisitTestSet.CommentsView.
ClassMethod GetTestSetComments(ID As %Library.String = "") As %Library.String
{
}

ClassMethod GetOrderIDFromVisitTestSetRowID(VisitTestSetRowID As %Library.String) As %Library.String
{
}

ClassMethod GetVisitTestSetRowID(OrderID As %Library.String) As %Library.String
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod ItemSensitivityListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemSensitivityListFetch ]
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod ItemSensitivityListExecute(ByRef QHandle As %Library.Binary, LabEpisodeID As %Library.String, TestSetCode As %Library.String, TestItemCode As %Library.String, Cnt As %Library.String) As %Library.Status
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod ItemSensitivityListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemSensitivityListExecute ]
{
}

ClassMethod AntiBioSens(LabEpisodeID As %Library.String, OrderID As %Library.String, OnlyThisOrderID, ResultStatusList As %Library.String = "") As %Library.Status
{
}

/// Author - John Hart
/// Purpose - To View Lab Result Audit Trail
/// Used by - EPR
ClassMethod AntiBioSensGet(LabEpisodeID As %Library.String, ByRef AntiLIST As %Library.String, OrderID As %Library.String, OnlyThisOrderID, ResultStatusList As %Library.String = "") As %Library.Status
{
}

ClassMethod AntiBioSensShow(LabEpisodeID As %Library.String, ByRef AntiLIST As %Library.String, OrderID As %Library.String) As %Library.Status
{
}

ClassMethod LabResultsAuditListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LabResultsAuditListFetch ]
{
}

/// Author - John Hart
/// Purpose - To View Lab Result Audit Trail
/// Used by - EPR
ClassMethod LabResultsAuditListExecute(ByRef QHandle As %Library.Binary, TestItemID As %Library.String) As %Library.Status
{
}

/// Author - John Hart
/// Purpose - To View Lab Result Audit Trail
/// Used by - EPR
ClassMethod LabResultsAuditListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LabResultsAuditListExecute ]
{
}

ClassMethod MarkResultAsRead(OrderID As %Library.String, ResultID As %Library.String, ResultType As %Library.String)
{
}

Query ItemSensitivityList(LabEpisodeID As %String, TestSetCode As %String, TestItemCode As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,AntiB:%String,Sensitivity:%String")
{
}

Query LabResultsAuditList(TestItemID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,AUDDate:%String,AUDTime:%String,Result:%String,Comment:%String,Tagged:%String,AUDUser:%String,ResultStatus,ResultRefRangeLow,ResultRefRangeHigh,InstrumentFlags,DisplaySequence,ResultUnit")
{
}

ClassMethod websysSaveSensitivities(compref As %String, id As %String, AllOrderIDs As %String) As %Boolean
{
}

/// if using LabTrak -> PatientID should be patient regonum
/// if using external lab system -> PatientID should be patient rowid
/// restrict search across episodes where collection date is within past WithinDays
/// WithinDays="" means all dates which is different from WithinDays=0 meaning today only
/// used in order questions (web.ARCItemQuestion).DisplayTestItemResults
ClassMethod GetRecentTCResult(PatientID As %Library.String = "", TestItem As %Library.String = "", WithinDays As %Library.String = "", ByRef RESDATA As %Library.String)
{
}

}
