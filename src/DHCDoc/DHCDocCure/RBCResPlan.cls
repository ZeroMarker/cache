Class DHCDoc.DHCDocCure.RBCResPlan Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 函数：QueryResourceWeekPlan
/// 功能：查询资源的星期计划
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResPlan","QueryResourceWeekPlan",82,1992)
Query QueryResourceWeekPlan(LocId As %String, ResourceId As %String) As %Query(ROWSPEC = "LocDesc:%String,LocId:%String,ResSourceDR:%String,ResourceDesc:%String,TWEEK:%String,TServiceGroup:%String,TTimeDesc:%String,TStartTime:%String,TEndTime:%String,TMax:%String,TAutoNumber:%String,TRowid:%String,TWeekNum:%String,TSerivceGourpId:%String,TTimePeriodCode:%String,TChargTime:%String,TAvailPatType:%String,TAutoAvtiveFlag:%String")
{
}

ClassMethod QueryResourceWeekPlanExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String) As %Status
{
	s ^TMP("QueryResourceWeekPlan")=LocId_"^"_ResourceId
 	If $g(ind)="" Set ind=1
 	i LocId=""  Quit $$$OK
 	s LocDesc=$p(^CTLOC(LocId),"^",2)
 	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	i ResourceId="" d
 	.s ResourceIdStr=##class(DHCDoc.DHCDocCure.RBCResSchdule).GetResIdByLocRowid(LocId)
	Set RowId=0	f  s RowId=$o(^DHCDocCureRBCResPlan(0,"LocId",LocId,RowId)) q:RowId=""  d
	.s (TimeDesc,ServiceGroup)=""
	.s ResSourceDR=$p(^DHCDocCureRBCResPlan(RowId),"^",2)
	.i ResSourceDR'="" d
	..s CareProvId=$p($g(^RB("RES",ResSourceDR)),"^",2)
	..i CareProvId'="" s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	.Q:(ResourceId'="")&&(ResSourceDR'=ResourceId)
	.Q:($g(ResourceIdStr)'="")&&(("@"_ResourceIdStr_"@")'[("@"_ResSourceDR_"@"))
	.s WeekNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",3)
	.s Week=..GetWeek(WeekNumber)
	.s TimeRangeDR=$p(^DHCDocCureRBCResPlan(RowId),"^",4)  //时间段代码
	.i TimeRangeDR'="" d
	..s TimeDesc=$p($g(^DHCDocCureRBCTimePeriodSet(TimeRangeDR)),"^",2)
	.s StartTime=$p(^DHCDocCureRBCResPlan(RowId),"^",5)
	.s StartTime=$zt(StartTime)
	.s EndTime=$p(^DHCDocCureRBCResPlan(RowId),"^",6)
	.s EndTime=$zt(EndTime)
	.s ServiceGroupID=$p(^DHCDocCureRBCResPlan(RowId),"^",7)
	.i ServiceGroupID'="" d
	..s ServiceGroup=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)),"^",2)
	.s MaxNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",8)
    .s AutoNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",9)
    .s ChargeTime=$p(^DHCDocCureRBCResPlan(RowId),"^",10)
    .i ChargeTime'="" s ChargeTime=$zt(ChargeTime)
    .s AvailPatType=$p(^DHCDocCureRBCResPlan(RowId),"^",11)
    .s AutoAvtiveFlag=$p(^DHCDocCureRBCResPlan(RowId),"^",12)
    .Do OutRowResourceWeekPlan
	Quit $$$OK

OutRowResourceWeekPlan
	set Data=$lb(LocDesc,LocId,ResSourceDR,ResourceDesc,Week,ServiceGroup,TimeDesc,StartTime,EndTime,MaxNumber,AutoNumber,RowId,WeekNumber,ServiceGroupID,TimeRangeDR,ChargeTime,AvailPatType,AutoAvtiveFlag)
 	Set qHandle($i(ind))=Data
	quit
}

ClassMethod QueryResourceWeekPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceWeekPlanExecute ]
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

/// 函数：QueryWeek
/// 功能：查询星期 
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryWeek")
Query QueryWeek() As %Query(ROWSPEC = "WeekName:%String,WeekId:%String")
{
}

ClassMethod QueryWeekExecute(ByRef qHandle As %Binary) As %Status
{
 	If $g(ind)="" Set ind=1
 	
	Set RowId=0	f  s RowId=$o(^CT("DOW",1,RowId)) q:RowId=""  d
	.s Name=$p(^CT("DOW",1,RowId),"^",1)
	.s Sequence=$p(^CT("DOW",1,RowId),"^",2)
	.s Checked=$p(^CT("DOW",1,RowId),"^",3)
	.;i Checked="Y"  d
    .Do OutRow2
	Quit $$$OK
OutRow2
	set Data=$lb(Name,Sequence,RowId)
 	Set qHandle($i(ind))=Data
	quit
}

