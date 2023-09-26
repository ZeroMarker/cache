Class web.MRCClinicalPathways Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 639;

Parameter SQLDATEFROM = "CPW_DateFrom";

Parameter SQLDATETO = "CPW_DateTo";

Parameter SQLCODE = "CPW_Code";

Parameter SQLDESCRIPTION = "CPW_Desc";

Parameter SQLROWID = "CPW_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindMultiProblemandStepClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMultiProblemandStepFetch ]
{
}

ClassMethod FindMultiProblemandStepExecute(ByRef QHandle As %Library.Binary, CPWDesc As %Library.String, GroupID As %Library.String = "", HOSPDesc As %Library.String = "", Location As %Library.String = "", CLPTDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod FindMultiProblemandStepFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMultiProblemandStepExecute ]
{
}

ClassMethod GetStepString(PathEpId As %Library.String, PathwayID As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerFindMultiProbStep(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String = "", val1 As %Library.String = "", val2 As %Library.String = "", val3 As %Library.String = "", val4 As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerFindMultiProbStep1(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod Show(PathwayID As %Library.String = "", PathEpID As %Library.String = "", PathStepID As %Library.String = "")
{
}

ClassMethod ShowAll(PathwayID As %Library.String)
{
}

Query FindMultiProblemandStep(CPWDesc As %String, GroupID As %String, HOSPDesc As %String, Location As %String, CLPTDesc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN:%String,prob:%String,HIDDEN:%String,ProbCode")
{
}

Query FindPathways(Pathway As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "HIDDEN:%String,CPWDesc:%String")
{
SELECT CPW_RowId, CPW_Desc
FROM SQLUser.MRC_ClinicalPathways
WHERE CPW_Desc  %STARTSWITH  :Pathway
ORDER BY CPW_Desc
}

Query FindPathwaysCode(Pathway As %Library.String, DateActive As %Library.String, PWTypeDR As %Library.String, HOSPDesc As %String, Location As %String, CLPTDesc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "HIDDEN:%String,CPWDesc:%String,CPWCode:%String")
{
SELECT CPW_RowId, CPW_Desc, CPW_Code
FROM SQLUser.MRC_ClinicalPathways
WHERE ((CPW_Desc  %STARTSWITH  :Pathway) OR (CPW_Code =:Pathway) OR (:Pathway IS NULL)) 
AND ((CPW_DateFrom <= :DateActive) OR (CPW_DateFrom IS NULL))
AND ((CPW_DateTo >= :DateActive) OR (CPW_DateTo IS NULL))
AND	((CPW_CPWTypeDR=:PWTypeDR) OR (:PWTypeDR IS NULL))
AND ((CPW_CPWTypeDR->CLPT_Desc=:CLPTDesc) OR (:CLPTDesc IS NULL))
AND ((CPW_CTLOC_DR->CTLOC_Desc=:Location) OR (:Location IS NULL))
AND ((CPW_Hospital_DR->HOSP_Desc=:HOSPDesc) OR (:HOSPDesc IS NULL))
ORDER BY CPW_Desc
}

Query FindSteps(PathEpId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,DAYSDesc:%String,HIDDEN:%String,EPEpisode:%String,EPRowId:%String")
{
SELECT DAYS_RowId, DAYS_Desc, DAYS_ParRef, DAYS_ParRef->EP_Episode, DAYS_ParRef->EP_RowId
FROM SQLUser.MRC_ClinPathwEpDays
WHERE  (DAYS_ParRef= :PathEpId)
}

/// Copied ListDiagnosis Query from web.MRDiagnos-ListEPRNew
/// JD for log 57868
ClassMethod ListDiagnosisExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", PAAdmTransactionID As %Library.String = "", GrpSetCarPrv As %Library.String = "", DischEpisodes As %String = "") As %Library.Status
{
}

ClassMethod ListDiagnosisFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod GetRow(rowid, parent, code)
{
}

ClassMethod ConvStepPathIdsToOrders(StepPathIds As %Library.String, ProbSttDate As %Library.String, HasIntervTest As %Library.String)
{
}

/// log 56894
ClassMethod SaveClinicalPathway(compref As %Library.String, ID As %Library.String)
{
}

ClassMethod ListDiagnosisClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindClinicalPathwayClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindClinicalPathwayFetch ]
{
}

ClassMethod FindClinicalPathwayExecute(ByRef QHandle As %Library.Binary, PathwayDesc As %Library.String = "", CLPTDesc As %Library.String = "", Location As %Library.String = "", HOSPDesc As %Library.String = "", ShowInactive As %Library.String = "", CPWRowId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindClinicalPathwayFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindClinicalPathwayExecute ]
{
}

ClassMethod Reschedule(compref As %Library.String)
{
}

Query ListDiagnosis(mradm, PAAdmTransactionID, GrpSetCarPrv, DischEpisodes) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,MRCIDCode,MRCIDDesc,DSYMDesc,DSTATDesc,MRDIADate,MRDIATime,MRDIADesc,MRDIAMRADMParRef,IcdID,DaggerAster,AltDesc,UpdateDate,UpdateTime,UpdateUserName,UpdateHospitalDesc,HRGDesc,ApptIds,EpisodeID,UserCreatedName,DeletionReasonDesc,MRDIADSReportFlag")
{
}

// seanl log 58214 Added from web.SSGroupClinPathwayType(W642DEVSOURCE)

Query FindPathwayForGroup(GroupID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CPWTypeDR")
{
SELECT	CPW_CPWType_DR
FROM	SQLUser.SS_GroupClnPathwayType
WHERE	CPW_ParRef=:GroupID
}

//Query FindAllPathways(DateActive As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CPWDesc,CPWCode")

//{

//SELECT	CPW_Desc,CPW_Code

//FROM	SQLUser.MRC_ClinicalPathways

//WHERE 	((CPW_DateFrom <= :DateActive) OR (CPW_DateFrom IS NULL))

//AND 	((CPW_DateTo >= :DateActive) OR (CPW_DateTo IS NULL))

//}

/// log 56894
Query FindClinicalPathway(PathwayDesc As %Library.String, CLPTDesc As %Library.String, Location As %Library.String, HOSPDesc As %Library.String, ShowInactive As %Library.String, CPWRowId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,CPWDesc,CLPTDesc,CPWNumberOfCycle,CPWStartDay,CPWDateFrom,CPWDateTo,CTLOCDesc,HOSPDesc,EPTotalDays,EPDesc,EPEpisode,EPRowId")
{
}

}
