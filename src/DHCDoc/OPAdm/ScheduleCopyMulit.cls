Class DHCDoc.OPAdm.ScheduleCopyMulit Extends DHCDoc.Util.RegisteredObject
{

Query GetApptScheduleCopy(MasterASRowID As %String, StDate As %String, EnDate As %String) As %Query(ROWSPEC = "LocDesc:%String:出诊科室,DocDesc:%String:出诊医生,ASSessionType:%String:职称,ASSessStartTime:%String:开始时间,TimeRange:%String:时段,ASRoom:%String:诊室名称,ASQueueNoCount:%String:合计限额,ASAppLoad:%String:预约限额,ASLoad:%String:挂号限额,ASStatus:%String:状态,ASReason:%String:原因,ASRowId:%String:排班ID,ASAddLoad:%String:加号限额,LoginTime:%String,LoginStatus:%String,ASAutoLoad:%String,ASExtLoad:%String,AppStartSeqNo:%String:预约起始号,IrregularFlag:%String:异常,ASSessionEndTime:%String:结束时间,RegisterNum:%String:已挂号数,AppedNum:%String:已预约数,AppedArriveNum:%String:已取号数,QueueNO:%String:剩号,ASDate:%String:出诊日期,ASAuditStatus:%String,Docdr:%String,LocDr:%String,ReferralUser:%String,ClinicGroupStr:%String,AppMethodStr:%String,AppTRInfoStr:%String,ASWeek:%String,NoLimitLoadFlag:%String")
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","GetApptSchedule",305,"","2016-09-12","2016-09-12",2919,206,"",5)
/// Type 0查询所有 1 查询停诊、替诊、暂停 2用于判断日期是否有出诊记录
ClassMethod GetApptScheduleCopyExecute(ByRef qHandle As %Binary, MasterASRowID As %String, StDate As %String, EnDate As %String) As %Status
{
	s ^tempGetApptScheduleExecute=MasterASRowID_","_StDate_","_EnDate
	s repid=$I(^CacheTemp)
	s ind=1
	kill ^TMP("GetApptScheduleCopy",$j)
	if StDate["-" Set StDate=$zdh(StDate,3)
	if EnDate["-" Set EnDate=$zdh(EnDate,3)
	if StDate'="" s StDate=..%ZDH(StDate)
	if EnDate'="" s EnDate=..%ZDH(EnDate)
	s qHandle=$lb(0,repid,0)
	Q:((StDate="")||(EnDate ="")) $$$OK
	Q:(MasterASRowID="") $$$OK
	
	s MasterTimeRange=$P(^RBAS(+MasterASRowID,$P(MasterASRowID,"||",2),"DHC"),"^",17) 
	s Startdate=StDate-1 
	s RBRowId=+MasterASRowID
	for{
		s Startdate=$o(^RBAS(RBRowId,0,"DateSTime",Startdate)) 
		q:(Startdate>EnDate)||(Startdate="")
		s DateSTime=""
		for{
			s DateSTime=$o(^RBAS(RBRowId,0,"DateSTime",Startdate,DateSTime)) 
			q:DateSTime=""
			s ASChildSub=""
			for {
				s ASChildSub=$o(^RBAS(RBRowId,0,"DateSTime",Startdate,DateSTime,ASChildSub))
				q:ASChildSub=""
				continue:'$$checkValid(RBRowId,ASChildSub,Startdate)
			    s LocDr=$p(^RB("RES",RBRowId),"^",1)
			    s LocHospDr=$p(^CTLOC(LocDr),"^",22)
			    Set IrregularFlag=$p(^RBAS(RBRowId,ASChildSub),"^",13)
			    s locDesc=$p(^CTLOC(LocDr),"^",2)
			    s Docdr=$p(^RB("RES",RBRowId),"^",2)
			    S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
			    s ASSessionType=""
			    s ASSessionTypeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",6)
			    i ASSessionTypeDR'="" s ASSessionType=$p(^RBC("SESS",ASSessionTypeDR),"^",2)
			    s ASSessStartTime=$p(^RBAS(RBRowId,ASChildSub),"^",4)
			    s ASSessStartTime=..%ZT(ASSessStartTime)
				s SessionEndTime=$p(^RBAS(RBRowId,ASChildSub),"^",5)
				s SessionEndTime=..%ZT(SessionEndTime,1)
			    s ASTimeRangeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",17)
			    continue:ASTimeRangeDR'=MasterTimeRange
			    s TimeRange=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
			    s ASRoom=""
			    s ASRoomDr=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",5)
			    i ASRoomDr'="" s ASRoom=$p(^CTLOC(ASRoomDr),"^",2)
				s ASStatusDR=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",10)
				S ASStatus=$P(^DHCRBCASStatus(ASStatusDR),"^",2)
				s ASStatusCode=$P(^DHCRBCASStatus(ASStatusDR),"^",1)
				s ReferralUser=$case(ASStatusCode,"R":$$GetReferralUser(RBRowId,ASChildSub),:"")
			    s ASReasonDr=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",11)
			    s ASReason=""
			    i ASReasonDr'="" s ASReason=$p(^RBC("NA",ASReasonDr),"^",2)
			    i ASStatus="正常" s ASReason=""
			    s LoginStr=##class(web.DHCApptScheduleNew).GetUserLoginTime(LocDr,Docdr,ASTimeRangeDR,Startdate)
			    s LoginTime=$p(LoginStr,"^",1)
			    s LoginStatus=$p(LoginStr,"^",2)
			    s DocDesc=##class(web.DHCOPAdmReg).CutLetter(DocDesc)
			    s AutoLoad=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",27)
				s ExtLoad=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",28)
				s AppStartSeqNo=$P(^RBAS(RBRowId,ASChildSub),"^",10) //预约起始号
				s QueueNO=$P($G(^RBAS(+RBRowId,ASChildSub,"DHC")),"^",4)
				s retnum=##class(web.DHCApptScheduleNew).GetRegisterNum(QueueNO)
				s RegisterNum=$P(retnum,"^",1)
				s AppedNum=$P(retnum,"^",2)
				s AppedArriveNum=$P(retnum,"^",3)
				;s QueueNO=##class(web.DHCRBAppointment).GetAvailableNum(RBRowId_"||"_ASChildSub,"NOR","WIN","")  //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(RBRowId_"||"_ASChildSub,"NOR") //##class(web.DHCRBResourceRule).GetFreeQueueNO(QueueNO)
				s NoLimitLoadFlag=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",31)
				s ASLoadJsonInfo=##class(web.DHCApptScheduleNew).GetASLoadInfo(RBRowId_"||"_ASChildSub)
				s ASLoadJsonObj={}.%FromJSON(ASLoadJsonInfo)
				s ASLoad=ASLoadJsonObj.ASLoad
				s ASAppLoad=ASLoadJsonObj.ASAppLoad
				s AppStartSeqNo=ASLoadJsonObj.AppStartSeqNo
				s AddLoad=ASLoadJsonObj.AddLoad
				s QueueNO=ASLoadJsonObj.LeftLoad
				
				s ASQueueNoCount=ASLoadJsonObj.ASQueueNoCount
				s ASDate=$P(^RBAS(+RBRowId,ASChildSub),"^",1)
				s ASDate=..%ZD(ASDate) 
				s ASAuditStatus=##class(web.DHCRBApptScheduleAudi).GetAuditStatus(RBRowId_"||"_ASChildSub)
				s ClinicGroupStr=##class(web.DHCApptScheduleNew).GetClinicGroupDrStr(RBRowId_"||"_ASChildSub)
				if ClinicGroupStr'="" s ClinicGroupStr=$P(ClinicGroupStr,"^",2)
				Set IrregularFlag=$p(^RBAS(+RBRowId,ASChildSub),"^",13)
				if (IrregularFlag="A"){s IrregularFlag="不规则排班"}else{s IrregularFlag=""}
				s AppMethodJSON=..GetAppMethodsInfo(RBRowId_"||"_ASChildSub) 
				s AppMethodStr=""
				if (AppMethodJSON'=""){
					s ASAppQtyObj={}.%FromJSON(AppMethodJSON)
					for i=1:1:ASAppQtyObj.%Size(){
						s obj=ASAppQtyObj.%Get(i-1)
						if i'=1 s AppMethodStr=AppMethodStr_","
						s AppMethodStr=AppMethodStr_obj.AppMethod_"-"_obj.ReserveQty_"-"_obj.MaxQty
					}
				}
				s ASTRFlag=$P(^RBAS(+RBRowId,ASChildSub,"DHC"),"^",19)
				s AppTRInfoStr=""
				if (ASTRFlag="Y"){
					s AppTRInfoJSON=..GetTRInfoNew(RBRowId_"||"_ASChildSub) 
					if (AppTRInfoJSON'=""){
						s ASAppQtyObj={}.%FromJSON(AppTRInfoJSON)
						for i=1:1:ASAppQtyObj.%Size(){
							s obj=ASAppQtyObj.%Get(i-1)
							if i'=1 s AppTRInfoStr=AppTRInfoStr_","
							s AppTRInfoStr=AppTRInfoStr_obj.SttTime_"-"_obj.EndTime_"-"_obj.Load
						}
					}
				}
				s ASWeek=$zd(Startdate,10)
				s ASWeek=$case(ASWeek,"1":"星期一","2":"星期二","3":"星期三","4":"星期四","5":"星期五","6":"星期六","0":"星期日",:"")
				Set data = $lb(locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,$g(ASRoom),ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,$g(ASReason),RBRowId_"||"_ASChildSub,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr,ReferralUser,ClinicGroupStr,AppMethodStr,AppTRInfoStr,ASWeek,NoLimitLoadFlag)
				s sort=Startdate
				Set ^TMP("ApptScheduleListArr",$j,sort,RBRowId_"||"_ASChildSub)=data
				}
			}
		}  
	Set ind=1
	Set L1="" For  Set L1=$O(^TMP("ApptScheduleListArr",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("ApptScheduleListArr",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("ApptScheduleListArr",$j,L1,L2)
	..Set ind=ind+1 	
	kill ^TMP("ApptScheduleListArr",$j)
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK


checkValid(RBRowId,ASChildSub,Startdate)
	Q:'$d(^RBAS(RBRowId,ASChildSub)) 0
	s ASStatusDR=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(ASStatusDR),"^",1)
	;Q:(Type=1)&&((ASStatusCode="S")||(ASStatusCode="PS")||(ASStatusCode="TR")) 0
	;Q:((SelectStop="Y")&&(ASStatusCode'="S")) 0
	s Docdr=$p(^RB("RES",RBRowId),"^",2)
    ;Q:(Doc'="")&&(Docdr'=Doc) 0
    s ActiveFlag=$p($g(^CTPCP(Docdr,1)),"^",9)
    Q:ActiveFlag'="Y" 0
    s DocDateTo=$p($g(^CTPCP(Docdr,2)),"^",15)
    Q:(DocDateTo'="")&&(DocDateTo<+$h) 0
    s ASTimeRangeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",17) 
   ; Q:(paraTimeRange'="")&&(ASTimeRangeDR'=paraTimeRange) 0
    s ASDate=$P(^RBAS(+RBRowId,ASChildSub),"^",1)
    ;s Week=$ZD(ASDate,10)
	;s:Week=0 Week=7
	;Q:((WeekStr'="")&&(WeekStr'[Week)) 0
	Set IrregularFlag=$p(^RBAS(+RBRowId,ASChildSub),"^",13)
    s PlanFlag=0
    if (IrregularFlag'="A")&&(ASStatusCode'="A")&&(ASStatusCode'="R")&&(ASStatusCode'="TR"){
		s DateChild=0 for {
			s DateChild=$O(^RB("RES",RBRowId,"DATE",DateChild)) Q:DateChild=""  
			s SESSChild=0 f  {
				s SESSChild=$O(^RB("RES",RBRowId,"DATE",DateChild,"SESS",SESSChild)) Q:SESSChild=""  
			    continue:'$d(^RB("RES",RBRowId,"DATE",DateChild,"SESS",SESSChild))
				S SessDOWRowid=$p(^RB("RES",RBRowId,"DATE",DateChild,"SESS",SESSChild),"^",2)
				s TRRowId=$p(^RB("RES",RBRowId,"DATE",DateChild,"SESS",SESSChild),"^",3)
				s Weekflag=$Zd(Startdate,10)
				if Weekflag=0 s Weekflag=7
				continue:Weekflag'=SessDOWRowid
				continue:TRRowId'=ASTimeRangeDR
				s PlanFlag=1
			}
		}
    }
	;Q:((PlanSchedule="true")&&(PlanFlag'=1)) 0
    Q 1
GetReferralUser(RBRowId,ASChildSub)
	s DocName=""
	s ReferralRBAS=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",12)
	if ReferralRBAS'="" {
		s DocId=$p(^RB("RES",+ReferralRBAS),"^",2)
		s DocName=$p(^CTPCP(DocId,1),"^",2)
	}
	q DocName
}

ClassMethod GetApptScheduleCopyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptScheduleCopyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApptScheduleCopyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptScheduleCopyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod MulitUpdateAllScheduleInfo(MasterASRowid, NeedASRowidStr, UserID)
{
	s ^tempqujina("MulitUpdateScheduleInfo")=MasterASRowid_","_NeedASRowidStr_","_UserID
	s ret=0
	q:((MasterASRowid="")||(NeedASRowidStr="")) ""
	s Len=$l(NeedASRowidStr,"^")
	for i=1:1:Len{
		s OneASRowID=$P(NeedASRowidStr,"^",i)
		set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_OneASRowID_"^"_"User.DHCRBApptSchedule"_$c(2)_OneASRowID)
		set schedule=##class(User.RBApptSchedule).%OpenId(OneASRowID)
		set DHCschedule=##class(User.DHCRBApptSchedule).%OpenId(OneASRowID)
		s ASRoomDR=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",5)
		do DHCschedule.ASRoomDRSetObjectId(ASRoomDR)
		s SessStartTime=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",4)
		set schedule.ASSessStartTime=SessStartTime
		s SessEndTime=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",5)
		set schedule.ASSessEndTime=SessEndTime
		s ClinicGroupDRStr=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",29)
		set DHCschedule.ASClinicGroupDRStr=ClinicGroupDRStr
		set ScheduleDate=schedule.ASDate
		set RoomID=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",5)
		set rtn=##class(web.DHCRBResourceRule).CheckSchedule(+OneASRowID,ScheduleDate,RoomID, SessStartTime,OneASRowID)
		if rtn'=0 {
			s retcode=$P(rtn,"^",1)
			s DulASRowId=$P(rtn,"^",2)
			if (DulASRowId'=""){
				s DulResRowId=$P(DulASRowId,"||",1)
				s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
				s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
				s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
				s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
			}
			s ret=retcode_"^"_DulResLocDesc_DulResDocDesc
			Q
		}
		;正号最大额,包括预约
		s TotalNum=$p(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",8)
		s NormalCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"NOR")
		if NormalCount>TotalNum s ret="-203^"_OneASRowID Q
		set oldTotalNum=schedule.ASLoad
		s schedule.ASLoad=TotalNum
		s ApptSession=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",2)
		;预约号最大值
		s AppCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"APP")
		if AppCount>ApptSession s ret="-204^"_OneASRowID Q
		s schedule.ASNoApptSession=ApptSession
		s QueueNoCount=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",10)
		set schedule.ASQueueNoCount=QueueNoCount
		s OverbookAllowed=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",3)
		s ASTRFlag=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",19)
		;加号最大值
		s AddCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"ADD")
		i AddCount>OverbookAllowed s ret="-205^"_OneASRowID Q
		s NoLimitLoadFlag=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",31)
		s oldTotalNum=schedule.ASLoad
		s oldOverBookNum=DHCschedule.ASNoOverbookAllowed
		s DHCschedule.ASNoOverbookAllowed=OverbookAllowed
		s DHCschedule.ASTimeRangeFlag=ASTRFlag
		s DHCschedule.ASNoLimitLoadFlag=NoLimitLoadFlag
		s oldQueueNo=DHCschedule.ASQueueNo
		s OverBookNum=OverbookAllowed
		s DHCschedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,TotalNum,oldOverBookNum,OverBookNum,OneASRowID,NoLimitLoadFlag)
		s AppJson=..GetAppMethodsInfo(MasterASRowid)
		&SQL(DELETE FROM SQLUser.DHC_RBApptScheduleAppQty WHERE ASQASParRef=:OneASRowID)
		d ##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(OneASRowID,AppJson,UserID)
		s AppJson=..GetTRInfoNew(MasterASRowid)
		&SQL(DELETE FROM SQLUser.RB_ApptScheduleTR WHERE ASTR_ParRef=:OneASRowID)
		d ##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(OneASRowID,AppJson)
		Set sc = DHCschedule.%Save()
		If $$$ISERR(sc) {
			Do $System.Status.DisplayError()
			Quit
		}
		Set sc = schedule.%Save()
		If $$$ISERR(sc) {
			Do $System.Status.DisplayError()
			Quit
		}
		;医生站业务数据修改日志
		set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBApptSchedule"_$c(2)_OneASRowID_"^"_"User.DHCRBApptSchedule"_$c(2)_OneASRowID)
		set ret=##class(web.DHCDocDataChangeLog).SaveLog("RB_ApptSchedule#DHC_RBApptSchedule","User.RBApptSchedule#User.DHCRBApptSchedule","排班信息","User.RBApptSchedule#User.DHCRBApptSchedule_"_OneASRowID,$p($g(^RB("RES",+OneASRowID)),"^",17),"U",NewDataJson,OldDataJson)

	}
		q ret
}

/// 同步其他日期的排班信息
/// 可以同步修改诊室，开始时间，结束时间，亚专业，正号限额，预约限额，起始号，加号限额，预约方式，分时段数
/// NeedASRowidStr根据^分割
/// w ##class(DHCDoc.OPAdm.ScheduleCopyMulit).MulitUpdateScheduleInfo("23||5","23||14","PositiveMax",60,1)
ClassMethod MulitUpdateScheduleInfo(MasterASRowid, NeedASRowidStr, Type, Info As %String = "", UserID)
{
	s ^tempqujina("MulitUpdateScheduleInfo")=MasterASRowid_","_NeedASRowidStr_","_Type_","_Info_","_UserID
	s ret=0
	q:((MasterASRowid="")||(NeedASRowidStr="")||(Type="")) ""
	s Len=$l(NeedASRowidStr,"^")
	for i=1:1:Len{
		s OneASRowID=$P(NeedASRowidStr,"^",i)
		set schedule=##class(User.RBApptSchedule).%OpenId(OneASRowID)
		set DHCschedule=##class(User.DHCRBApptSchedule).%OpenId(OneASRowID)
		if (Type="LocArea"){
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",5)
			do DHCschedule.ASRoomDRSetObjectId(Info)
		}elseif (Type="StartTime"){
			if Info'="",Info[":"  s Info=..%ZTH(Info)
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",4)
			set schedule.ASSessStartTime=Info
		}elseif (Type="EndTime"){
			if Info'="",Info[":"  s Info=..%ZTH(Info)
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",5)
			set schedule.ASSessEndTime=Info
		}elseif (Type="ClinicGroup"){
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",29)
			set DHCschedule.ASClinicGroupDRStr=Info
		}elseif (Type="PositiveMax"){
			;正号最大额,包括预约
			s NormalCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"NOR")
			if NormalCount>Info s ret="-203^"_OneASRowID Q
			set oldTotalNum=schedule.ASLoad
			s schedule.ASLoad=Info
			set oldOverBookNum=DHCschedule.ASNoOverbookAllowed
			set oldQueueNo=DHCschedule.ASQueueNo
			s TotalNum=Info
			s OverBookNum=oldOverBookNum
			set DHCschedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,TotalNum,oldOverBookNum,OverBookNum,OneASRowID)
		}elseif (Type="ApptMax"){
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",2)
			;预约号最大值
			s AppCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"APP")
			if AppCount>Info s ret="-204^"_OneASRowID Q
			s schedule.ASNoApptSession=Info
		}elseif (Type="EStartPrefix"){
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2)),"^",10)
			set schedule.ASQueueNoCount=Info
		}elseif (Type="AddtionMax"){
			if (Info="") s Info=$P(^RBAS(+MasterASRowid,$P(MasterASRowid,"||",2),"DHC"),"^",3)
			;加号最大值
			s AddCount=##class(web.DHCRBApptSchedule).GetNotAvailSeqNoCount(OneASRowID,"ADD")
			i AddCount>Info s ret="-205^"_OneASRowID Q
			set oldTotalNum=schedule.ASLoad
			set oldOverBookNum=DHCschedule.ASNoOverbookAllowed
			set DHCschedule.ASNoOverbookAllowed=Info
			set oldQueueNo=DHCschedule.ASQueueNo
			s TotalNum=oldTotalNum
			s OverBookNum=Info
			set DHCschedule.ASQueueNo=##class(web.DHCRBResourceRule).EditQueueNO(oldQueueNo,oldTotalNum,TotalNum,oldOverBookNum,OverBookNum,OneASRowID)
		}elseif (Type="AppMethod"){
			s AppJson=..GetAppMethodsInfo(MasterASRowid)
			&SQL(DELETE FROM SQLUser.DHC_RBApptScheduleAppQty WHERE ASQASParRef=:OneASRowID)
			d ##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(OneASRowID,AppJson,UserID)
		}elseif (Type="AppASFlag"){
			s AppJson=..GetTRInfoNew(MasterASRowid)
			&SQL(DELETE FROM SQLUser.RB_ApptScheduleTR WHERE ASTR_ParRef=:OneASRowID)
			d ##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(OneASRowID,AppJson)
			}
			Set sc = DHCschedule.%Save()
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError()
				Quit
			}
			Set sc = schedule.%Save()
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError()
				Quit
			}
		
		}
		q ret
}

