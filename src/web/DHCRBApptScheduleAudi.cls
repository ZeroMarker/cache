Class web.DHCRBApptScheduleAudi Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 ;New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query QueryLoc(depname As %String, UserID As %String = "", LogHospId = "") As %Query(ROWSPEC = "name:%String,id:%String,contactname:%String") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary, depname As %String, UserID As %String = "", LogHospId = "") As %Status
{
	;New repid, ind
	;New CTCode1,CTDesc1
 	Set repid=$I(^CacheTemp)
 	Set depname=$ZCVT(depname,"U")
 	s LogHospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogHospId)
	s ind=1
	set myrowid=0
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","O",myrowid)) q:myrowid=""  d
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .s CTDesc2=$p($g(^CTLOC(myrowid)),"^",43)
 	   .s CTDesc2=$zcvt(CTDesc2,"U")
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .;q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
	   .Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",myrowid,LogHospId)
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1
	   .q:($P(^CTLOC(myrowid),"^",14)'="Y")
 	   .q:$g(CTDesc1)
 	   .Do OutputRow
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","E",myrowid)) q:myrowid=""  d
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .;q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
 	   .Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",myrowid,LogHospId)
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .s CTDesc2=$p($g(^CTLOC(myrowid)),"^",43)
 	   .s CTDesc2=$zcvt(CTDesc2,"U")
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
	   .q:($P(^CTLOC(myrowid),"^",14)'="Y")
 	   .q:$g(CTDesc1)
 	   .Do OutputRow
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputRow
    s CTDesc1=##class(web.DHCOPAdmReg).LocDescFormate(CTDesc1)
	set Data=$lb(CTDesc1,CTCode1,CTDesc2)
 	Set ^CacheTemp(repid,CTDesc1)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc1,CTCode1)=""
	quit
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryAudiStat() As %Query(ROWSPEC = "name:%String,id:%String") [ SqlProc ]
{
}

ClassMethod QueryAudiStatExecute(ByRef QHandle As %Binary) As %Status
{
	s ind=1
 	Set repid=$I(^CacheTemp)
 	Set AudiStatStr="N^A^D^R"
 	s count=$l(AudiStatStr,"^")
 	for i=1:1:count{
	 	s AudiStatCode=$p(AudiStatStr,"^",i)
	 	s AudiStat=$CASE(AudiStatCode,"N":"待审核","A":"已审核","D":"已撤销","R":"已拒绝")	
	 	d OutputRowStat
	 }
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputRowStat
	set Data=$lb(AudiStat,AudiStatCode)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
ResetVariablesStat
	///set (repid)=0
	set (CTDesc1,CTCode1)=""
	quit
}

ClassMethod QueryAudiStatFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAudiStatExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAudiStatClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryAudiStatExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 ;New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RBASRequestQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBASRequestQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCRBApptScheduleAudi","RBASRequestQuery","2018-08-20","","","","","N","","","","","Y")

ClassMethod RBASRequestQueryExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", SessionTypeID As %String = "", ChkAuditStat As %String = "", ChkNew As %String = "", ChkStop As %String = "", ChkCancelStop As %String = "", ChkReplace As %String = "", ChkQryByLoc As %String = "", FindIndex As %String = "", ScheduleDate As %String = "", ReasonDr As %String = "", HospID = "") As %Status
{
	s ^tmpnk("RBASRequestQuery")=StartDate_","_EndDate_","_LocID_","_ DocID_","_SessionTypeID_","_ChkAuditStat_","_ChkNew_","_ ChkStop_","_ ChkCancelStop_","_ChkReplace_","_ChkQryByLoc_","_FindIndex
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
	s ind=1
	if StartDate'="" S StartDate=..%ZDH(StartDate)
	else  s StartDate=..%SysDate()
	if EndDate'="" S EndDate=..%ZDH(EndDate)
	else  s EndDate=..%SysDate()+90
	if (StartDate="")&&(EndDate="")&&(LocID="")&&(DocID="")&&(SessionTypeID="")&&(ChkAuditStat="")&&(ChkNew="")&&(ChkStop="")&&(ChkCancelStop="")&&(ChkReplace="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if ScheduleDate'="" S ScheduleDate=..%ZDH(ScheduleDate)
	else  s ScheduleDate=""

	s CurUserID=%session.Get("LOGON.USERID")
	
	
	if FindIndex'=""{
		s myTid=""
		for  s myTid=$o(^TMPRBASRequestQuery("RBASRequestQueryDetail",CurUserID,FindIndex,myTid)) Q:myTid=""  d
		.set Data=^TMPRBASRequestQuery("RBASRequestQueryDetail",CurUserID,FindIndex,myTid)
		.Set ^CacheTemp(repid,ind)=Data
 		.Set ind=ind+1
 		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	k ^TMPRBASRequestQuery("RBASRequestQuery",CurUserID)
	K ^TMPRBASRequestQuery("RBASRequestQueryDetail",CurUserID)
	//s Date=StartDate-1
	;i ChkAuditStat="ALL" s ChkAuditStat=""
	
	i (ChkAuditStat=""){
		if (ChkNew="")&&(ChkStop="")&&(ChkCancelStop="")&&(ChkReplace=""){
			s RequestType=""
			f  s RequestType=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType)) q:RequestType=""  d
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult
		}else{
			i ChkNew'="" d
			.s RequestType=" N"
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult
			.s RequestType=" NS"
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult	
			i ChkStop'="" d
			.s RequestType=" S"
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult
			i ChkCancelStop'="" d
			.s RequestType=" SC"
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult
			i ChkReplace'="" d
			.s RequestType=" R"
			.s Result=""
			.f  s Result=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result)) q:Result=""  d
			..d OneTypeResult	
		}
	}elseif (ChkAuditStat'=""){
		s Result=" "_ChkAuditStat
		if (ChkNew="")&&(ChkStop="")&&(ChkCancelStop="")&&(ChkReplace=""){
			s RequestType=""
			f  s RequestType=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType)) q:RequestType=""  d
			.d OneTypeResult
		}else{
			i ChkNew'="" d
			.s RequestType=" N"
			.d OneTypeResult
			.s RequestType=" NS"
			.d OneTypeResult	
			i ChkStop'="" d
			.s RequestType=" S"
			.d OneTypeResult	
			i ChkCancelStop'="" d
			.s RequestType=" SC"
			.d OneTypeResult	
			i ChkReplace'="" d
			.s RequestType=" R"
			.d OneTypeResult	
		}
	}
	
	if ChkQryByLoc="Y"{	
		s TSelect="0"
		if ChkAuditStat="N" s TSelect="1"
		s TDocDesc="双击查看明细"
		s TLocDesc=""
		set myRequestDate=""
		for  set myRequestDate=$o(^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,myRequestDate)) Q:myRequestDate=""  d
		.set myRBASLocID=""
		.for  set myRBASLocID=$o(^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,myRequestDate,myRBASLocID)) Q:myRBASLocID=""  d
		..set myRequestType=""
		..for  set myRequestType=$o(^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,myRequestDate,myRBASLocID,myRequestType)) Q:myRequestType=""  d
		...set myID=""
		...for  set myID=$o(^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,myRequestDate,myRBASLocID,myRequestType,myID)) Q:myID=""  d
		....set ^TMPRBASRequestQuery("RBASRequestQueryDetail",CurUserID,ind,myID)=^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,myRequestDate,myRBASLocID,myRequestType,myID)
		...set TRequestType=..GetRequestTypeDesc(myRequestType)
		...set TResult=##class(web.DHCOPAdmRegQuery).GetRequestResultDesc(ChkAuditStat)
		...set TRequestDate=..%ZD(myRequestDate)
		...set TLocDesc=$p(^CTLOC(myRBASLocID),"^",2)
		...set RBASLocID=myRBASLocID
		...set TFindIndex=ind
		...set (TID,TDate,TTimeRange,TSessionType,TRegNum,TReason,TRLocDesc,TRDocDesc,TRSessionType,TRequestAuditDate,TRequestAuditUser,TRequestWaitTime,TRInfo,TRequestUser,TRequestReason,NoLimitLoadFlag)=""
		...do FindRBASRequestBuild
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneTypeResult
	s Date=StartDate-1
	f  s Date=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result,Date)) q:(Date="")||(Date>EndDate)  d
	.s ID=0
	.f  s ID=$O(^User.DHCRBApptScheduleRequestI("TypeResultIndex",RequestType,Result,Date,ID)) q:ID=""  d
	..d OneInfoOut
	q
	