ClassMethod QueryWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWeekExecute ]
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

Query QueryBookTime(HospID As %String = "", SGRowID As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargTime:%String,NotAvailFlag:%String,EndAppointTime:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResPlan","QueryBookTime")
ClassMethod QueryBookTimeExecute(ByRef qHandle As %Binary, HospID As %String = "", SGRowID As %String = "", ExpStr As %String = "") As %Status
{
	s langid=$p(ExpStr,"^",1)
	s:langid="" langid=..%LanguageID()
	s ind=1
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureRBCTimePeriodSet",HospID,+$H)
	s TimeRowid=0  f  s TimeRowid=$o(^DHCDocCureRBCTimePeriodSet(TimeRowid)) q:TimeRowid=""  d
	.s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCTimePeriodSet",TimeRowid,HospID)
	.Q:(HospID'="")&&(HospShowDataFlag="N")
	.s HasConfigFlag=..CheckHasConfigFlag(SGRowID,TimeRowid,HospID)
	.Q:HasConfigFlag'="Y"
	.d OutTime 
	Quit $$$OK 
OutTime
	s TimeCode=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",1)
	s TimeDesc=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",2)
	s TimeDesc=##class(User.DHCDocCureRBCTimePeriodSet).GetTranByDesc("DDCTSDesc",TimeDesc,langid)
	s StartTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",3)
	i StartTime'="" d
	.s StartTime=$zt(StartTime)
	s EndTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",4)
	i EndTime'="" d 
	.s EndTime=$zt(EndTime)
	s EndChargeTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",5)
	i EndChargeTime'="" d
	.s EndChargeTime=$zt(EndChargeTime)
	s EndAppointTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",7)
	i EndAppointTime'="" d
	.s EndAppointTime=$zt(EndAppointTime)
	s NotAvailFlag=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",6)
	if NotAvailFlag="Y" q
	set Data=$lb(TimeRowid,TimeCode,TimeDesc,StartTime,EndTime,EndChargeTime,NotAvailFlag,EndAppointTime)
	Set qHandle($i(ind))=Data
	quit
}

ClassMethod QueryBookTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookTimeExecute ]
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

/// 函数： UpdateResoucePlan
/// 功能： 更新资源计划
/// w ##class(DHCDoc.DHCDocCure.RBCResPlan).SaveCureRBCResPlan(^TMP("SaveCureRBCResPlan"))
ClassMethod SaveCureRBCResPlan(value As %String, TimeRangeInfo As %String = "")
{
    n (value,TimeRangeInfo)
    s ^TMP("SaveCureRBCResPlan")=$lb(value,TimeRangeInfo)
    q:value="" 100
    s Rowid=$p(value,"^",1)
    s LocId=$p(value,"^",2)
	s ResourceId=$p(value,"^",3)
	s WeekNumber=$p(value,"^",4)
	s TimeDesc=$p(value,"^",5)
	s ServiceGroupID=$p(value,"^",6)
	s StartTime=$p(value,"^",7)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(value,"^",8)
	s EndTime=$zth(EndTime,3)

	s BookMaxNumber=$p(value,"^",9)
    s AutoNumber=$p(value,"^",10)
    s ChargeTime=$p(value,"^",11)
    i ChargeTime'="" d
    .s ChargeTime=$zth(ChargeTime,3)
    s GenerFlag=$p(value,"^",12)
    s EndAppointTime=$p(value,"^",13)
    i EndAppointTime'="" d
    .s EndAppointTime=$zth(EndAppointTime,3)
    Q:WeekNumber="" 100
    Q:LocId="" 100
    Q:ResourceId="" 100
    Q:'$D(^CTLOC(LocId)) 100
    Q:'$D(^RB("RES",ResourceId)) 100
    Q:'$D(^CT("DOW",1,WeekNumber)) 100
    Q:'$D(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)) 100
    Q:'$D(^DHCDocCureRBCTimePeriodSet(TimeDesc)) 100
    ;判断是否有同时段的排班模板
    s ret=..CheckCureRBCResPlan(LocId,ResourceId,WeekNumber,TimeDesc,ServiceGroupID,Rowid)
    if (ret=1) Q 101
    s (TimeRangeFlag,TRLength,ReservedNum,TRRegNumStr,TRRegInfoStr)=""
    if TimeRangeInfo'=""{
		s TimeRangeFlag=$p(TimeRangeInfo,"^",1)   
		if TimeRangeFlag="Y"{
			s TRLength=$p(TimeRangeInfo,"^",2)   
			s ReservedNum=$p(TimeRangeInfo,"^",3)   
			s TRRegNumStr=$p(TimeRangeInfo,"^",4)   
			s TRRegInfoStr=$p(TimeRangeInfo,"^",5)  
		} 
	}
	K PLIST
	s PLIST(2)=LocId
	s PLIST(3)=ResourceId
	s PLIST(4)=WeekNumber
	s PLIST(5)=TimeDesc
	s PLIST(6)=StartTime
	s PLIST(7)=EndTime
	s PLIST(8)=ServiceGroupID
	s PLIST(9)=BookMaxNumber
	s PLIST(10)=AutoNumber
	s PLIST(11)=ChargeTime
	s PLIST(14)=GenerFlag
	s PLIST(15)=EndAppointTime
	s PLIST(16)=TimeRangeFlag
	s PLIST(17)=TRLength
	s PLIST(18)=ReservedNum
	s PLIST(19)=TRRegNumStr
	s PLIST(20)=TRRegInfoStr
	if Rowid="" 
	{
	 	&sql(insert into SQLUser.DHC_DocCureRBCResPlan values :PLIST())
	 	q SQLCODE
	}else{
		&sql(update SQLUser.DHC_DocCureRBCResPlan VALUES :PLIST() WHERE  DDCRP_RowID=:Rowid )
	    q SQLCODE
	}
}

