Class web.PACWard Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2983;

Parameter SQLCODE = "WARD_Code";

Parameter SQLDATEFROM = "WARD_InactiveDateFrom";

Parameter SQLDESCRIPTION = "WARD_Desc";

Parameter SQLDATETO = "WARD_InactiveDateTo";

Parameter SQLROWID = "WARD_RowID";

Property dummy As %String(TRUNCATE = 1);

ClassMethod BookedBedListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = BookedBedListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 预约 PACWard.BookedBedList pac_wardadm 
ClassMethod BookedBedListExecute(ByRef QHandle As %Library.Binary, WardID As %Library.String, LocationID As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i WardID="" s QHandle=$lb(0,repid,0) q $$$OK
	s wadmsub=0 f  s wadmsub=$o(^PAWARDA(WardID,"WADM",wadmsub)) q:wadmsub=""  d
	.s (PatientName,AdmissionDate,BedCode,Room,BedDepartment,bedstatus,EpisodeID,PatientID,TransID,BedID,UR,admtype)=""
	.s bedstatus=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",2)
	.q:bedstatus'="R"
	.s EpisodeID=$P(^PAWARDA(WardID,"WADM",wadmsub),"^",1)
	.s Room=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",4)
    .s TempLoc=$P($g(^PAADM(EpisodeID)),"^",74)
	.s admglobalstr=^PAADM(EpisodeID)
    .s PatientID=$p(admglobalstr,"^",1)
	.s UR=$p(^PAPER(PatientID,"PAT",1),"^",1)
	.s PatientName=$p(^PAPER(PatientID,"ALL"),"^",1)	;PAPERName
	.s AdmissionDate=$p(admglobalstr,"^",6)
	.s TransID=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",3)
	.s admtype=$p(admglobalstr,"^",2)
	.d outputrow1
	s QHandle=$lb(0,repid,0)
	q $$$OK
outputrow1
	s ^CacheTemp(repid,ind)=$lb(PatientName,AdmissionDate,BedCode,Room,BedDepartment,bedstatus,EpisodeID,PatientID,TransID,BedID,UR,admtype)
	s ind=ind+1
	q
}

ClassMethod BookedBedListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = BookedBedListExecute ]
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

/// ab 8.05.03
/// show messages for ward age restriction
/// called by PAAdm.websysSave and PAAdmTransaction.websysSaveValidate
ClassMethod CheckAgeRestrict(compref As %Library.String = "", WardID As %Library.String = "", PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindActiveWardBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.Date = "", HospDesc As %Library.String = "", time As %Library.Time = "", Location As %String = "", EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindActiveWardsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindActiveWardsFetch ]
{
}

ClassMethod FindActiveWardsExecute(ByRef QHandle As %Library.Binary, warddesc As %Library.String, date As %Library.Date, HospDesc As %Library.String, time As %Library.Time = "", Location As %String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindActiveWardsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindActiveWardsExecute ]
{
}

/// ab 30.05.03 33794
/// checks sex restriction placed on ward
/// called by PAAdm.websysSave, PAAdmTransaction.websysSaveValidate
ClassMethod CheckWardSexRestrict(compref As %Library.String = "", WardID As %Library.String = "", PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindPatientsInWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientsInWardFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// PATIENTS IN WARD
/// d ##class(%ResultSet).RunQuery("web.PACWard","FindPatientsInWard","","",7)
ClassMethod FindPatientsInWardExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", WardID As %Library.String = "", expDischFrom As %Library.String = "", expDischTo As %Library.String = "", dischConfUnconf As %Library.String = "", BoardersIn As %Library.String = "", Inliers As %Library.String = "", Outliers As %Library.String = "") As %Library.Status
{
	//EpisodeID,PatientID,mradm,Bed,Room,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BookedWardHosp,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,MRADMNursingHours,CTSPCDesc,diagDesc,VIPStatus
	s repid=$I(^CacheTemp)
	s ind=1
	s (EpisodeID,PatientID,mradm,Bed,Room,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BookedWardHosp,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,MRADMNursingHours,CTSPCDesc,diagDesc,VIPStatus)=""
	
	i WardID="" s QHandle=$lb(0,repid,0) q $$$OK
	Set V8AdmDateFlag = ..%IsValidMethod("web.DHCDischargeHistory","GetAdminDateTime")
	s bedadm=0 f  s bedadm=$o(^PAWARDA(WardID,"BED",bedadm)) q:bedadm=""  d
	.s Bed=$p(^PAWARD(WardID,"BED",bedadm),"^",1)
	.s RoomDR=$p(^PAWARD(WardID,"BED",bedadm),"^",3)
	.s Room=$p(^PAROOM(RoomDR),"^",2)
	.s RoomTypeDR=$p(^PAROOM(RoomDR),"^",3)
	.s RoomType=$p(^PAC("ROOMT",RoomTypeDR),"^",2)
	.s Color="#FF8040"
	.s PriorityColor="FF8040"
	.s warddesc=$p(^PAWARD(WardID),"^",2)
	.s beddesc=Bed
	.s bedadmsub=0 s bedadmsub=$o(^PAWARDA(WardID,"BED",bedadm,"ADM",bedadmsub)) q:bedadmsub=""  d
	..s (EpisodeID,PatientID,mradm,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BookedWardHosp,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,MRADMNursingHours,CTSPCDesc,diagDesc,VIPStatus)=""
	..s EpisodeID=$p(^PAWARDA(WardID,"BED",bedadm,"ADM",bedadmsub),"^",1)
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
	..s DaysIn=..%SysDate()-$p(admglobalstr,"^",6)
	..s admdocdr=$p(admglobalstr,"^",9)
	..I (admdocdr'="")&&($d(^CTPCP(admdocdr,1))'=0) s admdoc=$p(^CTPCP(admdocdr,1),"^",2)
	..s DisDate=$p(admglobalstr,"^",17)
	..s DisTime=$p(admglobalstr,"^",18)
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
	..s MRADMPatCondDR=$p(^MR(mradm,"PRO",1),"^",40)
	..i (MRADMPatCondDR'="")&&($d(^MRC("COND",MRADMPatCondDR))'=0) s MRADMPatCondDesc=$p(^MRC("COND",MRADMPatCondDR),"^",2)
	.; FirstDayOfLeave,ReturnDayOfLeave,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,
	.; EstDisTime,LikelihoodAdmit,PriorityDesc,PresentComplaint,NotifDoc,NotifLoc,
	.; EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,AdmitUnit,
	.; Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,
	.; MRADMNursingHours,BookedWardHosp,CTSPCDesc,diagDesc,VIPStatus
	.d outputrow3
	s QHandle=$lb(0,repid,0)
	q $$$OK
outputrow3
	s ^CacheTemp(repid,ind)=$lb(EpisodeID,PatientID,mradm,Bed,Room,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BookedWardHosp,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,MRADMNursingHours,CTSPCDesc,diagDesc,VIPStatus)
	s ind=ind+1
	q
}

ClassMethod FindPatientsInWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientsInWardExecute ]
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

