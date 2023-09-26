Class DHCDoc.DHCDocCure.RBCResSchdule Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通过排班ID获取排班信息
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(1887,1)
ClassMethod GetResApptSchuldeInfo(ASRowID As %String, langid As %String = "") As %String
{
	Q:ASRowID="" ""
	s:langid="" langid=..%LanguageID()
	s Data=$g(^DHCDocCureRBCResSchdule(ASRowID))
	s DDCRSLocDR=$p(Data,"^",2)  //排班科室ID
	s DDCRSResSourceDR=$p(Data,"^",3)  //排班资源ID
	s DDCRSDate=$p(Data,"^",4)  //出诊日期
	s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
	s DDCRSStartTime=$p(Data,"^",6)  //开始时间
	s DDCRSEndTime=$p(Data,"^",7)  //结束时间
	s DDCRSServiceGroupDR=$p(Data,"^",8)  //服务组ID
	s DDCRSStatus=$p(Data,"^",9)  //排程记录状态
	s DDCRSMaxNumber=$p(Data,"^",10)  //最大预约数
	s DDCRSAutoNumber=$p(Data,"^",11)  //自动预约数
	s DDCRSChargeTime=$p(Data,"^",12)  //截止缴费时间
	s DDCRSAvailPatType=$p(Data,"^",13)  //允许预约的病人类型
	s DDCRSAutoAvtiveFlag=$p(Data,"^",14)  //自动预约启用开关
	s DDCRSEndAppointTime=$p(Data,"^",22)  //截止预约时间
	i DDCRSLocDR'=""{
		s DDCRSLoc=$P($G(^CTLOC(DDCRSLocDR)),"^",2)
		s DDCRSLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DDCRSLoc,langid)
		i $P(DDCRSLoc,"-",2)'="" s DDCRSLoc=$P(DDCRSLoc,"-",2)
	}
	i DDCRSResSourceDR'=""{
		s CTCareProvDr=$P($G(^RB("RES",DDCRSResSourceDR)),"^",2)
		i CTCareProvDr'=""{
			s CTCareProv=$p($g(^CTPCP(CTCareProvDr,1)),"^",2)
			s CTCareProv= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",CTCareProv,langid)
		}
	}
	s:DDCRSDate'="" DDCRSDate=##class(websys.Conversions).DateLogicalToHtml(DDCRSDate) ;$zd(DDCRSDate,3)
	i DDCRSTimeRangeDR'=""{
		s DDCRSTimeRangeDesc=$P($G(^DHCDocCureRBCTimePeriodSet(DDCRSTimeRangeDR)),"^",2)
		s DDCRSTimeRangeDesc=##class(User.DHCDocCureRBCTimePeriodSet).GetTranByDesc("DDCTSDesc",DDCRSTimeRangeDesc,langid)
	}
	s:DDCRSStartTime'="" DDCRSStartTime=$zt(DDCRSStartTime)
	s:DDCRSEndTime'="" DDCRSEndTime=$zt(DDCRSEndTime)
	i DDCRSServiceGroupDR'=""{
		s DDCRSServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(DDCRSServiceGroupDR)),"^",2)
		s DDCRSServiceGroupDesc=##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",DDCRSServiceGroupDesc,langid)
	}
	s DDCRSStatusCode=DDCRSStatus
	s DDCRSStatus=$case(DDCRSStatus,
	"N":##class(websys.Translation).Get("doccure.emr.cureapplist.hui.csp","正常"),
	"S":##class(websys.Translation).Get("doccure.emr.cureapplist.hui.csp","停诊"),
	:"")
	s:DDCRSChargeTime'="" DDCRSChargeTime=$zt(DDCRSChargeTime)
	
	if DDCRSEndAppointTime=""{
		;s DDCRSEndAppointTime=$p($g(^DHCDocCureRBCTimePeriodSet(+DDCRSTimeRangeDR)),"^",7)	
	}
	s:DDCRSEndAppointTime'="" DDCRSEndAppointTime=$zt(DDCRSEndAppointTime)
	
	s TimeRangeInfo=$g(^DHCDocCureRBCResSchdule(ASRowID,"TR"))
	s TimeRangeFlag=$p(TimeRangeInfo,"^",1)
	s TRLength=$p(TimeRangeInfo,"^",2)
	s TRReservedNum=$p(TimeRangeInfo,"^",3)
	s TRRegNumStr=$p(TimeRangeInfo,"^",4)
	s TRRegInfoStr=$p(TimeRangeInfo,"^",5)
	s TRAvailQtyStr=##class(DHCDoc.DHCDocCure.ScheduleTR).GetTRAvailQtyStr(ASRowID)
	s DDCRSStr=DDCRSLocDR_"^"_$G(DDCRSLoc)_"^"_DDCRSResSourceDR_"^"_CTCareProv_"^"_DDCRSDate
	s DDCRSStr=DDCRSStr_"^"_DDCRSTimeRangeDR_"^"_DDCRSTimeRangeDesc_"^"_DDCRSStartTime_"^"_DDCRSEndTime_"^"_DDCRSServiceGroupDR
	s DDCRSStr=DDCRSStr_"^"_DDCRSServiceGroupDesc_"^"_DDCRSStatus_"^"_DDCRSMaxNumber_"^"_DDCRSAutoNumber_"^"_DDCRSChargeTime
	s DDCRSStr=DDCRSStr_"^"_DDCRSAvailPatType_"^"_DDCRSAutoAvtiveFlag_"^"_DDCRSEndAppointTime ;18
	s DDCRSStr=DDCRSStr_"^"_TimeRangeFlag_"^"_TRLength_"^"_TRReservedNum_"^"_TRRegNumStr_"^"_TRRegInfoStr_"^"_TRAvailQtyStr
	s DDCRSStr=DDCRSStr_"^"_DDCRSStatusCode ;25
	Q DDCRSStr
}

/// 批量生成资源的排版计划
/// 修改可以按科室生成排版计划 
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GenCreateResApptSchulde("2020-09-17","2020-09-24","1","2")
ClassMethod GenCreateResApptSchulde(StartDate As %String, EndDate As %String, UserID As %String, HospDr As %String) As %String
{
	;n (StartDate,EndDate,UserID,HospDr,%session)
	;s $ztrap="GenCreateResApptSchuldeErr"
	s ^TMP("GenCreateResApptSchulde")=$lb(StartDate,EndDate,UserID,HospDr)
	s ResourceId=""
	k CreateScheLocArr
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryCureLoc")
	s ret=""
	do rset.Execute(HospDr)
	while (rset.Next())
	{
		s LocId=rset.GetDataByName("LocId")
		s CreateScheLocArr(LocId)=""
	}	
	d rset.Close()
	
	if $d(CreateScheLocArr){
		s LocId=""
		for{
			s LocId=$o(CreateScheLocArr(LocId))	
			Q:LocId=""
			s createStr=LocId_"^"_StartDate_"^"_EndDate_"^"_""
			s ret=..CreateResApptSchulde(createStr,UserID)
		}	
	}
	q ret
}