/// 检查是否已经有排班
ClassMethod CheckCureRBCResPlan(LocRowID As %String, ResRowID As %String, WeekNumber As %String, TRRowId As %String, ServiceGroupID As %String = "", PlanID As %String = "")
{
	n (LocRowID,ResRowID,WeekNumber,TRRowId,ServiceGroupID,PlanID)
	s FindFlag=0
	s DDCRPRowID=""  for  s DDCRPRowID=$o(^DHCDocCureRBCResPlan(0,"Week-Resource",WeekNumber,LocRowID,ResRowID,DDCRPRowID))  q:(DDCRPRowID="")||(FindFlag=1)  d
	.Q:(PlanID'="")&&(PlanID=DDCRPRowID)
	.s TimeDescCode=$p(^DHCDocCureRBCResPlan(DDCRPRowID),"^",4)  //时间段代码
	.s ServiceGroup=$p(^DHCDocCureRBCResPlan(DDCRPRowID),"^",7)  //服务组ID
	.i (TRRowId=TimeDescCode)&&(ServiceGroup=ServiceGroupID)  s FindFlag=1
	q FindFlag
}

/// 函数： DeleteCureRBCResPlan
/// 功能： 删除资源计划
ClassMethod DeleteCureRBCResPlan(Rowid As %String)
{
    q:Rowid="" 100
    &sql(delete from SQLUser.DHC_DocCureRBCResPlan  where DDCRP_RowID=:Rowid)
    q SQLCODE
}

/// 函数：GetWeek
/// 功能：获取星期的描述
ClassMethod GetWeek(WeekNumber As %String) As %String
{
	 s Name="",Sequence=""
	 Set RowId1=0	f  s RowId1=$o(^CT("DOW",1,RowId1)) q:(RowId1="")!(WeekNumber=Sequence)  d
	.s Sequence=$p(^CT("DOW",1,RowId1),"^",2)
	.i WeekNumber=Sequence d
	..s Name=$p(^CT("DOW",1,RowId1),"^",1)
    q Name
}

/**
	*导入排班模板方法非治疗站业务，已移至DHCDoc.OPAdm.ScheduleTemp.cls
	*ValidateRBResSessData
	*ImportRBResSessData
*/
/// CTOR:   nk
/// DATE:   2020-10-30
/// DESC:   导入Excel
/// INPUT:  科室名称     CT_Loc表 CTLOC_Desc
/// 		医护人员工号 CT_CareProv表 CTPCP_Code
/// 		医护人员姓名 CT_CareProv表 CTPCP_Desc
/// 		星期         CT_DayOfWeek表 DOW_Day
/// 		时段名称     DHC_DocCureRBCTimePeriodSet表 DDCTS_Desc
/// 		服务组名称   DHC_DocCureRBCServiceGroupSet表 DDCSGS_Desc
/// 		最大预约数   有效数字
/// 		是否激活   	 Y/N
/// 		是否分时段   		Y/N
/// 		分时段间隔分钟数   	有效数字
/// 		分时段保留号数   	有效数字
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.RBCResPlan).ImportExcel("康复门诊^1708^王康^3^上午^心理^102",2)
ClassMethod ImportExcel(excelStr As %String, ExpStr As %String = "") As %String
{
	n (excelStr,ExpStr)
	
	s InPara=..CheckBeforeImport(excelStr,ExpStr)
    q:(+InPara<0) InPara
	s TimeRangeInfo=$p(InPara,$c(1),2)
	s InPara=$p(InPara,$c(1),1)
	s ret=..SaveCureRBCResPlan(InPara,TimeRangeInfo)
    
    q ret
}

