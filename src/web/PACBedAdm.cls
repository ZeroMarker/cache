Class web.PACBedAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1015;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADM_RowId";

Parameter SQLDESCRIPTION = "ADM_RowId";

Parameter SQLROWID = "ADM_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindActivityReportClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindActivityReportFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindActivityReportExecute(ByRef QHandle As %Library.Binary, StaffedCubicles As %Library.String, EmergencyDepartment As %Library.String, EmergencyDepartmentId As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindActivityReportFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindActivityReportExecute ]
{
}

/// KM 23-Sep-2002: This method superceeded by PAAdmTransaction.GetBed()
ClassMethod GetBedAdm(ByRef obj As %String, element As %String) As %String
{
}

/// Author - John Hart
/// Purpose - Returns the book bed for a patient episode
/// Used By - PAADM.BedAdmissionEdit
/// 
/// KM 13-Nov-2001: 
///    This method also called from component PAAdmTransaction.Edit. 
///    Added roomdesc to variables c reated.
ClassMethod GetBookedBed(EpisodeID As %Library.String)
{
}

ClassMethod GetBookedBedData(EpisodeID As %Library.String, ByRef bedID As %Library.String, ByRef beddesc As %Library.String, ByRef warddesc As %Library.String, ByRef wardcode As %Library.String, ByRef wardID As %Library.String, ByRef bedstatus As %Library.String, ByRef roomdesc As %Library.String, ByRef TransID As %Library.String, ByRef BedAdmID As %Library.String)
{
}

/// ab - 32081 - used by icon definitions 'BedRequested' and 'BedAssigned'
/// ab - 39520 - changed to include ward bookings, and emergency bed requests.. also made episode specific if necessary
/// ab - 40310 - qh requests that we only show the icons for -bed- requests/bookings
ClassMethod GetCurrBedStatus(PatientID As %String = "", EpisodeID As %String = "") As %Library.String
{
}

/// KM 29-Mar-2002:  Get the ward and bed details where the patient is at present.
/// After some research!! This method seems to be called from PAAdm.FindDischargeDetailsFetch and 
/// PAAdm.FindCurrentInLocFetch().
/// 
ClassMethod GetLastBed(EpisodeID As %String = "", ShowEmergency As %Library.Integer = 0)
{
}

/// KM 19-Sep-2002: This method is called from epr.floorplan.csp	
ClassMethod GetNumIncompleteAdm(locID As %String = "", PAADMType As %String = "") As %Library.Integer
{
	;逻辑不明,暂时返回0
	Q 0
	s inPatientIncompleteNum=0
	i locID'="" {
		s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
		s roomID=0
		while roomID'=""&($d(^PAWARD(WardID,"ROOM",roomID))'=0 )
		{
		 s roomID=$o(^PAWARD(WardID,"ROOM",roomID))
		 s WardRoomID=$p($g(^PAWARD(WardID,"ROOM",roomID)),"^",1)	
		 s Incompletes=$p($g(^PAROOM(WardRoomID)),"^",7)
		 i Incompletes="Y"
		  {
		   s EpisodeId=0
		   f  s EpisodeId=$o(^PAADMi("CurrWard",wardID,WardRoomID,EpisodeId)) q:EpisodeId=""  d
		   .i PAADMType'=""&PAADMType=($p(^PAADM(EpisodeId),"^",2)) d 
		   ..s inPatientIncompleteNum=inPatientIncompleteNum+1 
		   //.i PAADMType="" d
		   //..s inPatientIncompleteNum=inPatientIncompleteNum+1
		  }
		}
	}
	Q inPatientIncompleteNum
}

/// Author - John Hart
/// Purpose - Returns the number of patients wating the ward's Waiting Room 
/// Used By - epr.Floorplan.csp
/// KM 19-Sep-2002: This method is called from epr.floorplan.csp
ClassMethod GetNumPatientsWaiting(locID As %String = "", QueryType As %String = "") As %Library.Integer
{
	;WA或WE类型的房间只能在急诊类型的科室中分配
	;6.9.3下测试发现在床位图中将病人拖到WA或WE类型的房间中,函数返回依然为0,里面的逻辑不明
	Q 0
 s inPatientWaitingNum=0
 i locID'="" 
  {
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
	s EpisodeId=0
    f  s EpisodeId=$o(^PAADMi("CurrWard",wardID,0,EpisodeId)) q:EpisodeId=""  d
    .s inPatientWaitingNum=inPatientWaitingNum+1 
	q inPatientWaitingNum
  }
  //&sql(select count(*) from PAC_WardAdm where WADM_ParRef=:WardID and WADM_Room_DR='')
}

ClassMethod GetStatistics(WardID As %Library.String, PARAMS As %Library.String, ByRef STATS As %Library.String, ByRef DISDATE As %Library.String, ByRef DISDATECON As %Library.String, ByRef DISDATEUNC As %Library.String, BOOK As %Library.String, ByRef OCC As %Library.String)
{
}

/// This is called from PACBedAdm.ListActivityReport.
ClassMethod UpdateStaffedCubicles(StaffedCubicles As %Library.String, EmergencyDepartment As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KM 29-Mar-2002: Created to be called from component PAAdm.EditBedAdmission
ClassMethod websysDeleteProcedure(compref As %Library.String, EpisodeID As %Library.String, TransID As %Library.String, NotifID As %Library.String)
{
}

/// Author - John Hart and Trung
/// Purpose - To get all the patient data for displaying on the floor plan icons, descriptions and tool tips
/// Used By - epr.floorplan.csp
/// 
Query Find(WardID As %String, RoomID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,PatientID:%String,mradm:%String,PAADMPriorityDR:%String")
{
SELECT ADM_PAADM_DR, ADM_PAADM_DR->PAADM_PAPMI_DR, ADM_PAADM_DR->PAADM_MainMRADM_DR, ADM_PAADM_DR->PAADM_Priority_DR
FROM SQLUser.PAC_BedAdm
WHERE ADM_ParRef->BED_WARD_PARREF = :WardID AND ADM_ParRef->BED_ROOM_DR = :RoomID
}

Query FindActivityReport(StaffedCubicles As %Library.String, EmergencyDepartment As %Library.String, EmergencyDepartmentId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "heading,code,description,cubicles,waitingroom,points,activity,totals,OccupiedCubicles")
{
}

/// PACBedAdm.Edit component replaced by PAAdmTransaction.Edit, this save is no longer used
ClassMethod zAllocateBed(compref As %String, BedID As %Library.String = "")
{
}

}
