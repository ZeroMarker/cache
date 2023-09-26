/// webimport
Class web.PAAdmLeave Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 598;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADML_RowId";

Parameter SQLDESCRIPTION = "ADML_RowId";

Parameter SQLROWID = "ADML_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckDatesAgainstAdm(compref As %Library.String, EpisodeID As %Library.String = "", Date As %Library.String = "", Time As %Library.String = "") As %Library.Boolean
{
}

/// BC 16-Jan-2002
/// Returns the Expected Return Date if the patient is on leave.  The search is based on the admission ID
/// 
/// ab 1.05.02
/// on leave status should not rely on the expected return date
///  	KM 21-Oct-2002: This method is now ALSO called from:
/// 	a) condition expression on the OnLeave Icon and 
/// 	b) from PACBedAdm.GetStatistics()
/// wanghc 医疗结算界面的onLeave组件，最终结算组件的最后更新日期
ClassMethod CheckForOnLeave(ID As %String = "", ClosedLeave As %String = "") As %Library.Date
{
	
	q ""
}

/// BC 16-Jan-2002
/// Returns the Expected Return Time if the patient is on leave.  The search is based on the admission ID
/// 
/// ab 1.05.02
/// on leave status should not rely on the expected return date
/// 最终结算组件的最后更新时间
ClassMethod CheckForOnLeaveTime(ID As %String = "", ClosedLeave As %String = "") As %Library.Date
{
	Q ""
}

ClassMethod CheckLeaveDate(compid As %String, LeaveFromDate As %Library.Date, LeaveFromTime As %Library.Time, ExpectedDateReturn As %Library.String, ExpectedTimeReturn As %Library.String, ActualDateReturn As %Library.String, ActualTimeReturn As %Library.String) As %Library.String
{
}

ClassMethod CheckLeaveForNoOverlap(ID As %Library.String, startdate As %Library.String, starttime As %Library.String, expectedenddate As %Library.String, expectedendtime As %Library.String, enddate As %Library.String, endtime As %Library.String, compref As %Library.String) As %Library.Boolean
{
}

ClassMethod CheckLeaveLength(StartDate As %String = "", EndDate As %String = "", EndDateReturn As %String = "", compref As %String = "") As %Library.Boolean
{
}

ClassMethod FindLeaveByAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLeaveByAdmFetch ]
{
	s repid=$li(QHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// zhouzq 未实现 转移菜单上PAAdmLeave.List组件用
ClassMethod FindLeaveByAdmExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, EpisodeID As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
 	Quit $$$OK
}

ClassMethod FindLeaveByAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLeaveByAdmExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLeaveClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLeaveFetch ]
{
}

ClassMethod FindLeaveExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod FindLeaveFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLeaveExecute ]
{
}

/// BC 6-Feb-2002 : A routine to return the ID of a leave based on an episode date and the current time and date. 
/// If the patient is not currently on leave the routine will return a blank. 
/// 
/// This is to be used to populate the date and time of a discharge if it falls within a leave
ClassMethod FindLeaveID(ID As %Library.String) As %Library.String
{
}

/// bugNO-161
/// PAAdmLeave.EditNew->CARETYPCode 照顾类型
ClassMethod GetCareType(EpisodeID As %String = "") As %String
{
	q ""
}

/// BC 6-Feb-2002:  A routine to return the start date of a patient's leave based on a Leave ID
ClassMethod GetCurrentLeaveDetails(EpisodeID As %Library.String) As %Library.String
{
}

/// MD.30.05.2003 Routine to return leave categories
/// wanghc PAADMDischarge.Edit component->LeaveCat
ClassMethod GetLeaveCategory(EpisodeID As %Library.String) As %Library.String
{
	s ^Temp("wanghc","EpisodeID")=EpisodeID
	s rowid=$o(^PAADM(EpisodeID,"LEA",""),-1)	//暂取新的那条
	q:+rowid=0 ""
	s obj1=##class(User.PAAdmLeave).%OpenId(EpisodeID_"||"_rowid) //.ADMLLeaveCategoryDR
	q:$IsObject(obj1.ADMLLeaveCategoryDR) obj1.ADMLLeaveCategoryDR.LEACATDesc
	q ""
}

ClassMethod IsOnLeave(ID As %Library.String) As %Library.Date
{
}