ClassMethod CheckBeforeImport(value, ExpStr)
{
	s ImportHospName=""
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s ForLocID=$p(ExpStr,"^",2) //导入科室
	s:ImportHospId'="" ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	
	s LocDesc=$p(value,"^",1)
	s RESCode=$p(value,"^",2)
	s RESDesc=$p(value,"^",3)
	s WeekNum=$p(value,"^",4)
	s TRDesc=$p(value,"^",5)
	s ServiceGroupDesc=$p(value,"^",6)
	s BookMaxNumber=$p(value,"^",7)
	s GenerFlag=$p(value,"^",8)
	s TimeRangeFlag=$p(value,"^",9)
	s TRLength=$p(value,"^",10)
	s ReservedNum=$p(value,"^",11)
	
	if (LocDesc=""){
		Q "-1^科室为空!"
	}
	s LocRowID="",FindLocRowID=""
	for {
		s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),LocRowID)) Q:LocRowID=""
		s LosHospDr=$p(^CTLOC(LocRowID),"^",22)
		continue:(ImportHospId'="")&&(LosHospDr'=ImportHospId)
		s FindLocRowID=LocRowID
		Q
	}
	s LocRowID=FindLocRowID
	if (LocRowID=""){
		Q "-1^未找到对应的科室:"_LocDesc
	}
	if (ForLocID'="")&&(ForLocID'=LocRowID){
		Q "-1^"_LocDesc_",仅允许导入本科室模板"
	}
	
	if (RESCode="")||(RESDesc=""){
		Q "-1^医生工号或姓名为空"
	}
	s MarkRowID=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(RESCode),0))
	if (MarkRowID=""){
		Q "-1^找不到对应的号别:"_RESCode
	}
	s tmpCTPCPDesc=$p($g(^CTPCP(MarkRowID,1)),"^",2)
	Q:(tmpCTPCPDesc'=RESDesc) "-1^根据号别代码获取到的号别名称和传入的号别名称不匹配!"
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",MarkRowID,ImportHospId)="N" "-1^"_ImportHospName_"无此科室的号别:"_RESCode
	s ResRowID=$O(^RB("RES",0,"CTPCP",MarkRowID,LocRowID,0))
	if (ResRowID=""){
		Q "-1^找不到对应的资源"
	}
	if (WeekNum<1)||(WeekNum>7){
		Q "-1^无效的星期:"_WeekNum
	}
	s WeekDr=""
	&SQL(SELECT DOW_RowId into :WeekDr FROM SQLUser.CT_DayOfWeek WHERE DOW_Day=:WeekNum)
	if (SQLCODE'=0)||(WeekDr=""){
		q "-1^无效的周数:"_WeekNum
	}
	if (TRDesc=""){
		q "-1^时段为空"
	}
	s TimeRangeDr=0,FindTimeRangeDr=""
	for {
		s TimeRangeDr=$o(^DHCDocCureRBCTimePeriodSet(TimeRangeDr)) Q:(TimeRangeDr="")||(FindTimeRangeDr'="")
		s tmpTRDesc=$p(^DHCDocCureRBCTimePeriodSet(TimeRangeDr),"^",2)
		continue:(tmpTRDesc'=TRDesc)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCTimePeriodSet",TimeRangeDr,ImportHospId)="N"
		s FindTimeRangeDr=TimeRangeDr
	}
	s TimeRangeDr=FindTimeRangeDr
	if (TimeRangeDr="") {
		Q "-1^无效的时段:"_TRDesc
	}	
	
	s ServiceGroupDr=0,FindServiceGroupDr=""
	for {
		s ServiceGroupDr=$o(^DHCDocCureRBCServiceGroupSet(ServiceGroupDr)) Q:(ServiceGroupDr="")||(FindServiceGroupDr'="")
		s tmpServiceGroupDesc=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupDr),"^",2)
		continue:(tmpServiceGroupDesc'=ServiceGroupDesc)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCServiceGroupSet",ServiceGroupDr,ImportHospId)="N"
		s FindServiceGroupDr=ServiceGroupDr
	}
	s ServiceGroupDr=FindServiceGroupDr
	if (ServiceGroupDr="") {
		Q "-1^无效的服务组:"_ServiceGroupDesc
	}	
	
	if (BookMaxNumber="")!(+BookMaxNumber=0){
		Q "-1^最大预约数不是有效数字:"_BookMaxNumber
	}
	
	s Rowid="",AutoNumber=""
    s StartTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRangeDr),"^",3)
    s:StartTime'="" StartTime=$zt(StartTime,1)
    s EndTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRangeDr),"^",4)
    s:EndTime'="" EndTime=$zt(EndTime,1)
    s ChargeTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRangeDr),"^",5)
    s:ChargeTime'="" ChargeTime=$zt(ChargeTime,1)

	s TimeRangeInfo=""
	if TimeRangeFlag="Y"{
		if (TRLength="")!(+TRLength=0){
			Q "-1^分时段间隔分钟数不是有效数字:"_TRLength
		}
		if (ReservedNum'="")&&(+ReservedNum=0){
			Q "-1^分时段保留号数不是有效数字:"_ReservedNum
		}
		s TRInfo=##class(DHCDoc.DHCDocCure.RBCResSchdule).TRInfoCalculate(StartTime,EndTime,TRLength,BookMaxNumber,StartTime,EndTime)
		;"Y^60^6^1-7,8-14,15-20^14:00-15:00,15:00-16:00,16:00-17:00"
		d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(TRInfo,.TRInfoArr)
		s (TimeSeqNoStr,TimeRangeStr)=""
		s Code=$g(TRInfoArr("Code"))
		if Code=0{
			s id=0
			for{
				s id=$o(TRInfoArr("TRInfo",id))
				Q:id=""
				s oneSeqNoStr=$g(TRInfoArr("TRInfo",id,"SeqNoStr"))
				s oneTimeRangeStr=$g(TRInfoArr("TRInfo",id,"TimeRange"))
				if TimeSeqNoStr="" s TimeSeqNoStr=oneSeqNoStr
				else  s TimeSeqNoStr=TimeSeqNoStr_","_oneSeqNoStr
				if TimeRangeStr="" s TimeRangeStr=oneTimeRangeStr
				else  s TimeRangeStr=TimeRangeStr_","_oneTimeRangeStr
			}			
		}else{
			s ErrMsg=$g(TRInfoArr("ErrMsg"))
			Q "-1^"_ErrMsg
		}
		s TimeRangeInfo=TimeRangeFlag_"^"_TRLength_"^"_ReservedNum_"^"_TimeSeqNoStr_"^"_TimeRangeStr
	}

	s OutStr=Rowid_"^"_LocRowID_"^"_ResRowID_"^"_WeekDr_"^"_TimeRangeDr
	s OutStr=OutStr_"^"_ServiceGroupDr_"^"_StartTime_"^"_EndTime_"^"_BookMaxNumber_"^"_AutoNumber
	s OutStr=OutStr_"^"_ChargeTime_"^"_GenerFlag
	s OutStr=OutStr_$c(1)_TimeRangeInfo
	Q OutStr
}

