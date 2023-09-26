Class web.MRSickNote Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLCODE = "NOT_RowId";

Parameter SQLDATEFROM = "NOT_StartDate";

Parameter SQLDATETO = "NOT_EndDate";

Parameter SQLDESCRIPTION = "NOT_RowId";

Parameter SQLROWID = "NOT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetConsultCareProv(ConsultID As %String = "") As %String
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod HasSickNote(EpisodeID As %String = "") As %String
{
}

Query Find(mradm As %String, ConsultID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,CreateDate:%Date,CreateTime:%Time,StartDate:%Date,EndDate:%Date,Status:%String,CareProv:%String,Diagnosis:%String,Remarks:%String,Complaints:%String,MedCertType:%String,LastUpdateDate:%Date,LastUpdateTime:%Time,LastUpdateUser:%String,LastUpdateHosp:%String")
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// ab 20.07.06 59776
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, mradm As %String = "", ConsultID As %String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

}