/// 按科室生成资源的排版计划
/// 修改可以按科室生成排版计划 
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).CreateResApptSchulde(^TMP("CreateResApptSchulde"),"1","1")
ClassMethod CreateResApptSchulde(Info As %String, UserID As %String, ExpStr As %String = "") As %String
{
	;n (Info,UserID,hisui)
	s $ztrap="CreateResApptSchuldeErr"
	s ^TMP("CreateResApptSchulde")=Info
	s LocId=$p(Info,"^",1)
	s StartDate=$p(Info,"^",2)
	s EndDate=$p(Info,"^",3)
	s ResourceId=$p(Info,"^",4)
	q:(LocId="") 100
	q:EndDate="" 100
	if ResourceId'=""{
		s ResID=ResourceId
	}else{
		s ResID=..GetResIdByLocRowid(LocId,ResourceId)
	}
	
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i StartDate="" s StartDate=+$h
	i EndDate="" s EndDate=+$h
	s errcount=0
    for CurrDate=StartDate:1:EndDate d
	.for i=1:1:$l(ResID,"@") d
	..s ResourceId=$p(ResID,"@",i)
	..q:ResourceId=""
	..s WeekNum=$zd(CurrDate,10)
	..i WeekNum=0 s WeekNum=7
	..s DDCRPRowid=0 f  s DDCRPRowid=$o(^DHCDocCureRBCResPlan(0,"Week-Resource",WeekNum,LocId,ResourceId,DDCRPRowid)) q:DDCRPRowid=""  d
	...s AvtiveFlag=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",13)
	...Q:AvtiveFlag'="Y"
	...s TimeRangeDR=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",4)  //时间段代码
	...s StartTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",5)
	...s EndTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",6)
	...s ServiceGroupID=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",7)
	...s MaxNumber=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",8)
	...s AutoNumber=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",9)
	...s ChargTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",10)
	...s AvailPatType=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",11)
	...s AutoAvtiveFlag=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",12)
	...s AvtiveFlag=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",13)	
	...s TimeRangeInfo=$g(^DHCDocCureRBCResPlan(DDCRPRowid,"TR"))
	...s EndAppointTime=$p(^DHCDocCureRBCResPlan(DDCRPRowid),"^",14)
	...s Para=CurrDate_"^"_LocId_"^"_ResourceId_"^"_TimeRangeDR_"^"_StartTime
	...s Para=Para_"^"_EndTime_"^"_ServiceGroupID_"^"_MaxNumber_"^"_AutoNumber_"^"_ChargTime
	...s Para=Para_"^"_EndAppointTime_"^"_AvailPatType_"^"_AutoAvtiveFlag
	...s ret=..InsertOneRBCSchedule(Para,UserID,TimeRangeInfo)
	...if +ret'=0  s errcount=errcount+errcount 
    q 0
CreateResApptSchuldeErr
   q 1000
}

/// 新增一条排班记录
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).InsertOneRBCSchedule("66177^100^240^1^28800^39600^4^20^^^39600^^","1","Y^30^5^1-4,5-8,9-11,12-14,15-17,18-20^08:00-08:30,08:30-09:00,09:00-09:30,09:30-10:00,10:00-10:30,10:30-11:00")
ClassMethod InsertOneRBCSchedule(Para As %String, UserID As %String, TimeRangeInfo As %String = "")
{
	s ^tmpnk("InsertOneRBCSchedule")=$lb(Para,UserID,TimeRangeInfo)
	s ASDate=$P(Para,"^",1)
	s LocRowID=$P(Para,"^",2)
	s ResRowID=$P(Para,"^",3)
	s TRRowId=$P(Para,"^",4)
	s SessStartTime=$P(Para,"^",5)
	s SessEndTime=$P(Para,"^",6)
	s ServiceGroupRowID=$P(Para,"^",7)
	s MaxNum=$P(Para,"^",8)
	s AutoNum=$P(Para,"^",9)
	s ChargeTime=$P(Para,"^",10)
	s EndAppointTime=$P(Para,"^",11)
	s AvailPatType=$P(Para,"^",12)
	s AutoAvtiveFlag=$P(Para,"^",13)

	s (TimeRangeFlag,TRLength,TRReservedNum,TRRegNumStr,TRRegInfoStr)=""
	if TimeRangeInfo'=""{
		s TimeRangeFlag=$p(TimeRangeInfo,"^",1)
		if TimeRangeFlag="Y"{
			s TRLength=$p(TimeRangeInfo,"^",2)
			s TRReservedNum=$p(TimeRangeInfo,"^",3)
			s TRRegNumStr=$p(TimeRangeInfo,"^",4)
			s TRRegInfoStr=$p(TimeRangeInfo,"^",5)
		}else{
			s TimeRangeFlag=""
		}
	}
	if MaxNum="" s MaxNum=1

	s ASDate=##class(websys.Conversions).DateHtmlToLogical(ASDate)
	if SessStartTime[":"  s SessStartTime=$zth(SessStartTime)
	s:SessStartTime="" SessStartTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",3)
	if SessEndTime[":"  s SessEndTime=$zth(SessEndTime)
	s:SessEndTime="" SessEndTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",4)
    if ChargeTime[":" s ChargeTime=$zth(ChargeTime)
    if EndAppointTime[":"  s EndAppointTime=$zth(EndAppointTime)
	s:EndAppointTime="" EndAppointTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",7)
    s ret=..CheckRBCSchedule(LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)
    if (ret=1){
		;s ^TMPInsertSchedule("DHCDoc.DHCDocCure.RBCResSchdule","CheckRBCSchedule",LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)=LocRowID_","_ResRowID_","_ASDate_","_TRRowId_","_ServiceGroupRowID 
	}
    b ;ret
    if ret=1  Q 101
	Set object = ##class(User.DHCDocCureRBCResSchdule).%New(ResRowID)
	Do object.DDCRSLocDRSetObjectId(LocRowID)
	Do object.DDCRSResSourceDRSetObjectId(ResRowID)
	set object.DDCRSDate=ASDate
	DO object.DDCRSTimeRangeDRSetObjectId(TRRowId)
	set object.DDCRSStartTime=SessStartTime
	set object.DDCRSEndTime=SessEndTime
	DO object.DDCRSServiceGroupDRSetObjectId(ServiceGroupRowID)
	set object.DDCRSStatus="N" 
	;预约限额
	set object.DDCRSMaxNumber=MaxNum
	set object.DDCRSAutoNumber=AutoNum
	set object.DDCRSChargeTime=ChargeTime
	set object.DDCRSAvailPatType=AvailPatType
	set object.DDCRSAutoAvtiveFlag=AutoAvtiveFlag
	set object.DDCRSEndAppointTime=EndAppointTime
	DO object.DDCRSCreateUserDRSetObjectId(UserID)
	set object.DDCRSCreateDate=+$H
	set object.DDCRSCreateTime=$P($H,",",2)
	set object.DDCRSTimeRangeFlag=TimeRangeFlag
	set object.DDCRSTRLength=TRLength
	set object.DDCRSTRReservedNum=TRReservedNum
	set object.DDCRSTRRegNumStr=TRRegNumStr
	set object.DDCRSTRRegInfoStr=TRRegInfoStr
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	Set ASRowid=object.%Id()
	do object.%Close()
	Q 0 //_"^"_ASRowid
}

/// 检查是否已经有排班
ClassMethod CheckRBCSchedule(LocRowID As %String, ResRowID As %String, ASDate As %String, TRRowId As %String, ServiceGroupRowID As %String = "", DDCRSRowId As %String = "")
{
	;n (LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID,DDCRSRowId)
	s FindFlag=0
	s ResSchduleID=""  for  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocRowID,ASDate,ResRowID,ResSchduleID))  q:(ResSchduleID="")||(FindFlag=1)  d
	.Q:(DDCRSRowId'="")&&(ResSchduleID=DDCRSRowId)
	.s TimeDescCode=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",5)
	.s DDCRSStatus=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",9)
	.s ServiceGroupDr=$p(^DHCDocCureRBCResSchdule(ResSchduleID),"^",8)
	.q:DDCRSStatus'="N"
	.q:(ServiceGroupRowID'="")&&(ServiceGroupDr'=ServiceGroupRowID)
	.i TRRowId=TimeDescCode  s FindFlag=1
	q FindFlag
}

/// 修改一条排班记录
/// ;w ##class(DHCDoc.DHCDocCure.RBCResSchdule).UpdateOneRBCSchedule("3^1^09:00:00^11:00:00^1^70^^")
ClassMethod UpdateOneRBCSchedule(Para As %String, UserID As %String, TimeRangeInfo As %String = "")
{
	s ^tmpnk("UpdateOneRBCSchedule")=Para
	s DDCRSRowId=$P(Para,"^",1)
	s TRRowId=$P(Para,"^",2)
	s SessStartTime=$P(Para,"^",3)
	s SessEndTime=$P(Para,"^",4)
	s ServiceGroupRowID=$P(Para,"^",5)
	s MaxNum=$P(Para,"^",6)
	s AutoNum=$P(Para,"^",7)
	s ChargeTime=$P(Para,"^",8)
	s EndAppointTime=$P(Para,"^",9)
	s AvailPatType=$P(Para,"^",10)
	s AutoAvtiveFlag=$P(Para,"^",11)
	s (TimeRangeFlag,TRLength,TRReservedNum,TRRegNumStr,TRRegInfoStr)=""
	if TimeRangeInfo'=""{
		s TimeRangeFlag=$p(TimeRangeInfo,"^",1)
		if TimeRangeFlag="Y"{
			s TRLength=$p(TimeRangeInfo,"^",2)
			s TRReservedNum=$p(TimeRangeInfo,"^",3)
			s TRRegNumStr=$p(TimeRangeInfo,"^",4)
			s TRRegInfoStr=$p(TimeRangeInfo,"^",5)
		}else{
			s TimeRangeFlag=""
		}
	}
	
	if MaxNum="" s MaxNum=1
	if SessStartTime'=""  s SessStartTime=$zth(SessStartTime)
	else  s SessStartTime=$P(^DHCDocCureRBCTimePeriodSet(TRRowId),"^",3)
	if SessEndTime'=""  s SessEndTime=$zth(SessEndTime)
	else  s SessEndTime=$P(^DHCDocCureRBCTimePeriodSet(TRRowId),"^",4)
    s:ChargeTime'="" ChargeTime=$zth(ChargeTime)
    if EndAppointTime[":"  s EndAppointTime=$zth(EndAppointTime)
	;s:EndAppointTime="" EndAppointTime=$P($g(^DHCDocCureRBCTimePeriodSet(TRRowId)),"^",7)
    
    s LocRowID=$p(^DHCDocCureRBCResSchdule(DDCRSRowId),"^",2)
    s ResRowID=$p(^DHCDocCureRBCResSchdule(DDCRSRowId),"^",3)
    s ASDate=$p(^DHCDocCureRBCResSchdule(DDCRSRowId),"^",4)
    s ret=..CheckRBCSchedule(LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID,DDCRSRowId)
    if (ret=1){
		;s ^TMPInsertSchedule("DHCDoc.DHCDocCure.RBCResSchdule","CheckRBCSchedule",LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupRowID)=LocRowID_","_ResRowID_","_ASDate_","_TRRowId_","_ServiceGroupRowID 
	}
    if ret=1  Q 101
    
	Set object = ##class(User.DHCDocCureRBCResSchdule).%OpenId(DDCRSRowId)
	;DO object.DDCRSTimeRangeDRSetObjectId(TRRowId)
	set object.DDCRSStartTime=SessStartTime
	set object.DDCRSEndTime=SessEndTime
	DO object.DDCRSServiceGroupDRSetObjectId(ServiceGroupRowID)
	;set object.DDCRSStatus=DDCRSStatus 
	set object.DDCRSMaxNumber=MaxNum
	set object.DDCRSAutoNumber=AutoNum
	set object.DDCRSChargeTime=ChargeTime
	set object.DDCRSEndAppointTime=EndAppointTime
	set object.DDCRSAvailPatType=AvailPatType
	set object.DDCRSAutoAvtiveFlag=AutoAvtiveFlag
	DO object.DDCRSCreateUserDRSetObjectId(UserID)
	set object.DDCRSLastUpdateDate=+$H
	set object.DDCRSLastUpdateTime=$P($H,",",2)
	set object.DDCRSTimeRangeFlag=TimeRangeFlag
	set object.DDCRSTRLength=TRLength
	set object.DDCRSTRReservedNum=TRReservedNum
	set object.DDCRSTRRegNumStr=TRRegNumStr
	set object.DDCRSTRRegInfoStr=TRRegInfoStr
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	do object.%Close()
	Q 0
}

ClassMethod StopRBCSchedule(ASRowIDStr As %String, UserID As %String, StopFlag As %String = "") As %String
{
	Ts
	s myrtn=""
	s len=$l(ASRowIDStr,"^")
	for loop=1:1:len{
		s ret=0
		s aASRowID=$p(ASRowIDStr,"^",loop)
		s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(aASRowID)),"^",9)
		if (StopFlag="S")&&(DDCRSStatus="S"){
			s ret=-1	
		}
		elseif (StopFlag="C")&&(DDCRSStatus'="S"){
			s ret=-2
		}
	
		s:ret=0 ret=..StopOneRBCSchedule(aASRowID,UserID,StopFlag)
		if ret'=0{
			s SchuldeInfo=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(aASRowID)
			if ret="-1"{
				s myrtn="排班已经是停诊状态,无需停诊"	
			}elseif ret="-2"{
				s myrtn="排班非停诊状态,无需撤销停诊"	
			}else{
				s myrtn="错误代码:"	_ret
			}
		    s LocDesc=$p(SchuldeInfo,"^",2)
		    s ResourceDesc=$p(SchuldeInfo,"^",4)
		    s DDCRSDate=$p(SchuldeInfo,"^",5)
		    s TimeDesc=$p(SchuldeInfo,"^",7)
		    s ServiceGroupDesc=$p(SchuldeInfo,"^",11)
			s myrtn=DDCRSDate_" "_LocDesc_" "_ResourceDesc_"("_TimeDesc_","_ServiceGroupDesc_"),停诊失败!"_myrtn
			Quit
		}
	}
	if myrtn=""{
		Tc
	}else{
		Tro	
	}
	Q myrtn
}

