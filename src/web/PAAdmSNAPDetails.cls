Class web.PAAdmSNAPDetails Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 161;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SNAPD_RowId";

Parameter SQLDESCRIPTION = "SNAPD_RowId";

Parameter SQLROWID = "SNAPD_RowId";

ClassMethod websysSNAPDetSave(compref As %String, id As %String, nextflag As %String = "")
{
}

ClassMethod CheckValidDates(SNAPEpisodeID As %Library.String, ID As %Library.String, date As %Library.String = "") As %Library.String
{
}

ClassMethod CheckBeforeDelete(ID As %Library.String)
{
}

ClassMethod websysSNAPDetSaveNew(compref As %String, id As %String, snapepid As %String, nextflag As %String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

Query FindSNAPDetailsForEpisode(SNAPEpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPDRowId,SNAPDDate,ADLSTDesc,SNAPDScore,SNAPPHDesc,SNAPDParRef,SNAPNumber,ADLSTCode")
{
SELECT SNAPD_RowId,SNAPD_Date,SNAPD_ADLSubType_DR->ADLST_Desc,SNAPD_Score,SNAPD_Phase_DR->SNAPPH_Desc,SNAPD_ParRef,SNAPD_ParRef->SNAP_Number,SNAPD_ADLSubType_DR->ADLST_Code 
FROM SQLUser.PA_AdmSNAPDetails
WHERE SNAPD_ParRef = :SNAPEpisodeID
ORDER By SNAPD_Date,SNAPD_ADLSubType_DR->ADLST_Desc
}

Query LookUpResticted(dval As %String, reststring As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "hidden,code,desc,visitstat")
{
SELECT RST_Desc,RST_RowId,RST_Code,RST_VisitStatus
FROM SQLUser.PAC_ReferralStatus
WHERE ((RST_Desc %STARTSWITH :dval) OR (RST_Code %STARTSWITH :dval) OR (:dval IS NULL))
AND ((RST_DateFrom <= CURRENT_DATE OR RST_DateFrom IS NULL) AND (RST_DateTo >= CURRENT_DATE OR RST_DateTo IS NULL))
AND (({fn CONCAT( '^', {fn CONCAT((:reststring),'^')})} [ {fn CONCAT( '^', {fn CONCAT((RST_VisitStatus),'^')})}) OR (:reststring IS NULL))
ORDER BY RST_DESC
}

ClassMethod LookUpRestrictedBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", reststring As %Library.String = "") As %Library.Boolean
{
}

Query LookUpFreeAlias(code As %String, desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Alias Text:%String")
{
}

ClassMethod LookUpFreeAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFreeAliasFetch ]
{
}

ClassMethod LookUpFreeAliasExecute(ByRef QHandle As %Library.Binary, code As %Library.String, desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpFreeAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFreeAliasExecute ]
{
}

}
