Class web.OEFilmExecute Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 715;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OEFE_RowId";

Parameter SQLDESCRIPTION = "OEFE_RowId";

Parameter SQLROWID = "OEFE_RowId";

ClassMethod DeleteFilm(OEOrdItemIDs As %Library.String = "")
{
}

ClassMethod DeleteNSRAll(OEOrdItemIDs As %Library.String = "")
{
}

ClassMethod GetDTString(OEOREParRef As %String = "", newDT As %Library.String = "", oldDT As %Library.String = "")
{
}

ClassMethod GetFilmItemIDs(OEOrdItemIDs As %Library.String = "", oefilm As %Library.String = "") As %Library.String
{
}

/// For fetching data for multiple ordered items to web components.
/// By default, if only one ordered item(OEOrdItem) is passed retrieves all data,
/// As multiple items are grouped using OEFilmExecute and OEFilmExecuteItems
/// 
/// Passed in a string of OEOrdItem ids separated by "^".
ClassMethod GetMultiplePrePostExam(OEOrdItemIDs As %Library.String = "", firstitem As %Library.String = "")
{
}

ClassMethod GetNSR(OEOrdItemID As %Library.String = "") As %Library.String
{
}

/// Passed in a string of OEOrdItem ids delimited by "^"
/// Returns the OEFilmExecute id asso
ClassMethod GetOEFilmIDFromOrdItemID(OEOrdItemIDs As %Library.String = "")
{
}

ClassMethod LookUpBrokerNonStdReportReason(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod PrefPrePostExamItems() As %Library.String [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod PrefPrePostExamListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PrefPrePostExamListFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod PrefPrePostExamListExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod PrefPrePostExamListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = PrefPrePostExamListExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod PrefPrePostExamSave() [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod RestrictPreExamField(PatientID As %Library.String = "") As %String
{
}

ClassMethod UpdateDispensingTime(compref As %String = "", ID As %Library.String = "")
{
}

ClassMethod UpdateNSR(id As %String = "", NSRdesc As %Library.String = "")
{
}

ClassMethod websysSavePrePostExam(compref As %Library.String = "", OEOrdItemIDs As %Library.String = "")
{
}

Query DeleteFilmItem(OEORDItemID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ITMRowId")
{
select ITM_RowId 
from SQLUser.OE_FilmExecuteItems
where ITM_OEORI_DR=:OEORDItemID
}

Query DeleteNSR(OEORDItemID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ResRowId")
{
select RES_RowId 
from SQLUser.OE_OrdResult
where RES_ParRef=:OEORDItemID
}

Query FindDispensingTime(OEORID As %String, DispensingDate As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "OEOERowId,DispensingTime,ExecuteTime")
{
SELECT OEORE_RowId,OEORE_ExStTime,OEORE_DateExecuted
 FROM SQLUser.OE_OrdExec
 WHERE OEORE_OEORI_ParRef=:OEORID
 AND OEORE_ExStDate=:DispensingDate
}

Query FindOEOREByTime(OEOREParRef, DispensingTime) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "OEOERowId")
{
SELECT OEORE_RowId
 FROM SQLUser.OE_OrdExec
 WHERE OEORE_ExStTime=:DispensingTime
 AND OEORE_OEORI_ParRef=:OEOREParRef
}

Query GetFilmIDFromOeordItemID(OEORDItemID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "FilmID")
{
select ITM_ParRef
from SQLUser.OE_FilmExecuteItems
where ITM_OEORI_DR=:OEORDItemID
}

Query GetFilmsUsedID(OEORDItemID As %String, type) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "FU_RowId")
{
select FU_RowId from SQLUser.OE_FilmExecuteFilmsUsed, SQLUser.OE_FilmExecuteItems
where (ITM_OEORI_DR=:OEORDItemID)
AND ITM_RowId=FU_OEFilmExecuteItems_DR
AND FU_UsageType=:type
}

Query GetFilmsUsedIDs(OEORDItemID As %String, type) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "FU_RowId")
{
select FU_RowId from SQLUser.OE_FilmExecuteFilmsUsed, SQLUser.OE_FilmExecuteItems
where (ITM_OEORI_DR=:OEORDItemID)
AND ITM_ParRef=FU_ParRef
AND FU_UsageType=:type
}

Query GetResult(OEORDItemID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ResRowId")
{
SELECT RES_RowId FROM SQLUser.OE_OrdResult
WHERE RES_ParRef=:OEORDItemID
ORDER BY RES_Childsub DESC
}

Query LookUpNonStdReportReason(desc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{


SELECT  NSRIR_Desc,NSRIR_RowId,NSRIR_Code,NSRIR_AlternateReport
FROM SQLUser.OEC_NonSTDRepIssReason
WHERE ((%ALPHAUP NSRIR_Desc  [%ALPHAUP :desc) OR ( %ALPHAUP NSRIR_Code  [%ALPHAUP :desc) OR (:desc IS NULL))
ORDER BY NSRIR_Desc
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query PrefPrePostExamList() As %Library.Query(CONTAINID = 0, ROWSPEC = "code:%String,caption:%String,selected:%Boolean")
{
}

}