ClassMethod FindPatsInWardsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatsInWardsFetch ]
{
}

/// HP: Log 28899
ClassMethod FindPatsInWardsExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", WardIDList As %Library.String = "", expDischFrom As %Library.String = "", expDischTo As %Library.String = "", dischConfUnconf As %Library.String = "", deptID As %Library.String = "", BoardersIn As %Library.String = "", Inliers As %Library.String = "", Outliers As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatsInWardsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatsInWardsExecute ]
{
}

ClassMethod FindWardBedStatusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardBedStatusFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindWardBedStatusExecute(ByRef QHandle As %Library.Binary, GroupID As %Library.String = "", LocationID As %Library.String = "", WardID As %Library.String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
 	s inputWardId=WardID
	s (WardDesc,Total,Empty,Occupied,Booked,UnAvailable,Inliers,Outliers,TotDisch,DueToday,DueTom,DueNextDay,ExpDisc1,ExpDisc2,ExpDisc3,ExpDisc4,ExpDisc5,tot,MedicallyFit,OnLeave,LocID,WardCode,TotDischConf,TotDischUnconf,ResUnit,current,PreAdmDue,TotalWithUnavail,GovDep,GovCat,Hospital,restrict,Zone,District,BookedEM,BookedNonEM,BoardersIn,BoardersOut,Trust,NursingHours)=""
	s groupid=$s(GroupID'="":GroupID,1:%session.Get("LOGON.GROUPID"))
 	s userid = %session.Get("LOGON.USERID")
 	Set inputWardId="",InputWardDesc=""
 	Set:inputWardId'="" InputWardDesc = $p(^PAWARD(inputWardId),"^",2)
 	Set:(InputWardDesc="")&&(%session.Get("LOGON.WARDID")'="") InputWardDesc = $p(^PAWARD(%session.Get("LOGON.WARDID")),"^",2)
 	i groupid d		
	.; Get Preferences
	.s prefs=##Class(websys.Preferences).GetData("User.SSUser",userid,"PACWARD","PACWard.FindWardBedStat.Preferences")
	.i prefs="" s prefs=##Class(websys.Preferences).GetData("User.SSGroup",groupid,"PACWARD","PACWard.FindWardBedStat.Preferences") 
	.i prefs="" s prefs=##Class(websys.Preferences).GetData("SITE",%session.Get("LOGON.SITECODE"),"PACWARD","PACWard.FindWardBedStat.Preferences") 
	.s isAllWard = $p(prefs,$c(1),3)
	.s prefs=$p(prefs,$c(1),1)	//desc|true^desc1|true^
	.s prefs=InputWardDesc_"|true^"_prefs ;默认查询本病区
	.s len = $l(prefs,"^")-1
	.f j=1:1:len d
	..s item = $p(prefs,"^",j)
	..s falg = $p(item,"|",2)
	..i isAllWard="Y" Set falg="true"
	..i falg="true" d
	...s UnAvailable=0 ;不可使用床,如包床
	...s RcFlagTotal=0
	...s TotalWithUnavail=0	
	...s blockBed=0
	...s WardDesc = $p(item,"|",1),WardID=0
	...q:WardDesc=""
	...s WardID=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(WardDesc),0))	
	...q:(WardID="")||($d(^PAWARD(WardID))=0)
	...;q:(inputWardId'="")&&(WardID'=inputWardId)
	...s WardCode = $p(^PAWARD(WardID),"^",1)
	...s current=0,Total=0,Occupied=0,Empty=0,Booked=0
	...;&sql(select count(1),PAADM_CurrentWard_DR from SQLUser.pa_adm where PAADM_CurrentWard_DR=:WardID and PAADM_VisitStatus='A')
	...s roomrowid="" f  s roomrowid=$o(^PAADMi("CurrWard",WardID,roomrowid)) q:roomrowid=""  d 
	....s admrowid=0 f  s admrowid=$o(^PAADMi("CurrWard",WardID,roomrowid,admrowid)) q:admrowid=""  d
	.....s PAADMVisitStatus=$p(^PAADM(admrowid),"^",20)
	.....q:PAADMVisitStatus'="A"
	.....s current=current+1	
	...;&sql(select count(1) into :Total from SQLUser.pac_bed where bed_ward_parref=:WardID)
	...s blockBed=0 ; 包床 
	...s bedsub=0 f  s bedsub=$o(^PAWARD(WardID,"BED",bedsub)) q:bedsub=""  d
	....s TotalWithUnavail=TotalWithUnavail+1
	....s BEDRcFlag=$p(^PAWARD(WardID,"BED",bedsub),"^",4)
	....s:BEDRcFlag="N" RcFlagTotal=RcFlagTotal+1
	....q:"Y"'=BEDRcFlag
	....s unavailreason=""
	....d ##class(web.PACBedStatusChange).IsUnavailBedStatus(WardID_"||"_bedsub,.unavailreason)
	....s:unavailreason'="" blockBed=blockBed+1
	....;
	....;&sql(select BED_Available into :available from  SQLUser.PAC_Bed WHERE BED_WARD_ParRef = :WardID and BED_Childsub = :bedsub)
	....;s:available="N" Occupied=Occupied+1
	...s bedadm=0 f  s bedadm=$o(^PAWARDA(WardID,"BED",bedadm)) q:bedadm=""  d
	....s bedadmsub=0 s bedadmsub=$o(^PAWARDA(WardID,"BED",bedadm,"ADM",bedadmsub)) q:bedadmsub=""  d
	.....s ADMBookedStatus=$p(^PAWARDA(WardID,"BED",bedadm,"ADM",bedadmsub),"^",2)
	.....i ADMBookedStatus="O" s Occupied=Occupied+1
	.....;i ADMBookedStatus="B" s Booked=Booked+1
	...s wadmsub=0 f  s wadmsub=$o(^PAWARDA(WardID,"WADM",wadmsub)) q:wadmsub=""  d
	....s wadmBookedStatus=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",2)
	....s:wadmBookedStatus="R" Booked=Booked+1
	...s Occupied=Occupied+blockBed
	...s Total=TotalWithUnavail-UnAvailable-RcFlagTotal
	...s Empty=Total-Occupied
	...d outputrow
 		
	s QHandle=$lb(0,repid,0)
	q $$$OK
outputrow
	s ^CacheTemp(repid,ind)=$lb(WardID,WardDesc,Total,Empty,Occupied,Booked,UnAvailable,Inliers,Outliers,TotDisch,DueToday,DueTom,DueNextDay,ExpDisc1,ExpDisc2,ExpDisc3,ExpDisc4,ExpDisc5,tot,MedicallyFit,OnLeave,LocID,WardCode,TotDischConf,TotDischUnconf,ResUnit,current,PreAdmDue,TotalWithUnavail,GovDep,GovCat,Hospital,restrict,Zone,District,BookedEM,BookedNonEM,BoardersIn,BoardersOut,Trust,NursingHours)
	s ind=ind+1
	q
}