/// CTOR:   nk
/// DATE:   2020-10-30
/// DESC:   导入Excel
/// INPUT:  科室名称     CT_Loc表 CTLOC_Desc
/// 		医护人员工号 CT_CareProv表 CTPCP_Code
/// 		医护人员姓名 CT_CareProv表 CTPCP_Desc
/// 		星期         CT_DayOfWeek表 DOW_Day
/// 		时段名称     DHC_DocCureRBCTimePeriodSet表 DDCTS_Desc
/// 		服务组名称   DHC_DocCureRBCServiceGroupSet表 DDCSGS_Desc
/// 		最大预约数   有效数字
/// 		是否激活   	 Y/N
/// 		是否分时段   		Y/N
/// 		分时段间隔分钟数   	有效数字
/// 		分时段保留号数   	有效数字
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCDoc.DHCDocCure.RBCResPlan).ImportExcel("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportTotalExcel(ByRef excelStrArr, ExpStr As %String = "") As %String
{
	m ^tmpnk("excelStrArr")=excelStrArr
	s mRtn=0
	s count=0
	Ts
	s loop=0
	for{
		s loop=$o(excelStrArr(loop))
		q:loop=""
		s excelStr=excelStrArr(loop)
		s totalLen=$l(excelStr,"!")
		
		f tloop=1:1:totalLen {
			s cInput = $p(excelStr,"!",tloop)
			s rtn=..ImportExcel(cInput,ExpStr)
			s count=count+1
			;s ^tmpnk("count",count)=$lb(cInput,rtn)
			i rtn'=0{
				s mRtn=rtn
				if mRtn=101{
					s mRtn="第"_(count+1)_"行数据:"_cInput_",已经存在同时段的模板,不能重复添加"
				}else{
					s mRtn="第"_(count+1)_"行数据:"_cInput_","_rtn
				}
			}
			q:rtn'=0 
		}
	}
	if mRtn=0{
		Tc
	}else{
		Tro	
	}
	
    q mRtn
}