/// 停诊/撤销停诊单条资源排班
/// 入参  ASRowID 排班ID, UserID: 用户ID
/// 返回值  0 为成功,非0 为失败
ClassMethod StopOneRBCSchedule(ASRowID As %String, UserID As %String, StopFlag As %String = "") As %String
{
	set schedule=##class(User.DHCDocCureRBCResSchdule).%OpenId(ASRowID,0)
	set DDCRSStatus=schedule.DDCRSStatus
	if StopFlag="S"{
		if DDCRSStatus="S"{
			Q -1	
		}
	}
	elseif StopFlag="C"{
		if DDCRSStatus'="S"{
			Q -2	
		}
	}
	if DDCRSStatus="S" s DDCRSStatus="N"
	else  if DDCRSStatus="N" s DDCRSStatus="S"
	if (DDCRSStatus="N"){
		s LocRowID=schedule.DDCRSLocDR.%Id()
		s ASDate=schedule.DDCRSDate
		s TRRowId=schedule.DDCRSTimeRangeDR.%Id()
		s ResRowID=schedule.DDCRSResSourceDR.%Id()
		s ServiceGroupID=schedule.DDCRSServiceGroupDR.%Id()
		s ret=..CheckRBCSchedule(LocRowID,ResRowID,ASDate,TRRowId,ServiceGroupID)
        if ret=1  {
	        Q 101
	    }
	}
	set schedule.DDCRSStatus=DDCRSStatus
	set schedule.DDCRSLastUpdateDate=+$H
	set schedule.DDCRSLastUpdateTime=$P($H,",",2)
	Do schedule.DDCRSLastUpdateUserDRSetObjectId(UserID)
	Set sc = schedule.%Save()
	If $$$ISERR(sc) {
		Quit 100
	}
	Q 0
}

/// 删除单条资源排班
/// 入参  ASRowID 排班ID
/// 返回值  0 为成功,非0 为失败
ClassMethod DeleteOneRBCSchedule(ASRowID As %String, UserID As %String = "") As %String
{
	s myrtn=0
	s ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ASRowID)
	if ResAppCount>0{
		Q "Apped"	
	}
	&sql(delete from SQLUser.DHC_DocCureRBCResSchdule where DDCRS_RowID=:ASRowID)
	s myrtn=SQLCODE
	Q myrtn
}