ClassMethod FindWardBedStatusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardBedStatusExecute ]
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

ClassMethod FindWardBedSummaryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardBedSummaryFetch ]
{
	
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询汇总
/// ab 15.08.02
/// Displays summary details for department(s) or responsible unit(s)
/// totals data of wards from PACWard.FindBedWardStatus
ClassMethod FindWardBedSummaryExecute(ByRef QHandle As %Library.Binary, dept As %Library.String = "", ru As %Library.String = "", alldept As %Library.String = "", allru As %Library.String = "", gc As %Library.String = "", allgc As %Library.String = "", gcdesc As %Library.String = "", gcat As %Library.String = "", allgcat As %Library.String = "", tots As %Library.String = "", hosp As %Library.String = "", allhosp As %Library.String = "", zone As %Library.String = "", allzone As %Library.String = "", district As %Library.String = "", alldistrict As %Library.String = "") As %Library.Status
{
	s repid1=$I(^CacheTemp)
	s ind1=1
	s (ResUnit,Dept,Total,Empty,Occupied,Booked,UnAvailable,Inliers,Outliers,MedicallyFit,OnLeave,DueToday,DueTom,DueNextDay,TotDisch,ExpDisc1,ExpDisc2,ExpDisc3,ExpDisc4,ExpDisc5,TotDischConf,TotDischUnconf,current,PreAdmDue,TotalWithUnavail,tot,TotPread,GovDep,GovCat,Hospital,bookedWIDs,bdToWIDs,bdTomWIDs,bdNDWIDs,ed1WIDs,ed2WIDs,ed3WIDs,ed4WIDs,ed5WIDs,deptID,Zone,District,BoardersIn,BoardersOut,boWIDs,biWIDs,inWIDs,outWIDs,totWIDs,Trust,DeptIDs,totDeptIDs,NursingHours)=""
	i tots="Y" d
	.;%request.Set("CONTEXT",oldcontext_"TOT")
	.s context=%request.Get("CONTEXT")
	.s fwbsrs = ##class(%ResultSet).%New("web.PACWard:FindWardBedStatus")
	.s %sc=fwbsrs.Execute(%session.Get("LOGON.GROUPID"),"","")
	.If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit
	.s (Total,Empty,Occupied,Booked,current)=0	;20130318 放在execute后
	.For  Quit:fwbsrs.Next(.%sc)=0  d
	..if $$$ISOK(%sc) d
	...s Total=Total+fwbsrs.GetDataByName("Total"), Empty=Empty+fwbsrs.GetDataByName("Empty")
	...s Occupied=Occupied+fwbsrs.GetDataByName("Occupied") 
	...s Booked=Booked+fwbsrs.GetDataByName("Booked")
	...s current=current+fwbsrs.GetDataByName("current") 
	...s:fwbsrs.GetDataByName("Booked")>0 bookedWIDs=fwbsrs.GetDataByName("WardID")_"^"_bookedWIDs
	.d fwbsrs.Close()
	.s fwbsrs=""
	.d outputrow2
	
	s QHandle=$lb(0,repid1,0)
	q $$$OK
outputrow2
	s ^CacheTemp(repid1,ind1)=$lb(ResUnit,Dept,Total,Empty,Occupied,Booked,UnAvailable,Inliers,Outliers,MedicallyFit,OnLeave,DueToday,DueTom,DueNextDay,TotDisch,ExpDisc1,ExpDisc2,ExpDisc3,ExpDisc4,ExpDisc5,TotDischConf,TotDischUnconf,current,PreAdmDue,TotalWithUnavail,tot,TotPread,GovDep,GovCat,Hospital,bookedWIDs,bdToWIDs,bdTomWIDs,bdNDWIDs,ed1WIDs,ed2WIDs,ed3WIDs,ed4WIDs,ed5WIDs,deptID,Zone,District,BoardersIn,BoardersOut,boWIDs,biWIDs,inWIDs,outWIDs,totWIDs,Trust,DeptIDs,totDeptIDs,NursingHours)
	s ind1=ind1+1
	q
}

ClassMethod FindWardBedSummaryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardBedSummaryExecute ]
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

