Class web.DHCPE.Statistic.IllnessStatistic Extends %RegisteredObject
{

/// 自动设置指标
/// d ##class(web.DHCPE.Statistic.IllnessStatistic).AutoSetTarget()
ClassMethod AutoSetTarget(Type As %String = "Aud")
{
	i Type="" s Type="Aud"
	i $d(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM")) {
		s Date=+$H-1
		s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
		d ##class(web.DHCPE.Statistic.IllnessStatistic).SetResultAnalysisTargetByDate(Date,Date,Type)
	} else {
		s BDate=1
		s BDate=##class(websys.Conversions).DateLogicalToHtml(BDate)
		s EDate=+$H-1
		s EDate=##class(websys.Conversions).DateLogicalToHtml(EDate)
		d ##class(web.DHCPE.Statistic.IllnessStatistic).SetResultAnalysisTargetByDate(BDate,EDate,Type)
	}
}

/// 保存表达式后更新指标
/// w ##class(web.DHCPE.Statistic.IllnessStatistic).SetResultAnalysisTargetByPR("Aud","39")
ClassMethod SetResultAnalysisTargetByPR(Type, PositiveRecord)
{
	i PositiveRecord="" q "无体征信息，无法更新查询指标！"
	i Type="" s Type="Aud"
	
	i $d(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",PositiveRecord)) q "已有该体征的查询指标在更新，无法继续！"
	i $d(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")) q "已有所有体征查询指标在更新，无法继续！"
	
	s Date=$o(^DHCPEIADM(0, "AdmDateTime", ""))
	q:Date="" "无体检人员，不需要更新查询指标"
	
	s BeginDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	s EndDate=+$h-1
	s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	d ##class(web.DHCPE.Statistic.IllnessStatistic).SetResultAnalysisTargetByDate(BeginDate,EndDate,Type,PositiveRecord)
	q ""
}

/// 重新设置所有指标 会先把已有的指标删除 再设置 需谨慎注意
/// 根据 Type (Aud 总检日期    Arr 到达日期) 
/// w ##class(web.DHCPE.Statistic.IllnessStatistic).SetAllTarget("Aud")
ClassMethod SetAllTarget(Type)
{
	k ^DHCPEQueryTarget("ResultAnalysis",Type)
	s Date=$o(^DHCPEIADM(0, "AdmDateTime", ""))
	q:Date="" "无体检人员，不需要更新查询指标"
	s EDate=+$h-1
	q ..SetResultAnalysisTargetByDate(Date,EDate,Type,"")
	q "0"
}

/// 通过日期设置 体检结果分析的查询指标 (Aud 总检日期    Arr 到达日期)
/// 查询指标分为 日期 体征 团体 套餐 性别 出生日期(年龄) IADM
/// 单独调用该方法时 请不要中途退出 中途退出的话 需要 k ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting") 或 ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting") 否则下次不能更新指标
/// d ##class(web.DHCPE.Statistic.IllnessStatistic).SetResultAnalysisTargetByDate("2020-02-01","2020-05-01","Aud","")
ClassMethod SetResultAnalysisTargetByDate(BeginDate, EndDate, Type, PositiveRecord = "")
{
	s $ZT="SetTargetErr"
	q:((BeginDate="")||(EndDate=""))
	s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	q:(BeginDate>EndDate)
	q:$d(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting"))  // 正在设置指标,不能重复设置
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	
	s:PositiveRecord'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",PositiveRecord)=""
	s:PositiveRecord="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")=""
	;b //
	//try {
		s Date=BeginDate-1
		if (Type="Arr") {
			s Date=BeginDate-1
		    f  s Date=$O(^DHCPEIADM(0, "AdmDateTime", Date)) Q:((""=Date)||(Date>EndDate))  d
		    .;d KillQueryTargetGlobal
			.s AdmTime=0
			.f  s AdmTime=$O(^DHCPEIADM(0, "AdmDateTime", Date, AdmTime)) Q:(""=AdmTime)  d
			..s IADM=0
			..f  s IADM=$O(^DHCPEIADM(0, "AdmDateTime", Date, AdmTime, IADM))  Q:(""=IADM)  d
			...d KillQueryTargetGlobal
		    ...s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
		    ...q:PAADM=""
			...d GetIADMInfo
			
		} elseif (Type="Aud") {
			f  s Date=$o(^DHCPEGS(0,"AuditDateTime",Date)) q:((""=Date)||(Date>EndDate))  d
			.s Time=""
			.f  s Time=$o(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:Time=""  d
		    ..s GSID=""
		    ..f  s GSID=$o(^DHCPEGS(0,"AuditDateTime",Date,Time,GSID)) q:GSID=""  d
		    ...s GSData=$g(^DHCPEGS(GSID,1))
		    ...;q:$p(GSData,"^",5)=""
		    ...s IADM=$p(GSData,"^",1)
		    ...q:IADM=""
			...
			...d KillQueryTargetGlobal
			...
		    ...s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
		    ...q:PAADM=""
			...;s MainDoctorGroup=$g(^DHCPESetting("DHCPE","MainDoctorGroup",ADMLoc))  //复检标志
		   	...;q:((MainDoctorGroup="Y")&&('$d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))))  // 复检判断
			...d GetIADMInfo
		}
	
	//} catch exp {
	//	k:PositiveRecord'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",PositiveRecord)
	//	k:PositiveRecord="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")
	///}
	
	k:PositiveRecord'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",PositiveRecord)
	k:PositiveRecord="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")
	q "OVER"
SetTargetErr
	k:PositiveRecord'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",PositiveRecord)
	k:PositiveRecord="" ^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")
	s ^DHCPEQueryTarget("ResultAnalysis",Type,"ErrInfo")=$H_"^"_$ZERROR
	q "Err"
KillQueryTargetGlobal
	if ($d(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM))) {
		s IADMInfos=$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM))
		f i=1:1:$l(IADMInfos,"$$") d
		.s IADMInfo=$p(IADMInfos,"$$",i)
		.q:IADMInfo=""
		.;q:$l(IADMInfo,"^")'=4
		.s kLocDR=$p(IADMInfo,"^",1)
		.s kPID=$p(IADMInfo,"^",2)
		.s kDate=$p(IADMInfo,"^",3)
		.s kGADM=$p(IADMInfo,"^",4)
		.q:((PositiveRecord'="")&&(PositiveRecord'=kPID))
		.;b //2
		.k ^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",kLocDR,kPID,kDate,kGADM,IADM)
		.
		.i $g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM,"TotalGNum"))>0 s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM,"TotalGNum")=+$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM,"TotalGNum"))-1
		.e  k ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM,"TotalGNum")
		.
		.;k ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM)
		.k ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",kLocDR,kPID,kDate,kGADM,IADM)
		.k ^DHCPEQueryTarget("ResultAnalysis",Type,"IADMNum",kLocDR,kPID,kDate,"Num",IADM)
		.s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM)=##class(web.DHCPE.Public.Setting).Replace($g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM)),"$$"_IADMInfo,"")
		
		k:$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM))="" ^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM)
	}
	
	q
