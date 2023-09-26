Class web.MRClinicalPathWays Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1927;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CPW_RowId";

Parameter SQLDESCRIPTION = "CPW_RowId";

Parameter SQLROWID = "CPW_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod ShowOrderChartTable()
{
}

ClassMethod GetDefaultServiceForStep(OEORIRowID As %String = "") As %Library.String
{
}

ClassMethod ClearConfSchedule()
{
}

ClassMethod ChangeApptStatus(id As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DeleteDiagnosis(mradm As %Library.String, CPWGroup As %Library.String, CPWRowId As %Library.String = "")
{
}

ClassMethod FindApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindApptsFetch ]
{
}

ClassMethod FindApptsExecute(ByRef QHandle As %Library.Binary, ApptDts As %Library.String, ApptTms As %Library.String) As %Library.Status
{
}

ClassMethod FindApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindApptsExecute ]
{
}

ClassMethod FindClinicalPathwaysListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindClinicalPathwaysListFetch ]
{
}

ClassMethod FindClinicalPathwaysListExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", EpisodeID As %Library.String = "", AcrossEpisodes As %Library.String = 0, ClosedProblems As %Library.String = 0, SummaryView As %Library.String = 0, PathwayDesc As %Library.String = "", HOSPDesc As %Library.String = "", Location As %Library.String = "", CLPTDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod FindClinicalPathwaysListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindClinicalPathwaysListExecute ]
{
}

ClassMethod FindNursingActions(CPWRowId As %Library.String = "") As %Library.String
{
}

ClassMethod GetProblemDates(CPWRowId As %Library.String = "") As %Library.String
{
}

ClassMethod FindPathwaysClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPathwaysFetch ]
{
}

ClassMethod FindPathwaysExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPathwaysFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPathwaysExecute ]
{
}

ClassMethod FindPatientOrdersApptClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientOrdersApptFetch ]
{
}

/// Log 28364 PeterC 23/09/02
/// 
/// Method modified from FindPatientOrdersExecute
ClassMethod FindPatientOrdersApptExecute(ByRef QHandle As %Library.Binary, ApptID As %Library.String) As %Library.Status
{
}

ClassMethod FindPatientOrdersApptFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientOrdersApptExecute ]
{
}

ClassMethod FindPatientOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientOrdersFetch ]
{
}

ClassMethod FindPatientOrdersExecute(ByRef QHandle As %Library.Binary, ORIRowIDs As %Library.String) As %Library.Status
{
}

ClassMethod FindPatientOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientOrdersExecute ]
{
}

ClassMethod GetAllServiceIDs(ARCIMIDs As %Library.String) As %Library.String
{
}

ClassMethod GetDefaultService(OEORIRowID As %Library.String = "") As %Library.String
{
}

ClassMethod GetDiagnosis(Parref As %Library.String) As %Library.String
{
}

ClassMethod GetOrderSetOrders(CPWRowId As %Library.String = "") As %Library.String
{
}

ClassMethod GetProblemDescription(PathEpID As %Library.String) As %Library.String
{
}

ClassMethod GetPathsComment(id As %Library.String = "") As %Library.String
{
}

ClassMethod GetGoalTargetDate(id As %Library.String = "") As %Library.String
{
}

ClassMethod GetStatusAndOutCome(id As %Library.String = "") As %Library.String
{
}

ClassMethod GetStepPathIds(CPWRowId As %Library.String, mradm As %Library.String) As %Library.String
{
}

ClassMethod GetCPWPathWays(mradm As %Library.String) As %Library.String
{
}