ClassMethod DeleteRBCSchedule(ASRowIDStr As %String) As %String
{
	Ts
	s myrtn=""
	s len=$l(ASRowIDStr,"^")
	for loop=1:1:len{
		s aASRowID=$p(ASRowIDStr,"^",loop)
		s ret=..DeleteOneRBCSchedule(aASRowID)
		if ret'=0{
			s SchuldeInfo=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResApptSchuldeInfo(aASRowID)
			if ret="Apped"{
				s myrtn="存在已预约记录"	
			}else{
				s myrtn="错误代码:"	_ret
			}
		    s LocDesc=$p(SchuldeInfo,"^",2)
		    s ResourceDesc=$p(SchuldeInfo,"^",4)
		    s DDCRSDate=$p(SchuldeInfo,"^",5)
		    s TimeDesc=$p(SchuldeInfo,"^",7)
		    s ServiceGroupDesc=$p(SchuldeInfo,"^",11)
			s myrtn=DDCRSDate_" "_LocDesc_" "_ResourceDesc_"("_TimeDesc_","_ServiceGroupDesc_"),删除失败!"_myrtn
			Quit
		}
	}
	if myrtn=""{
		Tc
	}else{
		Tro	
	}
	Q myrtn
}

/// 根据科室ID获取所有设备ID
/// sunyi 2012-01-10  
/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResIdByLocRowid("83")
ClassMethod GetResIdByLocRowid(LocID As %String, ResourceId As %String = "") As %String
{
	;n (LocID,ResourceId)
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryResource")
	s ret=""
	do rset.Execute(LocID)
	while (rset.Next())
	{
		continue:(ResourceId'="")&&(ResourceId'=rset.GetData(2))
		i ret="" s ret=rset.GetData(2)
	    e  s ret=ret_"@"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 函数：QueryResApptSchdule
/// 功能：查询资源排班
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryResApptSchdule","","","65842","",65842,2)
Query QueryResApptSchdule(LocId As %String, ResourceId As %String, BookStartDate As %String, ResGroupID As %String = "", BookEndDate As %String = "", HospID As %String = "", WeekID As %String = "") As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDr:%String,LocDesc:%String,ResourceDr:%String,ResourceDesc:%String,TimePeriodCode:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDr:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,EndAppointTime:%String,AppedLeftNumber:%String,TimeRangeFlag:%String,TRLength:%String,TRReservedNum:%String,TRRegNumStr:%String,TRRegInfoStr:%String")
{
}

ClassMethod QueryResApptSchduleExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, BookStartDate As %String, ResGroupID As %String = "", BookEndDate As %String = "", HospID As %String = "", WeekID As %String = "") As %Status
{
	s ^TMP("QueryResApptSchdule")=$lb(LocId,ResourceId,BookStartDate,ResGroupID,BookEndDate,HospID,WeekID)
 	if BookStartDate'="" S BookStartDate=##class(websys.Conversions).DateHtmlToLogical(BookStartDate)
	else  s BookStartDate=+$h
	if BookEndDate'="" S BookEndDate=##class(websys.Conversions).DateHtmlToLogical(BookEndDate)
	else  s BookEndDate=+$h
	i LocId=""{
		Set qLocSet=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryCureLoc")
		If qLocSet.QueryIsValid() { 
			Set Status=qLocSet.Execute(HospID)
			If 'Status Quit
			Set columns = qLocSet.GetColumnCount()
			While (qLocSet.Next()) {
				s LocId=qLocSet.Data("LocId")
				i LocId="" continue
				d GetScheByLoc
			}
		}
	}else{
		d GetScheByLoc
	}
	
	Quit $$$OK	
GetScheByLoc	
	for BookDate=BookStartDate:1:BookEndDate d
	.i ResourceId="" d
	..s ResourceId=0 f  s ResourceId=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
	...s ResSchduleID=0 f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
	....s TimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",5)
	....s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",8)
	....Q:(ResGroupID'="")&&(ResGroupID'=ServiceGroupDR)
	....s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCResPlan).CheckHasConfigFlag(ServiceGroupDR,TimeRangeDR)
	....Q:HasConfigFlag'="Y"
	....d OutRowResApptSchdule
	.else  d
	..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
  	...s TimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",5)
	...s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",8)
	...Q:(ResGroupID'="")&&(ResGroupID'=ServiceGroupDR)
	...s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCResPlan).CheckHasConfigFlag(ServiceGroupDR,TimeRangeDR)
	...Q:HasConfigFlag'="Y"
  	...d OutRowResApptSchdule 
  	Q
OutRowResApptSchdule
	Set DDCRSDate=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",4) 
	Set WeekNum=$zd(DDCRSDate,10)
	if WeekNum=0 s WeekNum=7
	Q:(WeekID'="")&&(WeekID'=WeekNum)
    Set Data=..GetResApptSchuldeInfo(ResSchduleID)
    Set LocDr=$p(Data,"^",1)
    Set LocDesc=$p(Data,"^",2)
    Set ResourceDr=$p(Data,"^",3)
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimePeriodCode=$p(Data,"^",6)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDr=$p(Data,"^",10)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set EndAppointTime=$p(Data,"^",18)
	Set TimeRangeFlag=$p(Data,"^",19)
    Set TRLength=$p(Data,"^",20)
    Set TRReservedNum=$p(Data,"^",21)
    Set TRRegNumStr=$p(Data,"^",22)
    Set TRRegInfoStr=$p(Data,"^",23)
    Set ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ResSchduleID)
    set AppedLeftNumber=MaxNumber-ResAppCount
    set Data=$lb(ResSchduleID,DDCRSDate,LocDr,LocDesc,ResourceDr,ResourceDesc,TimePeriodCode,TimeDesc,StartTime,EndTime,ServiceGroupDr,ServiceGroupDesc,DDCRSStatus,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag,ResAppCount,EndAppointTime,AppedLeftNumber,TimeRangeFlag,TRLength,TRReservedNum,TRRegNumStr,TRRegInfoStr)
 	Set qHandle($i(ind))=Data
	quit
}