ClassMethod FindWardResUserIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardResUserIDFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ab 04.04.02
/// if inpatient or emergency location list is present, limits ward lookup to these
/// also limits wards displayed to emergency, if you are in emergency (ie. demo/demo) and PAAdmType="EM"
/// by wuqk 2011-06-23 * 
/// 仅判断 WardDesc、AdmType、HospDesc
ClassMethod FindWardResUserIDExecute(ByRef QHandle As %Library.Binary, WardDesc As %Library.String, UID As %Library.String, AdmType As %Library.String, HospDesc As %Library.String = "", datefrom As %Library.String = "", timefrom As %Library.String = "", hosps As %Library.String = "", EpisodeID As %String = "", Location As %String = "", RestrictWardLocList As %String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s sql="select WARD_RowID,WARD_Code,WARD_Desc from PAC_Ward where 1=1"
	//WardDesc, UID, AdmType, HospDesc, datefrom , timefrom, hosps, EpisodeID, Location, RestrictWardLocList
	if WardDesc'="" set sql=sql_" and WARD_Desc %STARTSWITH '"_WardDesc_"'"
	
	//急诊科室
	if AdmType="E"{set sql=sql_" and WARD_LocationDR->CTLOC_Type='EM'"}
	else{set sql=sql_" and WARD_LocationDR->CTLOC_Type='W'"}
	
	//hosps  split by "|"  CTLOC_Hospital_DR
	if hosps'=""{
		set hospCondition=""
		for index=1:1:$l(hosps,"|"){
			if $p(hosps,"|",index)'=""{
				set:hospCondition'="" hospCondition=hospCondition_" OR "
				set hospCondition=hospCondition_" (WARD_LocationDR->CTLOC_Hospital_DR="_$p(hosps,"|",index)_")"
			}
		}
		set:hospCondition'="" sql=sql_" and ("_hospCondition_")"
	}
	;20140504 datefrom
	if datefrom'=""{
		s zdatefrom = $zdh(datefrom,4)
		set sql = sql_" and (WARD_LocationDR->CTLOC_DateActiveFrom="" or WARD_LocationDR->CTLOC_DateActiveFrom is null or WARD_LocationDR->CTLOC_DateActiveFrom<="_zdatefrom_")" 
		_"and (WARD_LocationDR->CTLOC_DateActiveTo="" or WARD_LocationDR->CTLOC_DateActiveTo is null or  WARD_LocationDR->CTLOC_DateActiveTo>="_zdatefrom_")"
	}
	
	s sql=sql_" order by WARD_Desc"
	s rset=##class(%ResultSet).%New("%DynamicQuery:SQL")
	s sc = rset.Prepare(sql)
	s sc=rset.Execute()
	while rset.%Next(){
		set WARDRowID=rset.Data("WARD_RowID")
		set WARDCode=rset.Data("WARD_Code")
		set WARDDesc=rset.Data("WARD_Desc")
		set ^CacheTemp(repid,ind)=$lb(WARDDesc,WARDCode,WARDRowID,"","","","","","","","")
		set ind=ind+1
	}
	
	q $$$OK
}

