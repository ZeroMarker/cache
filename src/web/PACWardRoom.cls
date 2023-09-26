Class web.PACWardRoom Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1115;

Parameter SQLDATEFROM = "ROOM_DateFrom";

Parameter SQLDATETO = "ROOM_DateTo";

Parameter SQLCODE = "ROOM_RowId";

Parameter SQLDESCRIPTION = "ROOM_Room_DR->ROOM_Desc";

Parameter SQLROWID = "ROOM_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 8.05.03
/// show messages for room sex restriction
/// called by PAAdm.websysSave and PAAdmTransaction.websysSaveValidate
ClassMethod CheckSexRestrict(compref As %Library.String = "", RoomID As %Library.String = "", PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpRoomsInWardsBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", WardIDs As %String = "", Room As %String = "", WardCodes As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpRoomsInWardsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRoomsInWardsFetch ]
{
}

ClassMethod LookUpRoomsInWardsExecute(ByRef QHandle As %Library.Binary, WardIDs As %String = "", Room As %String = "", WardCodes As %String = "") As %Library.Status
{
}

ClassMethod LookUpRoomsInWardsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRoomsInWardsExecute ]
{
}

ClassMethod FindPatientsInRoomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientsInRoomFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindPatientsInRoomExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, roomQuery As %Library.String = "", WardID As %Library.String, BookingDueDate As %Library.String = "", expDischFrom As %Library.String = "", expDischTo As %Library.String = "", dischConfUnconf As %Library.String = "", BoardersIn As %Library.String = "", BoardersOut As %Library.String = "", Inliers As %Library.String = "", Outliers As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (roomQuery="")||(WardID="") 	s QHandle=$lb(0,repid,0) q $$$OK
	Set V8AdmDateFlag = ##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","GetAdminDateTime")
	;参照epr.floorplan.csp
	i roomQuery'="MPR" d
	.s chl=0  f  s chl=$O(^PAWARDA(WardID,"WADM",chl)) q:chl=""  d
	..s (EpisodeID,PatientID,mradm,bed,roomdesc,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,ParentWard,CurrentWard,edob,BookedStatusDesc,MostRecentSeenByDocDesc,oradmid,orgadmtype,SpecialSeq,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BoarderOutFlag,OccStatus,Outlier,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,WardWaitingArea,MRADMNursingHours,FromTempLoc,VIPStatus)=""
	..s EpisodeID=$P(^PAWARDA(WardID,"WADM",chl),"^",1)
	..s Status=$P(^PAWARDA(WardID,"WADM",chl),"^",2)
    ..s TempLoc=$P($g(^PAADM(EpisodeID)),"^",74)
    ..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s mradm=$p(^PAADM(EpisodeID),"^",61)		; PAADMMainMRADMDR
	..s admglobalstr=^PAADM(EpisodeID)
	..s UR=$p(^PAPER(PatientID,"PAT",1),"^",1)
	..s Surname=$p(^PAPER(PatientID,"ALL"),"^",1)	;PAPERName
	..s GivenName=$P(^PAPER(PatientID,"ALL"),"^",2) ;PAPERName2
	..s Name3=$p(^PAPER(PatientID,"ALL"),"^",19)
	..S age = ##class(web.PAPerson).calculateAgeUnitsShow(PatientID)
	..;&sql(SELECT PAPER_AgeYr INTO:age FROM SQLUser.PA_Person where PAPER_Rowid=:PatientID)
	..s sexDr=$p(^PAPER(PatientID,"ALL"),"^",7)	;PAPERSexDR
	..s sexCode=$p(^CT("SEX",sexDr),"^",1)
	..s sex=$p(^CT("SEX",sexDr),"^",2)
	..s dob=$p(^PAPER(PatientID,"ALL"),"^",6)	;PAPERDob
	..i V8AdmDateFlag d
	...Set admdatetimestr = ##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	...Set admdate = $p(admdatetimestr,"^",1)
	...Set admtime =  $p(admdatetimestr,"^",2)
	..e  d
	...s admdate=$p(admglobalstr,"^",6)
	...s admtime=$p(admglobalstr,"^",7)
	..s admType=$p(admglobalstr,"^",2)
	..s DaysIn=+$h-$p(admglobalstr,"^",6)
	..s admdocdr=$p(admglobalstr,"^",9)
	..I (admdocdr'="")&&($d(^CTPCP(admdocdr,1))'=0) s admdoc=$p(^CTPCP(admdocdr,1),"^",2)
	..s DisDate=$p(admglobalstr,"^",17)
	..s DisTime=$p(admglobalstr,"^",18)
	..s Status=""
	..s EpisodeDeptDR=$p(admglobalstr,"^",4)
	..s EpisodeDept=$p(^CTLOC(EpisodeDeptDR),"^",2)
	..s PAADMSeenDate=$p(^PAADM(EpisodeID,1),"^",10)
	..s PAADMSeenTime=$p(^PAADM(EpisodeID,1),"^",11)
	..s templocdr=$p(admglobalstr,"^",74)
	..i templocdr'="" d
	...s TempLocCode=$p(^CTLOC(templocdr),"^",1)
	...s TempLoc=$p(^CTLOC(templocdr),"^",2)
	...s Color="#00FF00"
	...s PriorityColor="00FF00"
	..s Outlier=0
	..; FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime
	..; LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,
	..; EstDisConfirmed,OESubCatDesc,boarder,PayorType,DischClass,waitingTime,AdmitUnit,Visitors,
	..; LikelyTransICU,ParentWard,CurrentWard,edob,BookedStatusDesc,MostRecentSeenByDocDesc,oradmid,orgadmtype,SpecialSeq,
	..; PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BoarderOutFlag,OccStatus,
	..; RoomType, WardWaitingArea,MRADMNursingHours,FromTempLoc,VIPStatus
	..d outputrow2
	s QHandle=$lb(0,repid,0)
	q $$$OK