ClassMethod GetTRInfoNew(ASRowid)
{
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s TimeRanges=[]
	s ASTRSub=0 for{
		s ASTRSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub)) Q:ASTRSub=""
		s ASTRObj={}
		s ASTRObj.ASTRRowid=""
		s SttTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",1)
		s ASTRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml(SttTime)
		s EndTime=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",2)
		s ASTRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
		s ASTRObj.Load=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub),"^",3)
		s TRAppMethods=[]
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub)) Q:TRAMSub=""
			s TRAMObj={}
			s TRAMObj.TRAMRowid=ASRowid_"||"_ASTRSub_"||"_TRAMSub
			s TRAMObj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
			s TRAMObj.AppMethod=$P($G(^RBC("APTM",+TRAMObj.AppMethodID)),"^",2)
			s TRAMObj.MaxQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
			s TRAMObj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
			d TRAppMethods.%Push(TRAMObj)
		}
		s ASTRObj.tabTRAppMethodInfo=TRAppMethods
		s TRClinicGroup=[]
		s TRAMSub=0 for{
			s TRAMSub=$O(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub)) Q:TRAMSub=""
			s TRAMObj={}
			s TRAMObj.TRClinicGroupRowid=ASRowid_"||"_ASTRSub_"||"_TRAMSub
			s TRAMObj.ClinicGroupMethodID=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub),"^",1)
			s TRAMObj.ClinicGroup=$P(^RBC("CLGRP",TRAMObj.ClinicGroupMethodID),"^",2)
			s TRAMObj.Qty=$P(^RBAS(ResRowid,ASSub,"ASTR",ASTRSub,"TRCG",TRAMSub),"^",2)
			d TRClinicGroup.%Push(TRAMObj)
		}
		s ASTRObj.tabTRClinicGroupInfo=TRClinicGroup
		d TimeRanges.%Push(ASTRObj)
	}
	Q TimeRanges.%ToJSON()
}

ClassMethod GetAppMethodsInfo(ASRowid)
{
	q:ASRowid="" "[]"
	s ResRowid=+ASRowid,ASSub=$P(ASRowid,"||",2)
	s AppMethods=[]
	s ASQSub=0 for{	;预约方式限额
		s ASQSub=$O(^RBAS(ResRowid,ASSub,"AQ",ASQSub)) Q:ASQSub=""
		s obj={}
		s obj.ASAMRowid=""
		s obj.AppMethodID=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",1)
		s obj.AppMethod=$P(^RBC("APTM",obj.AppMethodID),"^",2)
		s obj.StartNo=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",3)
		s obj.ReserveQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",2)
		s obj.MaxQty=$P(^RBAS(ResRowid,ASSub,"AQ",ASQSub),"^",7)
		d AppMethods.%Push(obj)
	}
	Q AppMethods.%ToJSON()
}

}