ClassMethod QueryResApptSchduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResApptSchduleExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 为治疗申请单查找可以预约的排班
Query QueryAvailResApptSchdule(DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "", StartDate As %String = "", EndDate As %String = "", DDCISRowid As %String = "", ArcimId As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,AppedLeftNumber:%String,EndAppointTime:%String,TimeRangeFlag:%String,TRLength:%String,TRReservedNum:%String,TRRegNumStr:%String,TRRegInfoStr:%String,TRAvailQtyStr:%String,DDCRSStatusCode:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryAvailResApptSchdule","","","",66527,66533,"","","2^13^17473^20","^^^Y")
ClassMethod QueryAvailResApptSchduleExecute(ByRef qHandle As %Binary, DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "", StartDate As %String = "", EndDate As %String = "", DDCISRowid As %String = "", ArcimId As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Status
{
	s ^TMP("QueryAvailResApptSchdule")=$LB(DCARowId,BookDate,DCARowIdStr,StartDate,EndDate,DDCISRowid,ArcimId,SessionStr,SearchExpStr)
	s repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	if BookDate'="" s BookDate=##class(websys.Conversions).DateHtmlToLogical(BookDate)
	else  s BookDate=+$h
	if StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	else  s StartDate=+$h
	if EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	else  s EndDate=+$h
	
	s (HospID,LogLocID,LogUserID,langid)=""
	if SessionStr'=""{
		s HospID=$p(SessionStr,"^",1)
		s LogLocID=$p(SessionStr,"^",2)
		s LogUserID=$p(SessionStr,"^",3)
		s langid=$p(SessionStr,"^",4)
	}
	if $d(%session){
		s:HospID="" HospID=%session.Get("LOGON.HOSPID")
		s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
		s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
		s:langid="" langid=%session.Get("LOGON.LANGID")
	}
	s DoctorId=##class(web.SSUser).GetDefaultCareProvider(LogUserID)
	s myResRowId=""
	
	s (SearchLocID,SearchResID,SearchTimeRangeID,SearchByLoc)=""
	if SearchExpStr'=""{
		s SearchLocID=$p(SearchExpStr,"^",1)
		s SearchResID=$p(SearchExpStr,"^",2)
		s SearchTimeRangeID=$p(SearchExpStr,"^",3)
		s SearchByLoc=$p(SearchExpStr,"^",4) ;治疗预约时间表传入Y
	}
	
	s OrdRecLocStr=""
	if SearchByLoc="Y"{
		;按照科室全量查询
		s SearchLocIDStr=""
		if SearchLocID=""{
			s rowid=0
			for{
				s rowid=$o(^CTLOC(rowid)) q:rowid=""
				s LocDateTo=$p($g(^CTLOC(rowid)),"^",25)
				continue:(LocDateTo'="")&&(LocDateTo'>+$H)
				s CTHosp=$p($g(^CTLOC(rowid)),"^",22)
				continue:(HospID'="")&&(HospID'=CTHosp)
				continue:##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(rowid,"","",HospID)'=1
				if SearchLocIDStr="" s SearchLocIDStr=rowid
				else  s SearchLocIDStr=SearchLocIDStr_"^"_rowid
			}
		}else{
			s SearchLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(SearchLocID)
		}
		if (SearchLocIDStr="") s qHandle=$lb(0,repid,0) Quit $$$OK
		for loopLoc=1:1:$l(SearchLocIDStr,"^"){
			s SearchLocID=$p(SearchLocIDStr,"^",loopLoc)	
			for BookDate=StartDate:1:EndDate{
				s ResourceID=""
				for{
					s ResourceID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",SearchLocID,BookDate,ResourceID))
					Q:ResourceID=""
					s ResSchduleID=""
					for{
						s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",SearchLocID,BookDate,ResourceID,ResSchduleID))
						Q:ResSchduleID=""
						s TimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",5)
						s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",8)
						s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCResPlan).CheckHasConfigFlag(ServiceGroupDR,TimeRangeDR,HospID)
						continue:HasConfigFlag'="Y"
						d OutRowAvailResApptSchdule
					}
				}
			}
		}
	}elseif (DDCISRowid="")&&(ArcimId=""){
		s:DoctorId'="" myResRowId=$o(^RB("RES",0,"CTPCP",DoctorId,LogLocID,""))
		;按照申请单所属的服务组查询
		if (DCARowId="")&&(DCARowIdStr="") s qHandle=$lb(0,repid,0) Quit $$$OK
		
		S OrdRecLocStr=""
		if DCARowIdStr'=""{
			s DCARowIdStrLen=$l(DCARowIdStr,"!")
			for myIDCount=1:1:DCARowIdStrLen{
				s oneDCARowId=$p(DCARowIdStr,"!",myIDCount)
				s CureOrderId=$p($g(^DHCDocCure(oneDCARowId)),"^",2)
				s OrdRecLoc=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
				s OrderStatus=""
				s OrdStatusDR=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),1)),"^",13)
				s:OrdStatusDR'="" OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
				continue:(OrderStatus'="V")&&(OrderStatus'="E")
				s OrdRecLoc=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(OrdRecLoc)
				if OrdRecLocStr="" s OrdRecLocStr=OrdRecLoc
				else  s OrdRecLocStr=OrdRecLocStr_"^"_OrdRecLoc
				s DCARowId=oneDCARowId
			}
		}else{
			s CureOrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
			s OrdRecLoc=$p($g(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),3)),"^",6)
			s OrdRecLoc=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(OrdRecLoc)
			if OrdRecLocStr="" s OrdRecLocStr=OrdRecLoc
			else  s OrdRecLocStr=OrdRecLocStr_"^"_OrdRecLoc	
		}
		i (DCARowId="") s qHandle=$lb(0,repid,0) Quit $$$OK
		
		Set OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		i OrderId="" s qHandle=$lb(0,repid,0) Quit $$$OK
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		i ArcimId="" s qHandle=$lb(0,repid,0) Quit $$$OK
		
		if OrdRecLocStr'="" s OrdRecLocStr="^"_OrdRecLocStr_"^"
		s OrderStatus=""
		s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
		i (OrderStatus'="V")&&(OrderStatus'="E") s qHandle=$lb(0,repid,0) Quit $$$OK
		s ReLocID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
		set OrderAddDeptDr=""
		Set OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
		if OrderAddDeptDr'=""{
			s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
		}
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
		i DDCISRowid="" s qHandle=$lb(0,repid,0) Quit $$$OK
		s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		i ServiceGroupDR="" s qHandle=$lb(0,repid,0) Quit $$$OK
		d FindByServiceGroup
	}else{
		if DDCISRowid=""{	
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
		}
		i DDCISRowid="" s qHandle=$lb(0,repid,0) Quit $$$OK
		s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		i ServiceGroupDR="" s qHandle=$lb(0,repid,0) Quit $$$OK
		d FindByServiceGroup
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
FindByServiceGroup
	s LinkServiceGroupStr=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).GetLinkServiceGroup(ServiceGroupDR,HospID)
	s LinkServiceGroupStr=ServiceGroupDR_"^"_LinkServiceGroupStr
	for loop=1:1:$l(LinkServiceGroupStr,"^"){
		s ServiceGroupDR=$p(LinkServiceGroupStr,"^",loop)
		continue:ServiceGroupDR=""
		for BookDate=StartDate:1:EndDate{
			s StartTimeVal="" 
			for{
				s StartTimeVal=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal))
				q:StartTimeVal=""
				s ResSchduleID="" 
				for{
					s ResSchduleID=$o(^DHCDocCureRBCResSchdule(0,"Service-Time",ServiceGroupDR,BookDate,StartTimeVal,ResSchduleID))
					q:ResSchduleID=""
					s TimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",5)
					s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(ResSchduleID)),"^",8)
					s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCResPlan).CheckHasConfigFlag(ServiceGroupDR,TimeRangeDR)
					continue:HasConfigFlag'="Y"
					d OutRowAvailResApptSchdule
				}
			}
		}
	}
	Quit
OutRowAvailResApptSchdule
	Set Data=..GetResApptSchuldeInfo(ResSchduleID,langid)
    Set DDCRSLocDR=$p(Data,"^",1)
    Q:(OrdRecLocStr'="")&&(OrdRecLocStr'[("^"_DDCRSLocDR_"^"))
    Set LocDesc=$p(Data,"^",2)
    Set ResourceID=$p(Data,"^",3)
    Q:$$CheckQuit(ResourceID)=1
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set EndAppointTime=$p(Data,"^",18)
    Set ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ResSchduleID)
    set AppedLeftNumber=MaxNumber-ResAppCount
    // 分时段信息
    Set TimeRangeFlag = $p(Data, "^", 19)
    Set TRLength = $p(Data, "^", 20)
    Set TRReservedNum = $p(Data, "^", 21)
    Set TRRegNumStr = $p(Data, "^", 22)
    Set TRRegInfoStr = $p(Data, "^", 23)
    Set TRAvailQtyStr = $p(Data, "^", 24)
    Set DDCRSStatusCode = $p(Data, "^", 25)
    set Data=$lb(ResSchduleID,DDCRSDate,LocDesc,ResourceDesc,TimeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag,ResAppCount,AppedLeftNumber,EndAppointTime,TimeRangeFlag,TRLength,TRReservedNum,TRRegNumStr,TRRegInfoStr,TRAvailQtyStr,DDCRSStatusCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
CheckQuit(DDCRSResSourceDR)
	s CTCareUserDR=""
	s CTCareProvDr=$P($G(^RB("RES",DDCRSResSourceDR)),"^",2)
	i CTCareProvDr'=""{
		s CTCareProv=$p($g(^CTPCP(CTCareProvDr,1)),"^",2)
		s CTCareUserDR=$O(^SSU("SSUSR",0,"CTPCP",CTCareProvDr,""))
	}
	s DHCDocCureAppHiddenOtherUser=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocAppHiddenOtherUser",DDCRSLocDR,HospID)
	;+(##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAppHiddenOtherUser",HospID))
	if (myResRowId'="")&&(DHCDocCureAppHiddenOtherUser="1"){
		if (CTCareUserDR'="")&&(myResRowId'=DDCRSResSourceDR){
			Q 1
		}	
	}
	if (SearchByLoc'="Y")&&(SearchLocID'="")&&(SearchLocID'=DDCRSLocDR){
		Q 1	
	}
	if (SearchResID'="")&&(SearchResID'=DDCRSResSourceDR){
		Q 1	
	}
	if (SearchTimeRangeID'="")&&(SearchTimeRangeID'=TimeRangeDR){
		Q 1	
	}
	Q 0
}