OneInfoOut
	s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID,0)
	s RBASID=obj.ASRRBASIDGetObjectId()
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",+RBASID,HospID)
	s RBASObj=##class(User.RBApptSchedule).%OpenId(RBASID,0)
	q:'$IsObject(RBASObj)
	s curLoc=obj.ASRRBASID.ASRESParRef.RESCTLOCDR.%Id()
	q:(LocID'="")&&(LocID'=curLoc)
	s curDoc=obj.ASRRBASID.ASRESParRef.RESCTPCPDR.%Id()
	q:(DocID'="")&&(DocID'=curDoc)
	;q:(CurUserID'="")&&('##class(web.DHCUserGroup).UserCanDo(CurUserID,curLoc,curDoc))
	s TDate=obj.ASRRBASID.ASDate
	q:(ScheduleDate'="")&&(ScheduleDate'=TDate)
	s DHCRBASObj=##class(User.DHCRBApptSchedule).%OpenId(RBASID,0)
	s curSessionType=obj.ASRRBASID.ASSessionTypeDR.%Id()
	q:(SessionTypeID'="")&&(curSessionType'=SessionTypeID)
	s curTimeRange=obj.ASRRBASID.ASTimeRangeDR.%Id()
	;q:(TimeRangeID'="")&&(curTimeRange'=TimeRangeID)
	s TResult=obj.ASRRequestResult
	s TSelect="0"
	s:TResult="N" TSelect="1"
	s TResult=##class(web.DHCOPAdmRegQuery).GetRequestResultDesc(TResult)
	s TID=ID
	s RBASLocID=obj.ASRRBASID.ASRESParRef.RESCTLOCDR.%Id()
	s TLocDesc=obj.ASRRBASID.ASRESParRef.RESCTLOCDR.CTLOCDesc
	s TDocDesc=obj.ASRRBASID.ASRESParRef.RESCTPCPDR.CTPCPDesc
	s:TDate'="" TDate=..%ZD(TDate) //$ZD(TDate,3)
	s TTimeRange=obj.ASRRBASID.ASTimeRangeDR.TRDesc
	s TSessionType=obj.ASRRBASID.ASSessionTypeDR.SESSDesc
	;s TRegNum=+RBASObj.ASLoad ;正号限额
	;s TApptNum=+RBASObj.ASNoApptSession ;预约限额
	;s TOverRegNum=+DHCRBASObj.ASNoOverbookAllowed ;加号限额
	s NoLimitLoadFlag=DHCRBASObj.ASNoLimitLoadFlag
	s ASLoadJsonInfo=##class(web.DHCApptScheduleNew).GetASLoadInfo(RBASID)
	s ASLoadJsonObj={}.%FromJSON(ASLoadJsonInfo)
	s TRegNum=ASLoadJsonObj.ASLoad
	s TApptNum=ASLoadJsonObj.ASAppLoad
	s AppStartSeqNo=ASLoadJsonObj.AppStartSeqNo
	s TOverRegNum=ASLoadJsonObj.AddLoad
	s TRegNum="正号:"_TRegNum_",预约:"_TApptNum_",加号:"_TOverRegNum
	s TReason=obj.ASRReasonDR.RNAVDesc
	s TRLocDesc=obj.ASRLocDR.CTLOCDesc
	s TRDocDesc=obj.ASRDoctorDR.CTPCPDesc
	s TRSessionType=obj.ASRSessionTypeDR.SESSDesc
	s TRInfo=""
	s:(TRLocDesc'="")&&(TRDocDesc'="") TRInfo=TRLocDesc_" "_TRDocDesc_" ("_TRDocDesc_")"
	s TRequestAuditDate=""
	s RequestAuditDate=obj.ASRRequestAuditDate
	s:obj.ASRRequestAuditTime'="" RequestAuditTime=obj.ASRRequestAuditTime
	s:RequestAuditDate'="" TRequestAuditDate=..%ZD(RequestAuditDate)_" "_..%ZT(RequestAuditTime,2)
	s SRequestDate=obj.ASRRequestDate
	s RequestDate=..%ZD(obj.ASRRequestDate)
	s TRequestDate=RequestDate_" "_..%ZT(obj.ASRRequestTime,2)
	s TRequestAuditUser=obj.ASRRequestAuditUserDR.SSUSRName
	s TRequestUser=obj.ASRRequestUserDR.SSUSRName
	s STRequestType=obj.ASRRequestType
	s TRequestType=..GetRequestTypeDesc(obj.ASRRequestType) ;$CASE(obj.ASRRequestType,"SC":"撤消停诊","PS":"停诊","S":"停诊","R":"替诊","N":"新增(加诊)","NS":"新增",:"")
	s AuditDate=..%SysDate()
	s AuditTime=..%SysTime()
	s:obj.ASRRequestAuditDate'="" AuditDate=obj.ASRRequestAuditDate
	s:obj.ASRRequestAuditTime'="" AuditTime=obj.ASRRequestAuditTime
	s waitdate=AuditDate-obj.ASRRequestDate
	s waittime=AuditTime-obj.ASRRequestTime
	s TRequestReasondr=obj.ASRRequestRefuseReasonDrGetObjectId()
	q:((ReasonDr'="")&&(TRequestReasondr'="")&&(ReasonDr'=TRequestReasondr))
	s TRequestReason=obj.ASRRequestRefuseReasonDr.DHCRBASARDesc 
	s waithour=waittime\3600
	s waitminute=(waittime#3600)\60
	s waitss=((waittime#3600)#60)#60
	s waittime=""
	if waithour>0 s waittime=waithour_"小时"
	if waitminute>0 s waittime=waittime_waitminute_"分"
	if waitss>0 s waittime=waittime_waitss_"秒"
	if waitdate>0 s TRequestWaitTime=waitdate_"天"_waittime
	else  s TRequestWaitTime=waittime
	if ChkQryByLoc="Y"{
		d QryByLoc	
	}else{
		s TFindIndex=ind
		d FindRBASRequestBuild
	}
	q
FindRBASRequestBuild
	set Data=$lb(TSelect,TID,TLocDesc,TDocDesc,TDate,TTimeRange,TSessionType,TRegNum,TReason,TRLocDesc,TRDocDesc,TRSessionType,TResult,TRequestAuditDate,TRequestAuditUser,TRequestType,TRequestWaitTime,TRequestDate,TRInfo,TRequestUser,TFindIndex,RBASLocID,$g(TRequestReason),NoLimitLoadFlag)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
QryByLoc
	set ^TMPRBASRequestQuery("RBASRequestQuery",CurUserID,SRequestDate,RBASLocID,STRequestType,TID)=$lb(TSelect,TID,TLocDesc,TDocDesc,TDate,TTimeRange,TSessionType,TRegNum,TReason,TRLocDesc,TRDocDesc,TRSessionType,TResult,TRequestAuditDate,TRequestAuditUser,TRequestType,TRequestWaitTime,TRequestDate,TRInfo,TRequestUser,"","",$g(TRequestReason),NoLimitLoadFlag)
	q
}

ClassMethod RBASRequestQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBASRequestQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

Query RBASRequestQuery(StartDate As %String = "", EndDate As %String = "", LocID As %String = "", DocID As %String = "", SessionTypeID As %String = "", ChkAuditStat As %String = "", ChkNew As %String = "", ChkStop As %String = "", ChkCancelStop As %String = "", ChkReplace As %String = "", ChkQryByLoc As %String = "", FindIndex As %String = "", ScheduleDate As %String = "", ReasonDr As %String = "", HospID = "") As %Query(ROWSPEC = "TSelect:%String,TID:%String,TLocDesc:%String,TDocDesc:%String,TDate:%String,TTimeRange:%String,TSessionType:%String,TRegNum:%String,TReason:%String,TRLocDesc:%String,TRDocDesc:%String,TRSessionType:%String,TResult:%String,TRequestAuditDate:%String,TRequestAuditUser:%String,TRequestType:%String,TRequestWaitTime:%String,TRequestDate:%String,TRInfo:%String,TRequestUser:%String,TIndex:%String,TLocid:%String,TRequestReason:%String,TNoLimitLoadFlag:%String")
{
}

ClassMethod GetRequestTypeDesc(RequestType)
{
	s RequestTypeDesc=$CASE(RequestType,"SC":"撤消停诊","PS":"停诊","S":"停诊","R":"替诊","N":"新增(加诊)","NS":"新增",:"")	
	q RequestTypeDesc
}

ClassMethod RefuseRBASRequest(IDs As %String, UserID As %String = "", ReasonDr As %String = "", GenFlag As %String = "")
{
	//w ##class(web.DHCRBApptSchedule).RefuseRBASRequest("1")
	n (IDs,UserID,ReasonDr,GenFlag)
	
	s NoAuditNum=0
	;s:UserID="" UserID=%session.Get("LOGON.USERID")
	if (GenFlag="Y"){
		s NewIDs=..GetRequestIDByIndex(IDs,UserID)
		s IDs=NewIDs
	}
	s Date=..%SysDate()
	s Time=..%SysTime()
	s i=$L(IDs,"^")
	s ret=0
	TSTART
	f j=1:1:i
	{
		s ID=$P(IDs,"^",j)
		s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
		s OldReqult=obj.ASRRequestResult
		i OldReqult'="N" d
		.s NoAuditNum=NoAuditNum+1
		e  d
		.d obj.ASRRequestAuditUserDRSetObjectId(UserID)
		.s obj.ASRRequestAuditDate=Date
		.s obj.ASRRequestAuditTime=Time
		.s obj.ASRRequestResult="R"
		.d obj.ASRRequestRefuseReasonDrSetObjectId(ReasonDr)
		.s sc = obj.%Save()
		.s:$$$ISERR(sc) ret="-1"
		q:ret'=0
	}
	i ret'=0
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	q NoAuditNum
}

ClassMethod DeleteRBASRequest(IDs As %String, UserID As %String = "", GenFlag As %String = "")
{
	//w ##class(web.DHCRBApptSchedule).DeleteRBASRequest("1")
	n (IDs,UserID,GenFlag)
	
	s NoAuditNum=0
	;s:UserID="" UserID=%session.Get("LOGON.USERID")
	if (GenFlag="Y"){
		s NewIDs=..GetRequestIDByIndex(IDs,UserID)
		s IDs=NewIDs
	}
	s Date=..%SysDate()
	s Time=..%SysTime()
	s i=$L(IDs,"^")
	s ret=0
	TSTART
	f j=1:1:i
	{
		s ID=$P(IDs,"^",j)
		s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
		s OldReqult=obj.ASRRequestResult
		i OldReqult'="N" d
		.s NoAuditNum=NoAuditNum+1
		e  d
		.d obj.ASRRequestAuditUserDRSetObjectId(UserID)
		.s obj.ASRRequestAuditDate=Date
		.s obj.ASRRequestAuditTime=Time
		.s obj.ASRRequestResult="D"
		.s sc = obj.%Save()
		.s:$$$ISERR(sc) ret="-1"
		q:ret'=0
	}
	i ret'=0
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	q NoAuditNum
}

// 审核申请 w ##class(web.DHCRBApptScheduleAudi).AuditRBASRequest("674",1,'Y')

ClassMethod AuditRBASRequest(IDs As %String, UserID As %String = "", GenFlag As %String = "")
{
	n (IDs,UserID,GenFlag,%session)
	s ^TmpAuditRBASRequest("AuditRBASRequest")=IDs_","_UserID_","_GenFlag
	s NoAuditNum=0
	;s:UserID="" UserID=%session.Get("LOGON.USERID")
	if (GenFlag="Y"){
		s NewIDs=..GetRequestIDByIndex(IDs,UserID)
		s IDs=NewIDs
	}
	b ;1
	s Date=..%SysDate()
	s Time=..%SysTime()
	s i=$L(IDs,"^")
	s ret=0
	TSTART
	f j=1:1:i
	{
		s ID=$P(IDs,"^",j)
		s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(ID)
		s OldReqult=obj.ASRRequestResult
		s ScheduleID=obj.ASRRBASIDGetObjectId()
		i OldReqult'="N" d
		.s NoAuditNum=NoAuditNum+1
		e  d
		.s Type=obj.ASRRequestType
		.i ((Type="S")||(Type="SA")||(Type="SP")) d
		..s ReasonDR=obj.ASRReasonDRGetObjectId()
		..s ret=##class(web.DHCRBApptSchedule).StopOneSchedule(ScheduleID,ReasonDR,UserID,Type,"1")
		..;审核停诊已经取号记录分摊
		..;i ret=0 s ret=..AuditStopShare(ScheduleID,"1")
		.//替诊
		.b ;Type=
		.else  i Type="R" d
		..s ReasonDR=obj.ASRReasonDRGetObjectId()
		..s DoctorDR=obj.ASRDoctorDRGetObjectId()
		..s LocDR=obj.ASRLocDRGetObjectId()
		..s SessionTypeDR=obj.ASRSessionTypeDRGetObjectId()
		..s ret=##class(web.DHCRBApptSchedule).ReplaceOneSchedule(ScheduleID,DoctorDR,LocDR,ReasonDR,UserID, SessionTypeDR,"1")
		.else  i (Type="N")!(Type="NS") d
		..s ret=##class(web.DHCRBApptSchedule).UpdateScheduleAuditFlag(ScheduleID,Type,UserID)
		.else  i Type="SC" d
		..s ret=##class(web.DHCRBApptSchedule).CancelStopOneSchedule(ScheduleID,"1")
		.b ;ret=
		.s:ret'=0 ret=-1
		.q:ret'=0
		.d obj.ASRRequestAuditUserDRSetObjectId(UserID)
		.s obj.ASRRequestAuditDate=Date
		.s obj.ASRRequestAuditTime=Time
		.s obj.ASRRequestResult="A"
		.s sc = obj.%Save()
		.s:$$$ISERR(sc) ret="-2"
		q:ret'=0
	}
	i ret'=0
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	q NoAuditNum
}

/// w ##class(web.DHCRBApptScheduleAudi).GetRequestIDByIndex("5^4^6",1)
ClassMethod GetRequestIDByIndex(IndexStr, UserID)
{
	n (IndexStr,UserID)
	s RequestIDStr=""
	s IndexStrLen=$l(IndexStr,"^")
	for IndexStrCount=1:1:IndexStrLen d
	.s Index=$p(IndexStr,"^",IndexStrCount)
	.Q:'$D(^TMPRBASRequestQuery("RBASRequestQueryDetail",UserID,Index))
	.s RequestID=""
	.for  s RequestID=$o(^TMPRBASRequestQuery("RBASRequestQueryDetail",UserID,Index,RequestID)) Q:RequestID=""  d
	..if RequestIDStr="" s RequestIDStr=RequestID
	..else  s RequestIDStr=RequestIDStr_"^"_RequestID
	q RequestIDStr
}

ClassMethod FindLocListBroker(HospID = "")
{
	s qstr=""
	Set rset=##Class(%ResultSet).%New("web.DHCRBApptScheduleAudi:FindLocList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(HospID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s LocRowId=rset.Data("LocRowId")
			i LocRowId="" continue
			s LocDesc=rset.Data("LocDesc")
			s selected=rset.Data("selected")
			if qstr="" s qstr=LocRowId_$c(2)_LocDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_LocRowId_$c(2)_LocDesc_$c(2)_selected
		}
	}
	q qstr
}

/// w ##class(web.DHCRBApptScheduleAudi).FindGroupListBroker()
ClassMethod FindGroupListBroker(HospID = "")
{
	s qstr=""
	s AudiNotLimitedGroupStr=..%GetConfig("AudiNotLimitedGroupStr",HospID)
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:GetGroupAll")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute("",HospID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s GroupRowID=rset.Data("GroupRowID")
			i GroupRowID="" continue
			s GroupDesc=rset.Data("GroupDesc")
			s selected=0
	 		s:("^"_AudiNotLimitedGroupStr_"^")[("^"_GroupRowID_"^") selected=1
			
			if qstr="" s qstr=GroupRowID_$c(2)_GroupDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_GroupRowID_$c(2)_GroupDesc_$c(2)_selected
		}
	}
	q qstr
}

Query FindLocList(HospID = "") As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,selected:%Boolean")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, HospID = "") As %Status [ ProcedureBlock = 1 ]
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBApptScheduleAudi","FindLocList")
	Set repid=$I(^CacheTemp)
	k ^TMP($J,"FindLocList")
    Set ind=1
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s AudiNotNeedLocStr=..%GetConfig("AudiNotNeedLocStr",HospID)
    s AdmType="O^E"
	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s LocRowId=0 f  s LocRowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,LocRowId)) Q:LocRowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",LocRowId))
		.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",LocRowId,HospID)
		.Q:##class(web.DHCOPAdmReg).CheckLocDesc(LocRowId,"")'=1
		.s LocDateTo=$p($g(^CTLOC(LocRowId)),"^",25)
		.Q:(LocDateTo'="")&&(LocDateTo<+$H)
		.q:($P(^CTLOC(LocRowId),"^",14)'="Y")
 		.s LocDesc=$p(^CTLOC(LocRowId),"^",2)
	 	.s selected=0
	 	.s:("^"_AudiNotNeedLocStr_"^")[("^"_LocRowId_"^") selected=1
	 	.s CTAliasTem=""
		.i $l(LocDesc,"-")>1 s CTAliasTem=$P(LocDesc,"-",1) s LocDesc=$P(LocDesc,"-",2)
		.s CTAlias=$P(^CTLOC(LocRowId),"^",43)
		.i CTAlias="" s CTAlias=CTAliasTem
		.s CTLOCMarkNO=##class(web.DHCINSUPort).GetCNCODE(LocDesc,4,"") ;##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",LocRowId)
		.i CTLOCMarkNO="" s CTLOCMarkNO="999"
	    .s ^TMP($J,"FindLocList",CTLOCMarkNO,LocRowId)=LocDesc_"^"_selected   //建立临时Globle
	}
	//按照序号排序
	s seq="" for {
		s seq=$O(^TMP($j,"FindLocList",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"FindLocList",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"FindLocList",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s selected=$P(temp,"^",2)
			d OutputRowFindLocList		
		}
	}

	K ^TMP($J,"FindLocList")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLocList
	set Data=$lb($g(CTRowId),$g(CTDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindAudiReason(Type As %String = "", HospID = "", ShowAll = "") As %Query(ROWSPEC = "TAudiID:%String,TAudiDesc:%String,TAudiStartDate:%String,TAudiEndDate:%String")
{
}

ClassMethod FindAudiReasonExecute(ByRef qHandle As %Binary, Type As %String = "", HospID = "", ShowAll = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBApptScheduleAudi","FindAudiReason")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s RowId=""
    for  set RowId=$o(^DHCRBASAR("RBASAR",RowId)) q:RowId=""  D
    .Q:(ShowAll'=1)&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_RBApptScheduleAudiReason",RowId,HospID))
    .s Desc=$p(^DHCRBASAR("RBASAR",RowId),"^",1)
    .s StartDate=$p(^DHCRBASAR("RBASAR",RowId),"^",2)
    .Q:(Type'="")&&(StartDate'="")&&(StartDate>+$h)
    .s:StartDate'="" StartDate=..%ZD(StartDate)
    .s EndDate=$p(^DHCRBASAR("RBASAR",RowId),"^",3)
    .Q:(Type'="")&&(EndDate'="")&&(EndDate'>+$h)
    .s:EndDate'="" EndDate=..%ZD(EndDate)
    .d OutputRowReason
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowReason
	set Data=$lb($g(RowId),$g(Desc),$g(StartDate),$g(EndDate))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAudiReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAudiReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAudiReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAudiReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:nikang
/// Desc:  保存拒绝审批原因
/// Input: Para
/// Output:
ClassMethod SetAudiReason(Para As %String, HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_RBApptScheduleAudiReason",HospID)
	s ID=$p(Para,"^",1)
	s Desc=$p(Para,"^",2)
	s StartDate=$p(Para,"^",3)
	s EndDate=$p(Para,"^",4)
	if StartDate'="" s StartDate=..%ZDH(StartDate)
	if EndDate'="" s EndDate=..%ZDH(EndDate)
	if (StartDate'="")&&(EndDate'="")&&(EndDate<StartDate) {
		Q "结束日期不能小于开始日期!"
	}
	if ID=""{
		s obj=##class(User.DHCRBApptScheduleAudiReason).%New()
	}else{
		s obj=##class(User.DHCRBApptScheduleAudiReason).%OpenId(ID)
	}
	if $IsObject(obj){
		s obj.DHCRBASARDesc=Desc
		s obj.DHCRBASARFromDate=StartDate
		s obj.DHCRBASAREndDate=EndDate
		
		set sc=obj.%Save()
		if $$$ERROR(sc) {
			s myrtn="-101"
		}else{
			s myrtn=0
			if ID=""{
				d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_RBApptScheduleAudiReason",obj.%Id(),HospID)	
			}
		}
	}
	q myrtn
}

/// w ##class(web.DHCRBApptScheduleAudi).GetRBASRequestFlag("S","3461",1,3)
/// Creator:nikang
/// Desc:  根据排班操作类型判断  是否需要审批
/// Input: Type:SC 撤销停诊 S 停诊 NS 排班生成 N 新增排班(加诊) R 替诊
///        RBASRowID 排班ID
/// 	   LogGroupID 登录安全组ID
/// Output:1 需要审批 0 无需审批
ClassMethod GetRBASRequestFlag(Type As %String, RESRowID As %String = "", LogGroupID As %String = "", LogHospID = "")
{
	n (Type,RESRowID,LogGroupID,%session,LogHospID)
	if LogHospID=""{
		s LocRowID=$p($g(^RB("RES",+RESRowID)),"^",1)
		s LogHospID=$P(^CTLOC(LocRowID),"^",22)
	}
	s LogHospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogHospID)
	if LogGroupID'=""{
		s AudiNotLimitedGroupStr=..%GetConfig("AudiNotLimitedGroupStr",LogHospID)
		if (AudiNotLimitedGroupStr'="")&&(("^"_AudiNotLimitedGroupStr_"^")[("^"_LogGroupID_"^")) q "0^"
	}
	// 组织提示数据
	s mAsRowId = RESRowID
	s mStopResDesc = ""
	if ($l(mAsRowId,"||") >= 2) {
		s mAsDate = $p($g(^RBAS(+mAsRowId,$p(mAsRowId, "||", 2))), "^", 1)
		s mAsDate = ..%ZD(mAsDate)
		s mTimeRangeId = $p($g(^RBAS(+mAsRowId,$p(mAsRowId,"||",2),"DHC")), "^", 17)
		s:mTimeRangeId'="" mTimeRange = $p($g(^DHCTimeRange(mTimeRangeId)), "^", 2)
		s mLocId = $p($g(^RB("RES",+mAsRowId)), "^", 1)
		s mLocDesc = $p($g(^CTLOC(mLocId)), "^", 2)
		s mDocId = $p($g(^RB("RES",+mAsRowId)), "^", 2)
	    S mDocDesc = $p($g(^CTPCP(mDocId,1)), "^", 2)
	    s mStopResDesc = mLocDesc_" "_mDocDesc_" "_mAsDate_" "_$g(mTimeRange)
	}
	
	s LocDesc=""
	s LocRowID=$p($g(^RB("RES",+RESRowID)),"^",1)
	if LocRowID'=""{
		s LocDesc=$p($g(^CTLOC(LocRowID)),"^",2)
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		;不受限制的科室
		s AudiNotNeedLocStr=..%GetConfig("AudiNotNeedLocStr",LogHospID)
		if AudiNotNeedLocStr'=""{
			s AudiNotNeedLocStr="^"_AudiNotNeedLocStr_"^"
			if (AudiNotNeedLocStr[("^"_LocRowID_"^")) {
				if (mStopResDesc = "") {
					q "0^"_LocDesc
				} else {
					q "0^"_mStopResDesc
				}
			}
		}
		
	}
	if Type="SC" s Type="AudiCancelStopSchedule"
	else  if Type="S" s Type="AudiStopSchedule"
	else  if Type="R" s Type="AudiReplaceSchedule"
	else  if Type="NS" s Type="AudiGeneSchedule"
	else  if Type="N" s Type="AudiNewSchedule"
	s val=..%GetConfig(Type,LogHospID)
	if val="Y" s val=1
	else  s val=0
	if ($l(RESRowID,"||") >= 2) {
		Q val_"^"_mStopResDesc
	} else {
		Q val_"^"_LocDesc
	}
}

/// w ##class(web.DHCRBApptScheduleAudi).CheckIsAuditStatus("9992||7")
/// Creator:nikang
/// Desc:  根据排班判断当前是否存在待审核的操作，若存在则不允许操作
/// Input: RBASRowID 排班ID
/// Output:"":可以继续操作 非空:不允许操作
ClassMethod CheckIsAuditStatus(RBASRowID)
{
	n (RBASRowID,%session)
	s ASRRequestType=""
	s ResRowId=$P(RBASRowID,"||",1)
	s DulResDocRowId=$p(^RB("RES",ResRowId),"^",2)
	s DulResLocRowId=$p(^RB("RES",ResRowId),"^",1)
	s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
	s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
	s RequestID=""
	for  s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",RBASRowID,RequestID)) Q:RequestID=""  d
	.s RQObj=##class(User.DHCRBApptScheduleRequest).%OpenId(RequestID)
	.s ASRRequestResult=RQObj.ASRRequestResult
	.q:ASRRequestResult'="N"
	.s ASRRequestType=RQObj.ASRRequestType
	.s ASRRequestType=..GetRequestTypeDesc(ASRRequestType)
	if ASRRequestType'="" s ASRRequestType=DulResLocDesc_" "_DulResDocDesc_"当前是"""_ASRRequestType_"""待审核状态,请等待审核后继续操作."
	Q ASRRequestType
}

/// 得到排班的最新状态
/// w ##class(web.DHCRBApptScheduleAudi).GetAuditStatus("4014||11")
ClassMethod GetAuditStatus(RBASRowID)
{
	s rtn=""
	s RequestID=""
	s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",RBASRowID,""),-1)
	if RequestID="" q ""
	s RQObj=##class(User.DHCRBApptScheduleRequest).%OpenId(RequestID)
	s ASRRequestResult=RQObj.ASRRequestResult
	s ASRRequestType=RQObj.ASRRequestType
	s ASRRequestType=..GetRequestTypeDesc(ASRRequestType)
	s AudiStat=$CASE(ASRRequestResult,"N":"待审核","A":"已审核","D":"已撤销","R":"已拒绝")	
	q ASRRequestType_AudiStat
}

/// 再次申请审批
ClassMethod AuditStatusAgain(RBASRowID, UserID)
{
	s RequestID=""
	s RequestID=$o(^User.DHCRBApptScheduleRequestI("RBASIDIndex",RBASRowID,""),-1)
	if RequestID="" q ""
	s obj=##class(User.DHCRBApptScheduleRequest).%OpenId(RequestID)
	s ASRRequestType=obj.ASRRequestType
	s ASRReasonDR=obj.ASRReasonDRGetObjectId()
	s ASRDoctorDR=obj.ASRDoctorDRGetObjectId()
	s ASRLocDR=obj.ASRLocDRGetObjectId()
	s ASRSessionTypeDR=obj.ASRSessionTypeDRGetObjectId()
	s ASRRBASDR=obj.ASRRBASDRGetObjectId()
	s InfoStr=ASRRequestType_"^"_ASRReasonDR_"^"_ASRDoctorDR_"^"_ASRLocDR_"^"_ASRSessionTypeDR_"^"_ASRRBASDR
	s rtn=##class(web.DHCRBApptSchedule).RBASRequest(RBASRowID,InfoStr,UserID)
	q rtn
}

}