ClassMethod FindWardResUserIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardResUserIDExecute ]
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

ClassMethod EpsDeptInWardAlloc(WardID As %String = "", EpisodeID As %String = "", datefrom As %String = "", EpsLoc As %String = "") As %String
{
}

/// 	KM 24-Oct-2002: This broker goes with query FindWardandHospital
/// Please see notes in this query as to explanation of where it is used.
ClassMethod FindWardandHospitalBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", activedate As %Library.Date = "", HospDesc As %String = "", hosps As %String = "", locType As %String = "") As %Library.Boolean
{
}

/// This query is used by the broker (FindWardandHospitalBroker)
/// KK 16/Apr/2002 Log24240: see notes on query PACWard.FindWardandHospital
/// KM 17-Oct-2002: This query is used on the ward lookups for waitinglist components
/// where no ward restrictions are checked: PAWaitingListInquiry.Find, PAWaitingList.Edit
/// GC 26-May-2006 Log 59225: Included Day Surgery Location types 
Query FindWardandHospital(val As %String, activedate As %Library.Date, hospID As %String, hosps As %String, locType As %String, locType2 As %String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
 SELECT WARD_Desc,WARD_Code,Ward_Rowid,WARD_LocationDR->CTLOC_Hospital_DR->HOSP_Desc
 FROM SQLUser.PAC_Ward
 WHERE ((%ALPHAUP WARD_Desc = %ALPHAUP :val) OR (%ALPHAUP WARD_Code = %ALPHAUP :val) OR (:val IS NULL))
 AND (((WARD_LocationDR->CTLOC_DateActiveFrom <= :activedate) OR (WARD_LocationDR->CTLOC_DateActiveFrom IS NULL) OR (:activedate IS NULL))
 AND 	((WARD_LocationDR->CTLOC_DateActiveTo >= :activedate) OR (WARD_LocationDR->CTLOC_DateActiveTo IS NULL) OR (:activedate IS NULL)))
 AND (({fn CONCAT( '^', {fn CONCAT((:locType),'^')})} [ {fn CONCAT( '^', {fn CONCAT((WARD_LocationDR->CTLOC_Type),'^')})}) OR ({fn CONCAT( '^', {fn CONCAT((:locType2),'^')})} [ {fn CONCAT( '^', {fn CONCAT((WARD_LocationDR->CTLOC_Type),'^')})}) OR (:locType IS NULL))
 AND ((WARD_LocationDR->CTLOC_Hospital_DR = :hospID) OR (:hospID IS NULL))
 AND (({fn CONCAT( '|', {fn CONCAT((:hosps),'|')})} [ {fn CONCAT( '|', {fn CONCAT((WARD_LocationDR->CTLOC_Hospital_DR->HOSP_RowId),'|')})}) OR (:hosps IS NULL))
 ORDER BY WARD_Desc
}

/// query called from component PAWaitingListInquiry.Find on the Intended Ward lookup. 
/// KK 16/Apr/2002 Log24240: This query finds ward and associated hospital. 
/// RQG,Log28106: To find wards with admission date within the activedates of Location CT
Query FindWardandHospLookup(val As %String, activedate As %Library.Date, HospDesc As %String, hosps As %String, locType As %String) As %Library.Query(ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// ab 5.02.04 41754 - added hosps and loctype, used on EPVisitNumber.ClinicWorklist
ClassMethod FindWardandHospLookupExecute(ByRef QHandle As %Library.Binary, val As %String = "", activedate As %Library.Date = "", HospDesc As %String = "", hosps As %String = "", locType As %String = "") As %Library.Status
{
}

ClassMethod FindWardandHospLookupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardandHospLookupExecute ]
{
}

ClassMethod FindWardandHospLookupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardandHospLookupFetch ]
{
}

ClassMethod FindWardsBookedBedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardsBookedBedFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ///汇总上的预约query
/// Log 28899 HP:
/// Modified from web.PACWard:BookedBedList - list booked beds for list of WardIDs
/// Called from component PACWard.BookedBedList.Summary
ClassMethod FindWardsBookedBedExecute(ByRef QHandle As %Library.Binary, WardIDList As %Library.String, deptID As %Library.String = "") As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s (PatientName,AdmissionDate,BedCode,Room,BedDepartment,bedstatus,EpisodeID,PatientID,TransID,BedID,UR,admtype,ward)=""
	s len = $l(WardIDList,"^")
	f i=1:1:len d
	.s WardID=+$p(WardIDList,"^",i)
	.q:WardID=0
	.s wadmsub=0 f  s wadmsub=$o(^PAWARDA(WardID,"WADM",wadmsub)) q:wadmsub=""  d
	..s (PatientName,AdmissionDate,BedCode,Room,BedDepartment,bedstatus,EpisodeID,PatientID,TransID,BedID,UR,admtype)=""
	..s bedstatus=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",2)
	..q:bedstatus'="R"
	..s EpisodeID=$P(^PAWARDA(WardID,"WADM",wadmsub),"^",1)
	..s Room=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",4)
    ..s TempLoc=$P($g(^PAADM(EpisodeID)),"^",74)
	..s admglobalstr=^PAADM(EpisodeID)
    ..s PatientID=$p(admglobalstr,"^",1)
	..s UR=$p(^PAPER(PatientID,"PAT",1),"^",1)
	..s PatientName=$p(^PAPER(PatientID,"ALL"),"^",1)	;PAPERName
	..s AdmissionDate=$p(admglobalstr,"^",6)
	..s TransID=$p(^PAWARDA(WardID,"WADM",wadmsub),"^",3)
	..s admtype=$p(admglobalstr,"^",2)
	..d outputrow4
	s QHandle=$lb(0,repid,0)
	q $$$OK
outputrow4
	set ^CacheTemp(repid,ind)=$lb(PatientName,AdmissionDate,BedCode,Room,BedDepartment,bedstatus,EpisodeID,PatientID,TransID,BedID,UR,admtype,ward)
	set ind=ind+1
}

ClassMethod FindWardsBookedBedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardsBookedBedExecute ]
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