ClassMethod QueryAvailResApptSchduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAvailResApptSchduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAvailResApptSchduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAvailResApptSchduleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 功能：查询本科室可以预约的资源
/// 参数：LocID:科室ROWID
/// 返回：资源列表 
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryResource","173")
Query QueryResource(LocID As %String, SDate As %String = "", EDate As %String = "") As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String,TResCode:%String,TResDescPY:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String, SDate As %String = "", EDate As %String = "") As %Status
{
	
	if LocID="" Quit $$$OK
	k OutputResRowArr
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LocID)
	for loop=1:1:$l(LogLocIDStr,"^"){
		s aLocID=$p(LogLocIDStr,"^",loop)
		continue:aLocID=""
		d GetOneLocID	
	}
	Quit $$$OK
GetOneLocID
	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",aLocID,RowId) ) q:RowId=""  d
	.Q:$d(OutputResRowArr(RowId))
	.Q:..CheckExistResSchdule(aLocID,RowId,SDate,EDate)=0
	.s CTCPDR=$p(^RB("RES",RowId),"^",2)
	.Q:CTCPDR="" 
	.Q:'$d(^CTPCP(CTCPDR,1))
	.s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	.s ResCode=$p(^CTPCP(CTCPDR,1),"^",1)
	.s ResDescPY=##class(web.DHCINSUPort).GetCNCODE(ResDesc,4,"")  ;返回汉字的编码信息
    .Do OutputResRow
    .s OutputResRowArr(RowId)=""
 	q
	
OutputResRow
	set Data=$lb($g(ResDesc),RowId,ResCode,ResDescPY)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod CheckExistResSchdule(LocID, ResDocID, StartDate As %String = "", EndDate As %String = "")
{
	;n (LocID,ResDocID,StartDate,EndDate)
	S FIND=0
	if (LocID="")!(ResDocID="") Q FIND
	s DateFormat=##class(websys.Conversions).DateFormat()
	if StartDate'="" s StartDate=$zdh(StartDate,DateFormat)
	else  s StartDate=+$h
	if EndDate'="" s EndDate=$zdh(EndDate,DateFormat)
	else  s EndDate=+$h+7
	for date=StartDate:1:EndDate{
		s ID=""
		for{
			s ID=$O(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",LocID,date,ResDocID,ID)) q:ID=""
			S FIND=1
		}
	}
	Q FIND
}

/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetAdmDateStr("2021-01-15",$list(^tempnk("GetAdmDateStr"),2))
ClassMethod GetAdmDateStr(StartDate As %String, ParamJson As %String = "", NotNeedYear As %String = "", cspName As %String = "")
{
	if cspName="" s cspName="doccure.workreport.cureitemschedule.hui.csp"
	;n (StartDate,ParamJson,NotNeedYear)
	s ^tempnk("GetAdmDateStr")=$lb(StartDate,ParamJson)
	if StartDate=""{
		Set StartDate=+$h
	}else{
		Set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	}
	if (ParamJson'="") {
		k ParaCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ParamJson,.ParaCongeriesArr)
	}
	s weekstr="日,一,二,三,四,五,六"
	//获取一周内的日期串
	s ExistScheduleFlag=0
	if $d(ParaCongeriesArr) {
		 ;(DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "", StartDate As %String = "", EndDate As %String = "", DDCISRowid As %String = "", ArcimId As %String = "", SessionStr As %String = ""
		 Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryAvailResApptSchdule")
		 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),ParaCongeriesArr("Arg3"),(StartDate),(StartDate),ParaCongeriesArr("Arg6"),ParaCongeriesArr("Arg7"),ParaCongeriesArr("Arg8"))
		 While (rset.Next()) {
			s ExistScheduleFlag=1
		 }
		 d rset.Close()
	}
	s mStartDate=##class(websys.Conversions).DateLogicalToHtml(StartDate)
	if NotNeedYear="Y"{
		if mStartDate["-" s mStartDate=$P(mStartDate,"-",2,3)
		else  if mStartDate["/" s mStartDate=$P(mStartDate,"/",1,2)	
	}
	s WeekDesc="("_##class(websys.Translation).Get(cspName,"周"_$p(weekstr,",",$zd(StartDate,10)+1))_")"
	s str=mStartDate_WeekDesc_$C(1)_ExistScheduleFlag
	for i=1:1:6{
		s ExistScheduleFlag=0
		if $d(ParaCongeriesArr) {
			 Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryAvailResApptSchdule")
			 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),ParaCongeriesArr("Arg3"),(StartDate+i),(StartDate+i),ParaCongeriesArr("Arg6"),ParaCongeriesArr("Arg7"),ParaCongeriesArr("Arg8"))
			 While (rset.Next()) {
				s ExistScheduleFlag=1
			 }
			 d rset.Close()
		}
		s mStartDate=##class(websys.Conversions).DateLogicalToHtml(StartDate+i)
		if NotNeedYear="Y"{
			if mStartDate["-" s mStartDate=$P(mStartDate,"-",2,3)
			else  if mStartDate["/" s mStartDate=$P(mStartDate,"/",1,2)	
		}
		
		s WeekDesc="("_##class(websys.Translation).Get(cspName,"周"_$p(weekstr,",",$zd((StartDate+i),10)+1))_")"
		s str=str_"^"_mStartDate_WeekDesc_$C(1)_ExistScheduleFlag	
	}
	Quit str
}

/// w ##class(DHCDoc.DHCDocCure.RBCResSchdule).GetScheduleDateStr("2021-04-08",$list(^tempnk("GetScheduleDateStr"),2))
ClassMethod GetScheduleDateStr(StartDate As %String, ParamJson As %String = "", cspName As %String = "")
{
	;n (StartDate,ParamJson)
	s ^templog("GetScheduleDateStr")=$lb(StartDate,ParamJson)
	if StartDate=""{
		Set StartDate=+$h
	}else{
		Set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	}
	if (ParamJson'="") {
		k ParaCongeriesArr
		d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ParamJson,.ParaCongeriesArr)
	}
	if cspName="" s cspName="doccure.rbcresschdule.hui.csp"
	s weekstr="日,一,二,三,四,五,六"
	//获取一周内的日期串
	s ExistScheduleFlag=0
	if $d(ParaCongeriesArr) {
		 Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryResApptSchdule")
		 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),(StartDate),ParaCongeriesArr("Arg4"),(StartDate),ParaCongeriesArr("Arg6"))
		 While (rset.Next()) {
			s ExistScheduleFlag=1
		 }
		 d rset.Close()
	}
	s WeekDesc="("_##class(websys.Translation).Get(cspName,"周"_$p(weekstr,",",$zd(StartDate,10)+1))_")"
	s str=##class(websys.Conversions).DateLogicalToHtml(StartDate)_WeekDesc_$C(1)_ExistScheduleFlag
	for i=1:1:6{
		s ExistScheduleFlag=0
		if $d(ParaCongeriesArr) {
			 Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryResApptSchdule")
			 do rset.Execute(ParaCongeriesArr("Arg1"),ParaCongeriesArr("Arg2"),(StartDate+i),ParaCongeriesArr("Arg4"),(StartDate+i),ParaCongeriesArr("Arg6"))
			 While (rset.Next()) {
				s ExistScheduleFlag=1
			 }
			 d rset.Close()
		}
		s WeekDesc="("_##class(websys.Translation).Get(cspName,"周"_$p(weekstr,",",$zd((StartDate+i),10)+1))_")"
		s str=str_"^"_##class(websys.Conversions).DateLogicalToHtml(StartDate+i)_WeekDesc_$C(1)_ExistScheduleFlag	
	}
	Quit str
}

