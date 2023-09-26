Class web.PAAdmSNAP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 218;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SNAP_RowId";

Parameter SQLDESCRIPTION = "SNAP_RowId";

Parameter SQLROWID = "SNAP_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckMandatory(EpisodeID As %Library.String, INPATADMTYPE As %Library.String = "") As %Library.String
{
}

ClassMethod CheckSNAP(PatientID As %Library.String) As %Library.String
{
}

ClassMethod CheckSNAP1(PatientID As %Library.String, ADMINTTYPE As %Library.String = "") As %Library.String
{
}

ClassMethod FindEpisodeSNAPClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeSNAPFetch ]
{
}

ClassMethod FindEpisodeSNAPExecute(ByRef QHandle As %Library.Binary, regostring As %Library.String, admstring As %Library.String) As %Library.Status
{
}

ClassMethod FindEpisodeSNAPFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeSNAPExecute ]
{
}

ClassMethod FindEpisodeSNAPNClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeSNAPNFetch ]
{
}

ClassMethod FindEpisodeSNAPNExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, admstring As %Library.String = "") As %Library.Status
{
}

ClassMethod FindEpisodeSNAPNFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeSNAPNExecute ]
{
}

ClassMethod IsSNAPEpisode(EpisodeID As %Library.String, ADMINTTYPE As %Library.String = "") As %Library.String
{
}

ClassMethod websysSNAPSave(compref As %String, id As %String)
{
}

ClassMethod CheckValidDates(EpisodeID As %Library.String, ID As %Library.String, startdate As %Library.String = "", enddate As %Library.String = "") As %Library.String
{
}

ClassMethod CheckBeforeDelete(ID As %Library.String)
{
}

ClassMethod CheckBeforeNew(EpisodeID As %String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod CheckSNAPWard(adm As %Library.String) As %Library.String
{
}

/// w ##class(web.PAAdmSNAP).CheckSNAPMovementWard(77128)
/// 转移菜单上PAAdmLeave.List组件用
ClassMethod CheckSNAPMovementWard(EpisodeID As %Library.String) As %Library.String
{
	Q ""
}

/// md LOG 53755
ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

ClassMethod zCheckExternal(id As %String)
{
}

Query FindEpisodeSNAP(regostring As %String, admstring As %String, action As %String, btype As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SNAPRowId,SNAPDate,SNAPTime,SNAPPhase,SNAPScore,ADLCTDesc,ADLSTDesc,SNAPCTDesc ")
{
}

Query FindEpisodeSNAPN(PatientID As %String, admstring As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SNAPRowId,SNAPDate,SNAPTime,SNAPPhase,SNAPScore,ADLCTDesc,ADLSTDesc,SNAPCTDesc,SNAPParRef")
{
}

Query FindSNAPByEpisode(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPRowId,SNAPDate,SNAPTime,SNAPPhase,SNAPScore,ADLCTDesc,ADLSTDesc,SNAPCTDesc ,SNAPParRef")
{
SELECT SNAP_RowId,SNAP_Date,SNAP_Time,SNAP_Phase,SNAP_Score,SNAP_ADLCareType_DR->ADLCT_Desc,
SNAP_ADLSubType_DR->ADLST_Desc,SNAP_SNAPCareType_DR->SNAPCT_Desc,SNAP_ParRef 
FROM SQLUser.PA_AdmSNAP
WHERE SNAP_ParRef = :EpisodeID
}

Query FindSNAPEpisodeNew(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPRowId,SNAPNumber,SNAPStartDate,SNAPEndDate,SNAPCTDesc,ADLCTDesc,SNAPParRef,ADLCTCode")
{
SELECT SNAP_RowId,SNAP_Number,SNAP_StartDate,SNAP_EndDate,SNAP_SNAPCareType_DR->SNAPCT_Desc,SNAP_ADLCareType_DR->ADLCT_Desc,SNAP_ParRef,SNAP_ADLCareType_DR->ADLCT_Code 
FROM SQLUser.PA_AdmSNAP
WHERE SNAP_ParRef = :EpisodeID
}

}
