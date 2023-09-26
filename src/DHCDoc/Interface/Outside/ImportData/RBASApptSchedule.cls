Class DHCDoc.Interface.Outside.ImportData.RBASApptSchedule Extends DHCDoc.Util.RegisteredObject
{

/// 导入排版
/// w ##Class(DHCDoc.Interface.Outside.ImportData.RBASApptSchedule).ImportRBApptScheduleData("28^泌尿外科门诊^4811^孔松^2021-01-11^上午^知名专家^^^99^^^^N^8:30^11:30^^^",2)
ClassMethod ImportRBApptScheduleData(SessData As %String, ExpStr As %String)
{
	s ^tempqujian("ImportRBApptScheduleData")=SessData_","_ExpStr
	s GroupID=$P(ExpStr,"^",2) //导入安全组
	s OutPutStr=..ValidateRBApptScheduleData(SessData,ExpStr)
	q:(+OutPutStr<0) OutPutStr
	s ResRowID=$P(OutPutStr,"^",3)
	s ScheduleDate=$P(OutPutStr,"^",4)
	s TimeRangeDr=$P(OutPutStr,"^",5)
	s SessionTypeDr=$P(OutPutStr,"^",6)
	s CLGRPDr=$P(OutPutStr,"^",7)
	s RoomDr=$P(OutPutStr,"^",8)
	s SessLoad=$P(OutPutStr,"^",9)
	s SessNoApptSlot=$P(OutPutStr,"^",10)
	s SessNoSlots=$P(OutPutStr,"^",11)
	s AddtionMax=$P(OutPutStr,"^",12)
	s SessNumberOfWeeks=$P(OutPutStr,"^",13)
	s TRFlag=$P(OutPutStr,"^",14)
	s TRStartTime=$P(OutPutStr,"^",15)
	s TREndTime=$P(OutPutStr,"^",16)
	s TRLength=$P(OutPutStr,"^",17)
	s TRRegNum=$P(OutPutStr,"^",18)
	s AMObjStr=$P(OutPutStr,"^",19)
	s TRInfoObjStr=$P(OutPutStr,"^",20)
	
	s LocId=$P(^RB("RES",ResRowID),"^",1)
	s DocId=$P(^RB("RES",ResRowID),"^",2)
	s TStartTime=$P(^DHCTimeRange(TimeRangeDr),"^",3)
	s TEndTime=$P(^DHCTimeRange(TimeRangeDr),"^",4)
	s:TStartTime'="" TStartTime=..%ZT(TStartTime,1)
	s:TEndTime'="" TEndTime=..%ZT(TEndTime,1)
	s ASRowidrtn=##class(web.DHCRBApptSchedule).InsertOneSchedule(ScheduleDate,DocId, LocId,TimeRangeDr, SessLoad, SessNoApptSlot, AddtionMax,RoomDr, SessionTypeDr, CLGRPDr, SessNumberOfWeeks, TStartTime, TEndTime,  "N",  "",  "",  "",  GroupID)
	s ret=$P(ASRowidrtn,"^",1)
	If ret'=0 {
		if (ret="-201") s Msg="同一个医生不能在同一天同一时段安排两次！"
		else  if (ret="-202") s Msg="此诊室已经在同一天同一时段被安排过！"
		else  if (ret="300") s Msg="医生没有安排资源!"
		else  if (ret="200") s Msg="当前医生已经有排班记录!"
		else  s Msg="插入排班记录失败！"
		Quit "-1^"_Msg
	}
	s ASRowid=$P(ASRowidrtn,"^",2)
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateAppMethodQtyNew(ASRowid,AMObjStr,"")
	If ret'=0 {
		Quit "-1^更新排班预约方式限额失败！"
	}
	s ret=##class(DHCDoc.OPAdm.Schedule).UpdateTRInfoNew(ASRowid,TRInfoObjStr)
	If ret'=0 {
		Quit "-1^更新排班分时段信息失败！"
	}
	Q "0^"_ASRowid
}