/// 功能：查询本科室可以预约的资源
/// 参数：LocID:科室ROWID
/// 返回：资源列表 
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","QueryAvailDate","2030")
Query QueryAvailDate(ScheduleID As %String, SttDate As %String = "") As %Query(ROWSPEC = "Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,AppedLeftNumber:%String,EndAppointTime:%String")
{
}

ClassMethod QueryAvailDateExecute(ByRef qHandle As %Binary, ScheduleID As %String, SttDate As %String = "") As %Status
{
	if ScheduleID="" Quit $$$OK
	s ind=0
	s Data=$g(^DHCDocCureRBCResSchdule(ScheduleID))
	s RSLocDR=$p(Data,"^",2)  //排班科室ID
	s RSResSourceDR=$p(Data,"^",3)  //排班资源ID
	s RSDate=$p(Data,"^",4)  //出诊日期
	s RSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
	s RSServiceGroupDR=$p(Data,"^",8) 
	s Date=RSDate
	for{
		s Date=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",RSLocDR,Date))
		Q:Date=""
		s ID=""
		for{
			s ID=$o(^DHCDocCureRBCResSchdule(0,"Loc-Date-Res",RSLocDR,Date,RSResSourceDR,ID))
			Q:ID=""
			s DDCRSTimeRangeDR=$p($g(^DHCDocCureRBCResSchdule(ID)),"^",5)
			continue:DDCRSTimeRangeDR'=RSTimeRangeDR
			s DDCRSServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(ID)),"^",8) 
			continue:DDCRSServiceGroupDR'=RSServiceGroupDR
			s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(ID)),"^",9)  //排程记录状态
			continue:DDCRSStatus'="N"
			d GetOneResSchdule
		}
	}
	Quit $$$OK
GetOneResSchdule
	Set Data=..GetResApptSchuldeInfo(ID)
    Set DDCRSLocDR=$p(Data,"^",1)
    Set LocDesc=$p(Data,"^",2)
    Set ResourceID=$p(Data,"^",3)
    Set ResourceDesc=$p(Data,"^",4)
    Set DDCRSDate=$p(Data,"^",5)
    Set TimeDesc=$p(Data,"^",7)
    Set StartTime=$p(Data,"^",8)
    Set EndTime=$p(Data,"^",9)
    Set ServiceGroupDesc=$p(Data,"^",11)
    Set DDCRSStatus=$p(Data,"^",12)
    Set MaxNumber=$p(Data,"^",13)
    Set AutoNumber=$p(Data,"^",14)
    Set ChargeTime=$p(Data,"^",15)
    Set AvailPatType=$p(Data,"^",16)
    Set AutoAvtiveFlag=$p(Data,"^",17)
    Set EndAppointTime=$p(Data,"^",18)
    Set ResAppCount=##class(DHCDoc.DHCDocCure.Appointment).GetRBResAppCount(ID)
    set AppedLeftNumber=MaxNumber-ResAppCount
    set Data=$lb(ID,DDCRSDate,LocDesc,ResourceDesc,TimeDesc,StartTime,EndTime,ServiceGroupDesc,DDCRSStatus,MaxNumber,AutoNumber,ChargeTime,AvailPatType,AutoAvtiveFlag,ResAppCount,AppedLeftNumber,EndAppointTime)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod QueryAvailDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAvailDateExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query FindScheduleList(DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "", StartDate As %String = "", EndDate As %String = "", DDCISRowid As %String = "", ArcimId As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Query(ROWSPEC = "RowId:%String,LocRowid:%String,DocRowid:%String,ServiceGroupID:%String,TimeRangeID:%String,LocDesc:%String,ResourceDesc:%String,ServiceGroupDesc:%String,TimeDesc:%String,admDate1:%String,admDate2:%String,admDate3:%String,admDate4:%String,admDate5:%String,admDate6:%String,admDate7:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResSchdule","FindScheduleList","514","","514","2021-07-15","2021-07-15","","","2^115^12175","")
ClassMethod FindScheduleListExecute(ByRef qHandle As %Binary, DCARowId As %String, BookDate As %String, DCARowIdStr As %String = "", StartDate As %String = "", EndDate As %String = "", DDCISRowid As %String = "", ArcimId As %String = "", SessionStr As %String = "", SearchExpStr As %String = "") As %Status
{
	s ^tmpnk("FindScheduleList")=$lb(DCARowId , BookDate , DCARowIdStr, StartDate, EndDate, DDCISRowid, ArcimId, SessionStr, SearchExpStr)
	s AddDay=6
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=StartDate+AddDay
	k ArrayList
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.RBCResSchdule:QueryAvailResApptSchdule")
	do rset.Execute(DCARowId , BookDate , DCARowIdStr, StartDate, EndDate, DDCISRowid, ArcimId, SessionStr, SearchExpStr)
	While (rset.Next()) {
		;"Rowid:%String,DDCRSDate:%String,LocDesc:%String,ResourceDesc:%String,TimeDesc:%String,StartTime:%String,EndTime:%String,ServiceGroupDesc:%String,DDCRSStatus:%String,MaxNumber:%String,AutoNumber:%String,ChargeTime:%String,AvailPatType:%String,AutoAvtiveFlag:%String,AppedNumber:%String,AppedLeftNumber:%String,EndAppointTime:%String"
		s ASRowID=rset.Data("Rowid")
		s LocDesc=rset.Data("LocDesc")
		s ResourceDesc=rset.Data("ResourceDesc")
		s TimeDesc=rset.Data("TimeDesc")
		s AppedNumber=rset.Data("AppedNumber")
		s AppedLeftNumber=rset.Data("AppedLeftNumber")
		s MaxNumber=rset.Data("MaxNumber")
		s DDCRSDateHTML=rset.Data("DDCRSDate")
		s StartTime=rset.Data("StartTime")
		s:StartTime'="" StartTime=$zt($zth(StartTime,1),2)
		s EndTime=rset.Data("EndTime")
		s:EndTime'="" EndTime=$zt($zth(EndTime,1),2)
		s ServiceGroupDesc=rset.Data("ServiceGroupDesc")
		s TimeRangeFlag=rset.Data("TimeRangeFlag")
		s TRLength=rset.Data("TRLength")
		s TRReservedNum=rset.Data("TRReservedNum")
		s TRRegNumStr=rset.Data("TRRegNumStr")
		s TRRegInfoStr=rset.Data("TRRegInfoStr")
		s TRAvailQtyStr=rset.Data("TRAvailQtyStr")
		s DDCRSStatusCode=rset.Data("DDCRSStatusCode")
		s TimeRangeInfo=TimeRangeFlag_"&&"_TRLength_"&&"_TRReservedNum_"&&"_TRRegNumStr_"&&"_TRRegInfoStr_"&&"_TRAvailQtyStr
		s Data=$g(^DHCDocCureRBCResSchdule(ASRowID))
		s DDCRSLocDR=$p(Data,"^",2)  //排班科室ID
		s DDCRSResSourceDR=$p(Data,"^",3)  //排班资源ID
		s DDCRSDate=$p(Data,"^",4)  //出诊日期
		s DDCRSTimeRangeDR=$p(Data,"^",5)  //排程出诊时段
		s DDCRSServiceGroupDR=$p(Data,"^",8)  //服务组ID
		s mLabel=AppedLeftNumber_"/"_MaxNumber
		s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR,DDCRSDate)=mLabel_"^"_AppedNumber_"^"_ASRowID_"^"_DDCRSDateHTML_"^"_TimeRangeInfo_"^"_DDCRSStatusCode
		s ArrayList(DDCRSLocDR,DDCRSResSourceDR,DDCRSServiceGroupDR,DDCRSTimeRangeDR)=LocDesc_"^"_ResourceDesc_"^"_ServiceGroupDesc_"^"_TimeDesc_" "_StartTime_"-"_EndTime
	}
	d rset.Close()
	if $d(ArrayList){
		s mLocID=""
		for{
			s mLocID=$o(ArrayList(mLocID))	
			Q:mLocID=""
			s mResSourceID=""
			for{
				s mResSourceID=$o(ArrayList(mLocID,mResSourceID))	
				Q:mResSourceID=""
				s mServiceGroupID=""
				for{
					s mServiceGroupID=$o(ArrayList(mLocID,mResSourceID,mServiceGroupID))	
					Q:mServiceGroupID=""
					s mTimeRangeID=""
					for{
						s mTimeRangeID=$o(ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID))	
						Q:mTimeRangeID=""
						s tmpData=ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID)
						s mLocDesc=$p(tmpData,"^",1)
						s mResourceDesc=$p(tmpData,"^",2)
						s mServiceGroupDesc=$p(tmpData,"^",3)
						s mTimeRangeDesc=$p(tmpData,"^",4)
	
						s RowId=mLocID_"^"_mResSourceID_"^"_mServiceGroupID_"^"_mTimeRangeID
						s mResourceDesc=mResourceDesc_"("_mLocDesc_")"
						s Data=$lb(RowId,mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mLocDesc,mResourceDesc,mServiceGroupDesc,mTimeRangeDesc)
						for mDate=StartDate:1:EndDate{
							s Info=$g(ArrayList(mLocID,mResSourceID,mServiceGroupID,mTimeRangeID,mDate))
							s Data=Data_$lb(Info)
						}
						d OutputRow
					}
				}
			}
		}	
	}
	Quit $$$OK