outputrow2
	s ^CacheTemp(repid,ind)=$lb(EpisodeID,PatientID,mradm,bed,roomdesc,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,ParentWard,CurrentWard,edob,BookedStatusDesc,MostRecentSeenByDocDesc,oradmid,orgadmtype,SpecialSeq,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BoarderOutFlag,OccStatus,Outlier,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,WardWaitingArea,MRADMNursingHours,FromTempLoc,VIPStatus)
	s ind=ind+1
	q
}

ClassMethod FindPatientsInRoomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientsInRoomExecute ]
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

ClassMethod FindWardsPatInRoomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardsPatInRoomFetch ]
{
}

/// HP: Log 28899
ClassMethod FindWardsPatInRoomExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, roomQuery As %Library.String = "", WardIDList As %Library.String, BookingDueDate As %Library.String = "", expDischFrom As %Library.String = "", expDischTo As %Library.String = "", dischConfUnconf As %Library.String = "", deptID As %Library.String = "", BoardersIn As %Library.String = "", BoardersOut As %Library.String = "", Inliers As %Library.String = "", Outliers As %Library.String = "") As %Library.Status
{
}

ClassMethod FindWardsPatInRoomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardsPatInRoomExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerRoomInWard(itmjs As %Library.String = "", itmjsex As %Library.String = "", RoomDesc As %Library.String = "", WardDesc As %Library.String = "", RestrictedWardID As %Library.String = "", Avail As %Library.String = "", EpisodeID As %Library.String = "", tdate As %String = "", AdmType As %String = "", Location As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpRoomInWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRoomInWardFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 转科选择房间
/// d ##class(%ResultSet).RunQuery("web.PACWardRoom:LookUpRoomInWard","","","","","","")
/// 暂时只考虑WardDesc不为空的情况（转科)
ClassMethod LookUpRoomInWardExecute(ByRef QHandle As %Library.Binary, RoomDesc As %Library.String, WardDesc As %Library.String, RestrictedWardID As %Library.String, Avail As %Library.String = "", EpisodeID As %Library.String = "", tdate As %String = "", AdmType As %String = "", Location As %String = "") As %Library.Status
{
   	//input,RoomDesc,WardDesc,RestrictedWardID,Avail,EpisodeID,tdate,AdmType,Location
    //Description:,WardDesc:,RoomCode:,HIDDEN:,HIDDEN:,HIDDEN:,HIDDEN:,HIDDEN:,HIDDEN:,HIDDEN:)
    s ^TEMP("LookUPRoomInWard")=RoomDesc_","_WardDesc_","_RestrictedWardID_","_Avail_","_EpisodeID_","_tdate_","_AdmType_","_Location
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
    s WardID=""
    i WardDesc'="" {
	    s WardDesc=$$ALPHAUP^SSUTIL4(WardDesc)
	    s WardID=$o(^PAWARD(0,"WARD_Desc",WardDesc,""))
	    s RoomDesc=$$ALPHAUP^SSUTIL4(RoomDesc)
	   
	
		s RoomRowID=0
		f  s RoomRowID=$o(^PAWARD(WardID,"ROOM",0,"Room",RoomRowID)) q:RoomRowID=""  d
			.q:$g(^PAROOM(RoomRowID))=""
		    .s Description=$p(^PAROOM(RoomRowID),"^",2)
		    .q:Description'[RoomDesc
		    .s RoomCode=$p(^PAROOM(RoomRowID),"^",1)
			.s Data=$lb(Description,WardDesc,RoomCode,"","","","","","","")
			.set ^CacheTemp(repid,ind)=Data
			.set ind=ind+1
    }else {
	     
	        s RoomRowID=0
	    	f  s RoomRowID=$o(^PAROOM(RoomRowID)) q:RoomRowID=""  d
		    .s Description=$p(^PAROOM(RoomRowID),"^",2)
		    .q:Description'[RoomDesc
		    .s RoomCode=$p(^PAROOM(RoomRowID),"^",1)
		   
			.s Data=$lb(Description,WardDesc,RoomCode,"","","","","","","")
			.set ^CacheTemp(repid,ind)=Data
			.set ind=ind+1
			
	    
    }
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpRoomInWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRoomInWardExecute ]
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