ClassMethod ValidateRBApptScheduleData(SessData As %String, ExpStr As %String)
{
	s ^Tempqujian("ValidateRBResSessData")=SessData_","_ExpStr
	q:(SessData="") "-1^无效数据"
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	s RSLDesc=$P(SessData,"^",1)	//班次（为空）
	s LocDesc=$P(SessData,"^",2)	//科室名称
	s RESCode=$P(SessData,"^",3)	//号别代码
	s RESDesc=$P(SessData,"^",4)	//号别名称
	s ScheduleDate=$P(SessData,"^",5)	//出诊日期
	s TRDesc=$P(SessData,"^",6)		//时段
	s SessionTypeDesc=$P(SessData,"^",7)	//挂号职称
	s CLGRPDesc=$P(SessData,"^",8)	//亚专业
	s RoomDesc=$P(SessData,"^",9)	//诊室
	s SessLoad=$P(SessData,"^",10)	//正号限额
	s SessNoApptSlot=$P(SessData,"^",11)	//预约限额
	s AddtionMax=$P(SessData,"^",12)	//加号限额
	s SessNoSlots=SessLoad-SessNoApptSlot
	s SessNumberOfWeeks=$P(SessData,"^",13)	//预约起始号
	s TRFlag=$P(SessData,"^",14)	//分时段就诊
	s TRStartTime=$P(SessData,"^",15)	//开始时间
	s TREndTime=$P(SessData,"^",16)	//结束时间
	s TRLength=$P(SessData,"^",17)	//间隔分钟
	s TTrtemName=$P(SessData,"^",18)	//分时段模板
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	if (LocDesc=""){
		Q "-1^科室为空!"
	}
	s LocRowID="",FindLocRowID=""
	for {
		s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),LocRowID)) Q:LocRowID=""
		s LosHospDr=$p(^CTLOC(LocRowID),"^",22)
		continue:LosHospDr'=ImportHospId
		s FindLocRowID=LocRowID
		Q
	}
	s LocRowID=FindLocRowID
	//s LocRowID=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
	if (LocRowID=""){
		Q "-1^未找到对应的科室"
	}
	if (RESCode="")||(RESDesc=""){
		Q "-1^号别为空"
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
	if (ScheduleDate=""){
		q "-1^出诊日期不能为空"
	}
	s ScheduleDate=..%ZDH(ScheduleDate)
	if (ScheduleDate=""){
		q "-1^出诊日期符合逻辑"
	}
	if (TRDesc=""){
		q "-1^时段为空"
	}
	s TimeRangeDr=0,FindTimeRangeDr=""
	for {
		s TimeRangeDr=$o(^DHCTimeRange(TimeRangeDr)) Q:(TimeRangeDr="")||(FindTimeRangeDr'="")
		s tmpTRDesc=$p(^DHCTimeRange(TimeRangeDr),"^",2)
		continue:(tmpTRDesc'=TRDesc)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TimeRangeDr,ImportHospId)="N"
		s FindTimeRangeDr=TimeRangeDr
	}
	s TimeRangeDr=FindTimeRangeDr
	if (TimeRangeDr="") {
		Q "-1^无效的时段:"_TRDesc
	}
	/*&SQL(SELECT TR_RowId into :TimeRangeDr FROM SQLUser.DHC_TimeRange WHERE TR_Desc=:TRDesc)
	if (SQLCODE'=0)||(TimeRangeDr=""){
		q "-1^无效的时段:"_TRDesc
	}*/
	if (SessionTypeDesc=""){
		q "-1^职称为空"
	}
	s SessionTypeDr=0,FindSessionTypeDr=""
	for {
		s SessionTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessionTypeDesc),SessionTypeDr)) Q:(SessionTypeDr="")||(FindSessionTypeDr'="")
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_SessionType",SessionTypeDr,ImportHospId)="N"
		s FindSessionTypeDr=SessionTypeDr
	}
	s SessionTypeDr=FindSessionTypeDr
	//s SessionTypeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessionTypeDesc),0))
	if (SessionTypeDr=""){
		q "-1^无效的职称"_SessionTypeDesc
	}
	s CLGRPDr=0,FindCLGRPDr=""
	if (CLGRPDesc'=""){
		for iG=1:1:$L(CLGRPDesc,",") {
			s OneCLGRPDesc=$P(CLGRPDesc,",",iG)
			for {
				s CLGRPDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(OneCLGRPDesc),CLGRPDr)) Q:(CLGRPDr="")||(FindCLGRPDr'="")
				continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",CLGRPDr,ImportHospId)="N"
				s FindCLGRPDr=CLGRPDr
				if (FindCLGRPDr=""){s FindCLGRPDr=CLGRPDr}else{s FindCLGRPDr=FindCLGRPDr_","_CLGRPDr}
			}
		}
		if (FindCLGRPDr="") {
			Q "-1^无效的亚专业"_CLGRPDesc
		}
	}
	s CLGRPDr=FindCLGRPDr
	s RoomDr=0,FindRoomDr=""
	if (RoomDesc'=""){
		for {
			s RoomDr=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RoomDesc),RoomDr)) Q:(RoomDr="")||(FindRoomDr'="")
			s RoomHospDr=$p(^CTLOC(RoomDr),"^",22)
			continue:RoomHospDr'=ImportHospId
			s FindRoomDr=RoomDr
		}
		if (FindRoomDr=""){
			q "-1^无效的诊室"_RoomDesc
		}
	}
	s RoomDr=FindRoomDr
	
	if (+SessLoad=0){
		q "-1^正号限额不能为空"
	}
	if (+SessNoApptSlot'=0)&&(+SessNumberOfWeeks=0){
		q "-1^预约限额不为空时,预约起始号不能为空"
	}
	if (SessLoad<SessNoApptSlot){
		q "-1^正号限额不能小于预约限额"
	}
	if (+SessNoApptSlot'=0){
		if (SessLoad-SessNumberOfWeeks+1)<SessNoApptSlot{
			q "-1^正号限额减去预约起始号要大于等于预约限额！"
		}
	}
	if (SessLoad>999){
		q "-1^正号限额不能超过999！"
	}
	s AMObjStr=""
	s TRInfoObjStr=[].%ToJSON()
	s AMObjStr=..GetTempAppMethod(AppMethodStr)
	if (TRFlag="Y"){
		s TRInfoObjStr=..GetTRInfo(TRStartTime,TREndTime,TTrtemName,TRLength,TimeRangeDr,SessLoad)
		if (TRInfoObjStr["-1^"){
			q TRInfoObjStr
		}
	}
	s OutPutStr="0^"_"^"_ResRowID_"^"_ScheduleDate_"^"_TimeRangeDr
	s OutPutStr=OutPutStr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_RoomDr_"^"_SessLoad_"^"_SessNoApptSlot
	s OutPutStr=OutPutStr_"^"_SessNoSlots_"^"_AddtionMax_"^"_SessNumberOfWeeks_"^"_TRFlag_"^"_TRStartTime
	s OutPutStr=OutPutStr_"^"_TREndTime_"^"_TRLength_"^"_""_"^"_AMObjStr_"^"_TRInfoObjStr
	q OutPutStr
}

