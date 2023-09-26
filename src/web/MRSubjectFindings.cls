Class web.MRSubjectFindings Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 281;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SUBF_RowId";

Parameter SQLDESCRIPTION = "SUBF_RowId";

Parameter SQLROWID = "SUBF_RowId";

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Log 64759 YC - Created websys save for MRSubjectFindings.Edit
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod websysSaveSOAP(compref As %String, id As %String)
{
}

ClassMethod SaveToObj(compid, ID, mradm, Comments, OnsetDate, ConsultID, ChiefComplaints, BodySite, Laterality, Severity, DurationNum, DurationUnit, user, hosp, ApproxOnsetDate, OnsetTime, EndDate, EndTime) As %Library.String
{
}

ClassMethod websysSaveSnomed(compref As %String, id As %String)
{
}

ClassMethod ListSnomedExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", ConsultID As %Library.String = "", ShowSnomed As %Library.String) As %Library.Status
{
}

ClassMethod ListSnomedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListSnomedExecute ]
{
}

ClassMethod ListSnomedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListSnomedFetch ]
{
}

/// Log 63805 YC - For Deleting Snomed Chief Complaints
ClassMethod websysDeleteSnomed(ID As %Library.String = "")
{
}

Query TempDeleteAtWill(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SUBF_Date,SUBF_ParRef,SUBF_Text,SUBF_Time,CTPCP_Desc")
{
SELECT SUBF_RowId, SUBF_Date, SUBF_ParRef, SUBF_Text, SUBF_Time, SUBF_CTCP_DR->CTPCP_Desc
FROM SQLUser.MR_SubjectFindings
WHERE SUBF_ParRef = :mradm
}

Query ListSnomed(mradm As %Library.String = "", ConsultID As %Library.String = "", ShowSnomed As %Library.String = 0) As %Library.Query(ROWSPEC = "ID,EnteredDate,EnteredTime,UpdateUser,UpdateDate,UpdateTime,UpdateHosp,DiagSignSym,Duration,DurationUnit,Comments,Qualifiers,ApproxOnsetDate,BodySiteID,LateralityID,SeverityID,SnoDiagSignSym,OnsetDate,OnsetTime,EndDate,EndTime,mradm")
{
}

}
