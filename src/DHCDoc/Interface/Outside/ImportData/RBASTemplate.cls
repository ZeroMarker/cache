Class DHCDoc.Interface.Outside.ImportData.RBASTemplate Extends DHCDoc.Util.RegisteredObject
{

/// 导入排版模板
/// w ##Class(DHCDoc.DHCDocCure.RBCResPlan).ImportRBResSessData()
ClassMethod ImportRBResSessData(SessData As %String, ExpStr As %String)
{
	s ^tempqujian("ImportRBResSessData")=SessData_","_ExpStr
	s OutPutStr=..ValidateRBResSessData(SessData,ExpStr)
	q:(+OutPutStr<0) OutPutStr
	s AppMethodStr=$P(SessData,"^",19)	//预约方式信息（方式|限额|起始号）
	s RSLRowID=$P(OutPutStr,"^",2)
	s ResRowID=$P(OutPutStr,"^",3)
	s WeekDr=$P(OutPutStr,"^",4)
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
	s DOW=WeekDr_$C(1)_$P(^CT("DOW",1,WeekDr),"^",1)
	s TStartTime=$P(^DHCTimeRange(TimeRangeDr),"^",3)
	s TEndTime=$P(^DHCTimeRange(TimeRangeDr),"^",4)
	s:TStartTime'="" TStartTime=..%ZT(TStartTime,1)
	s:TEndTime'="" TEndTime=..%ZT(TEndTime,1)
	
	s SessPatientType="O"
	s AutoLoad=""
	s ExtLoad=""
	s InsertData=""_"^"_DOW_"^"_TStartTime_"^"_TEndTime_"^^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot
	s InsertData=InsertData_"^"_SessNumberOfWeeks_"^"_AddtionMax_"^"_RoomDr_"^"_SessionTypeDr_"^"_CLGRPDr_"^"_SessPatientType_"^"_TimeRangeDr_"^"_"Y"
	s InsertData=InsertData_"^"_TRFlag_"^"_TRStartTime_"^"_TREndTime_"^"_TRLength_"^"_TRRegNum_"^"_""_"^"_""_"^"_AutoLoad_"^"_ExtLoad
	
	TS
	if (CLGRPDr'=""){
		s LocSpecCount=0
		&sql(select count(DHCLS_Loc_DR) into :LocSpecCount from SQLUSER.DHC_LocSpec where DHCLS_Loc_DR=:LocId and DHCLS_CG_DR=:CLGRPDr)
		if (SQLCODE=0)&&(LocSpecCount=0)
		{
			//自动插入科室及专业组对照
			d ##Class(web.DHCLocSpec).InsertLocSpec(LocId,CLGRPDr)
		}
	}
	b ;09333
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).GetDocDateRowid(LocId, DocId, RSLRowID)
	b ;ccddd
	if (+ret'=0){
		TRO
		q ret_"^插入班次失败"
	}
	b ;zzd
	s ResEffDate=$P(ret,"^",2)
	s ret=##Class(web.DHCRBResSession).Insert(ResEffDate,InsertData)
	if (+ret'=0){
		TRO
		q ret_"^插入排版模板失败"
	}
	b ;zddsd
	s SessRowId=$P(ret,"^",2)
	s RetSessRowId=$P(ret,"^",2)
	if (AMObjStr'=""){
		s ret=##Class(DHCDoc.OPAdm.ScheduleTemp).SaveTempAppMethodNew(SessRowId, AMObjStr) 
		//s ret=##Class(web.DHCRBResEffDateSessAppQty).SaveScheduleAppQty(paraString)
		if (+ret'=0){
			TRO
			q ret_"^插入预约方式限额失败"
		}
	}
	if (TRInfoObjStr'=""){
		s ret=##Class(DHCDoc.OPAdm.ScheduleTemp).SaveTempTRNew(SessRowId, TRInfoObjStr) 
		if (+ret'=0){
			TRO
			q ret_"^插入分时限额失败"
		}
	}
	
	TC
	q 0_"^"_RetSessRowId
}

/// w ##Class(DHCDoc.DHCDocCure.RBCResPlan).ValidateRBResSessData()
ClassMethod ValidateRBResSessData(SessData As %String, ExpStr As %String) As %String
{
	s ^Tempqujian("ValidateRBResSessData")=SessData_","_ExpStr
	q:(SessData="") "-1^无效数据"
	s ImportHospId=$p(ExpStr,"^",1) //导入院区
	s ImportHospName=$p(^CT("HOSP",ImportHospId),"^",2)
	s RSLDesc=$P(SessData,"^",1)	//班次
	s LocDesc=$P(SessData,"^",2)	//科室名称
	s RESCode=$P(SessData,"^",3)	//号别代码
	s RESDesc=$P(SessData,"^",4)	//号别名称
	s WeekNum=$P(SessData,"^",5)	//出诊时间(星期)
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
	
	if (RSLDesc=""){
		Q "-1^班次为空!"
	}
	s RSLRowID=0,FindRSLRowID=""
	for {
		s RSLRowID=$o(^RB("RSL",RSLRowID)) Q:(RSLRowID="")||(FindRSLRowID'="")
		s tmpRSLDesc=$p(^RB("RSL",RSLRowID),"^",2)
		continue:(tmpRSLDesc'=RSLDesc)
		s RSLStartDate=$p(^RB("RSL",RSLRowID),"^",3)
		continue:(RSLStartDate'="")&&(RSLStartDate>+$h)
		s RSLEndDate=$p(^RB("RSL",RSLRowID),"^",4)
		continue:(RSLEndDate'="")&&(RSLEndDate<=..%SysDate())
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_ResScheduleLines",RSLRowID,ImportHospId)="N"
		s FindRSLRowID=RSLRowID
	}
	/*&SQL(SELECT RSL_RowId into :RSLRowID FROM SQLUser.RB_ResScheduleLines WHERE RSL_Desc=:RSLDesc)
	if (SQLCODE'=0)||(RSLRowID=""){
		q "-1^未找到对应的班次!"
	}*/
	s RSLRowID=FindRSLRowID
	if (RSLRowID="") {
		Q "-1^未找到对应的班次!"
	}
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
	if (WeekNum<1)||(WeekNum>7){
		Q "-1^无效的星期"
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
	s ret=##class(DHCDoc.DHCDocConfig.ScheduleTemp).CheckBeforeSaveSess("",LocRowID,MarkRowID,WeekDr,TimeRangeDr,RSLRowID)
	q:(+ret<0) ret
	
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
	s TRInfoObjStr=""
	s AMObjStr=..GetTempAppMethod(AppMethodStr)
	if (TRFlag="Y"){
		s TRInfoObjStr=..GetTRInfo(TRStartTime,TREndTime,TTrtemName,TRLength,TimeRangeDr,SessLoad)
		if (TRInfoObjStr["-1^"){
			q TRInfoObjStr
		}
	}
	s OutPutStr="0^"_RSLRowID_"^"_ResRowID_"^"_WeekDr_"^"_TimeRangeDr
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
	b ;093323
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
	if (InusID="")&&(TTrtemName'="") q "-1^"_TTrtemName_"模板维护不正确"
	s StartDate=..%ZTH(TRStartTime,3)
	s EndDate=..%ZTH(TREndTime,3)
	q:TRLength="" "-1^分时段就诊为Y时,间隔分钟数不能为空"
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