ClassMethod GetLeaveImage(EpisodeID As %Library.String) As %Library.String
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

ClassMethod GetLeaveStartDate(ID As %String = "") As %Library.Date
{
}

ClassMethod GetLeaveStartTime(ID As %String = "") As %Library.Time
{
}

/// ab 26.07.02
/// sums all the days of leave taken from the episode
ClassMethod GetTotalLeave(id As %Library.String) As %Library.String
{
}

/// md 18.04.2005 Log 51518
/// total leave that is not Contracted
ClassMethod GetTotalNonContractedLeave(EpisodeId As %Library.String) As %Library.String
{
	Q ""
}

/// KM 13-Aug-2002: Created for showing Icon on Icon Profiles.
ClassMethod IsLateFromLeave(EpisodeID As %Library.String) As %Library.Integer
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, id As %String) As %Boolean
{
}

/// Author - Bradley Collins
/// Date - 8/10/2001
/// 
/// Purpose - To save out leave details for a patient's particular episode
/// 
/// Used by - PAAdmLeave.Edit, PAAdmLeave.EditNew
/// 
/// Comment - There are missing fields that have to be added to PAAdmLeave before this can be completed
ClassMethod websysSaveLeave(compref As %Library.String, id As %Library.String)
{
}

ClassMethod ValidateCodeTableDates(compref As %String, id As %String = "") As %String
{
}

Query FindLeave(PatientID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "GoingOutDate:%String,GoingOutTime:%String,NurseDR:%String,ExpectedDateReturn:%String,ExpectedTimeReturn:%String,ReasonDR:%String,DoctorApproved:%String,ActualDateReturn:%String,ActualTimeReturn:%String,NurseReturnDR:%String")
{
}

Query FindLeaveByAdm(TSRTITM As %String, TSRTORD As %String, EpisodeID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ADMLRowId:%String,GoingOutDate:%String,GoingOutTime:%String,NurseDR:%String,ExpectedDateReturn:%String,ExpectedTimeReturn:%String,ReasonDR:%String,DoctorApproved:%String,ActualDateReturn:%String,ActualTimeReturn:%String,NurseReturnDR:%String,Type:%String,Category:%String,TempAddress:%String,PAADMUpdateDate:%String,SSUSRName:%String,LHospital:%String,AHospital:%String")
{
}

Query FindLeaveByEpisode(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ADMLRowId:%String,GoingOutDate:%String,GoingOutTime:%String,NurseDR:%String,ExpectedDateReturn:%String,ExpectedTimeReturn:%String,ReasonDR:%String,DoctorApproved:%String,ActualDateReturn:%String,ActualTimeReturn:%String,NurseReturnDR:%String,PAADMUpdateDate:%Date,SSUSRName:%String,Type,Category,Ward,Room,Bed,TempAddress,HOSPDesc,AHOSPDesc")
{
SELECT ADML_RowId,ADML_GoingOutDate,
 ADML_GoingOutTime,ADML_Nurse_DR->CTPCP_Desc,
 ADML_ExpectedDateReturn,
 ADML_ExpectedTimeReturn,
 ADML_Reason_DR->RFL_Desc, 
 ADML_DoctorApprove_DR->CTPCP_Desc,
 ADML_ActualDateReturn,ADML_ActualTimeReturn,
 ADML_NurseReturn_DR->CTPCP_Desc,
 ADML_UpdateDate,
 ADML_UpdateUser_DR->SSUSR_Name,
 ADML_LeaveType_DR->LEATYP_Desc,
 ADML_LeaveCategory_DR->LEACAT_Desc,
 ADML_ParRef->PAADM_CurrentWard_DR->WARD_Desc,
 ADML_ParRef->PAADM_CurrentRoom_DR->ROOM_Desc,
 ADML_ParRef->PAADM_CurrentBed_DR->BED_Code,
 ADML_TempAddress_DR,
 ADML_UpdateUserHospital_DR ->HOSP_Desc,
 ADML_ParRef->PAADM_Hospital_DR->HOSP_Desc
FROM SQLUser.PA_AdmLeave
WHERE (ADML_ParRef = :EpisodeID)
ORDER BY ADML_GoingOutDate DESC, ADML_GoingOutTime DESC
}

}
