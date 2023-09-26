Class web.RTCReasonRequest Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 113;

Parameter SQLDATEFROM = "REA_DateFrom";

Parameter SQLDATETO = "REA_DateTo";

ClassMethod LookUpReasonByLocBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", locid As %String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "REA_Code";

Parameter SQLDESCRIPTION = "REA_Desc";

Parameter SQLROWID = "REA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpReasColClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpReasColFetch ]
{
}

ClassMethod LookUpReasColExecute(ByRef QHandle As %Library.Binary, READesc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpReasColFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpReasColExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query FindReasonForRequest(ReasForRequest As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "READesc:%String,HIDDEN:%Library.String")
{
SELECT REA_Desc,REA_RowId
FROM SQLUser.RTC_Reason_Request
WHERE (REA_Desc  %STARTSWITH  :ReasForRequest) OR (REA_Code  %STARTSWITH  :ReasForRequest)
AND ((REA_DateFrom IS NULL) OR (Current_Date>=REA_DateFrom))
AND ((REA_DateTo IS NULL) OR (Current_Date<=REA_DateTo))
ORDER BY REA_Desc
}

Query FindReasonForRequestByLoc(ReasForRequest As %String, LocID As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "READesc:%String,REACode:%String,HIDDEN:%Library.String")
{
 SELECT	distinct REA_Desc,REA_Code,REA_RowId
 FROM	SQLUser.RTC_Reason_Request
 WHERE	((REA_Desc  %STARTSWITH  :ReasForRequest) OR (REA_Code  %STARTSWITH  :ReasForRequest)) AND
 (REA_RowId NOT IN (SELECT REA_RowId FROM SQLUser.RTC_Reason_Request,SQLUser.RTC_Reason_RequestHosp
 WHERE REA_RowId=HOS_ParRef)
 OR REA_RowId IN (SELECT REA_RowId FROM SQLUser.RTC_Reason_Request,SQLUser.RTC_Reason_RequestHosp,SQLUser.CT_Loc
 WHERE REA_RowId=HOS_ParRef AND
 HOS_Hospital_DR=CTLOC_Hospital_DR AND
 CTLOC_RowID=:LocID))
 AND ((REA_DateFrom IS NULL) OR (Current_Date>=REA_DateFrom))
 AND ((REA_DateTo IS NULL) OR (Current_Date<=REA_DateTo))
}

/// Gets the reason for request and the color stored for the reason in VB Code Tales.
Query LookUpReasCol(READesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ReaDesc:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String,")
{
}

Query LookupPartialDesc(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "desc:%String,HIDDEN:%String,Code:%String")
{
SELECT REA_Desc,REA_Rowid,REA_Code
FROM SQLUser.RTC_Reason_Request
WHERE (%ALPHAUP REA_Desc  %STARTSWITH  %ALPHAUP :desc)
AND ((REA_DateFrom IS NULL) OR (Current_Date>=REA_DateFrom))
AND ((REA_DateTo IS NULL) OR (Current_Date<=REA_DateTo))
ORDER BY REA_Desc
}

}
