Class web.DHCApptScheduleNew Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(web.DHCApptScheduleNew).GetAdmDateStr("2019-08-23",^tempscl("GetAdmDateStr"))
ClassMethod GetAdmDateStr(StartDate As %String, ParamJson As %String = "")
{
	s ^tempscl("GetAdmDateStr")=ParamJson
	if StartDate=""{
		Set StartDate=..%SysDate()
	}else{
		Set StartDate=..%ZDH(StartDate)
	}
	if (ParamJson'="") {
		k ParaCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ParamJson,.ParaCongeriesArr)
	}
	s weekstr="日,一,二,三,四,五,六"
	//获取一周内的日期串
	s ExistScheduleFlag=0
	if $d(ParaCongeriesArr) {
		 Set rset=##class(%ResultSet).%New("web.DHCApptScheduleNew:GetApptSchedule")
		 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),(StartDate),(StartDate),ParaCongeriesArr("Arg5"),ParaCongeriesArr("Arg6"),ParaCongeriesArr("Arg7"),ParaCongeriesArr("Arg8"),ParaCongeriesArr("Arg9"),ParaCongeriesArr("Arg10"),ParaCongeriesArr("Arg11"),ParaCongeriesArr("Arg12"),ParaCongeriesArr("Arg13"),ParaCongeriesArr("Arg14"))
		 While (rset.Next()) {
			s ExistScheduleFlag=1
		 }
		 d rset.Close()
	}
	s str=..%ZD(StartDate)_"(周"_$p(weekstr,",",$zd(StartDate,10)+1)_")"_$C(1)_ExistScheduleFlag
	for i=1:1:6{
		s ExistScheduleFlag=0
		if $d(ParaCongeriesArr) {
			 Set rset=##class(%ResultSet).%New("web.DHCApptScheduleNew:GetApptSchedule")
			 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),(StartDate+i),(StartDate+i),ParaCongeriesArr("Arg5"),ParaCongeriesArr("Arg6"),ParaCongeriesArr("Arg7"),ParaCongeriesArr("Arg8"),ParaCongeriesArr("Arg9"),ParaCongeriesArr("Arg10"),ParaCongeriesArr("Arg11"),ParaCongeriesArr("Arg12"),ParaCongeriesArr("Arg13"),ParaCongeriesArr("Arg14"))
			 While (rset.Next()) {
				s ExistScheduleFlag=1
			 }
			 d rset.Close()
		}
		s str=str_"^"_..%ZD(StartDate+i)_"(周"_$p(weekstr,",",$zd((StartDate+i),10)+1)_")"_$C(1)_ExistScheduleFlag	
	}
	Quit str
}

/// w ##class(web.DHCApptScheduleNew).GetMonday("20/06/2016")
/// 根据日期获取本周的周一点
ClassMethod GetMonday(StartDate As %String)
{
	s Monday=""
	if StartDate=""{
		Set StartDate=..%SysDate()
	}else{
		//if StartDate["/" Set StartDate=$zdh(StartDate,4)	
		//if StartDate["-" Set StartDate=$zdh(StartDate,3)	
		Set StartDate=..%ZDH(StartDate)
	}
	s weekday=$zd(StartDate,10)
	s Monday=..%ZD(StartDate-weekday+1)  //$zd(StartDate-weekday+1,3)
	Quit Monday
}