Query FindScheduleTemp(LocRowid, UserRowid, ResourceId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "LocDesc:%String:科室,ResDesc:%String:医生,TimeRange:%String:时段,Week1:%String:星期一,Week2:%String:星期二,Week3:%String:星期三,Week4:%String:星期四,Week5:%String:星期五,Week6:%String:星期六,Week7:%String:星期天,RowId:%String:HIDDEN,LocRowid:%String:HIDDEN,DocRowid:%String:HIDDEN,TimeRangeDr:%String:HIDDEN,ServiceGroup:%String:服务组,ServiceGroupID:%String:服务组ID") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCResPlan","FindScheduleTemp","90","1","306","","","2")
ClassMethod FindScheduleTempExecute(ByRef qHandle As %Binary, LocRowid = "", UserRowid = "", ResourceId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Status
{
	s ^tmpnk("FindScheduleTemp")=$lb(LocRowid, UserRowid, ResourceId,ILocDesc,IDocDesc,HospId)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s ILocDesc=$ZCVT(ILocDesc,"U")
	s:UserRowid="" UserRowid=%session.Data("LOGON.USERID")
	i LocRowid=""{
		Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryCureLoc")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(HospId)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s LocRowid=rset.Data("LocId")
				i LocRowid="" continue
				d OneLoc
			}
		}
	}else{
		if ResourceId'=""{
			s RowId=0	
			for{
				s RowId=$o(^DHCDocCureRBCResPlan(0,"LRS",LocRowid,ResourceId,RowId)) q:RowId=""
				s mLocID=$p(^DHCDocCureRBCResPlan(RowId),"^",1)
				s ResSourceId=$p(^DHCDocCureRBCResPlan(RowId),"^",2)
				s LocDesc=$P(^CTLOC(mLocID),"^",2)
				s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
				d OneDateSess
			}
		}else{
			d OneLoc
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneLoc
	s mLocID=$TR(LocRowid," ")
	s LocHospId=$P(^CTLOC(mLocID),"^",22)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",mLocID,HospId)
	s LocDesc=$P(^CTLOC(mLocID),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	q:(ILocDesc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(mLocID,ILocDesc))
	s ResSourceId=0	f  s ResSourceId=$o(^DHCDocCureRBCResPlan(0,"LRS",mLocID,ResSourceId)) q:ResSourceId=""  d
	.d OneDateSess
	Q
OneDateSess
	k DOWList
	s (TimeDesc,ServiceGroup,ResourceDesc)=""
	s CareProvId=$p($g(^RB("RES",ResSourceId)),"^",2)
	i CareProvId'="" s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CarePrv",CareProvId,HospId)
	q:ResourceDesc=""
	q:((IDocDesc'="")&&(ResourceDesc'[IDocDesc))
	
	s RowId=""
	for{
		s RowId=$o(^DHCDocCureRBCResPlan(0,"LRS",mLocID,ResSourceId,RowId)) q:RowId=""
		s WeekNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",3)
		s Week=..GetWeek(WeekNumber)
		s DOW=$P(^CT("DOW",1,WeekNumber),"^",2)
		s TimeRangeDR=$p(^DHCDocCureRBCResPlan(RowId),"^",4)  //时间段代码
		continue:TimeRangeDR=""
		i TimeRangeDR'=""{
			s TimeDesc=$p($g(^DHCDocCureRBCTimePeriodSet(TimeRangeDR)),"^",2)
		}
		s ServiceGroupDR=$p(^DHCDocCureRBCResPlan(RowId),"^",7)
		s HasConfigFlag=..CheckHasConfigFlag(ServiceGroupDR,TimeRangeDR,HospId)
		continue:HasConfigFlag'="Y"
		s MaxNumber=$p(^DHCDocCureRBCResPlan(RowId),"^",8)
	    s AvtiveFlag=$p(^DHCDocCureRBCResPlan(RowId),"^",13)
	    s Load=MaxNumber_"^"_AvtiveFlag
	    s DOWList(ServiceGroupDR,TimeRangeDR,DOW)=Load_"^"_RowId
	}
	Q:'$D(DOWList)
	s LocResRowId=mLocID_"||"_ResSourceId
	s ServiceGroupDR=0
	for{
		s ServiceGroupDR=$O(DOWList(ServiceGroupDR)) q:ServiceGroupDR=""
		s ServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR),"^",2)
		s SessNo=0
		for{
			s SessNo=$O(DOWList(ServiceGroupDR,SessNo)) q:SessNo=""
			s TimeRange=$P(^DHCDocCureRBCTimePeriodSet(SessNo),"^",2)
			s TimeRangeDr=SessNo
			s Data=$lb(LocDesc,ResourceDesc,TimeRange)
			s ServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR),"^",2)
			for DOW=1:1:7{
				s DOWListVal=$G(DOWList(ServiceGroupDR,SessNo,DOW))
				s Data=Data_$LB(DOWListVal)
			}
			s RowId=LocResRowId_"^"_SessNo_"^"_ServiceGroupDR
			s Data=Data_$LB(RowId,mLocID,ResSourceId,TimeRangeDr,ServiceGroup,ServiceGroupDR)
			d OutputRow
		}
	}
	Q
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
    quit
}