ClassMethod FindWardsByLocTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardsByLocTypeFetch ]
{
}

/// KM 17-Oct-2002: See notes in query description
ClassMethod FindWardsByLocTypeExecute(ByRef QHandle As %Library.Binary, wardtypes As %Library.String) As %Library.Status
{
}

ClassMethod FindWardsByLocTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardsByLocTypeExecute ]
{
}

ClassMethod GetBedDepartment(ward As %Library.String = "", bed As %Library.String = "") As %Library.String
{
}

/// VB Codetable: System Parameters: Patient Managment2: Assign Department To Individual Beds
/// GetEpisodeDetails
/// ab 26.06.02 - version 0.2
ClassMethod GetBedDepartmentRevised(ward As %Library.String = "") As %Library.String
{
	//User.PACBedDepartmentAllocation
	quit ""
}

/// w ##class(web.PACWard).GetPropertyValue(10,"WARDDesc")
ClassMethod GetPropertyValue(ID As %Library.String, Property1 As %Library.String = "", Property2 As %Library.String = "", Property3 As %Library.String = "")
{
	n obj
	if Property1="" Q ""
	s obj=##class(User.PACWard).%OpenId(ID)
	s exp="s val=obj."_Property1
	if Property2'="" {
		s exp=exp_"."_Property2
		if Property3'="" s exp=exp_"."_Property3
	}
	x exp
	Q val
    ;
}