OutputRow
	set qHandle($I(ind))=Data
    quit
}

ClassMethod FindScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScheduleListExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 获取分时段信息
ClassMethod GetTRInfoByRowid(PlanRowid As %String, SchedRowId As %String) As %String
{
	s ^tmplog("GetTRInfoByRowid")=$lb(PlanRowid, SchedRowId)
	s TRInfoObj=##class(%DynamicObject).%New()
	if PlanRowid="",SchedRowId="" q TRInfoObj.%ToJSON()
	if PlanRowid'="" {
		s TRRegNumStr=$p($g(^DHCDocCureRBCResPlan(PlanRowid,"TR")),"^",4)
		s TRRegInfoStr=$p($g(^DHCDocCureRBCResPlan(PlanRowid,"TR")),"^",5)
	}else {
		s TRRegNumStr=$p($g(^DHCDocCureRBCResSchdule(SchedRowId,"TR")),"^",4)
		s TRRegInfoStr=$p($g(^DHCDocCureRBCResSchdule(SchedRowId,"TR")),"^",5)
	}
	s StartTime="", EndTime=""
	s ArrList=##class(%DynamicArray).%New()	
	if TRRegNumStr'="",TRRegInfoStr'="" {
		s len=$l(TRRegNumStr,",")
		f i=1:1:len {
			s List=##class(%DynamicObject).%New()
			s TRRegNum=$p(TRRegNumStr,",",i)
			s TRRegInfo=$p(TRRegInfoStr,",",i)
			s StNum=$p(TRRegNum,"-",1)
			s EndNum=$p(TRRegNum,"-",2)
			s Qty=EndNum-StNum+1
			if i=1{
				s StartTime=$p(TRRegInfo,"-",1)
				s:$l(StartTime,":")=2 StartTime=StartTime_":00"
			}
			if i=len{
				s EndTime=$p(TRRegInfo,"-",2)
				s:$l(EndTime,":")=2 EndTime=EndTime_":00"
			}
			d List.%Set("SeqNoStr",TRRegNum)
			d List.%Set("TimeRange",TRRegInfo)
			d List.%Set("Qty",Qty)
			d ArrList.%Push(List)
		}
	}
	d TRInfoObj.%Set("TRStartTime",StartTime)
	d TRInfoObj.%Set("TREndTime",EndTime)
	d TRInfoObj.%Set("TRInfo",ArrList)
	q TRInfoObj.%ToJSON()
}

/// 分时段计算
ClassMethod TRInfoCalculate(TRStartTime As %String, TREndTime As %String, TimeLength As %String, RegNum As %String, StartTime As %String, EndTime As %String) As %String
{
	s TRInfoObj=##class(%DynamicObject).%New()
    if (+TimeLength=0)||(+RegNum=0)||(TRStartTime="")||(TREndTime=""){
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","缺少必要计算参数")
		q TRInfoObj.%ToJSON()
	}
	s TRStartTime=$ZTH(TRStartTime,3)
	s TREndTime=$ZTH(TREndTime,3)
	s StartTime=$ZTH(StartTime,3)
	s EndTime=$ZTH(EndTime,3)
	s TimeLength=TimeLength*60
	s TimeInterval=TREndTime-TRStartTime
	
	i TRStartTime<StartTime {
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","分时段开始时间不能小于开始时间")
		q TRInfoObj.%ToJSON()
	}
	i TREndTime>EndTime {
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","分时段结束时间不能大于结束时间")
		q TRInfoObj.%ToJSON()
	}
	i TimeInterval<=0 {
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","分时段开始时间不能小于结束时间")
		q TRInfoObj.%ToJSON()
	}
	s mod=TimeInterval#TimeLength
	i mod>0 {
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","分时段时间间隔数不是整数")
		q TRInfoObj.%ToJSON()
	}
	s Step=TimeInterval/TimeLength
	i Step>RegNum {
		d TRInfoObj.%Set("Code",-1)
		d TRInfoObj.%Set("ErrMsg","分时段时间间隔数不能大于分时段号数")
		q TRInfoObj.%ToJSON()
	}
	s mod=RegNum#Step
	s OneStepNum=RegNum\Step
	s RegNumInfo="",TimeRangeInfo=""
	s One=1
	s OneNum=0
	s ArrList=##class(%DynamicArray).%New()		
	f i=1:1:Step
	{
		s List=##class(%DynamicObject).%New()
		i i<=mod{
			s OneNum=OneNum+OneStepNum+1
		}else{
			s OneNum=OneNum+OneStepNum
		}
		s time=TRStartTime+((i-1)*TimeLength)
		s time2=TRStartTime+((i)*TimeLength)

		s RegNumInfo=One_"-"_OneNum
		s TimeRangeInfo=$P($ZT(time,1),":",1,2)_"-"_$P($ZT(time2,1),":",1,2)
		d List.%Set("SeqNoStr",RegNumInfo)
		d List.%Set("TimeRange",TimeRangeInfo)
		d List.%Set("Qty",(OneNum-One+1))
		d ArrList.%Push(List)
		s One=1+OneNum
	}
	d TRInfoObj.%Set("Code",0)
	d TRInfoObj.%Set("TRInfo",ArrList)
	q TRInfoObj.%ToJSON()
}

}