ClassMethod FindScheduleTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScheduleTempExecute ]
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

ClassMethod FindScheduleTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScheduleTempFetch ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSessData(ResPlanId)
{
	Q:'$d(^DHCDocCureRBCResPlan(ResPlanId)) ""
	
	s (TimeDesc,ServiceGroup)=""
	s LocId=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",1)
	s LocDesc=$p(^CTLOC(LocId),"^",2)
 	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	s ResSourceDR=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",2)
	i ResSourceDR'="" d
	.s CareProvId=$p($g(^RB("RES",ResSourceDR)),"^",2)
	.i CareProvId'="" s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	s WeekNumber=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",3)
	s Week=..GetWeek(WeekNumber)
	s TimeRangeDR=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",4)  //时间段代码
	i TimeRangeDR'="" d
	.s TimeDesc=$p($g(^DHCDocCureRBCTimePeriodSet(TimeRangeDR)),"^",2)
	s StartTime=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",5)
	s StartTime=$zt(StartTime)
	s EndTime=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",6)
	s EndTime=$zt(EndTime)
	s ServiceGroupID=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",7)
	i ServiceGroupID'="" d
	.s ServiceGroup=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)),"^",2)
	s MaxNumber=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",8)
    s AutoNumber=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",9)
    s ChargeTime=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",10)
    i ChargeTime'="" s ChargeTime=$zt(ChargeTime)
    s AvailPatType=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",11)
    s AutoAvtiveFlag=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",12)
    s AvtiveFlag=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",13)
    s EndAppointTime=$p(^DHCDocCureRBCResPlan(ResPlanId),"^",14)
    i EndAppointTime'=""{
	    s EndAppointTime=$zt(EndAppointTime)
    }else{
	    ;s EndAppointTime=$p($g(^DHCDocCureRBCTimePeriodSet(+$g(TimeRangeDR))),"^",7)
	    ;s:EndAppointTime'="" EndAppointTime=$zt(EndAppointTime)
	}
	s TimeRangeInfo=$g(^DHCDocCureRBCResPlan(ResPlanId,"TR"))
	s TimeRangeFlag=$p(TimeRangeInfo,"^",1)
	s TRLength=$p(TimeRangeInfo,"^",2)
	s TRReservedNum=$p(TimeRangeInfo,"^",3)
	s TRRegNumStr=$p(TimeRangeInfo,"^",4)
	s TRRegInfoStr=$p(TimeRangeInfo,"^",5)
    
    s ret=LocId_"^"_LocDesc_"^"_ResSourceDR_"^"_ResourceDesc_"^"_WeekNumber
    s ret=ret_"^"_Week_"^"_TimeRangeDR_"^"_TimeDesc_"^"_StartTime_"^"_EndTime
    s ret=ret_"^"_ServiceGroupID_"^"_ServiceGroup_"^"_MaxNumber_"^"_AutoNumber_"^"_ChargeTime
    s ret=ret_"^"_AvailPatType_"^"_AutoAvtiveFlag_"^"_AvtiveFlag_"^"_EndAppointTime_"^"_TimeRangeFlag
    s ret=ret_"^"_TRLength_"^"_TRReservedNum_"^"_TRRegNumStr_"^"_TRRegInfoStr
    Q ret
}

ClassMethod ActiveSess(LocResRowid, DOW, TimeRange, ServiceGroup, HospID = "")
{
	s ResPlanRowid=..GetResDataWeeks(LocResRowid,DOW,TimeRange,ServiceGroup,HospID)
	Q:ResPlanRowid="" -1
	s GenerFlag=$p(^DHCDocCureRBCResPlan(ResPlanRowid),"^",13)
	i GenerFlag="Y" s GenerFlag="N"
	e  s GenerFlag="Y"
	&SQL(UPDATE SQLUser.DHC_DocCureRBCResPlan SET DDCRP_AvtiveFlag=:GenerFlag WHERE DDCRP_RowID=:ResPlanRowid)
	Q SQLCODE
}