ClassMethod GetTempAppMethod(AppMethodStr)
{
	s RetObj=[]
	for i=1:1:$L(AppMethodStr,"&") {
		s OneAppMethod=$P(AppMethodStr,"&",i)
		if (OneAppMethod=""){
			continue
		}
		s ApptMethod=$P(OneAppMethod,"|",1)
		s MaxQty=$P(OneAppMethod,"|",2)
		s ReserveQty=$P(OneAppMethod,"|",3)
		s ApptMethodDr=$O(^RBC("APTM",0,"Desc",ApptMethod,0))
		s obj={}
		s obj.AppMethodID=ApptMethodDr
		s obj.AppMethod=ApptMethod
		s obj.MaxQty=MaxQty
		s obj.ReserveQty=ReserveQty
		d RetObj.%Push(obj)
	}
	Q RetObj.%ToJSON()
}

/// w ##class(DHCDoc.Interface.Outside.ImportData.RBASTemplate).GetTRInfo("08:00","12:00",cc,"30",2)
ClassMethod GetTRInfo(TRStartTime, TREndTime, TTrtemName, TRLength, TimeRangeDr, APPLoad)
{
	s AMArr=[]
	s InusID=""
	if (TTrtemName'=""){
		s ID=0
		for {
			s ID=$o(^User.DHCTRInfoTempD(ID)) Q:ID=""
			s Name=$lg(^User.DHCTRInfoTempD(ID),8)
			continue:Name'=TTrtemName
			s TimeRangeDR=$lg(^User.DHCTRInfoTempD(ID),3)
			continue:(TimeRangeDr'=TimeRangeDR)
			s Data=$lg(^User.DHCTRInfoTempD(ID),9)
			s Load=0
			if (Data'="") {
				k TimeTangeCongeriesArr
				d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(Data,.TimeTangeCongeriesArr)
				s TimeRangeId=0
				for {
					s TimeRangeId=$o(TimeTangeCongeriesArr(TimeRangeId)) Q:TimeRangeId=""
					s Load=Load+$g(TimeTangeCongeriesArr(TimeRangeId,"Load"))
				}
			}
			continue:Load'=APPLoad
			s InusID=ID
		}
	}
	s RegNum=APPLoad
	if InusID'="" q $lg(^User.DHCTRInfoTempD(InusID),9)
	if (InusID="")&&(TTrtemName'="") q "-1^"_TTrtemName_"模板维护不正确！"
	Q:(TRStartTime="") "-1^分时段就诊为Y时,分时段开始时间不能为空！"
	Q:(TREndTime="") "-1^分时段就诊为Y时,分时段结束时间不能为空！"
	Q:(TRLength="") "-1^分时段就诊为Y时,分时段间隔分钟不能为空！"
	s StartDate=..%ZTH(TRStartTime,3)
	s EndDate=..%ZTH(TREndTime,3)
	s TimeLength=TRLength*60
	s TimeInterval=EndDate-StartDate
	q:TimeInterval<=0 "-1^分时段开始时间不小于结束时间"
	s mod=TimeInterval#TimeLength
	q:mod>0 "-1^分时段时间间隔数不是整数"
	s Step=TimeInterval/TimeLength
	q:Step>RegNum "-1^分时段时间间隔数不能大于分时段号数"
	s mod=RegNum#Step
	s OneStepNum=RegNum\Step
	s RegNumInfo="",TimeRangeInfo=""
	s One=1
	s OneNum=0	
	s AMArr=[]	
	f i=1:1:Step
	{
		s TRObj={}
		i i<=mod{
			s OneNum=OneNum+OneStepNum+1
		}else{
			s OneNum=OneNum+OneStepNum
		}
		s time=StartDate+((i-1)*TimeLength)
		s time2=StartDate+((i)*TimeLength)
		s TRObj.SttTime=##class(websys.Conversions).TimeLogicalToHtml(time)
		s TRObj.EndTime=##class(websys.Conversions).TimeLogicalToHtml(time2)
		s TRObj.Load=OneNum-One+1
		s TRObj.tabTRAppMethodInfo=[]
		s One=1+OneNum
		d AMArr.%Push(TRObj)
	}
	Q AMArr.%ToJSON()
}

}