GetIADMInfo
	s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	q:'("ARRIVED"=Status)
	s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
	q:PreIADM=""
	s PreIBI=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
	q:PreIBI=""
	s LocDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",26)
	q:LocDR=""
	s ReCheckFlag=##class(web.DHCPE.PreCommon).IsReCheck(IADM,"IADM",LocDR)   // 复查的不设置指标
	q:ReCheckFlag'=0
	
	
	s IADMData=$g(^DHCPEIADM(IADM))
	s PreIADMData=$g(^DHCPEPreIADM(PreIADM))
	s PreIBaseData=$g(^DHCPEPreIBI(PreIBI))
	// --------------- 基本信息 --------------- //
	s Sex=$p(PreIBaseData,"^",3)
	s:Sex="1" Sex="M"
	s:Sex="2" Sex="F"
	s BirthDay=$p(PreIBaseData,"^",4)
	
	// --------------- 预约信息 --------------- //
	s GADM=$p(IADMData,"^",2)  // 团体
	s:GADM="" GADM="I"
	s PreOrdSets="",Sub="0"  // 获取该人员套餐
	f  s Sub=$o(^DHCPEPreIADM(PreIADM,"ORDENT",Sub)) q:Sub=""  d
	.q:$p($g(^DHCPEPreIADM(PreIADM,"ORDENT",Sub)),"^",9)'="1"
	.s OrdSetsDr=$p($g(^DHCPEPreIADM(PreIADM,"ORDENT",Sub)),"^",1)
	.s:PreOrdSets'="" PreOrdSets=PreOrdSets_OrdSetsDr_"$"
	.s:PreOrdSets="" PreOrdSets="$"_OrdSetsDr_"$"
		
	// --------------- 体征信息 --------------- //
	;b:PositiveRecord'="" //s
	s PID=0
	f  s PID=$o(^User.DHCPEPositiveRecordI("TypeIndex","Q",PID)) q:PID=""  d
	.q:((PositiveRecord'="")&&(PositiveRecord'=PID))
	.
	.s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM)=$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMInfo",IADM))_"$$"_LocDR_"^"_PID_"^"_Date_"^"_GADM
	.s:'$d(^DHCPEQueryTarget("ResultAnalysis",Type,"IADMNum",LocDR,PID,Date,"Num",IADM)) ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDR,PID,Date,GADM,"TotalGNum")=+$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDR,PID,Date,GADM,"TotalGNum"))+1  // 体征下 按日期 团体 的 总人数
	.s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADMNum",LocDR,PID,Date,"Num",IADM)=""   // 设置global 防止团体人数重复增加
	.
	.s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,0))
	.i ExpressID'=""  d
	..s Express="",ResultInfo=""
	..s QuitFlag=0
	..s ExpressID=0
	..f  s ExpressID=$O(^User.DHCPEExpressI("SourceIDIndex","PR",PID,ExpressID)) q:(ExpressID="")||(QuitFlag=1)  d
	...// ^User.DHCPEExpressD(ID)=$LB("",EType,ESourceID,EPreBracket,EItemDR,ETOperator,EODStandardDR,EReference,EAfterBracket,ERelation,EOperator,ESex,ENoBloodFlag,EAgeRange)
	...s ItemID=$lg(^User.DHCPEExpressD(ExpressID),5)    // 细项ID
	...s NoBloodFlag=$lg(^User.DHCPEExpressD(ExpressID),13)    // 血标记
	...s ItemID=$$GetUseItemID(PAADM,ItemID,NoBloodFlag)
	...i ItemID="" s ItemID="a||b"
	...
	...s ItemDesc="",ItemResult=""
	...s:ItemID'="a||b" ItemDesc=$p($g(^DHCPEST($p(ItemID,"||",1),"OD",$p(ItemID,"||",2))),"^",1)    // 细项描述
	...s IsResult=0
	...i $d(^DHCPERLT(0,"PAADM_OD",PAADM,ItemID)) d  ;;逐个判断此细项是否满足
	....s ItemType=$p($g(^DHCPEST($p(ItemID,"||",1),"OD",$p(ItemID,"||",2))),"^",2)    // 细项类型
	....s ItemUnit=$p($g(^DHCPEST($p(ItemID,"||",1),"OD",$p(ItemID,"||",2))),"^",4)
	....s Reference=$lg(^User.DHCPEExpressD(ExpressID),8)    // 参考值
	....s:Reference="" IsResult="1"
	....q:Reference=""
	....s ODStandardDR=$lg(^User.DHCPEExpressD(ExpressID),7)    // 细项选择维护DR
	....;i Reference="" s Reference=$p($g(^DHCPEST(+ODStandardDR,"OD",$p(ODStandardDR,"||",2),"ODS",$p(ODStandardDR,"||",3))),"^",2)    // 细项选择的范围？？
	....s:Reference[("NULL") IsResult="1"
	....q:Reference[("NULL")
	....s Operator=$lg(^User.DHCPEExpressD(ExpressID),11)    // 运算符
	....s ResultId=0
	....f  s ResultId=$O(^DHCPERLT(0,"PAADM_OD",PAADM,ItemID,ResultId)) q:(ResultId="")||(IsResult=1)  d
 	.....s Result=$P(^DHCPERLT(ResultId),"^",4)
 	.....s ItemResult=Result
 	.....s:ItemResult[";诊断意见:" ItemResult=$p(ItemResult,";诊断意见:",2)
 	.....s ItemResult=ItemResult_ItemUnit
 	.....s EDID=$P(^DHCPERLT(ResultId),"^",9)
 	.....i (ItemType="S")||(ItemType="T") d
 	......s Result=""""_Result_""""
 	......s Reference=""""_Reference_""""
 	.....s OneExpress=Result_Operator_Reference
 	.....
 	.....s IsResult=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(OneExpress)
	...e  d  ;;没有结果设置为0
	....s IsResult=0
	...
	...i ItemResult'="" d
	....s:ResultInfo'="" ResultInfo=ResultInfo_$c(13,10)_ItemDesc_"："_ItemResult
	....s:ResultInfo="" ResultInfo=ItemDesc_"："_ItemResult
	...
	...s PreBracket=$lg(^User.DHCPEExpressD(ExpressID),4)    // 前置括号
	...s AfterBracket=$lg(^User.DHCPEExpressD(ExpressID),9)    // 前置括号
	...s Relation=$lg(^User.DHCPEExpressD(ExpressID),10)    // 关系
	...s ExpressSex=$lg(^User.DHCPEExpressD(ExpressID),12)    // 性别
	...;;性别不符设置为0
	...s:(ExpressSex'="N")&&(ExpressSex'=Sex) IsResult=0
	...s Express=Express_PreBracket_IsResult_AfterBracket_Relation
	...;w:ItemID["2||" "  "_Express_","_ExpressSex_","_Sex,!
	...s:Relation="" QuitFlag=1
	..s rStr=##class(web.DHCPE.ExcuteExpress).ExcuteExpress(Express)
	..;b:PositiveRecord'="" ////3443543
	..i rStr d  //日期 体征 团体 套餐 性别 出生日期(年龄) IADM
	...s:PreOrdSets'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",LocDR,PID,Date,GADM,IADM)=PreOrdSets  // 套餐
	...s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDR,PID,Date,GADM,IADM)=PreIBI_"^"_Sex_"^"_BirthDay_"^"_ResultInfo
	..e  d
	...k ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDR,PID,Date,GADM,IADM)
	...k:PreOrdSets'="" ^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",LocDR,PID,Date,GADM,IADM)
	.e  d  // 没有设表达式 也查询出来？
	..;s ^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",LocDR,PID,Date,PreGADM,IADM)=PreOrdSets  // 套餐
	..;s ^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDR,PID,Date,PreGADM,IADM)=PreIBI_"^"_Sex_"^"_BirthDay
	
	q
	
GetUseItemID(PAADM,ItemID,NoBloodFlag)
	q:(+ItemID'=LabStation) ItemID
	s ret=""
	s ODDesc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	s ODDesc=$$ALPHAUP^SSUTIL4(ODDesc)
	s ODSub=0
	f  s ODSub=$O(^DHCPEST(0,"OD_Desc",ODDesc,LabStation,ODSub)) q:(ODSub="")||(ret'="")  d
	.s CurItemID=LabStation_"||"_ODSub
	.s RltID=0
	.f  s RltID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,CurItemID,RltID)) q:(RltID="")||(ret'="")  d
	..;只显示血的结果
	..s OEORIRowId=$P(^DHCPERLT(RltID),"^",9)
	..s SpecimenType=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
	..q:(SpecimenType'[("血"))&&(NoBloodFlag="N")
	..q:(SpecimenType[("血"))&&(NoBloodFlag="Y")
	..s ret=CurItemID
	s ItemID=ret
	
	q ItemID
}

/// 获取指标错误信息
/// w ##class(web.DHCPE.Statistic.IllnessStatistic).GetResultAnalysisErrInfo("Aud")
ClassMethod GetResultAnalysisErrInfo(Type)
{
	if $d(^DHCPEQueryTarget("ResultAnalysis",Type,"ErrInfo")) {
		s ErrInfo=$g(^DHCPEQueryTarget("ResultAnalysis",Type,"ErrInfo"))
		s ErrDate=$p(ErrInfo,"^",1)
		s:ErrDate'="" ErrDate=##class(websys.Conversions).DateLogicalToHtml(ErrDate)
		q "-1^"_ErrDate_" 生成指标时出现错误，需要重新生成指标！"
	} elseif $d(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")) {
		s tid=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting",0))
		if tid'="" {
			q "1^正在生成部分体征指标，请耐心等待！"
		} else {
			q "1^正在生成全部体征指标，请耐心等待！"
		}
	}
	q "0"
}

/// 根据指标 获取体检结果分析    Type  Aud总检日期 Arr 到达日期     SexDR  F 女 M 男 N 所有    Other (AgeGroup^PreOrdSets)     ShowList Y 显示明细
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.IllnessStatistic","PEResultAnalysis","2020-01-01","2020-01-31","Aud","","N","39$40$41","","25-65,10,6^","Y",304)
Query PEResultAnalysis(BeginDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", AgeRange As %Library.String = "", SexDR As %Library.String = "N", PositiveRecords As %Library.String = "", GADM As %Library.String = "", Other As %Library.String = "", ShowList As %Library.String = "", CurLocDr As %Library.String = "") As websys.Query(ROWSPEC = "PID:%String,PositiveName:%String,PManNum:%String,PWomanNum:%String,Age1Num:%String,Age2Num:%String,Age3Num:%String,Age4Num:%String,Age5Num:%String,Age6Num:%String,Age7Num:%String,Age8Num:%String,Age9Num:%String,Age0Num:%String,Age1MNum:%String,Age2MNum:%String,Age3MNum:%String,Age4MNum:%String,Age5MNum:%String,Age6MNum:%String,Age7MNum:%String,Age8MNum:%String,Age9MNum:%String,Age0MNum:%String,Age1WNum:%String,Age2WNum:%String,Age3WNum:%String,Age4WNum:%String,Age5WNum:%String,Age6WNum:%String,Age7WNum:%String,Age8WNum:%String,Age9WNum:%String,Age0WNum:%String,PositiveNum:%String,TotalNum:%String,PositiveRatio:%String,ResultInfo:%String,PACCardDesc:%String") [ SqlProc ]
{
}

ClassMethod PEResultAnalysisExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", Type As %Library.String = "", AgeRange As %Library.String = "", SexDR As %Library.String = "N", PositiveRecords As %Library.String = "", GADM As %Library.String = "", Other As %Library.String = "", ShowList As %Library.String = "", CurLocDr As %Library.String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	
	s AgeGroup=$p(Other,"$",1)
	s PreOrdSets=$p(Other,"$",2)
	i ((BeginDate="")||(EndDate="")||(PositiveRecords="")||(AgeGroup="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	i Type="" s Type="Aud"
	i $d(^DHCPEQueryTarget("ResultAnalysis",Type,"Setting")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	// s ^zrc=BeginDate_"."_EndDate_"."_Type_"."_AgeRange_"."_SexDR_"."_PositiveRecords_"."_GADM_"."_Other_"."_CurLocDr_"."_ShowList
	
	s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i (BeginDate>EndDate) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s AgeMin=$p($g(AgeRange),"-",1)
	s AgeMax=$p($g(AgeRange),"-",2)
	s AgeGroupMin=+$p($p($g(AgeGroup),",",1),"-",1)
	s AgeGroupMax=+$p($p($g(AgeGroup),",",1),"-",2)
	s AgeGroupInterval=+$p($g(AgeGroup),",",2)
	s AgeGroupInNum=+$p($g(AgeGroup),",",3)
	
	s LocDr=""
	f  s LocDr=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr)) q:LocDr=""  d
	.q:LocDr'=CurLocDr   // 非当前科室退出
	.s PID=""
	.f  s PID=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID)) q:PID=""  d
	..q:(("$"_PositiveRecords_"$")'[("$"_PID_"$"))
	..d SetVariable
	..s PositiveName=$lg(^User.DHCPEPositiveRecordD(PID),3)
	..s Date=BeginDate-1
	..f  s Date=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID,Date)) q:((Date="")||(Date>EndDate))  d
	...s GID=""
	...f  s GID=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID,Date,GID)) q:GID=""  d
	....q:((GADM'="")&&(GADM'["ALLI")&&(GID="I"))
	....q:((GADM'="")&&(GADM'["ALLG")&&(GID'="I")&&(("$"_GADM_"$")'[("$"_GID_"$")))
	....;w GADM_",,"_GID
	....s TotalNum=TotalNum+$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID,Date,GID,"TotalGNum"))
	....s IADM=""
	....f  s IADM=$o(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID,Date,GID,IADM)) q:IADM=""  d
	.....q:IADM="TotalGNum"  // 团体总人数
	.....s qFlag=""
	.....i ((PreOrdSets'="")&&(($g(^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",LocDr,PID,Date,GID,IADM))="")||(("$"_PreOrdSets_"$")'[($g(^DHCPEQueryTarget("ResultAnalysis",Type,"OrderSets",LocDr,PID,Date,GID,IADM)))))) d  // 判断存在该套餐
	......s TotalNum=TotalNum-1
	......s qFlag="1"
	.....q:qFlag="1"
	.....
	.....s TempData=$g(^DHCPEQueryTarget("ResultAnalysis",Type,"IADM",LocDr,PID,Date,GID,IADM))
	.....s PreIBI=$p(TempData,"^",1)    // DHC_PE_PreIBI RowId
	.....s Sex=$p(TempData,"^",2)
	.....q:((SexDR'="N")&&(SexDR'=Sex))
	.....s BirthDay=$p(TempData,"^",3)
	.....s ADMDate=$p($g(^DHCPEIADM(IADM)),"^",5)
	.....s:ADMDate="" ADMDate=+$h
	.....s myAge=+$p(##class(web.DHCLCNUREXCUTE).CalAge(BirthDay,ADMDate),"Y",1)
	.....q:((AgeMin'="")&&(AgeMin>myAge))||((AgeMax'="")&&(AgeMax<myAge))
	.....
	.....// 根据年龄判断该年龄属于哪个年龄段
	.....s AgeIndex=""
	.....f Ti=1:1:AgeGroupInNum d
	......q:AgeIndex'=""
	......s:(AgeGroupMin+AgeGroupInterval*(Ti-1))>myAge AgeIndex=Ti
	......s:AgeGroupMax<=myAge AgeIndex=Ti
	.....q:AgeIndex=""
	.....
	.....s ResultInfo=$p(TempData,"^",4)
	.....
	.....s PositiveNum=PositiveNum+1   // 该体征的总人数
	.....
	.....i ShowList="Y" d
	......s PreIBIData=$g(^DHCPEPreIBI(PreIBI))
	......s RegNo=$p(PreIBIData,"^",1)
	......s PatName=$p(PreIBIData,"^",2)
	......s PatSex=$p(PreIBIData,"^",3)
	......s:PatSex'="" PatSex=$p($g(^CT("SEX",PatSex)),"^",2)
	......s PatAge=myAge_"岁"  // 加上年龄单位
	......s PatBirthDay=##class(websys.Conversions).DateLogicalToHtml(BirthDay)  // $zd(BirthDay,3)
	......
	......s PACCardDesc=""
	......s PACCardTypeDR=$p($g(^PAPER($o(^PAPERi("PAPMI_PatNo",RegNo,0)),"PAT",3)),"^",7)
	......i PACCardTypeDR'="" s PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	......s IDCard=$p($g(^PAPER($o(^PAPERi("PAPMI_PatNo",RegNo,0)),"PAT",3)),"^",6)
	......
	......;s IDCard=$p(PreIBIData,"^",9)
	......s PatTel=$p(PreIBIData,"^",8)
	......s ParMar=$p(PreIBIData,"^",17)
	......s:ParMar'="" ParMar=$p($g(^CT("MAR",ParMar)),"^",2)
	......s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	......s HPNo=$p($g(^DHCPEPreIADM(PreIADM)),"^",27)
	......i ((GID'="")&&(GID'="I")) d
	.......s GName="",LinkMan="",LinkTel=""
	.......s GBI=$p($g(^DHCPEGADM(GID)),"^",1)
	.......s GName=$p($g(^DHCPEGBI(GBI)),"^",2)
	.......s LinkMan=$p($g(^DHCPEGBI(GBI)),"^",6)
	.......i LinkMan="" s LinkMan=$p($g(^DHCPEGBI(GBI)),"^",7)
	.......s LinkTel=$p($g(^DHCPEGBI(GBI)),"^",10)
	.......i LinkMan="" s LinkTel=$p($g(^DHCPEGBI(GBI)),"^",11)
	......e  d  
	.......s GName="个人客户",LinkMan="",LinkTel=""
	......// ind,PositiveName,RegNo,PatName,PatSex,PatAge,PatBirthDay,IDCard,PatTel,ParMar,HPNo,GName,LinkMan,LinkTel
	......d PEResultAnalysisList
	
	.....e  d
	......i Sex="M" d  // 男
	.......s PManNum=PManNum+1
	.......s:AgeIndex=1 Age1Num=Age1Num+1, Age1MNum=Age1MNum+1
	.......s:AgeIndex=2 Age2Num=Age2Num+1, Age2MNum=Age2MNum+1
	.......s:AgeIndex=3 Age3Num=Age3Num+1, Age3MNum=Age3MNum+1
	.......s:AgeIndex=4 Age4Num=Age4Num+1, Age4MNum=Age4MNum+1
	.......s:AgeIndex=5 Age5Num=Age5Num+1, Age5MNum=Age5MNum+1
	.......s:AgeIndex=6 Age6Num=Age6Num+1, Age6MNum=Age6MNum+1
	.......s:AgeIndex=7 Age7Num=Age7Num+1, Age7MNum=Age7MNum+1
	.......s:AgeIndex=8 Age8Num=Age8Num+1, Age8MNum=Age8MNum+1
	.......s:AgeIndex=9 Age9Num=Age9Num+1, Age9MNum=Age9MNum+1
	.......s:AgeIndex=10 Age0Num=Age0Num+1,Age0MNum=Age0MNum+1
	......e  i Sex="F" d  // 女
	.......s PWomanNum=PWomanNum+1
	.......s:AgeIndex=1 Age1Num=Age1Num+1, Age1WNum=Age1WNum+1
	.......s:AgeIndex=2 Age2Num=Age2Num+1, Age2WNum=Age2WNum+1
	.......s:AgeIndex=3 Age3Num=Age3Num+1, Age3WNum=Age3WNum+1
	.......s:AgeIndex=4 Age4Num=Age4Num+1, Age4WNum=Age4WNum+1
	.......s:AgeIndex=5 Age5Num=Age5Num+1, Age5WNum=Age5WNum+1
	.......s:AgeIndex=6 Age6Num=Age6Num+1, Age6WNum=Age6WNum+1
	.......s:AgeIndex=7 Age7Num=Age7Num+1, Age7WNum=Age7WNum+1
	.......s:AgeIndex=8 Age8Num=Age8Num+1, Age8WNum=Age8WNum+1
	.......s:AgeIndex=9 Age9Num=Age9Num+1, Age9WNum=Age9WNum+1
	.......s:AgeIndex=10 Age0Num=Age0Num+1,Age0WNum=Age0WNum+1
	..s:TotalNum'=0 PositiveRatio=$fn(PositiveNum/TotalNum*100,"",1)_"%"
	..d:ShowList'="Y" PEResultAnalysis
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SetVariable
	s PositiveName=""
	s PManNum=0,PWomanNum=0  // 体征男女总数
	s Age1Num=0,Age2Num=0,Age3Num=0,Age4Num=0,Age5Num=0,Age6Num=0,Age7Num=0,Age8Num=0,Age9Num=0,Age0Num=0  // 年龄段总数
	s Age1MNum=0,Age2MNum=0,Age3MNum=0,Age4MNum=0,Age5MNum=0,Age6MNum=0,Age7MNum=0,Age8MNum=0,Age9MNum=0,Age0MNum=0  // 年龄段 男
	s Age1WNum=0,Age2WNum=0,Age3WNum=0,Age4WNum=0,Age5WNum=0,Age6WNum=0,Age7WNum=0,Age8WNum=0,Age9WNum=0,Age0WNum=0  // 年龄段 女
	s TotalNum=0,PositiveNum=0,PositiveRatio="0%"
	s ResultInfo="",PACCardTypeDR=""
	
	q
	
PEResultAnalysis
	Set Data=$LB(PID,PositiveName,PManNum,PWomanNum,Age1Num,Age2Num,Age3Num,Age4Num,Age5Num,Age6Num,Age7Num,Age8Num,Age9Num,Age0Num,Age1MNum,Age2MNum,Age3MNum,Age4MNum,Age5MNum,Age6MNum,Age7MNum,Age8MNum,Age9MNum,Age0MNum,Age1WNum,Age2WNum,Age3WNum,Age4WNum,Age5WNum,Age6WNum,Age7WNum,Age8WNum,Age9WNum,Age0WNum,PositiveNum,TotalNum,PositiveRatio,ResultInfo,PACCardDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
 	
PEResultAnalysisList
	Set Data=$LB(ind,PositiveName,RegNo,PatName,PatSex,PatAge,PatBirthDay,IDCard,PatTel,ParMar,HPNo,GName,LinkMan,LinkTel,Age1MNum,Age2MNum,Age3MNum,Age4MNum,Age5MNum,Age6MNum,Age7MNum,Age8MNum,Age9MNum,Age0MNum,Age1WNum,Age2WNum,Age3WNum,Age4WNum,Age5WNum,Age6WNum,Age7WNum,Age8WNum,Age9WNum,Age0WNum,PositiveNum,TotalNum,PositiveRatio,ResultInfo,PACCardDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 获取年龄段信息  
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.IllnessStatistic","AgeGroup","25-65,10,6")
Query AgeGroup(AgeGroup As %Library.String = "") As websys.Query(ROWSPEC = "AgeGroup1:%String,AgeGroup2:%String,AgeGroup3:%String,AgeGroup4:%String,AgeGroup5:%String,AgeGroup6:%String,AgeGroup7:%String,AgeGroup8:%String,AgeGroup9:%String,AgeGroup0:%String") [ SqlProc ]
{
}

ClassMethod AgeGroupExecute(ByRef qHandle As %Binary, AgeGroup As %Library.String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	
	i (AgeGroup="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s (AgeGroup1,AgeGroup2,AgeGroup3,AgeGroup4,AgeGroup5,AgeGroup6,AgeGroup7,AgeGroup8,AgeGroup9,AgeGroup0)=""  // 年龄段总数
	
	s AgeMin=$p($p($g(AgeGroup),",",1),"-",1)
	s AgeMax=$p($p($g(AgeGroup),",",1),"-",2)
	s AgeInterval=$p($g(AgeGroup),",",2)  // 间隔
	s AgeInNum=$p($g(AgeGroup),",",3)
	
	s AgeGroup1="<="_AgeMin
	
	//s @("AgeGroup"_AgeInNum)=">"_AgeMax
	//s Temp="s AgeGroup"_AgeInNum_"="""_">"_AgeMax_""""
	//xecute Temp  //执行上面的M表达式
	
	f Tempi=1:1:+AgeInNum {
		s Age1=+AgeMin+$num((Tempi-2)*AgeInterval)
		s Age2=+AgeMin++$num((Tempi-1)*AgeInterval)
		//s @("AgeGroup"_Tempi)=Age1_"-"_Age2
		//s Temp="s AgeGroup"_Tempi_"="""_Age1_"-"_Age2_""""
		//xecute Temp  //执行上面的M表达式
		i Tempi=1 {
			s AgeGroup1="<="_AgeMin
		} elseif Tempi=+AgeInNum {
			s:Tempi=2 AgeGroup2=">"_AgeMax
			s:Tempi=3 AgeGroup3=">"_AgeMax
			s:Tempi=4 AgeGroup4=">"_AgeMax
			s:Tempi=5 AgeGroup5=">"_AgeMax
			s:Tempi=6 AgeGroup6=">"_AgeMax
			s:Tempi=7 AgeGroup7=">"_AgeMax
			s:Tempi=8 AgeGroup8=">"_AgeMax
			s:Tempi=9 AgeGroup9=">"_AgeMax
			s:Tempi=10 AgeGroup0=">"_AgeMax
		} else {
			s:Tempi=2 AgeGroup2=Age1_"-"_Age2
			s:Tempi=3 AgeGroup3=Age1_"-"_Age2
			s:Tempi=4 AgeGroup4=Age1_"-"_Age2
			s:Tempi=5 AgeGroup5=Age1_"-"_Age2
			s:Tempi=6 AgeGroup6=Age1_"-"_Age2
			s:Tempi=7 AgeGroup7=Age1_"-"_Age2
			s:Tempi=8 AgeGroup8=Age1_"-"_Age2
			s:Tempi=9 AgeGroup9=Age1_"-"_Age2
		}
	}
	
	d OutAgeGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutAgeGroup
	Set Data=$LB(AgeGroup1,AgeGroup2,AgeGroup3,AgeGroup4,AgeGroup5,AgeGroup6,AgeGroup7,AgeGroup8,AgeGroup9,AgeGroup0)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	Quit
}

/// 疾病统计设置临时global
/// d ##class(web.DHCPE.Statistic.IllnessStatistic).SetTempIllnessGlobal("01/01/2023","18/04/2023","","","87","","105","17283")
ClassMethod SetTempIllnessGlobal(BeginDate As %Library.String = "", EndDate As %Library.String = "", MarriedDR As %Library.String = "", SexDR As %Library.String = "", IllnessList As %Library.String = "", GADMList As %Library.String = "", CurLoc As %Library.String = "", CurUser As %Library.String = "")
{
	q:(((BeginDate="")&(EndDate="")&(GADMList=""))||(IllnessList="")) ""
	
	s Job=CurUser
	s ^TempDHCPEIllnessStatistic("Illness")=BeginDate_"^"_EndDate_"^"_MarriedDR_"^"_SexDR_"^"_IllnessList_"^"_GADMList_"^"_CurLoc
	k ^TempDHCPEIllnessStatistic(Job)
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	s GroupFlag=""
	i (("ALLI"=GADMList)||("ALLG"=GADMList)) {
		s GroupFlag=GADMList
		s GADMList=""
	}
	
	i GADMList'="" d
	.s Len=$L(GADMList,"^")
	.f i=1:1:Len d
	..s GADM=$p(GADMList,"^",i)
	..s Team=""
	..f  s Team=$o(^DHCPEIADM(0,"GADM",GADM,Team)) q:Team=""  d
	...s IADM=""
	...f  s IADM=$o(^DHCPEIADM(0,"GADM",GADM,Team,IADM)) q:IADM=""  d
	....s GSID=$o(^DHCPEGS(0,"IADM",IADM,0))
	....q:GSID=""
	....d GetIllnessInfo
	e  d
	.s Date=BeginDate-1	
	.f  s Date=$o(^DHCPEGS(0,"AuditDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	..s Time=""
	..f  s Time=$o(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:Time=""  d
    ...s GSID=""
    ...f  s GSID=$o(^DHCPEGS(0,"AuditDateTime",Date,Time,GSID)) q:GSID=""  d
	....d GetIllnessInfo
	
	q "0"
GetIllnessInfo
    s GSData=$g(^DHCPEGS(GSID,1))
    q:$p(GSData,"^",5)=""
    s IADM=$p(GSData,"^",1)
    q:IADM=""
    s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
    q:PAADM=""
    s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CurLoc) 
	q:LocFlag=1
    s Sex="",Age=""
    s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
    s PreGADM=$P($G(^DHCPEPreIADM(PreIADM)),"^",2)
    q:(((GroupFlag="ALLI")&&(PreGADM'=""))||((GroupFlag="ALLG")&&(PreGADM="")))
    s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
    s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	q:(SexDR'="")&&(SexDR'=PIBISex)
	s Married=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	q:(MarriedDR'="")&&(MarriedDR'=Married)
	s AuditDate=$p(GSData,"^",6)
	q:(BeginDate'="")&&(AuditDate<BeginDate)
	q:(EndDate'="")&&(AuditDate>EndDate)
	s RegNo=$p(^DHCPEPreIBI(PIBIDR),"^",1)
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	s HospID=$P($g(^PAADM(PAADM,2)),"^",85)
	s LocID=$P($g(^DHCPEPreIADM(PreIADM)),"^",26)
	//i PAPMIRowId'="" s Age=+##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	i PAPMIRowId'="" s Age=+##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,LocID)

	s AgeArea=..GetAgeArea(20,80,10,Age)
	s ^TempDHCPEIllnessStatistic(Job,"TotalPerson",AgeArea,PIBISex,PreIADM)=""
	s GSIll=""
	f  s GSIll=$o(^User.DHCPEGSIllnessI("IndexParref",GSID,GSIll)) q:GSIll=""  d
	.s GSIStatus=$lg(^User.DHCPEGSIllnessD(GSIll),8)
	.q:GSIStatus'=0
	.s GSIllnessID=$lg(^User.DHCPEGSIllnessD(GSIll),3)
	.q:("^"_IllnessList_"^")'[("^"_GSIllnessID_"^")
	.s ^TempDHCPEIllnessStatistic(Job,"Illness",GSIllnessID,AgeArea,PIBISex,PreIADM)=""

    q
}

/// Creator：      ln
/// CreateDate：   2020-03-09
/// Description:：疾病统计
/// Table：       DHC_PE_GeneralSummarize  ^TempDHCPEIllnessStatistic(Job,"TotalPerson",AgeArea,PIBISex,PreIADM) 
/// Input：       BeginDate,EndDate,AgeRange,MarriedDR,SexDR,IllnessList,GADMList,CTLOCID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.IllnessStatistic","TotalStatistic","2023-01-01","2023-04-19","17283")                       
Query TotalStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "") As websys.Query(ROWSPEC = "PreIADM:%String,AgeArea:%String,PIBISex:%String,Sex:%String") [ SqlProc ]
{
}

ClassMethod TotalStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	i (BeginDate="")&(EndDate="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s Job=CurUser
	s AgeArea=""
	f  s AgeArea=$o(^TempDHCPEIllnessStatistic(Job,"TotalPerson",AgeArea)) q:AgeArea=""  d
	.s PIBISex=""
	.f  s PIBISex=$o(^TempDHCPEIllnessStatistic(Job,"TotalPerson",AgeArea,PIBISex)) q:PIBISex=""  d
	..s Sex=$p(^CT("SEX",PIBISex),"^",2)
	..s PreIADM=""
	..f  s PreIADM=$o(^TempDHCPEIllnessStatistic(Job,"TotalPerson",AgeArea,PIBISex,PreIADM)) q:PreIADM=""  d
	...d OutTotalPerson
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutTotalPerson
	Set Data=$LB(PreIADM,AgeArea,PIBISex,Sex)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	Quit
}

/// Creator：      ln
/// CreateDate：   2020-03-09
/// Description:：疾病统计
/// Table：       DHC_PE_GeneralSummarize  ^TempDHCPEIllnessStatistic(Job,"Illness",GSIllnessID,AgeArea,PIBISex,PreIADM)
/// Input：       BeginDate,EndDate,AgeRange,MarriedDR,SexDR,IllnessList,GADMList,CTLOCID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.IllnessStatistic","IllnessStatistic","2019-08-22","2019-08-22","","","","17283")                       
Query IllnessStatistic(BeginDate As %Library.String = "", EndDate As %Library.String = "", Illness As %Library.String = "", AgeAreaDR As %Library.String = "", SexDR As %Library.String = "", CurUser As %Library.String = "") As websys.Query(ROWSPEC = "IllnessDR:%String,IllnessDesc:%String,AgeArea:%String,PIBISex:%String,Sex:%String,PreIADM:%String,RegNo:%String,Name:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,GroupName:%String,GTName:%String,Position:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod IllnessStatisticExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", Illness As %Library.String = "", AgeAreaDR As %Library.String = "", SexDR As %Library.String = "", CurUser As %Library.String = "") As %Status
{
	Set ind=1
	Set repid=$I(^CacheTemp)
	i (BeginDate="")&(EndDate="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s Job=CurUser
	s IllnessDR=""
	f  s IllnessDR=$o(^TempDHCPEIllnessStatistic(Job,"Illness",IllnessDR)) q:IllnessDR=""  d
	.q:(Illness'="")&&(Illness'=IllnessDR)
	.s IllnessDesc=$p(^DHCPEILLS(IllnessDR),"^",2)
	.s AgeArea=""
	.f  s AgeArea=$o(^TempDHCPEIllnessStatistic(Job,"Illness",IllnessDR,AgeArea)) q:AgeArea=""  d
	..q:(AgeAreaDR'="")&&(AgeAreaDR'=AgeArea)
	..s PIBISex=""
	..f  s PIBISex=$o(^TempDHCPEIllnessStatistic(Job,"Illness",IllnessDR,AgeArea,PIBISex)) q:PIBISex=""  d
	...q:(SexDR'="")&&(SexDR'=PIBISex)
	...s Sex=$p(^CT("SEX",PIBISex),"^",2)
	...s PreIADM=""
	...f  s PreIADM=$o(^TempDHCPEIllnessStatistic(Job,"Illness",IllnessDR,AgeArea,PIBISex,PreIADM)) q:PreIADM=""  d
	....s Info=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("Pre",PreIADM)
	....d OutIllnessDetail
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutIllnessDetail
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	Set Data=$LB(IllnessDR,IllnessDesc,AgeArea,PIBISex,Sex,PreIADM,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",7),$p(Info,"^",8),$p(Info,"^",9),$p(Info,"^",10),Now)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	Quit
}

/// 获取年龄所在的区间
/// w ##class(web.DHCPE.Statistic.IllnessStatistic).GetAgeArea(20,80,10,65)
ClassMethod GetAgeArea(aAgeFrom As %String = "", aAgeTo As %String = "", aAgeStep As %String = "", aAge As %String = "")
{

	
	s aAge=+$G(aAge)
	Q:(aAge>=+aAgeTo) "80及以上"
	q:aAge<20 "20岁以下"
	;Q:(aAge<+aAgeFrom) "20-29"
	s n=(aAge-aAgeFrom)\aAgeStep 
	s LowerAgeArea=aAgeFrom+(aAgeStep*n) 
	s HeightAgeArea=aAgeFrom+(aAgeStep*(n+1))-1
	s:(HeightAgeArea>aAgeTo) HeightAgeArea=aAgeTo
	 
	Q LowerAgeArea_"-"_HeightAgeArea
}

/// Creator：      ln
/// CreateDate：   2021-07-27
/// Description:：异常结果统计
/// Table：       DHC_PE_IADM  
/// Input：       BeginDate,EndDate,AgeRange,MarriedDR,SexDR,IllnessList,GADMList,CTLOCID
/// Output：      
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.IllnessStatistic","UnNormalResult","2021-07-01","2021-07-27","","","152") 
Query UnNormalResult(BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", OEItem As %Library.String = "", CTLOCID As %Library.String = "") As websys.Query(ROWSPEC = "PAADM:%String,ARCIM:%String,ARCIMDesc:%String,ODDR:%String,ODDesc:%String,Result:%String,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,GroupName:%String,GTName:%String,Position:%String,Now:%String") [ SqlProc ]
{
}

ClassMethod UnNormalResultExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", GroupDR As %Library.String = "", OEItem As %Library.String = "", CTLOCID As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
 	if ((""=BeginDate)&(""=EndDate)&(""=GroupDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
 	i EndDate'=""   s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	i (+GroupDR=0)&&(GroupDR'="ALLI")&&(GroupDR'="ALLG") s GroupDR=""
	
	s GroupFlag=""
	i (("ALLI"=GroupDR)||("ALLG"=GroupDR)) {
		s GroupFlag=GroupDR
		s GroupDR=""
	}
	
	if GroupDR'=""
	{
		s TeamDR=""
		f  s TeamDR=$O(^DHCPEIADM(0,"GADM",GroupDR,TeamDR)) q:TeamDR=""  d
		.s IADM=""
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GroupDR,TeamDR,IADM)) q:IADM=""  d
		..s id=IADM
		..d OneInfo
	}
	else
	{
		s AdmDate=BeginDate-1
		f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>EndDate)  d
		.s Time=""
		.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
		...s id=IADM
		...d OneInfo
	}	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneInfo
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",id,CTLOCID)
	q:LocFlag="1"
	s CurData=$g(^DHCPEIADM(id))
	s IADMCRMADM=$p(CurData,"^",4)  // DHC_PE_PREIADM
	Q:(""=IADMCRMADM)
	s PAADM=$p(CurData,"^",1)
	s IADMStatus=$p(CurData,"^",8)
	Q:(IADMStatus'="ARRIVED")
	s GADM=$p(CurData,"^",2)
	q:((GADM="")&&(GroupDR="ALLG"))||((GADM'="")&&(GroupDR="ALLI"))
	s Date=$p(CurData,"^",5)
	q:(Date<BeginDate)||(Date>EndDate)
	s BaseInfo=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PAADM",PAADM)
		
	s ORORI=""
	f  s ORORI=$o(^DHCPERLT(0,"ADMOD",PAADM,ORORI)) q:ORORI=""  d
	.s ARCIM=$p($G(^OEORD(+ORORI,"I",$p(ORORI,"||",2),1)),"^",2)
	.q:(OEItem'="")&&(OEItem'=ARCIM)
	.s ARCIMDesc=$P($G(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",2)
	.s ODDR=""
	.f  s ODDR=$o(^DHCPERLT(0,"ADMOD",PAADM,ORORI,ODDR)) q:ODDR=""  d
	..s ODDesc=$p(^DHCPEST(+ODDR,"OD",$p(ODDR,"||",2)),"^",1)
	..s RLTRowID=""
	..f  s RLTRowID=$o(^DHCPERLT(0,"ADMOD",PAADM,ORORI,ODDR,RLTRowID)) q:RLTRowID=""  d
	...s Normal=$p($G(^DHCPERLT(RLTRowID)),"^",7)
	...q:Normal'="0"
	...s Result=$p($G(^DHCPERLT(RLTRowID)),"^",4)
	...d ItemStatisticOut

	q	
ItemStatisticOut
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))     
    s Data=$LB(PAADM,ARCIM,ARCIMDesc,ODDR,ODDesc,Result,$p(BaseInfo,"^",1),$p(BaseInfo,"^",2),$p(BaseInfo,"^",3),$p(BaseInfo,"^",4),$p(BaseInfo,"^",5),$p(BaseInfo,"^",6),$p(BaseInfo,"^",7),$p(BaseInfo,"^",8),$p(BaseInfo,"^",9),$p(BaseInfo,"^",10),Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	q
}

}