ClassMethod GetResDataWeeks(LocResRowid, DOWNo = "", TimeRange = "", ServiceGroup = "", HospID = "")
{
	s LocID=+LocResRowid
	s ResSourceId=$P(LocResRowid,"||",2)
	Q:ResSourceId="" ""
	k DOWList		
	s ret=""
	s RowId=0
	for{
		s RowId=$O(^DHCDocCureRBCResPlan(0,"LRS",LocID,ResSourceId,RowId)) q:RowId=""
		s DOWDR=$p(^DHCDocCureRBCResPlan(RowId),"^",3)
		continue:DOWDR=""
		s DOWSeq=$P(^CT("DOW",1,DOWDR),"^",2)
		s SessNo=$p(^DHCDocCureRBCResPlan(RowId),"^",4)
		s ServiceGroupID=$p(^DHCDocCureRBCResPlan(RowId),"^",7)
		s HasConfigFlag=..CheckHasConfigFlag(ServiceGroupID,SessNo,HospID)
		continue:HasConfigFlag'="Y"
		s DOWList(DOWSeq)=$P($G(^CT("DOW",1,+DOWDR)),"^",1)
		s DOWList(DOWSeq,ServiceGroupID,SessNo)=RowId
	}
	Q:(DOWNo'="")&&(TimeRange'="")&&(ServiceGroup'="") $G(DOWList(DOWNo,ServiceGroup,TimeRange))
	s DOWSeq=""
	f  s DOWSeq=$O(DOWList(DOWSeq)) q:DOWSeq=""  d
	.s ServiceGroupID="",oneServiceGroup=""
	.f  s ServiceGroupID=$O(DOWList(DOWSeq,ServiceGroupID)) q:ServiceGroupID=""  d
	..s ServiceGroup=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupID)),"^",2)
	..s SessNo="",oneday=""
	..f  s SessNo=$O(DOWList(DOWSeq,ServiceGroupID,SessNo)) q:SessNo=""  d
	...s TimeRange=$P($G(^DHCDocCureRBCTimePeriodSet(+SessNo)),"^",2)
	...s PlanRowId=DOWList(DOWSeq,ServiceGroupID,SessNo)
	...i oneday="" s oneday=TimeRange_$c(1)_PlanRowId
	...e  s oneday=oneday_$c(2)_TimeRange_$c(1)_PlanRowId
	..q:oneday=""
	..if oneServiceGroup="" s oneServiceGroup=ServiceGroup_"@"_oneday
	..e  s oneServiceGroup=oneServiceGroup_"#"_ServiceGroup_"@"_oneday
	.q:oneServiceGroup=""
	.s DOW=DOWList(DOWSeq)
	.i ret="" s ret=DOW_":"_oneServiceGroup
	.e  s ret=ret_"^"_DOW_":"_oneServiceGroup
	Q ret
}

ClassMethod GenCreateResApptSchulde(StartDate As %String, EndDate As %String, SchStr As %String, UserID As %String, HospDr As %String, ForLocID As %String = "") As %String
{
	n (StartDate,EndDate,UserID,SchStr,HospDr,%session,ForLocID)
	;s $ztrap="GenCreateResApptSchuldeErr"
	s ^TMP("GenCreateResApptSchulde")=$lb(StartDate,EndDate,SchStr,UserID,HospDr)
	s ResourceId=""
	k CreateScheLocArr
	if SchStr'=""{
		Set SchStrLen=$l(SchStr,"^")
		for i=1:1:SchStrLen{
			Set SchLoc=$p($p(SchStr,"^",i),"|",1)
			Set SchDoc=$p($p(SchStr,"^",i),"|",2)
			if (SchLoc'=""){
				if $g(CreateScheLocArr(SchLoc))="" Set CreateScheLocArr(SchLoc)=SchDoc
				else  Set CreateScheLocArr(SchLoc)=CreateScheLocArr(SchLoc)_"@"_SchDoc
			}
		}
	}else{
		s rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryCureLoc")
		s ret=""
		do rset.Execute(HospDr)
		while (rset.Next())
		{
			s LocId=rset.GetDataByName("LocId")
			continue:(ForLocID'="")&&(ForLocID'=LocId)
			s CreateScheLocArr(LocId)=""
		}	
		d rset.Close()
	}
	
	if $d(CreateScheLocArr){
		s LocId=""
		for{
			s LocId=$o(CreateScheLocArr(LocId))	
			Q:LocId=""
			s ResourceIdStr=$g(CreateScheLocArr(LocId))
			s createStr=LocId_"^"_StartDate_"^"_EndDate_"^"_ResourceIdStr
			s ret=##class(DHCDoc.DHCDocCure.RBCResSchdule).CreateResApptSchulde(createStr,UserID)
		}	
	}
	q ret
}

ClassMethod CheckHasConfigFlag(SGRowID, TRRowID, HospID As %String = "")
{
	n (SGRowID,TRRowID,HospID,%session)
	s:HospID="" HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HasConfigFlag="Y"
	if SGRowID'="" d
	.if '$d(^User.DHCDocCureTimeLinkGroupI("TLGServiceGroupIndex",SGRowID)) d
	..s HasConfigFlag="Y"
	.else  d
	..s HasConfigFlag=##class(DHCDoc.DHCDocCure.RBCTimePeriodSet).CheckHasConfigFlag(TRRowID,SGRowID,HospID)
	Q HasConfigFlag
}

}