/// KM 4-Jan-2002: Called From PAAdmTransaction.websysSaveTransfer
/// 
ClassMethod getRoomQueryID(RoomQuery As %Library.String, WardID As %Library.String) As %Library.String
{
	s RoomQueryID=""
	s getroomqueryRS = ##class(%ResultSet).%New("web.PACWardRoom:FindQueryTypeInWard")
	s getroomquerySC=getroomqueryRS.Execute(RoomQuery,WardID)
	If $$$ISERR(getroomquerySC) Do DisplayError^%apiOBJ(getroomquerySC) Quit
	d getroomqueryRS.%Next(.getroomquerySC)
	i $$$ISOK(getroomquerySC) d
	.s RoomQueryID = getroomqueryRS.GetDataByName("ID")
	d getroomqueryRS.%Close()
	s getroomqueryRS=""
	q RoomQueryID
}

/// ID is the rowid for table PAC_WardRoom (not PAC_Room)
ClassMethod getRoomQueryType(ID As %Library.String) As %Library.String
{
}

/// zhouzq 测试传递床位ID进去后,返回空,逻辑不明，应该返回的是PACWardRoomID
ClassMethod GetWardRoomForBed(BedID As %String = "") As %String
{
	q ""
	q:BedID="" ""
	s wardID=$p(BedID,"||",1)
	s wardroomDR=$p($g(^PAWARD(wardID)),"^",3)  
	s wardroomDR=+wardroomDR
	q:wardroomDR=0 ""
	s wardroom=$p($g(^PAROOM(wardroomDR)),"^",2)
	q wardroom
}

/// Thecompref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