/// returns the first ward asscoiated with the department
/// qse 20110721
/// w ##class(web.PACWard).GetWardFromLoc(6)
/// lxz 2017-04-19 获取登录科室对应的病区，住院证查询界面使用修改。
ClassMethod GetWardFromLoc(loc As %Library.String) As %Library.String
{
	n WardID
	//病区类型的科室直接查找病区
	s WardID=$O(^PAWARD(0,"WARD_LocationDR",loc,0))
	
	//医生登录科室->关联病区类型的科室->关联病区
	if WardID=""  d
	.s childid=""
	.f  s childid=$o(^CTLOC(loc,"LINK",childid))  q:childid=""  d
	..s linkid=$p(^CTLOC(loc,"LINK",childid),"^",1)
	..q:($d(^CTLOC(linkid))=0)
	..s loctype=$p(^CTLOC(linkid),"^",13)
	..q:(loctype'="W")
	..s ctdesc=$p(^CTLOC(linkid),"^",2)
	..s WardID=""
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",linkid,0))
	q WardID
}

ClassMethod GetBookedWaitArea(ward As %String = "") As %String
{
}

/// Log 43454 PeterC return WardID based by code/desc and HospitalDR 
ClassMethod GetWardIDFromCodeDescHosp(desc As %Library.String, hospid As %Library.String) As %Library.String
{
}

/// Log#27892 HP: Get current ward's visit and rest time. Used to populates these fields when 
/// temporary location field is blank. 
ClassMethod GetWardLocVisitRestTime(CurWardID As %Library.String)
{
}

/// Gets Details for the Ward Summary Page.
ClassMethod GetWardSummaryDetails(id As %Library.String)
{
}

/// A routine to determine if the user is able to place a patient in the ward based on the UserID and Ward ID
ClassMethod IsAbleToPlace(WardID As %String = "", AdmType As %String = "") As %Library.Boolean
{
}

ClassMethod IsActive(WardID As %Library.String = "") As %Library.String
{
}

/// ab 4.07.02
/// checks active flag, location active date from/to, and restrictions on availability to determine if ward is active
ClassMethod IsAvailable(WardID As %Library.String = "", date As %Library.Date = "", time As %Library.Time = "") As %Library.Integer
{
}

/// 19/11/02 HP Log#29549: Check if all available beds are closed via PACBedStatusChange.Edit
ClassMethod IsWardClosed(Ward As %Library.String) As %Library.Boolean
{
}

ClassMethod LookUpBrokerWardResUserID(itmjs As %Library.String = "", itmjsex As %Library.String = "", WardDesc As %Library.String = "", UID As %Library.String = "", AdmType As %Library.String = "", HospDesc As %Library.String = "", datefrom As %Library.String = "", timefrom As %Library.String = "", hosps As %Library.String = "", EpisodeID As %String = "", Location As %String = "", RestrictWardLocList As %String = "") As %Library.Boolean
{
}

/// wanghc 猜的,summary=0显示,1不显示
/// ab 2.07.03 - setup the component to have items and tableitems to match the setup
/// originally code from pacward.findwardbedstatus.csp
/// now used to setup columns for both PACWard.FinsWardBedStatus and PACWard.FindWardBedStatus.Summary
ClassMethod SetupExpDischColumns(component As %String = "", summary As %String = 0)
{
	if summary=0 d
	.s compSum=##Class(websys.Component).OpenName(component)
	.i compSum d
	..d compSum.Show()
	..d compSum.%Close()
}

ClassMethod websysDeletePreferences(compref As %Library.String, type As %Library.String)
{
	s objRef=%session.Get("LOGON.USERID")
	s objType="User.SSUser"
	i type="G" d
	.s objRef=%session.Get("LOGON.GROUPDESC")
	.s objType="User.SSGroup"
	i type="T" d
	.s objRef=%session.Get("LOGON.SITECODE")
	.s objType="SITE"
	s appKey="PACWARD",appSubKey="PACWard.FindWardBedStat.Preferences"
	s rowid=$O(^websys.PreferencesI("Index",objType,objRef,appKey,appSubKey,0))
	i +rowid>0 d
	.d ##class(websys.Preferences).%DeleteId(rowid)
}

/// 2011-10-22 wanghc 
/// component=PACWard.FindWardBedStat.Preferences
ClassMethod websysSavePreferences(compid As %Library.String, type As %Library.String = "", params As %Library.String = "", filters As %Library.String = "", allwards As %Library.String = "", alldept As %Library.String = "", allru As %Library.String = "", allgc As %Library.String = "", allgcat As %Library.String = "", tots As %Library.String = "", allhosp As %Library.String = "", allzone As %Library.String = "", alldistrict As %Library.String = "", alltrust As %String = "")
{
	s objRef=%session.Get("LOGON.USERID")
	s objType="User.SSUser"
	i type="G" d
	.s objRef=%session.Get("LOGON.GROUPID")
	.s objType="User.SSGroup"
	i type="T" d
	.s objRef=%session.Get("LOGON.SITECODE")
	.s objType="SITE"
	s appKey="PACWARD",appSubKey="PACWard.FindWardBedStat.Preferences"
	s rowid=$O(^websys.PreferencesI("Index",objType,objRef,appKey,appSubKey,0))
	i +rowid=0 d
	.s preferencesObj=##class(websys.Preferences).%New()
	.s preferencesObj.AppKey="PACWARD"
	.s preferencesObj.AppSubKey="PACWard.FindWardBedStat.Preferences"
	.s preferencesObj.ObjectReference=objRef
	.s preferencesObj.ObjectType=objType

	
	e  d
	.s preferencesObj=##class(websys.Preferences).%OpenId(rowid)
	s preferencesObj.Data=params_$c(1)_filters_$c(1)_allwards_$c(1)_ alldept_$c(1)_ allru_$c(1)_ allgc_$c(1)_ allgcat_$c(1)_ tots_$c(1)_ allhosp_$c(1)_ allzone _$c(1)_ alldistrict_$c(1)_alltrust
	set sc =  preferencesObj.%Save()
	s preferencesObj=""
	q ""
}

/// Called from component PACWard.BookedBedList
Query BookedBedList(WardID As %Library.String, LocationID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Patient Name:%String,Admission Date:%String,Bed Code:%String,Room:%String,Bed Department:%String,bedstatus:%String,EpisodeID,PatientID,TransID,BedID,UR,admtype")
{
}

Query FindActiveWards(code As %Library.String, activedate As %Library.Date, HospDesc As %Library.String, time As %Library.Time, Location As %Library.String, EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// NB: Before changing this query please consult with Leon
Query FindPatientsInWard(TSRTITM, TSRTORD, WardID As %Library.String, expDischFrom As %Library.String, expDischTo As %Library.String, dischConfUnconf As %Library.String, BoardersIn As %Library.String, Inliers As %Library.String, Outliers As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeID,PatientID,mradm,Bed,Room,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,PAADMPayorDesc,PAADMInPatAdmTypeDesc,MRADMPatCondDesc,BookedWardHosp,PAADMSeenDate,PAADMSeenTime,RoomType,Name4,Name5,Name6,Name7,Name8,MRADMNursingHours,CTSPCDesc,diagDesc,VIPStatus")
{
}

/// Log 28899 HP:
/// Called from component PACWard.ListPatientsInWard.Summary
Query FindPatsInWards(TSRTITM, TSRTORD, WardIDList As %Library.String, expDischFrom As %Library.String, expDischTo As %Library.String, dischConfUnconf As %Library.String, deptID As %Library.String, BoardersIn As %Library.String, Inliers As %Library.String, Outliers As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeID,PatientID,mradm,Bed,Room,UR,Surname,GivenName,Name3,age,sex,sexCode,admdate,admtime,admType,DaysIn,admdoc,DaysOut,FirstDayOfLeave,ReturnDayOfLeave,Color,dob,EpisodeDept,EpisodeSubType,MedicallyFit,ExpAdmDate,EstDisDate,EstDisTime,LikelihoodAdmit,PriorityDesc,PriorityColor,PresentComplaint,warddesc,beddesc,NotifDoc,NotifLoc,DisDate,DisTime,EstDisConfirmed,OESubCatDesc,Status,boarder,PayorType,DischClass,waitingTime,TempLoc,TempLocCode,AdmitUnit,Visitors,LikelyTransICU,bedstatus,ParentWard,edob,MostRecentSeenByDocDesc,curWard,Name4,Name5,Name6,Name7,Name8")
{
}

Query FindWardBedStatus(GroupID As %String, LocationID As %String, WardID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "WardID:%String,Ward Desc:%String,Total:%String,Empty:%String,Occupied:%String,Booked:%String,UnAvailable:%String,Inliers:%String,Outliers:%String,TotDisch:%String,DueToday:%String,DueTom:%String,DueNextDay:%String,ExpDisc1:%String,ExpDisc2:%String,ExpDisc3:%String,ExpDisc4:%String,ExpDisc5:%String,tot:%String,MedicallyFit:%String,OnLeave:%String,LocID:%String,WardCode:%String,TotDischConf:%String,TotDischUnconf:%String,ResUnit:%String,current:%String,PreAdmDue:%String,TotalWithUnavail:%String,GovDep:%String,GovCat:%String,Hospital:%String,restrict:%String,Zone:%String,District:%String,BookedEM:%String,BookedNonEM:%String,BoardersIn:%String,BoardersOut:%String,Trust:%String,NursingHours")
{
}

Query FindWardBedSummary(dept As %String, ru As %String, alldept As %String, allru As %String, gc As %String, allgc As %String, gcdesc As %String, gcat As %String, allgcat As %String, tots As %String, hosp As %String, allhosp As %String, zone As %String = "", allzone As %String = "", district As %String = "", alldistrict As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ResUnit:%String,Dept:%String,Total:%String,Empty:%String,Occupied:%String,Booked:%String,UnAvailable:%String,Inliers:%String,Outliers:%String,MedicallyFit:%String,OnLeave:%String,DueToday:%String,DueTom:%String,DueNextDay:%String,TotDisch:%String,ExpDisc1:%String,ExpDisc2:%String,ExpDisc3:%String,ExpDisc4:%String,ExpDisc5:%String,TotDischConf:%String,TotDischUnconf:%String,current:%String,PreAdmDue:%String,TotalWithUnavail:%String,tot:%String,TotPread:%String,GovDep:%String,GovCat:%String,Hospital:%String,bookedWIDs,bdToWIDs,bdTomWIDs,bdNDWIDs,ed1WIDs,ed2WIDs,ed3WIDs,ed4WIDs,ed5WIDs,deptID,Zone,District,BoardersIn,BoardersOut,boWIDs,biWIDs,inWIDs,outWIDs,totWIDs,Trust,DeptIDs,totDeptIDs,NursingHours")
{
}

/// KM 15-Oct-2002: This is the main ward lookup that most (if not all!!) of the bed 
/// managment components use for their ward lookups.
/// 
Query FindWardResUserID(WardDesc As %Library.String, UID As %Library.String, AdmType As %Library.String, HospDesc As %Library.String, datefrom As %Library.Date, timefrom As %Library.Time, hosps As %Library.String, EpisodeID As %String, Location As %String, RestrictWardLocList As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,HIDDEN:%String")
{
}

/// Log 28899 HP:
/// Called from component PACWard.BookedBedList.Summary
Query FindWardsBookedBed(WardIDList As %Library.String, deptID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Patient Name:%String,Admission Date:%String,Bed Code:%String,Room:%String,Bed Department:%String,bedstatus:%String,EpisodeID,PatientID,TransID,BedID,UR,admtype,ward")
{
}

/// KM 17-Oct-2002: Called from epr.Palm.GetAllWards()
Query FindWardsByLocType(wardtypes As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,WARDCode:%String,WARDDesc:%String")
{
}

}