ClassMethod GetUnScheduledORIRowIDs(PatientID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod ShowOrderItemRow(ByRef rsQry As %Library.String, cpwID As %Library.String, cpwDesc As %Library.String, datefr As %Library.String, daystoview As %Library.String, ByRef statusColourLIST As %Library.String, row As %Library.String, qrycnt As %Library.String, lnk As %Library.String = "", PathEpid As %Library.String = "", StepID As %Library.String = "", stepdesc As %Library.String = "", Diagnosis As %Library.String = "", Status As %Library.String = "", mradm As %Library.String = "", PatientID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod UpdateSchedule(PatientID As %Library.String, EpisodeID As %Library.String, rescID As %Library.String)
{
}

ClassMethod UpdateSchedule1(PatientID As %Library.String, EpisodeID As %Library.String)
{
}

ClassMethod checkConfSchedule() As %Library.Boolean
{
}

ClassMethod websysInsert(mradm As %Library.String, PathwayID As %Library.String, ByRef PathwayDR As %Library.String, ByRef StepPathIds As %Library.String, Comments As %Library.String = "", Status As %Library.String = "", Outcomes As %Library.String = "")
{
}

ClassMethod websysInsertCPWGoalText(mradm As %Library.String, PathwayID As %Library.String, PathEpID As %Library.String, CPWGoalText As %Library.String, ByRef CPWRowId As %Library.String, CPWPathwayDR As %Library.String = "", CPWNurseAction As %Library.String = "")
{
}

ClassMethod websysInsertDiagnosis(mradm As %Library.String, PathwayDR As %Library.String, DiagnosisIDs As %Library.String = "", CLPSId As %Library.String = "", CLPOId As %Library.String = "", Comments As %Library.String = "", DeleteFlag As %Library.Boolean = "", CPWNurseAction As %Library.String = "", GoalTargetDate As %Library.String = "", ProbStartDate As %Library.String = "", ProbEndDate As %Library.String = "", ProbRevDate As %Library.String = "", CareProvider As %Library.String = "")
{
}

ClassMethod websysInsertStep(mradm As %Library.String, PathwayID As %Library.String, PathEpID As %Library.String, StepID As %Library.String, ByRef PathwayDR As %Library.String, Comments As %Library.String = "", Status As %Library.String = "", Outcomes As %Library.String = "")
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

ClassMethod websysSaveStep(compref As %Library.String, id As %Library.String, mradm As %Library.String, PathwayID As %Library.String, PathEpID As %Library.String, StepID As %Library.String)
{
}

Query Find(mradm As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,EPDesc:%String,EPEpisode,DAYSDesc:%String,DAYSDay,CPWUsedFlag:%String,CPWIDDate:%Date,CPWIDTime:%Time,pathwayID,pathwayDesc,pathEpid,StepID")
{
SELECT CPW_RowID, CPW_Pathways_DR->DAYS_ParRef->EP_Desc, CPW_Pathways_DR->DAYS_ParRef->EP_Episode, CPW_Pathways_DR->DAYS_Desc, CPW_Pathways_DR->DAYS_Day, CPW_UsedFlag, CPW_IDDate, CPW_IDTime, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef->CPW_Desc,CPW_Pathways_DR->DAYS_ParRef,CPW_Pathways_DR
FROM SQLUser.MR_ClinicalPathWays
WHERE CPW_ParREf = :mradm
}

/// Log 28364 PeterC 23/09/02
/// 
/// Find OEORIRowIds of all item associated with a particular appointment.
Query FindApptID(ApptID As %String, SerARCIM As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OEORIRowID:%String")
{
select OEORI_RowId
from SQLUser.OE_OrdItem
where OEORI_Appt_DR=:ApptID
}

Query FindAppts(ApptDts As %Library.String, ApptTms As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ApptDate:%Library.String,ApptTime:%Library.String")
{
}

Query FindCPWRowIDs(mradm As %Library.String, CPWNumber As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CPWRowId:%String")
{
SELECT CPW_RowId
FROM SQLUser.MR_ClinicalPathways
WHERE ((CPW_Number=:CPWNumber) AND (CPW_ParREf= :mradm))
}

Query FindClinicalPathway() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "")
{
SELECT CPW_Pathways_DR->DAYS_ParRef->EP_Episode, CPW_Pathways_DR->DAYS_Desc, CPW_IDDate, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef->CPW_Desc
FROM SQLUser.MR_ClinicalPathWays
}

Query FindClinicalPathwaysList(PatientID As %String, EpisodeID As %String, AcrossEpisodes As %String, ClosedProblems As %String, SummaryView As %String, PathwayDesc As %String, HOSPDesc As %String, Location As %String, CLPTDesc As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,EPDesc:%String,DAYSDesc:%String,IDDate:%Date,CPWDesc:%String,CTPCPDesc:%String,PAADMDischgDate:%String,CTLOCDesc:%String,OrderID:%String,OrderDesc:%String,CLPSDesc:%String,Diagnosis:%String,CPWRowId:%String,DAYSRowId:%String,orderbuffer:%String,oeidbuffer:%String,PathwayID:%String,EpRowId:%String,OEORIROWID:%String,DiagnosisStr:%String,pathwayString:%String,savedStepString:%String,oeoribuffer:%String,APPTDt,APPTTm:%String,ORIids:%String,OEORIItemStatDesc:%String,CPWDate:%String,CPWNurseAction:%String,CLPODesc:%String,CPStDate:%String,CPEndDate:%String,CPRevDate:%String,CaseManager:%String,CPWGoalTargetDate:%String,CPWProbStartDate:%String,CPWProbEndDate:%String,CPWProbRevDate:%String,CPWCareProvider:%String,Service:%String,ReasForRept:%String,ApptDate:%String,ApptTime:%String,ApptStatus:%String,ApptID:%String")
{
}

Query FindDiagnosis(Parref As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MRCIDCode:%String,MRCIDRowId:%String,MRCIDDesc:%String")
{
SELECT ICD_ICD_DR->MRCID_Code,ICD_ICD_DR->MRCID_RowId,ICD_ICD_DR->MRCID_Desc
FROM SQLUser.MR_ClinicalPathWaysICD
WHERE (ICD_ParRef = :Parref)
}

///  AND ((CPW_Status_DR->CLPS_Code =:StatusCode))
Query FindEpisodeClinicalPathway(mradm As %String, StatusCode As %String, StatusCode2 As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CPWRowId:%String,EPDesc:%String,DAYSDesc:%String,CPWIDDate:%Date,CTPCPDesc:%String,PAADMDischgDate:%String,CTLOCDesc:%String,EPRowId:%String,DAYSRowId:%String,PathwayID:%String,CLPSDesc:%String,CPWGoalText:%String,CPWDesc:%String,CLPSCode:%String,PathwayID:%String,CPWDate:%String,CPWNurseAction:%String,CLPODesc:%String,CPWGoalTargetDate:%String,CPWProbEndDate:%String,CPWProbRevDate:%String,CPWProbStartDate:%String,CPWCareProvider:%String")
{
SELECT CPW_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_Desc, CPW_Pathways_DR->DAYS_Desc, CPW_IDDate, 
CPW_ParREf->MRADM_ADM_DR->PAADM_AdmDocCodeDR->CTPCP_Desc, CPW_ParREf->MRADM_ADM_DR->PAADM_DischgDate, 
CPW_ParREf->MRADM_ADM_DR->PAADM_DepCode_DR->CTLOC_Desc, CPW_Pathways_DR->DAYS_ParRef->EP_RowId, 
CPW_Pathways_DR->DAYS_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef,CPW_Status_DR->CLPS_Desc,CPW_GoalText, 
CPW_Pathway_DR->CPW_Desc, CPW_Status_DR->CLPS_Code,CPW_Pathway_DR, CPW_Date, CPW_NurseAction, CPW_Outcome_DR->CLPO_Desc,
CPW_GoalTargetDate,CPW_ProblemEndDate,CPW_ProblemReviewDate,CPW_ProblemStartDate,CPW_CareProvider_DR
FROM SQLUser.MR_ClinicalPathWays
WHERE (CPW_ParRef =:mradm) AND ((CPW_Status_DR->CLPS_Code = :StatusCode)OR(CPW_Status_DR->CLPS_Code = :StatusCode2))
ORDER BY (CPW_Number)
}

Query FindEpisodeClinicalPathwayNew(mradm As %String, StatusCode As %String, StatusCode2 As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CPWRowId:%String,EPDesc:%String,DAYSDesc:%String,CPWIDDate:%Date,CTPCPDesc:%String,PAADMDischgDate:%String,CTLOCDesc:%String,EPRowId:%String,DAYSRowId:%String,PathwayID:%String,CLPSDesc:%String,CPWGoalText:%String,CPWDesc:%String,CLPSCode:%String,PathwayID:%String,CPWDate:%String,CPWNurseAction:%String,CLPODesc:%String,CPWGoalTargetDate:%String,CPWProbEndDate:%String,CPWProbRevDate:%String,CPWProbStartDate:%String,CPWCareProvider:%String")
{
SELECT CPW_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_Desc, CPW_Pathways_DR->DAYS_Desc, CPW_IDDate, 
CPW_ParREf->MRADM_ADM_DR->PAADM_AdmDocCodeDR->CTPCP_Desc, CPW_ParREf->MRADM_ADM_DR->PAADM_DischgDate, 
CPW_ParREf->MRADM_ADM_DR->PAADM_DepCode_DR->CTLOC_Desc, CPW_Pathways_DR->DAYS_ParRef->EP_RowId, 
CPW_Pathways_DR->DAYS_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_ParRef,CPW_Status_DR->CLPS_Desc,CPW_GoalText, 
CPW_Pathway_DR->CPW_Desc, CPW_Status_DR->CLPS_Code,CPW_Pathway_DR, CPW_Date, CPW_NurseAction, CPW_Outcome_DR->CLPO_Desc,
CPW_GoalTargetDate,CPW_ProblemEndDate,CPW_ProblemReviewDate,CPW_ProblemStartDate,CPW_CareProvider_DR
FROM SQLUser.MR_ClinicalPathWays
WHERE (CPW_ParRef =:mradm) AND ((CPW_Status_DR->CLPS_Code = :StatusCode)OR(CPW_Status_DR->CLPS_Code = :StatusCode2))
ORDER BY CPW_Pathways_DR->DAYS_ParRef->EP_ParRef->CPW_RowId, CPW_Pathways_DR->DAYS_ParRef->EP_Episode, CPW_Pathways_DR->DAYS_DayNumber
}

Query FindMultiProblemandStep(PathwayEpisodeID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "PWEpsStepsID:%String,PWEpsStepsDesc:%String,PWEpsStepsDay,PWEpsStepsNotes:%List")
{
SELECT DAYS_RowId, DAYS_Desc, DAYS_Day, DAYS_Notes
FROM SQLUser.MRC_ClinPathwEpDays
WHERE (DAYS_ParRef = :PathwayEpisodeID)
ORDER BY DAYS_Day
}

/// PatientID,EpisodeID,mradm is only there to pass on for paging
Query FindPathways(PatientID As %String) As %Query(CONTAINID = 0, ROWSPEC = "EPDesc:%String")
{
}

Query FindPatientOrders(ORIRowIDs) As %Library.Query(CONTAINID = 0, ROWSPEC = "ORIRowID,ARCIMDesc,ARCIMRowId,Frequency,FreqDesc,FreqIntDays,Duration,DurDesc,ServiceTime,DipensingTime,HTMLDipensingTime,ARCIMAdminQuestionnDR,ARCIMObservationGroupDR,OEOrdExecID,AdminStatusDR,AdminStatusCode,AdminStatusDesc,APPTDate,APPTTime")
{
}

Query FindPatientOrdersAppt(ApptID) As %Library.Query(CONTAINID = 0, ROWSPEC = "ORIRowID,ARCIMDesc,ARCIMRowId,Frequency,FreqDesc,FreqIntDays,Duration,DurDesc,ServiceTime,DipensingTime,HTMLDipensingTime,ARCIMAdminQuestionnDR,ARCIMObservationGroupDR,OEOrdExecID,AdminStatusDR,AdminStatusCode,AdminStatusDesc,OEORISeqNo,OEORETimeExecuted")
{
}

Query FindStepPathIds(CPWNumber As %String, mradm As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CPWRowId:%String,CPWPathwaysDR:%String,PathEpID:%String")
{
select CPW_RowId,CPW_Pathways_DR,CPW_Pathways_DR->DAYS_ParRef->EP_RowId
from SQLUser.MR_ClinicalPathways
where ((CPW_Number=:CPWNumber) AND (CPW_Parref= :mradm))
}

Query GetDiagnosisIDs(Parref As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ICDRowId:%String")
{
SELECT ICD_RowId
FROM SQLUser.MR_ClinicalPathWaysICD
WHERE ICD_ParRef=:Parref
}

}