/// Called from various methods, including:
///      PACBed.ConvertFloorplanFromRooms() 
///      PACBed.FindForFloorplan
///      PACBedAllocation.GetIdFromRoomAndWard()
///      PACWardRoom.LookUpRoom
Query Find(WardID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ROOMRoomDR:%String,ROOMDesc:%String,ROOMPositionLeft:%String,ROOMPositionTop:%String,ROOMPositionWidth:%String,ROOMPositionHeight:%String,ROOMCode:%String,ROOMQuery:%String,ROOMNoOfRows:%String")
{
SELECT ROOM_RowID, ROOM_Room_DR, ROOM_Room_DR->ROOM_Desc, ROOM_PositionLeft, ROOM_PositionTop, ROOM_PositionWidth, ROOM_PositionHeight, ROOM_Room_DR->ROOM_Code, ROOM_Room_DR->ROOM_Query, ROOM_Room_DR->ROOM_NoOfRows
FROM SQLUser.PAC_WardRoom
WHERE ROOM_ParRef = :WardID
}

/// KM 7-Jan-2002: Log 21853
Query FindPatientsInRoom(TSRTITM As %String, TSRTORD As %String, QueryType As %String, WardID As %String, BookingDueDate As %String, expDischFrom As %Library.String, expDischTo As %Library.String, dischConfUnconf As %Library.String, BoardersIn As %Library.String, BoardersOut As %Library.String, Inliers As %Library.String, Outliers As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeID,PatientID,mradm,bed,roomdesc,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,ParentWard,CurrentWard,edob,BookedStatusDesc,MostRecentSeenByDocDesc,oradmid,orgadmtype,SpecialSeq,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BoarderOutFlag,OccStatus,Outlier,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,WardWaitingArea,MRADMNursingHours,FromTempLoc,VIPStatus")
{
}

Query LookUpRoomsInWards(WardIDs As %String, Room As %String, WardCodes As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description,Ward,HIDDEN,HIDDEN,Code")
{
}

/// Created to be called from query PACBed.FindForFloorplan
/// 
Query FindQueryRooms(WardID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ROOMDesc,ROOMPositionLeft,ROOMPositionTop,ROOMPositionWidth,ROOMPositionHeight,ROOMQuery,ROOMNoOfRows,Incompletes,RoomType")
{
SELECT ROOM_RowID, ROOM_Room_DR->ROOM_Desc, 
ROOM_PositionLeft, ROOM_PositionTop, 
ROOM_PositionWidth, ROOM_PositionHeight, 
ROOM_Room_DR->ROOM_Query, 
ROOM_Room_DR->ROOM_NoOfRows,
ROOM_Room_DR->ROOM_Incompletes,
ROOM_Room_DR->ROOM_RoomType_DR->ROOMT_Desc
FROM SQLUser.PAC_WardRoom
WHERE ROOM_ParRef = :WardID 
AND (ROOM_Room_DR->ROOM_Query IS NOT NULL)
}

/// KM 15-Oct-2002:  Called from PACWardRoom.getRoomQueryID()
Query FindQueryTypeInWard(QueryType As %String, WardID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RoomDesc:%String,RoomCode:%String,WardDesc:%String,RoomQuery")
{
SELECT ROOM_RowID,ROOM_Room_DR->ROOM_Desc,
 ROOM_Room_DR->ROOM_Code,
 ROOM_ParRef->WARD_Desc,
 ROOM_Room_DR->ROOM_Query
FROM SQLUser.PAC_WardRoom
WHERE (:QueryType [ ROOM_Room_DR->ROOM_Query)
AND (ROOM_ParRef->WARD_Rowid = :WardID)
}

/// KM 15-Oct-2002: Called from PACWardRoom.LookUpRoomInWardExecute()
Query FindRoomInWardByLoc(RoomDesc As %String, WardDesc As %String, locid As %String, tdate As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RoomDesc:%String,RoomCode:%String,WardDesc:%String,RoomQuery:%String,RoomDiffSex:%String,RoomID:%String,RoomType:%String,hospdesc:%String,WardID:%String")
{
SELECT  ROOM_RowID,
 ROOM_Room_DR->ROOM_Desc, ROOM_Room_DR->ROOM_Code,
 ROOM_ParRef->WARD_Desc, ROOM_Room_DR->ROOM_Query,
 ROOM_Room_DR->ROOM_DifferentSexPatients, ROOM_Room_DR->ROOM_RowID,ROOM_Room_DR->ROOM_RoomType_DR->ROOMT_Desc,
 ROOM_ParRef->WARD_LocationDR->CTLOC_Hospital_DR->HOSP_Desc,ROOM_ParRef->WARD_RowID
FROM SQLUser.PAC_WardRoom
WHERE (ROOM_ParRef->WARD_LocationDR=:locid)	
AND ((ROOM_Room_DR->ROOM_Desc %STARTSWITH :RoomDesc) OR (:RoomDesc IS NULL))
AND ((ROOM_ParRef->WARD_Desc %STARTSWITH :WardDesc) OR (:WardDesc IS NULL))
AND ((ROOM_ParRef->WARD_LocationDR->CTLOC_DateActiveFrom <= CURRENT_DATE OR ROOM_ParRef->WARD_LocationDR->CTLOC_DateActiveFrom IS NULL) 
AND (ROOM_ParRef->WARD_LocationDR->CTLOC_DateActiveTo >= CURRENT_DATE OR ROOM_ParRef->WARD_LocationDR->CTLOC_DateActiveTo IS NULL))
AND ((:tdate IS NULL) OR ((ROOM_Room_DR->ROOM_DateFrom IS NULL OR ROOM_Room_DR->ROOM_DateFrom <= :tdate) AND (ROOM_Room_DR->ROOM_DateTo IS NULL OR ROOM_Room_DR->ROOM_DateTo >= :tdate)))
ORDER BY ROOM_ParRef->WARD_Desc
}

/// HP: Log 28899
Query FindWardsPatInRoom(TSRTITM As %String, TSRTORD As %String, QueryType As %String, WardIDList As %String, BookingDueDate As %String, expDischFrom As %Library.String, expDischTo As %Library.String, dischConfUnconf As %Library.String, deptID As %Library.String, BoardersIn As %Library.String, BoardersOut As %Library.String, Inliers As %Library.String, Outliers As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeID,PatientID,mradm,bed,roomdesc,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,ParentWard,CurrentWard,edob,BookedStatusDesc,MostRecentSeenByDocDesc,oradmid,orgadmtype,curWard,Name4,Name5,Name6,Name7,Name8")
{
}

/// KM 15-Oct-2002: This is the main query used by the room lookups in the various bed management components.
/// 
Query LookUpRoomInWard(RoomDesc As %String, WardDesc As %String, RestrictedWardID As %String, Avail As %String, EpisodeID As %String, tdate As %String, AdmType As %String, Location As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,WardDesc:%String,RoomCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

}
