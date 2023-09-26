Include webimport

IncludeGenerator webimport

Class web.MRPresentIllness Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 321;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PRESI_RowId";

Parameter SQLDESCRIPTION = "PRESI_Desc";

Parameter SQLROWID = "PRESI_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod ListEMRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListEMRFetch ]
{
}

/// If the order by of the query is changed it will affect keywSummaryGet which is used in the EPR.
/// If changed make sure that still works.
/// Any question see John H or Trung
/// MRPresentIllnesses = MR Present Illnesses (Note the capital "I" followed by two lower-case "l"s- Ill.
ClassMethod ListEMRExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", mradm As %Library.String = "") As %Library.Status
{
}

ClassMethod ListEMRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListEMRExecute ]
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
/// 
/// Log 25878 - In this case we need to pass out the id for a child table to use.  This is why this is overwritten but the generated stuff is still there.
/// ID has been changed to pass by reference not value
ClassMethod websysSave(compref As %String, ByRef id As %String) [ CodeMode = generator ]
{
}

ClassMethod websysSaveIllness(compref As %Library.String, id As %Library.String)
{
}

/// Log 55973 - PC - 06-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PRESIDesc:%List,mradm:%String")
{
SELECT PRESI_RowID, PRESI_Desc, PRESI_ParRef
FROM MR_PresentIllness
WHERE (PRESI_RowID = :ID)
}

/// AI 05-Jul-2002: This Query is used in the ..obsSummaryGet method()
/// AI 05-Jul-2002: Changed this to be an Execute/Fetch/Close query so that it could be comma-delimited and returned as a string.
Query ListEMR(TSRTITM, TSRTORD, mradm As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,PRESIDesc:%String,PRESIDate:%Date,PRESITime:%Time,SSUSRName:%String,KeywordStr:%String,UpdateHospital:%String,PRESIDSReportFlag:%String,MRCIDDesc:%String,PRESIDateOnset:%Date,BODPDesc:%String,SYSDesc:%String,SUBSDesc:%String,PRESIEndDate:%Date,DSTATDesc:%String,EditCP")
{
}

ClassMethod ListHistClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListHistFetch ]
{
}

ClassMethod ListHistExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", mradm As %Library.String = "", Current As %Library.String = "") As %Library.Status
{
}

ClassMethod ListHistFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListHistExecute ]
{
}

Query ListHist(PatientID As %Library.String, mradm As %Library.String, Current As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,PRESIDesc:%String,PRESIDate:%Date,PRESITime:%Time,SSUSRName:%String,KeywordStr:%String,UpdateHospital:%String,PRESIDSReportFlag:%String,MRCIDDesc:%String,PRESIDateOnset:%Date,BODPDesc:%String,SYSDesc:%String,SUBSDesc:%String,PRESIEndDate:%Date,DSTATDesc:%String,HiddenFields:%String")
{
}

ClassMethod websysSaveHist() As %Boolean
{
}

/// Log 58610 - GC 20/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

}