Query GetApptSchedule(Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "", SDocSession As %String = "", SStatus As %String = "") As %Query(ROWSPEC = "LocDesc:%String:出诊科室,DocDesc:%String:出诊医生,ASSessionType:%String:职称,ASSessStartTime:%String:开始时间,TimeRange:%String:时段,ASRoom:%String:诊室名称,ASQueueNoCount:%String:合计限额,ASAppLoad:%String:预约限额,ASLoad:%String:挂号限额,ASStatus:%String:状态,ASReason:%String:原因,ASRowId:%String:排班ID,ASAddLoad:%String:加号限额,LoginTime:%String,LoginStatus:%String,ASAutoLoad:%String,ASExtLoad:%String,AppStartSeqNo:%String:预约起始号,IrregularFlag:%String:异常,ASSessionEndTime:%String:结束时间,RegisterNum:%String:已挂号数,AppedNum:%String:已预约数,AppedArriveNum:%String:已取号数,QueueNO:%String:剩号,ASDate:%String:出诊日期,ASAuditStatus:%String,Docdr:%String,LocDr:%String,ReferralUser:%String,StopRegFlag:%String,NoLimitLoadFlag:%String")
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","GetApptSchedule",305,"","2016-09-12","2016-09-12",2919,206,"",5)
/// Type 0查询所有 1 查询停诊、替诊、暂停 2用于判断日期是否有出诊记录
ClassMethod GetApptScheduleExecute(ByRef qHandle As %Binary, Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "", SDocSession As %String = "", SStatus As %String = "") As %Status
{
	s ^tempGetApptScheduleExecute=Loc_","_Doc_","_StDate_","_EnDate_","_userid_","_groupid_","_ResID_","_ExaID_","_paraTimeRange_","_Type_","_PlanSchedule
	s repid=$I(^CacheTemp)
	s ind=1
	kill ^TMP("ApptScheduleListArr",$j)
	if StDate["-" Set StDate=$zdh(StDate,3)
	if EnDate["-" Set EnDate=$zdh(EnDate,3)
	if StDate'="" s StDate=..%ZDH(StDate)
	if EnDate'="" s EnDate=..%ZDH(EnDate)
	s qHandle=$lb(0,repid,0)
	Q:((StDate="")||(EnDate ="")) $$$OK
	Q:(Type="")&&(Loc="")&&(Doc="")&&(ExaID="")&&(ResID="")&&(SelectStop'="Y") $$$OK
	;如果是用于判断日期是否有出诊记录,必须是科室以下的范围;诊区没有意义
	Q:(Type=2)&&(Loc="")&&(Doc="")&&(ResID="") $$$OK
	i Loc'=""  {
	  s CTLocDateTo=$p($g(^CTLOC(Loc)),"^",25)
	  i (CTLocDateTo'="")&&(CTLocDateTo<+$h) Quit $$$OK
	}
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Set langid=..%LanguageID()
	s DefaultLoc=1 //%session.Get("LOGON.CTLOCID")
	// 门办不限制
	/*s flag=0
	if groupid'="" {
		s groupdesc=$p($g(^SSU("SSGRP",groupid)),"^",1)
		if groupdesc["门办" s flag=1
	}*/
	// 按操作员诊区对照限制
	s DepStr="" 
	if ExaID'="" {
		//未进行诊区科室对照的科室列表
		if (ExaID="Other"){
			s AdmTypeStr="O^E"
			for i=1:1:$l(AdmTypeStr,"^"){
				s AdmType=$p(AdmTypeStr,"^",i)
				s myrowid=0
				for  {
					s myrowid=$o(^PAC("ADMLOC",0,"AdmType",AdmType,myrowid)) 
					q:myrowid=""
					if '$d(^CTLOC(myrowid)) continue
					continue:$d(^User.DHCExaBorDepI("BordDepDrIndex",myrowid))
					s DepDateTo=$p($g(^CTLOC(myrowid)),"^",25)
					continue:(DepDateTo'="")&&(DepDateTo<+$H)
					continue:("^"_DepStr_"^")[("^"_myrowid_"^")
					if DepStr="" s DepStr=myrowid
					else  s DepStr=DepStr_"^"_myrowid
				}
			}
		}else{
			s ExaBorough=ExaID
			d GetDepStr
		}
	}
	If (ResID'="") {
		d sdsd(ResID,Type,langid)
	}elseif (Loc'=""){
		s RBRowId="" for {
			s RBRowId=$o(^RB("RES",0,"CTLOC",Loc,RBRowId)) Q:RBRowId=""
			;b ;03345
			s QuitFlag=$$sdsd(RBRowId,Type,langid)
			Q:QuitFlag=1
		}
	}elseif (ExaID'=""){
		for i=1:1:$length(DepStr,"^"){
			s Loc=$p(DepStr,"^",i)
			continue:Loc=""
			s RBRowId="" for {
				s RBRowId=$o(^RB("RES",0,"CTLOC",Loc,RBRowId)) Q:RBRowId=""
				s QuitFlag=$$sdsd(RBRowId,Type,langid)
				q:QuitFlag=1
			}
		}
	}else{ 
		s RBRowId=0
		for {
			Set RBRowId=$o(^RBAS(RBRowId)) Quit:RBRowId=""
			s QuitFlag=$$sdsd(RBRowId,Type,langid)
			q:QuitFlag=1
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

GetDepStr
	s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaBorough,ID)) q:ID=""  do
	.s DeptID=$list(^User.DHCExaBorDepD(ID),7)
	.q:DeptID="" 
	.q:'$d(^CTLOC(DeptID))
	.s DepDateTo=$p($g(^CTLOC(DeptID)),"^",25)
	.Q:(DepDateTo'="")&&(DepDateTo<+$H)
	.q:("^"_DepStr_"^")[("^"_DeptID_"^")
	.if DepStr="" s DepStr=DeptID
	.else  s DepStr=DepStr_"^"_DeptID
	quit
	
sdsd(RBRowId,Type,langid)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RBRowId,HospId) 0
	b ;Type=2 表示为检索日期是否有出诊记录,不检索明细
	if Type=2 {
		/*s ASChildSub=$o(^RBAS(0,"Date",StDate,RBRowId,0))
		i ASChildSub'="" {
			s (locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,ASRoom,ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,ASReason,ASRowId,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr)=""
			Set data = $lb(locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,ASRoom,ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,ASReason,ASRowId,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr)
			set sort="不处理"
			Set ^TMP("ApptScheduleListArr",$j,sort,RBRowId_"||"_ASChildSub)=data
			q 1
		}*/
		s ExistFlag=0
		s ASChildSub=0
		for {
			s ASChildSub=$o(^RBAS(0,"Date",StDate,RBRowId,ASChildSub)) Q:(ASChildSub="")||(ExistFlag=1)
			continue:'$$checkValid(RBRowId,ASChildSub,StDate)
			s ExistFlag=1
		}
		if (ExistFlag=1) {
			s (locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,ASRoom,ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,ASReason,ASRowId,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr)=""
			Set data = $lb(locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,ASRoom,ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,ASReason,ASRowId,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr)
			set sort="不处理"
			Set ^TMP("ApptScheduleListArr",$j,sort,RBRowId_"||"_ASChildSub)=data
			q 1
		}
		Q 0
	}
  	if RBRowId'="",$d(^RB("RES",RBRowId)) do
  	.s DateTo=$p(^RB("RES",RBRowId),"^",19)
	.s Startdate=StDate-1 f  s Startdate=$o(^RBAS(RBRowId,0,"DateSTime",Startdate)) q:(Startdate>EnDate)||(Startdate="")  d
	..s DateSTime="" f  s DateSTime=$o(^RBAS(RBRowId,0,"DateSTime",Startdate,DateSTime)) q:DateSTime=""  d
    ...s ASChildSub="" f  s ASChildSub=$o(^RBAS(RBRowId,0,"DateSTime",Startdate,DateSTime,ASChildSub)) q:ASChildSub=""  d
    ....Q:'$$checkValid(RBRowId,ASChildSub,Startdate)
    ....s LocDr=$p(^RB("RES",RBRowId),"^",1)
    ....s LocHospDr=$p(^CTLOC(LocDr),"^",22)
    ....Set IrregularFlag=$p(^RBAS(RBRowId,ASChildSub),"^",13)
    ....s locDesc=$p(^CTLOC(LocDr),"^",2)
    ....s locDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locDesc,langid)
    ....s Docdr=$p(^RB("RES",RBRowId),"^",2)
    ....S DocDesc=$p(^CTPCP(Docdr,1),"^",2)
    ....Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
    ....s ASSessionType=""
    ....s ASSessionTypeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",6)
    ....i ASSessionTypeDR'="" s ASSessionType=$p(^RBC("SESS",ASSessionTypeDR),"^",2)
    ....Set ASSessionType= ##class(User.RBCSessionType).GetTranByDesc("SESSDesc",ASSessionType,langid)
    ....s ASSessStartTime=$p(^RBAS(RBRowId,ASChildSub),"^",4)
    ....s ASSessStartTime=..%ZT(ASSessStartTime)
    ....;结束时间
	....s SessionEndTime=$p(^RBAS(RBRowId,ASChildSub),"^",5)
	....s SessionEndTime=..%ZT(SessionEndTime,1)
    ....s ASTimeRangeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",17) 
    ....s TimeRange=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
    ....Set TimeRange= ##class(User.DHCTimeRange).GetTranByDesc("TRDesc",TimeRange,langid)
    ....s ASRoom=""
    ....s ASRoomDr=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",5)
    ....i ASRoomDr'="" s ASRoom=$p(^CTLOC(ASRoomDr),"^",2)
    ....s ASRoom=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ASRoom,langid)
	....s ASAppLoad=$P(^RBAS(RBRowId,ASChildSub),"^",2) 
	....s ASLoad=$p(^RBAS(RBRowId,ASChildSub),"^",8)
	....s ASStatusDR=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",10)
	....S ASStatus=$P(^DHCRBCASStatus(ASStatusDR),"^",2)
	....Set ASStatus= ##class(User.DHCRBCASStatus).GetTranByDesc("ASSDesc",ASStatus,langid)
	....s ASStatusCode=$P(^DHCRBCASStatus(ASStatusDR),"^",1)
	....s ReferralUser=$case(ASStatusCode,"R":$$GetReferralUser(RBRowId,ASChildSub),:"")
	....Set ReferralUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ReferralUser,langid)
    ....s ASReasonDr=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",11)
    ....s ASReason=""
    ....i ASReasonDr'="" s ASReason=$p(^RBC("NA",ASReasonDr),"^",2)
    ....i ASStatus="正常" s ASReason=""
    ....s AddLoad=+$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",3)
    ....s ASQueueNoCount=ASLoad+AddLoad
    ....s LoginStr=..GetUserLoginTime(LocDr,Docdr,ASTimeRangeDR,Startdate)
    ....s LoginTime=$p(LoginStr,"^",1)
    ....s LoginStatus=$p(LoginStr,"^",2)
    ....//s DocDesc=##class(web.DHCOPAdmReg).CutLetter(DocDesc)
    ....//if $P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",27)["," s $P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",27)=""
    ....//if $P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",28)["," s $P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",28)=""
    ....s AutoLoad=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",27)
	....s ExtLoad=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",28)
	....s AppStartSeqNo=$P(^RBAS(RBRowId,ASChildSub),"^",10) //预约起始号
	....s QueueNO=$P($G(^RBAS(+RBRowId,ASChildSub,"DHC")),"^",4)
	....s retnum=..GetRegisterNum(QueueNO,RBRowId_"||"_ASChildSub)
	....s RegisterNum=$P(retnum,"^",1)
	....s AppedNum=$P(retnum,"^",2)
	....s AppedArriveNum=$P(retnum,"^",3)
	....;s QueueNO=##class(web.DHCRBAppointment).GetAvailableNum(RBRowId_"||"_ASChildSub,"NOR","WIN","")  //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(RBRowId_"||"_ASChildSub,"NOR") //##class(web.DHCRBResourceRule).GetFreeQueueNO(QueueNO)
	....if (ASStatusCode="TR")||(ASStatusCode="S") s QueueNO=0
	....s ASDate=$P(^RBAS(+RBRowId,ASChildSub),"^",1)
	....s ASDate=..%ZD(ASDate) 
	....s ASAuditStatus=##class(web.DHCRBApptScheduleAudi).GetAuditStatus(RBRowId_"||"_ASChildSub)
	....s StopRegFlag=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",30)
	....s NoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(RBRowId_"||"_ASChildSub)
	....s ASLoadJsonInfo=..GetASLoadInfo(RBRowId_"||"_ASChildSub)
	....s ASLoadJsonObj={}.%FromJSON(ASLoadJsonInfo)
	....s ASLoad=ASLoadJsonObj.ASLoad
	....s ASAppLoad=ASLoadJsonObj.ASAppLoad
	....s AppStartSeqNo=ASLoadJsonObj.AppStartSeqNo
	....s AddLoad=ASLoadJsonObj.AddLoad
	....s QueueNO=ASLoadJsonObj.LeftLoad
	....s ASQueueNoCount=ASLoadJsonObj.ASQueueNoCount
	....Set data = $lb(locDesc,DocDesc,ASSessionType,ASSessStartTime,TimeRange,$g(ASRoom),ASQueueNoCount,ASAppLoad,ASLoad,ASStatus,$g(ASReason),RBRowId_"||"_ASChildSub,AddLoad,LoginTime,LoginStatus,AutoLoad,ExtLoad,AppStartSeqNo,IrregularFlag,SessionEndTime,RegisterNum,AppedNum,AppedArriveNum,QueueNO,ASDate,ASAuditStatus,Docdr,LocDr,ReferralUser,StopRegFlag,NoLimitLoadFlag)
	....s sort=Startdate_""_locDesc_""_DocDesc
	....Set ^TMP("ApptScheduleListArr",$j,sort,RBRowId_"||"_ASChildSub)=data
	....//set ^CacheTemp(repid,ind)=data
	....//set ind=ind+1
    q ""
checkValid(RBRowId,ASChildSub,Startdate)
	Q:'$d(^RBAS(RBRowId,ASChildSub)) 0
	s ASStatusDR=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",10)
	s ASStatusCode=$P(^DHCRBCASStatus(ASStatusDR),"^",1)
	Q:(Type=1)&&(ASStatusCode="AUD") 0
	Q:(Type=1)&&((ASStatusCode="S")||(ASStatusCode="PS")||(ASStatusCode="TR")) 0
	Q:((SelectStop="Y")&&(ASStatusCode'="S")) 0
	s Docdr=$p(^RB("RES",RBRowId),"^",2)
    Q:(Doc'="")&&(Docdr'=Doc) 0
    s ActiveFlag=$p($g(^CTPCP(Docdr,1)),"^",9)
    Q:ActiveFlag'="Y" 0
    s DocDateTo=$p($g(^CTPCP(Docdr,2)),"^",15)
    Q:(DocDateTo'="")&&(DocDateTo<+$h) 0
    s ASTimeRangeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",17) 
    Q:(paraTimeRange'="")&&(ASTimeRangeDR'=paraTimeRange) 0
    s ASDate=$P(^RBAS(+RBRowId,ASChildSub),"^",1)
    s Week=$ZD(ASDate,10)
	s:Week=0 Week=7
	Q:((WeekStr'="")&&(WeekStr'[Week)) 0
	s ASSessionTypeDR=$P(^RBAS(RBRowId,ASChildSub,"DHC"),"^",6)
	Q:((SDocSession'="")&&(SDocSession'=ASSessionTypeDR)) 0
	Q:((SStatus'="")&&(SStatus'=ASStatusCode)) 0
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
	Q:((PlanSchedule="true")&&(PlanFlag'=1)) 0
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

ClassMethod GetRegisterNum(QueueNO As %String, ASRowID As %String = "") As %String
{
	s JiaHao=..GetRegisterNumRule($piece(QueueNO,$char(1),2))
	s JiaoHaoRegedCount=$P(JiaHao,"^",1)
	s JiaHaoUnArriveCount=$P(JiaHao,"^",2) //加号已预约数
	s JiaoHaoArriveCount=$P(JiaHao,"^",3)
	s RegNumber=0
	if (ASRowID'=""){
		s ret=##class(web.DHCRBApptSchedule).GetRegisterNum(ASRowID)	
		s RegNumber=$P(ret,"^",1)
		s AppedCount=$P(ret,"^",2)
		s AppedArriveCount=$P(ret,"^",3)
	}else{
		s ZhengHao=..GetRegisterNumRule($piece(QueueNO,$char(1),1))
		s RegedCount=$P(ZhengHao,"^",1)
		s AppedCount=$P(ZhengHao,"^",2)
		s AppedArriveCount=$P(ZhengHao,"^",3)
		s RegNumber=RegedCount+JiaoHaoRegedCount
	}
	quit RegNumber_"^"_(AppedCount+JiaHaoUnArriveCount)_"^"_(AppedArriveCount+JiaoHaoArriveCount) //_"^"_(JiaHaoRegedCount+JiaHaoUnArriveCount)
}

ClassMethod GetRegisterNumRule(QueueNO As %String) As %String
{
	if QueueNO="" quit 0
	s returnvalue=0,returnvalue1=0,returnvalue2=0,returnvalue3=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write(QueueNO)
	
	s OneStr=""
	While 'Stream.AtEnd {
		s One=Stream.Read(1)
		i One'="," {
			s OneStr=OneStr_One
			continue:'Stream.AtEnd
		}

		set status=$piece(OneStr,":",2)
		if (status=1)||(status=3) //0-未取号?4-已退号
		{
			set returnvalue=returnvalue+1
		}
		if (status=2)||(status=3){
			set returnvalue1=returnvalue1+1
		}
		if (status=3){
			set returnvalue2=returnvalue2+1
		}
		if (status=2){
			set returnvalue3=returnvalue3+1
		}
		if (QueueNO["+")&&(status=5){
			set returnvalue3=returnvalue3+1
		}
		s OneStr=""
	}
	//已挂号数 已预约数 预约已取号 
	quit returnvalue_"^"_returnvalue1_"^"_returnvalue2_"^"_returnvalue3
}

ClassMethod GetApptScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptScheduleExecute ]
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

ClassMethod GetApptScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptScheduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindLoc(Desc As %String, userid As %String = "", groupid As %String = "", ExamRowId As %String = "", HospitalDr As %String = "") As %Query(ROWSPEC = "LocDesc:%String,RowId:%String,code:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","FindLoc","",1,1,5)

ClassMethod FindLocExecute(ByRef qHandle As %Binary, Desc As %String, userid As %String = "", groupid As %String = "", ExamRowId As %String = "", HospitalDr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	// 门办不限制
	i ($g(HospitalDr)="")&&($d(%session)) s HospitalDr=%session.Get("LOGON.HOSPID")
	s flag=0
	if groupid'="" {
		s groupdesc=$p($g(^SSU("SSGRP",groupid)),"^",1)
		if groupdesc["Demo Group" s flag=1
	}
	// 按操作员诊区对照限制
	s DepStr="" 
	if userid'="" {
	 	s BoruID="" f  s BoruID=$o(^User.DHCBorUserI("BoruUseDrIndex"," "_userid,BoruID)) q:BoruID=""  do
		.s ExaBorough=$list(^User.DHCBorUserD(BoruID),2)
		.q:ExaBorough=""
		.s ID="" f  s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ExaBorough,ID)) q:ID=""  do
		..s DeptID=$list(^User.DHCExaBorDepD(ID),7)
		..q:DeptID="" 
		..q:'$d(^CTLOC(DeptID))
		..q:("^"_DepStr_"^")[("^"_DeptID_"^")
		..if DepStr="" s DepStr=DeptID
		..else  s DepStr=DepStr_"^"_DeptID
		b ;43434
		if (DepStr'="") s DepStr="^"_DepStr_"^"
	}
	
	s Desc=$ZCVT(Desc,"U")
	s AdmType="O^E"
	s count=0
	s Len=$L(AdmType,"^")
	for i=1:1:Len  {
		s AdmTypePut=$P(AdmType,"^",i)
		s RowId=0 f  s RowId=$O(^PAC("ADMLOC",0,"AdmType",AdmTypePut,RowId)) Q:RowId=""  d
		.Q:'$d(^RB("RES",0,"CTLOC",RowId))
		.s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
		.s CTAliasTem=""
		.i $l(CTDesc,"-")>1 s CTAliasTem=$P(CTDesc,"-",1)
		.s CTAlias=$P(^CTLOC(RowId),"^",43)
		.//Quit:(desc'="")&&(CTDesc'[desc)&&(CTAlias'[desc)
		.q:(Desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(RowId,Desc))
		.q:(flag'=1)&&(DepStr'[("^"_RowId_"^"))&&(DepStr'="")
		.s FindExamLoc=0
        .i (ExamRowId'="")&&(ExamRowId'="Other") d
        ..s RowId1=0
        ..f  s RowId1=$o(^User.DHCExaBorDepI("BordDepDrIndex",RowId,RowId1)) q:((RowId1="")||(FindExamLoc=1))  d
        ...s ExamRowId1=$list(^User.DHCExaBorDepD(RowId1),6)
        ...q:ExamRowId1'=ExamRowId
        ...s FindExamLoc=1
        .q:(ExamRowId'="")&&(ExamRowId'="Other")&&(FindExamLoc=0)
        .q:(ExamRowId="Other")&&(($d(^User.DHCExaBorDepI("BordDepDrIndex",RowId)))||('##class(web.DHCUserGroup).UserCanDo(userid,RowId)))
        .Q:(ExamRowId'="Other")&&('##class(web.DHCUserGroup).UserCanDo(userid,RowId))
		.i CTAlias="" s CTAlias=CTAliasTem
		.s CTDescHospital=$p($g(^CTLOC(RowId)),"^",22)
		.q:HospitalDr'=CTDescHospital
		.q:($P(^CTLOC(RowId),"^",14)'="Y")
		.do OutputRow
	}
	
	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc,RowId,CTAlias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
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

ClassMethod FindLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpRoomByUser(desc As %String, UserId As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	
	SELECT CTLOC_Desc,CTLOC_Code,CTLOC_RowId FROM SQLUser.CT_LOC 
	WHERE (CTLOC_Desc like '%'_:desc_'%' or CTLOC_Code like '%'_:desc_'%' )  and CTLOC_Type='OR'
	ORDER BY CTLOC_Code
}

/*Query LookUpTimeRange(date As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	SELECT TR_Desc,TR_Code,TR_RowId FROM SQLUser.DHC_TimeRange 
		WHERE ((TR_ValidStartDate <= :date) OR (TR_ValidStartDate IS NULL))
		AND  ((TR_ValidEndDate>= :date) OR (TR_ValidEndDate IS NULL) )
}*/
Query LookUpTimeRange(date As %String, HospId As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,RowId:%String,SttTime:%String,EndTime:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","LookUpTimeRange",+$H,"")

ClassMethod LookUpTimeRangeExecute(ByRef qHandle As %Binary, date As %String, HospId As %String = "") As %Status
{
	s ^tempnk("LookUpSessionType")=date_"^"_HospId
	s repid=$I(^CacheTemp)
	s ind=1
	i date="" s date=..%SysDate()
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s RowId=""
	f  s RowId=$O(^DHCTimeRange(RowId)) q:RowId=""  d
	.s Code=$P(^DHCTimeRange(RowId),"^",1)
	.s Desc=$P(^DHCTimeRange(RowId),"^",2)
	.s ValidStartDate=$P(^DHCTimeRange(RowId),"^",7)
	.s ValidEndDate=$P(^DHCTimeRange(RowId),"^",8)
	.q:((ValidStartDate >date)&&(ValidStartDate'=""))
	.q:((ValidEndDate <date)&&(ValidEndDate'=""))
	.Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TimeRange",RowId,HospId)="N"
	.s SttTime=$P(^DHCTimeRange(RowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(RowId),"^",4)
	.d OutputTimeRange
	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
OutputTimeRange
	set Data=$lb(Desc,Code,RowId,SttTime,EndTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTimeRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTimeRangeExecute ]
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

ClassMethod LookUpTimeRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTimeRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpSessionTypeNew(AdmLocID As %String = "", AdmDocID As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","LookUpSessionType","","")

ClassMethod LookUpSessionTypeNewExecute(ByRef qHandle As %Binary, AdmLocID As %String = "", AdmDocID As %String = "") As %Status
{
	s ^tempnk("LookUpSessionType")=AdmLocID_"^"_AdmDocID
	s repid=$I(^CacheTemp)
	s ind=1
	s ContrastSessRow=""
	s ResRowid=""
	if (AdmLocID'="")&&(AdmDocID'=""){
		s ResRowid=$o(^RB("RES",0,"CTPCP",AdmDocID,AdmLocID,0))
	}
	if ResRowid'=""{
		s ContrastStr=##CLASS(web.DHCDocSessContrast).GetResSessType(ResRowid)
		if ContrastStr'=""{
			s ContrastSessRow=$p(ContrastStr,"^",1)
		}
	}
	s SessRowID=""
	for  s SessRowID=$o(^RBC("SESS",SessRowID)) q:SessRowID=""  D
	.s SessCode=$p(^RBC("SESS",SessRowID),"^",1)
	.s SessDesc=$p(^RBC("SESS",SessRowID),"^",2)
	.Q:(ContrastSessRow'="")&&(ContrastSessRow'=SessRowID)
	.s SessDataFrom=$p(^RBC("SESS",SessRowID),"^",6)
	.Q:(SessDataFrom'="")&&(SessDataFrom>+$H)
	.s SessDateTo=$p(^RBC("SESS",SessRowID),"^",7)
	.Q:(SessDateTo'="")&&(SessDateTo'>+$H)
	.d OutputRowSess
	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
OutputRowSess
	set Data=$lb(SessDesc,SessCode,SessRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpSessionTypeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpSessionTypeNewExecute ]
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

ClassMethod LookUpSessionTypeNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpSessionTypeNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpSessionType(date As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	SELECT SESS_Desc, SESS_Code,SESS_RowId FROM SQLUser.RBC_SessionType
		WHERE ((SESS_DateFrom <= :date) OR (SESS_DateFrom IS NULL))
		AND  ((SESS_DateTo >= :date) OR (SESS_DateTo IS NULL) )
}

Query LookUpClinicGroup(date As %String, LocId As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "RowId:%String,Desc:%String,Code:%String")
{
		
	select DISTINCT A.CLGRP_RowId,A.CLGRP_Desc, A.CLGRP_Code from SQLUser.RBC_ClinicGroup A,SQLUser.DHC_LocSpec B
		WHERE ((A.CLGRP_DateFrom <= :date) OR (A.CLGRP_DateFrom IS NULL))
		AND  ((A.CLGRP_DateTo>= :date) OR (A.CLGRP_DateTo IS NULL) )
		AND ((A.CLGRP_RowId=B.DHCLS_CG_DR)AND(B.DHCLS_Loc_DR=:LocId) )
}

Query LookUpClinicGroupAll(LocId As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	select A.CLGRP_Desc, A.CLGRP_Code, A.CLGRP_RowId from SQLUser.RBC_ClinicGroup A,SQLUser.DHC_LocSpec B
		WHERE ((A.CLGRP_DateFrom <= +$h) OR (A.CLGRP_DateFrom IS NULL))
		AND  ((A.CLGRP_DateTo>= +$h) OR (A.CLGRP_DateTo IS NULL) )
		AND ((A.CLGRP_RowId=B.DHCLS_CG_DR)AND(B.DHCLS_Loc_DR=:LocId) )
}

Query LookUpReasonNotAvail(date As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	select RNAV_Desc, RNAV_Code, RNAV_RowId from SQLUser.RBC_ReasonNotAvail
		WHERE ((RNAV_DateFrom <= :date) OR (RNAV_DateFrom IS NULL))
		AND  ((RNAV_DateTo>= :date) OR (RNAV_DateTo IS NULL) )
}

Query LookUpELeader(date As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	SELECT SSUSR_Name,SSUSR_Initials,SSUSR_RowId FROM SQLUser.SS_User 
		WHERE SSUSR_Group=1 
		AND ((SSUSR_DateFrom <= :date) OR (SSUSR_DateFrom IS NULL))
		AND  ((SSUSR_DateTo>= :date) OR (SSUSR_DateTo IS NULL) )
}

Query LookUpELeaderNew(loc As %String = "", desc As %String = "", HospID = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
}

ClassMethod LookUpELeaderNewExecute(ByRef qHandle As %Binary, loc As %String = "", desc As %String = "", HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s RowId=0 for{
		s RowId=$o(^SSU("SSUSR",RowId)) Q:RowId=""
		s Avtive=$p(^SSU("SSUSR",RowId),"^",19)
		continue:Avtive'="Y"
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",RowId,HospID)
		continue:##class(DHCDoc.Util.Base).CheckUserName("SS_User",RowId,desc)'=1
		if loc'=""{
			s defaultLogloc=$p(^SSU("SSUSR",RowId),"^",4)
			s Flag=(defaultLogloc=loc)
			if 'Flag{
				s OTHLLChildsub=0 for{
					s OTHLLChildsub=$o(^SSU("SSUSR",RowId,"OTHLL",OTHLLChildsub)) Q:OTHLLChildsub=""
					s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",RowId,"OTHLL",OTHLLChildsub)),"^",1)
					s Flag=(OTHLLCTLOCDR=loc)
					Q:Flag
				}
			}
			continue:'Flag
		}
		s Datefrom=$p(^SSU("SSUSR",RowId),"^",96)
		s DateTo=$p(^SSU("SSUSR",RowId),"^",97)
		continue:(Datefrom'="")&&(Datefrom>+$H)
		continue:(DateTo'="")&&(DateTo<+$H)
		s Desc=$p(^SSU("SSUSR",RowId),"^",2)
		s Code=$p(^SSU("SSUSR",RowId),"^",1)
		d rows.%Push($lb(Desc,Code,RowId))
	}
	Quit $$$OK
}

ClassMethod LookUpELeaderNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpELeaderNewExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

/// /
Query FinNoRegDoc(AdmDate As %String, loc As %String, TimeRangeRowId As %String, desc As %String = "") As %Query(ROWSPEC = "Desc:%String,RowId:%String,code:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","FinNoRegDoc","","1","","")

ClassMethod FinNoRegDocExecute(ByRef qHandle As %Binary, AdmDate As %String, loc As %String, TimeRangeRowId As %String, desc As %String = "") As %Status
{
	s ^tempscl("FinNoRegDoc")=AdmDate_","_loc_","_TimeRangeRowId_","_desc
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ret=""
	s ^Temp("FinNoRegDoc")=$lb(AdmDate,loc,TimeRangeRowId)
	if loc="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s userid=%session.Get("LOGON.USERID")
	if desc'="" s desc=$zcvt(desc,"U")
	s AdmDateLen=$l(AdmDate,",")
	if (AdmDate'="")&&(AdmDateLen=1){
		if AdmDate["-" s AdmDate=$ZDH(AdmDate,3)
		if AdmDate["/" s AdmDate=$ZDH(AdmDate,4)
	}
	s RowId=0 f  Set RowId=$o(^RB("RES",0,"CTLOC",loc,RowId)) quit:RowId=""  d
	.s CTPCPRowId=$P(^RB("RES",RowId),"^",2)
	.Q:CTPCPRowId=""
	.Q:(userid'="")&&('##class(web.DHCUserGroup).UserCanDo(userid,loc,CTPCPRowId))
	.s DateFrom=$p(^RB("RES",RowId),"^",22)
	.Quit:(DateFrom'="")&&(DateFrom>(+$h))
	.s DateTo=$p(^RB("RES",RowId),"^",23)
	.Quit:(DateTo'="")&&(DateTo<(+$h))
	.s ScheSt=$p(^RB("RES",RowId),"^",6)
	.Q:(ScheSt'="Y")
	.s Find=0
	.i AdmDateLen=1,AdmDate'="",TimeRangeRowId'="" s Find=$$HaveSchedule(RowId,AdmDate,TimeRangeRowId)
	.Q:(Find=1)&&(AdmDate'="")&&(TimeRangeRowId'="")
	.s CTPCPDesc=$p(^CTPCP(CTPCPRowId,1),"^",2)
	.s CTPCPActiveFlag=$P($G(^CTPCP(CTPCPRowId,1)),"^",9)
	.Q:CTPCPActiveFlag="N"
	.s DocOtherName=""
	.i $d(^CTPCP(CTPCPRowId,3)) d
	..s DocOtherName=$p(^CTPCP(CTPCPRowId,3),"^",28)
	.Q:(desc'="")&&(CTPCPDesc'[desc)
	.s UserActive="Y"
	.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId,"0"))
	.if Userdr'="" d
	..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
	.q:UserActive'="Y"
	.s Data=$lb(CTPCPDesc,CTPCPRowId,DocOtherName)
	.d OutputRowDoc
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
HaveSchedule(ResRowId,AdmDate,TimeRangeRowId)
	s Find=0
	s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	..;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..Q:(TRRowId'=TimeRangeRowId)
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..;被替诊的可以再次被安排
	..Q:(status="TR")!(status="S")
	..s Find=1
	Q Find

	
OutputRowDoc
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FinNoRegDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinNoRegDocExecute ]
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

ClassMethod FinNoRegDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinNoRegDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDocResource(CTLocID, CTDocID, TimeRange As %String = "") As %String
{
	s RESRowId=$o(^RB("RES",0,"CTPCP",CTDocID,CTLocID,0))
	q:RESRowId="" ""
	s Data=$g(^RB("RES",RESRowId,"DHC"))
	s RESClinicGroupDR=$p(Data,"^",2)
	s PositiveMax=$p(Data,"^",3)
	s ApptMax=$p(Data,"^",4)
	s EStartPrefix=$p(Data,"^",5)
	s RESTAutoLoad="",RESTExtLoad=""
	if (TimeRange'=""){
		s RESTRowId="",findRESTRowId=""
		f  s RESTRowId=$o(^RB("RES",RESRowId,"REST",RESTRowId)) q:(RESTRowId="")||(findRESTRowId'="")  d
		.s RESTTimeRange=$p(^RB("REST",RESTRowId),"^",2)
		.q:RESTTimeRange'=TimeRange
		.s findRESTRowId=RESTRowId
		if (findRESTRowId'=""){
			s PositiveMax=$p(^RB("REST",findRESTRowId),"^",3)
			s ApptMax=$p(^RB("REST",findRESTRowId),"^",4)
			s EStartPrefix=$p(^RB("REST",findRESTRowId),"^",5)
			s RESTAutoLoad=$p(^RB("REST",findRESTRowId),"^",6)
		    s RESTExtLoad=$p(^RB("REST",findRESTRowId),"^",7)
		    //s $p(Data,"^",6)=RESTAutoLoad
	        //s $p(Data,"^",7)=RESTExtLoad
		}
		
	}
	// 起始号空的
	// 1) 预约号不为空或0 : 按正号-预约号算
	// 2) 预约号为空的 :  默认为3, 正号不足3的默认为1
	if (EStartPrefix=""){
		if (PositiveMax'="")&&(ApptMax'="")&&(ApptMax'=0)&&(PositiveMax>=ApptMax) s EStartPrefix=PositiveMax-ApptMax+1
		else  if (PositiveMax>=4) s EStartPrefix=4
		else  s EStartPrefix=""
	}
	
	if ApptMax=""{
		if (EStartPrefix'="")&&(PositiveMax>=EStartPrefix) s ApptMax=PositiveMax-EStartPrefix+1
	}

	s $p(Data,"^",4)=ApptMax	
	s $p(Data,"^",5)=EStartPrefix
	
	s $p(Data,"^",3)=PositiveMax
	s $p(Data,"^",$l(Data,"^")+1)=RESClinicGroupDR
	//s $p(Data,"^",6)=RESTAutoLoad
	//s $p(Data,"^",7)=RESTExtLoad
	;取模板分时段信息
	s TRInfo=""
	if TimeRange'=""{
		s TRFlag=""
		s DATEChildsub=0
		for  s DATEChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildsub)) q:(DATEChildsub="")!(TRFlag="Y")  d
		.s SESSChildsub=0
		.for  s SESSChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildsub,"SESS",SESSChildsub)) q:(SESSChildsub="")!(TRFlag="Y")  d
		..s DHCData=$g(^RB("RES",+RESRowId,"DATE",DATEChildsub,"SESS",SESSChildsub,"DHC"))
		..s ASTimeRangeDR=$P(^RB("RES",RESRowId,"DATE",DATEChildsub,"SESS",SESSChildsub),"^",3)
		..q:ASTimeRangeDR=""
		..q:(TimeRange'=ASTimeRangeDR)
		..s DowName=""
		..s SESSDOWDR=$P(^RB("RES",RESRowId,"DATE",DATEChildsub,"SESS",SESSChildsub),"^",2) ;周
		..i SESSDOWDR'=""  d
		...S DowName=$P(^CT("DOW",1,SESSDOWDR),"^",2)
		..s CurWeek=$zd(+$h,10)
		..if CurWeek=0 s CurWeek=7
		..Q:(CurWeek'=DowName)&&(DowName'="")
		..s TRFlag=$p(DHCData,"^",1)
		..s TRInfo=DHCData
	}
	s Data=Data_"$"_RESTAutoLoad_"^"_RESTExtLoad_"$"_TRInfo
				
	q Data
}

/// w ##class(web.DHCApptScheduleNew).GetUserLoginTime(3,8,1,+$h)
ClassMethod GetUserLoginTime(LocRowid As %String, DocRowid As %String, ASTimeRangeDR As %String, ASDate As %String)
{
	Set UserId=$o(^SSU("SSUSR",0,"CTPCP",DocRowid,0))
	if UserId="" Quit ""
	Set EndTime=$p(^DHCTimeRange(ASTimeRangeDR),"^",4)
	s date=ASDate
	s LoginTime=""
	s loginstatus=""
	s time=0
	for  s time=$o(^SST("LOG",0,"User",UserId,date,time)) Quit:(time="")  do
	.Set rowid=0
	.for  s rowid=$o(^SST("LOG",0,"User",UserId,date,time,rowid)) Quit:(rowid="")  do
	..Set LocId=$p(^SST("LOG",rowid),"^",7)
	..Quit:LocId'=LocRowid
	..Quit:EndTime<($p(^SST("LOG",rowid),"^",4))
	..if LoginTime="" do
	...s LoginTime=$p(^SST("LOG",rowid),"^",4)
	..s LogoffDate=$p(^SST("LOG",rowid),"^",5)
	..if LogoffDate="" do
	...s loginstatus=1
	..else  do
	...s loginstatus=""
	if loginstatus'="" s loginstatus="在线"
	else  s loginstatus="离线"
	
	if LoginTime'="" s LoginTime=..%ZT(LoginTime,1)
	Quit LoginTime_"^"_loginstatus
}

ClassMethod StopSchedule(ScheduleIDStr As %String, StopReasonID As %String, AuditUserID As %String, StatusCode As %String = "S", IsAudit As %String = "0")
{
}

// w ##class(web.DHCApptScheduleNew).GetApptScheduleInfo("1960||11")

// 1960||11

ClassMethod GetApptScheduleInfo(ARCOSRowId As %String) As %String
{
   s ASTimeRangeDR=$P(^RBAS(+ARCOSRowId,$p(ARCOSRowId,"||",2),"DHC"),"^",17)
   s ASDate=$P(^RBAS(+ARCOSRowId,$p(ARCOSRowId,"||",2)),"^",1)
   s ASDate=$zd(ASDate,3)
   s LocRowId=$p(^RB("RES",+ARCOSRowId),"^",1)
   Q ASTimeRangeDR_"^"_ASDate_"^"_LocRowId
}

// 根据科室查找对应的诊区

// w ##class(web.DHCApptScheduleNew).GetExaRowidStrByLoc(6)

ClassMethod GetExaRowidStrByLoc(LocRowId As %String) As %String
{
	q:LocRowId="" ""
	s ExaRowidStr=""
	s id=0
	//f  s id=$o(^User.DHCExaBorDepI("BordDepDrIndex"," "_LocRowId,id)) q:id=""  d
	f  s id=$o(^User.DHCExaBorDepI("BordDepDrIndex",LocRowId,id)) q:id=""  d
	.s BordBorDr=$list(^User.DHCExaBorDepD(id),6)
	.i ExaRowidStr="" s ExaRowidStr=BordBorDr
	.e  s ExaRowidStr=ExaRowidStr_"^"_BordBorDr
	Q ExaRowidStr
}

// 

Query LookUpRoomByUserNew(desc As %String, UserId As %String, loc As %String, HospId As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
}

// D ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","LookUpRoomByUserNew","泌尿外科","1","6")

ClassMethod LookUpRoomByUserNewExecute(ByRef qHandle As %Binary, desc As %String, UserId As %String, loc As %String, HospId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//挂号设置->排班诊室允许跨诊区
	s AllowOpenAllRoms=##class(web.DHCOPRegConfig).GetSpecConfigNode("AllowOpenAllRoms",HospId)
	s ExaRowidStr=..GetExaRowidStrByLoc(loc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s RowId=0
	f  s RowId=$o(^CTLOC(0,"LocType","OR",RowId)) q:RowId=""  d
	.s RoomHospDr=$p(^CTLOC(RowId),"^",22)
	.Q:(HospId'=RoomHospDr)
	.s Desc=$p(^CTLOC(RowId),"^",2)
	.s Code=$p(^CTLOC(RowId),"^",1)
	.Q:($$ALPHAUP^SSUTIL4(Desc)'[desc)&&($$ALPHAUP^SSUTIL4(Code)'[desc)&&(desc'="")
	.q:($P(^CTLOC(RowId),"^",14)'="Y")
	.s id=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RowId,""))
	.q:(id="")&&(ExaRowidStr'="")&&(AllowOpenAllRoms=0)
	.s LocAreaExamRowid=""
	.i id'="" s LocAreaExamRowid=$list(^User.DHCBorExaRoomD(id),5)
	.q:("^"_ExaRowidStr_"^")'[("^"_LocAreaExamRowid_"^")&&(ExaRowidStr'="")&&(AllowOpenAllRoms=0)
	.d OutputRowDoc
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowDoc
    set Data=$lb(Desc,Code,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpRoomByUserNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpRoomByUserNewExecute ]
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

ClassMethod LookUpRoomByUserNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpRoomByUserNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCApptScheduleNew).GetClinicGroupDrStr("2131||187")
ClassMethod GetClinicGroupDrStr(ASRowID)
{
	s ResRowId=+ASRowID
	s ASChildSub=$p(ASRowID,"||",2)
	Set langid=..%LanguageID()
	Q:ASChildSub="" ""
	Set DepID=$p($g(^RB("RES",ResRowId)),"^",1)
	s SessionClinicGroupDrStr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",29)
	s SessionClinicGroupDescStr=""
	if SessionClinicGroupDrStr'=""{
		s tmpClinicGroupDrStr="",tmpClinicGroupDescStr=""
		for myloop=1:1:$l(SessionClinicGroupDrStr,","){
			s oneClinicGroupDr=$p(SessionClinicGroupDrStr,",",myloop)
			continue:oneClinicGroupDr=""
			s oneClinicGroupDr=##class(web.DhcResEffDateSessionClass).CheckClinicGroupDR(DepID,oneClinicGroupDr)
    		i oneClinicGroupDr'=""{
	    		s oneClinicGroupDesc=$P($G(^RBC("CLGRP",oneClinicGroupDr)),"^",2)
	    		set oneClinicGroupDesc= ##class(User.RBCClinicGroup).GetTranByDesc("CLGRPDesc",oneClinicGroupDesc,langid)
	    		if tmpClinicGroupDrStr=""{
		    		s tmpClinicGroupDrStr=oneClinicGroupDr
	    		}else{
		    		s tmpClinicGroupDrStr=tmpClinicGroupDrStr_","_oneClinicGroupDr
		    	}
		    	if tmpClinicGroupDescStr=""{
		    		s tmpClinicGroupDescStr=oneClinicGroupDesc
	    		}else{
		    		s tmpClinicGroupDescStr=tmpClinicGroupDescStr_","_oneClinicGroupDesc
		    	}
    		}
		}
		s SessionClinicGroupDrStr=tmpClinicGroupDrStr
		s SessionClinicGroupDescStr=tmpClinicGroupDescStr
	}
	Q SessionClinicGroupDrStr_"^"_SessionClinicGroupDescStr
}

Query ApptScheduleExport(Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ASStatus:%String:状态,ASDate:%String:出诊日期,LocDesc:%String:出诊科室,DocDesc:%String:出诊医生,ASRoom:%String:诊室名称,ASSessionType:%String:职称,TimeRange:%String:时段,ASSessStartTime:%String:开始时间,ASSessionEndTime:%String:结束时间,NoLimitLoadFlag:%String:便捷排班,ASLoad:%String:挂号限额,ASAppLoad:%String:预约限额,AppStartSeqNo:%String:预约起始号,ASAddLoad:%String:加号限额,ASQueueNoCount:%String:合计限额,RegisterNum:%String:已挂号数,AppedNum:%String:已预约数,AppedArriveNum:%String:已取号数,QueueNO:%String:剩号,IrregularFlag:%String:异常")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","RegFindExportExecute","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod ApptScheduleExportExecute(ByRef qHandle As %Library.Binary, Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCApptScheduleNew:GetApptSchedule")
	d rset.Execute(Loc, Doc, StDate, EnDate, userid, groupid, ResID, ExaID, paraTimeRange, Type, PlanSchedule, SelectStop, WeekStr, HospId)
	While (rset.Next()) {
		s ASStatus=rset.Data("ASStatus")
		s ASDate=rset.Data("ASDate")
		s LocDesc=rset.Data("LocDesc")
		s DocDesc=rset.Data("DocDesc")
		s ASRoom=rset.Data("ASRoom")
		s ASSessionType=rset.Data("ASSessionType")
		s TimeRange=rset.Data("TimeRange")
		s ASSessStartTime=rset.Data("ASSessStartTime")
		s ASSessionEndTime=rset.Data("ASSessionEndTime")
		s ASLoad=rset.Data("ASLoad")
		s ASAppLoad=rset.Data("ASAppLoad") 
		s AppStartSeqNo=rset.Data("AppStartSeqNo")
		s ASAddLoad=rset.Data("ASAddLoad")
		s ASQueueNoCount=rset.Data("ASQueueNoCount")
		s RegisterNum=rset.Data("RegisterNum")
		s AppedNum=rset.Data("AppedNum")
		s AppedArriveNum=rset.Data("AppedArriveNum")
		s QueueNO=rset.Data("QueueNO")
		s IrregularFlag=rset.Data("IrregularFlag")
		if IrregularFlag="A"  s IrregularFlag="不规则排班"
		s NoLimitLoadFlag=rset.Data("NoLimitLoadFlag")
		s OutputList=$lb(ASStatus,ASDate,LocDesc,DocDesc,ASRoom,ASSessionType,TimeRange,ASSessStartTime,ASSessionEndTime,NoLimitLoadFlag,ASLoad,ASAppLoad,AppStartSeqNo,ASAddLoad,ASQueueNoCount,RegisterNum,AppedNum,AppedArriveNum,QueueNO,IrregularFlag)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ApptScheduleExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ApptScheduleExportExecute ]
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
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ApptScheduleExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ApptScheduleExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 发送短信
ClassMethod SentMessage(ASRowID, GroupID, UserID)
{
	q:((ASRowID="")||(GroupID="")) ""
	s HospId=$P(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ASRowID,""),"^",1)
	s ScheduleSentMessage=##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"ScheduleSentMessage")
	q:ScheduleSentMessage'=1 "安全组不允许发送短信"
	s MessageSentFunction=##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"MessageSentFunction")
	q:MessageSentFunction="" "发送短信方法为空，请到挂号设置授权管理维护"
	s MessageSentContent=##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"MessageSentContent")
	q:MessageSentContent="" "发送短信内容为空，请到挂号设置授权管理维护"
	s PatientIDStr=""
	s APPTChild=0  f  {
		s APPTChild=$O(^RBAS(+ASRowID,$P(ASRowID,"||",2),"APPT",APPTChild)) 
		q:(APPTChild="")
		s StatusCode=$P($G(^RBAS(+ASRowID,$P(ASRowID,"||",2),"APPT",APPTChild)),"^",3) 
		continue:StatusCode'="I"
		s PatientID=$P($G(^RBAS(+ASRowID,$P(ASRowID,"||",2),"APPT",APPTChild)),"^",2)
		if (PatientIDStr=""){s PatientIDStr=PatientID}else{s PatientIDStr=PatientIDStr+"^"+PatientID}
	}
	s RegfeeDr="" f {
		s RegfeeDr=$O(^User.DHCRegistrationFeeI("RBASDr",ASRowID,RegfeeDr))
		q:RegfeeDr=""
		s PAAdm=$List(^User.DHCRegistrationFeeD(RegfeeDr),2)
		s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
		continue:VisitStatus'="A"
		s PatientID=$p($g(^PAADM(PAAdm)),"^",1)
		if (PatientIDStr=""){s PatientIDStr=PatientID}else{s PatientIDStr=PatientIDStr+"^"+PatientID}
		}
	if (PatientIDStr'=""){
		for i=1:1:$l(PatientIDStr,"^"){
			s PatientID=$P(PatientIDStr,"^",i)
			s Message=MessageSentContent
			s (LocDesc,MarkDesc,Date,TimeRangeDesc,DocSessionDesc,ASStatus,PatName,PatNo)=""
			s Date=$P(^RBAS(+ASRowID,$P(ASRowID,"||",2)),"^",1)
			s Date=..%ZD(Date) 
			s Message=$replace(Message,"{Date}",Date)
			s LocDr=$p(^RB("RES",+ASRowID),"^",1)
			s LocDesc=$p(^CTLOC(LocDr),"^",2)
			s Message=$replace(Message,"{LocDesc}",LocDesc)
			s Docdr=$p(^RB("RES",+ASRowID),"^",2)
			S MarkDesc=$p(^CTPCP(Docdr,1),"^",2)
			s Message=$replace(Message,"{MarkDesc}",MarkDesc)
			s ASTimeRangeDR=$P(^RBAS(+ASRowID,$P(ASRowID,"||",2),"DHC"),"^",17) 
    		s TimeRangeDesc=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
    		s Message=$replace(Message,"{TimeRangeDesc}",TimeRangeDesc)
    		s ASSessionTypeDR=$P(^RBAS(+ASRowID,$P(ASRowID,"||",2),"DHC"),"^",6)
    		i ASSessionTypeDR'="" s DocSessionDesc=$p(^RBC("SESS",ASSessionTypeDR),"^",2)
    		s Message=$replace(Message,"{DocSessionDesc}",DocSessionDesc)
    		s ASStatusDR=$p(^RBAS(+ASRowID,$P(ASRowID,"||",2),"DHC"),"^",10)
			S ASStatus=$P(^DHCRBCASStatus(ASStatusDR),"^",2)
			s Message=$replace(Message,"{ASStatus}",ASStatus)
			s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
			s Message=$replace(Message,"{PatName}",PatName)
			s PatNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
			s Message=$replace(Message,"{PatNo}",PatNo)
			;科室{LocDesc},号别{MarkDesc},日期{Date},时段{TimeRangeDesc},职称{DocSessionDesc},排班状态{ASStatus},患者姓名{PatName},登记号{PatNo}
			x MessageSentFunction
			}
		
		}
		q 0
}

Query ApptScheduleRegDoc(Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ASStatus:%String:状态,ASDate:%String:出诊日期,LocDesc:%String:出诊科室,DocDesc:%String:出诊医生,ASRoom:%String:诊室名称,ASSessionType:%String:职称,TimeRange:%String:时段,ASSessStartTime:%String:开始时间,ASSessionEndTime:%String:结束时间,ASLoad:%String:挂号限额,ASAppLoad:%String:预约限额,AppStartSeqNo:%String:预约起始号,ASAddLoad:%String:加号限额,ASQueueNoCount:%String:合计限额,RegisterNum:%String:已挂号数,AppedNum:%String:已预约数,AppedArriveNum:%String:已取号数,QueueNO:%String:剩号,IrregularFlag:%String:异常,ASRowId:%String,ReferralUser:%String,StopRegFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCApptScheduleNew","ApptScheduleRegDoc","115","1","02/07/2021","02/07/2021","","","","","","","","","","2")
ClassMethod ApptScheduleRegDocExecute(ByRef qHandle As %Library.Binary, Loc As %String, Doc As %String, StDate As %String, EnDate As %String, userid As %String = "", groupid As %String = "", ResID As %String = "", ExaID As %String = "", paraTimeRange As %String = "", Type As %String = "", PlanSchedule As %String = "", SelectStop As %String = "", WeekStr As %String = "", HospId As %String = "") As %Library.Status
{
	s ^tmp("ApptScheduleRegDocExecute")=$LB(Loc, Doc, StDate, EnDate, userid, groupid, ResID, ExaID, paraTimeRange, Type, PlanSchedule, SelectStop, WeekStr, HospId)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ASStatusStr="^停诊^被替诊^待审核^"
	s rset=##class(%ResultSet).%New("web.DHCApptScheduleNew:GetApptSchedule")
	d rset.Execute(Loc, Doc, StDate, EnDate, userid, groupid, ResID, ExaID, paraTimeRange, Type, PlanSchedule, SelectStop, WeekStr, HospId)
	While (rset.Next()) {
		s ASStatus=rset.Data("ASStatus")
		//不显示停诊和被替诊、待审核的排班
		continue:(ASStatusStr[("^"_ASStatus_"^"))
		s ASDate=rset.Data("ASDate")
		s LocDesc=rset.Data("LocDesc")
		s DocDesc=rset.Data("DocDesc")
		s ASRoom=rset.Data("ASRoom")
		s ASSessionType=rset.Data("ASSessionType")
		s TimeRange=rset.Data("TimeRange")
		s ASSessStartTime=rset.Data("ASSessStartTime")
		s ASSessionEndTime=rset.Data("ASSessionEndTime")
		s ASSessionEndTime1=$ZTH(ASSessionEndTime)
		s NowTime=$P($H,",",2)
		continue:(ASSessionEndTime1<NowTime)
		s ASLoad=rset.Data("ASLoad")
		s ASAppLoad=rset.Data("ASAppLoad") 
		s AppStartSeqNo=rset.Data("AppStartSeqNo")
		s ASAddLoad=rset.Data("ASAddLoad")
		s ASQueueNoCount=rset.Data("ASQueueNoCount")
		s RegisterNum=rset.Data("RegisterNum")
		s AppedNum=rset.Data("AppedNum")
		s AppedArriveNum=rset.Data("AppedArriveNum")
		s QueueNO=rset.Data("QueueNO")
		s IrregularFlag=rset.Data("IrregularFlag")
		if IrregularFlag="A"  s IrregularFlag="不规则排班"
		s ASRowId=rset.Data("ASRowId")
		s ReferralUser=rset.Data("ReferralUser")
		s StopRegFlag=rset.Data("StopRegFlag")
		s OutputList=$lb(ASStatus,ASDate,LocDesc,DocDesc,ASRoom,ASSessionType,TimeRange,ASSessStartTime,ASSessionEndTime,ASLoad,ASAppLoad,AppStartSeqNo,ASAddLoad,ASQueueNoCount,RegisterNum,AppedNum,AppedArriveNum,QueueNO,IrregularFlag,ASRowId,ReferralUser,StopRegFlag)
		d OutputRowRegDoc
	}
	d rset.Close()

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowRegDoc
	Set ^CacheTemp(repid,ind)=OutputList
	Set ind=ind+1
	quit
}

ClassMethod ApptScheduleRegDocFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ApptScheduleRegDocExecute ]
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
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ApptScheduleRegDocClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ApptScheduleRegDocFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetASLoadInfo(ASRowID)
{
	s RBRowId=+ASRowID
	s ASChildSub=$p(ASRowID,"||",2)
	Q:'$d(^RBAS(RBRowId,ASChildSub)) "{}"
	s ASLoad=$p(^RBAS(RBRowId,ASChildSub),"^",8)
	s NoLimitLoadFlag=$p(^RBAS(RBRowId,ASChildSub,"DHC"),"^",31)
	s AddLoad=+$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",3)
	if NoLimitLoadFlag="Y"{
		s (ASAppLoad,AppStartSeqNo)="-"
	}else{
		s QueueNO=$P($G(^RBAS(RBRowId,ASChildSub,"DHC")),"^",4)
		s ASAppLoad=$P(^RBAS(RBRowId,ASChildSub),"^",2) 
		s AppStartSeqNo=$P(^RBAS(RBRowId,ASChildSub),"^",10) //预约起始号
	}
	s LeftLoad=##class(web.DHCRBAppointment).GetAvailableNum(ASRowID,"NOR","WIN","")
	s ASQueueNoCount=ASLoad+AddLoad ;合计限额 正号限额+加号限额
	s JsonObj={}
	s JsonObj.ASLoad=ASLoad 				;正号限额
	s JsonObj.ASAppLoad=ASAppLoad			;预约限额
	s JsonObj.AppStartSeqNo=AppStartSeqNo	;预约起始号
	s JsonObj.ASQueueNoCount=ASQueueNoCount	;合计限额
	s JsonObj.AddLoad=AddLoad				;加号限额
	s JsonObj.LeftLoad=LeftLoad				;剩号
	Q JsonObj.%ToJSON()
}

}
