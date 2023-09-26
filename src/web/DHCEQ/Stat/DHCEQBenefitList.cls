Class web.DHCEQ.Stat.DHCEQBenefitList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取设备消息的基本信息
/// add by zy 2017-08-28
/// 入参：pEquipDR
/// 出参：TEquipDR: 设备id
/// 		TEquipName:设备名称
/// 		TModel:规格型号
///       TLeaveFactoryNo:出厂编号
///       TStartdate:启用日期
///       TUseLoc:使用科室
///       TManuFactory:生产厂家
///       TOriginalFee:设备总值(原值)
///       TTransAssetDate:购入日期
///       TPurposeType:设备用途
///       TRegistrationNo:配置证号
///       TFunds:资金来源
///       TInitYear:分析初始年度
///       TPreWorkLoad:预测工作量
///       TNewFunction:填补诊治空白
///       TSpecialService:服务特殊人群
///       TOtherSocial:其他社会效益
///       TGraduateNum:培养研究生数量
///       TStaffNum:培养进修人员数量
///       TOtherTasks:承担的其他科研教学任务
///       保留字段:THold1,THold2,THold3,THold4,THold5
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","BenefitList")
Query BenefitList(pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TModel:%String,TLeaveFactoryNo:%String,TStartdate:%String,TUseLoc:%String,TManuFactory:%String,TOriginalFee:%String,TTransAssetDate:%String,TPurposeType:%String,TRegistrationNo:%String,TFunds:%String,TInitYear:%String,TPreWorkLoad:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod BenefitListExecute(ByRef qHandle As %Binary, pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	if pEquipDR'=""
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(0,"Equip",pEquipDR,rowid)) q:rowid=""  d
	 	.d BenefitList
	}
 	else
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(rowid)) q:rowid=""  d
	 	.d BenefitList
	}
 	
 	Quit $$$OK
BenefitList 	
 	d ResetVariablesBenefitList
 	s BenefitEquipListData=$g(^DHCEQBenefitEquipList(rowid))
 	s TRowID=rowid
 	s TEquipDR=$p(BenefitEquipListData,"^",1)
 	s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)		             //设备名称
 	s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)		                 //规格型号
 	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	s TLeaveFactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)	             //出厂编号
 	s TStartdate=$p($g(^DHCEQEquip(TEquipDR)),"^",44) 
 	s TStartdate=##class(web.DHCEQCommon).TransValueToPage(TStartdate,"date")                  //启用日期
 	s TUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
 	i TUseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
 	i TManuFactoryDR'="" s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
 	s TOriginalFee = $p($g(^DHCEQEquip(TEquipDR)),"^",27)
 	s TTransAssetDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
 	s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
 	s TPurposeTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",65)
 	i TPurposeTypeDR'="" s TPurposeType=$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
 	s TRegistrationNo=$p($g(^DHCEQEquip(TEquipDR)),"^",92)
 	Set Funds=##Class(web.DHCEQFunds).GetFundsInfo(1,TEquipDR)
	i Funds'="" d
	.Set n=$Length(Funds,";")
	.For i=1:1:n Do
	..If TFunds'="" Set TFunds=TFunds_"/"
	..Set TFunds=TFunds_$p($p(Funds,";",i),",",1)
 	s TInitYear=$p(BenefitEquipListData,"^",2)
 	s TPreWorkLoad=$p(BenefitEquipListData,"^",3)
 	s TNewFunction=$p(BenefitEquipListData,"^",4)
 	s TSpecialService=$p(BenefitEquipListData,"^",5)
 	s TOtherSocial=$p(BenefitEquipListData,"^",6)
 	s TGraduateNum=$p(BenefitEquipListData,"^",7)
 	s TStaffNum=$p(BenefitEquipListData,"^",8)
 	s TOtherTasks=$p(BenefitEquipListData,"^",9)
 	s THold1=$p(BenefitEquipListData,"^",10)
 	s THold2=$p(BenefitEquipListData,"^",11)
 	s THold3=$p(BenefitEquipListData,"^",12)
 	s THold4=$p(BenefitEquipListData,"^",13)
 	s THold5=$p(BenefitEquipListData,"^",14)
 	d OutputRowBenefitList
 	quit
OutputRowBenefitList
	s Data=$lb(TRowID,TEquipDR,TEquipName,TModel,TLeaveFactoryNo,TStartdate,TUseLoc,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeType,TRegistrationNo,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBenefitList
	s (TRowID,TEquipDR,TEquipName,TModelDR,TModel,TLeaveFactoryNo,TStartdate,TUseLocDR,TUseLoc,TManuFactoryDR,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeTypeDR,TPurposeType,TRegistrationNo,Funds,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BenefitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenefitListExecute ]
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

ClassMethod BenefitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenefitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备效益分析记录
/// add by QW 2017-08-30
/// 入参：Year:YYYY    年度
///       MonthStr:YYYY-MM  年月
///       pLocDR            科室id
///       pEquipDR           设备id
/// 输出:TRowID
/// 		 TYear          统计年度
///      TMonth:        统计月份
///      TEquipDR:     设备id
///      TExpectedSatis:预期满意度
///      TActualSatis:  实际满意度
///      TPatientSatis: 患者满意度
///      TNewFunction:  填补诊治空白
///      TSpecialService:服务特殊人群
///      TOtherSocial:其他社会效益
///      TGraduateNum:培养研究生数量
///      TStaffNum:培养进修人员数量
///      TOtherTasks:承担的其他科研教学任务
///      TTotalScore:总分(得分)
///      TBenefitAnalysis:经济效益分析
///      TUseEvaluation:使用评价（维修维护、运行情况）
///      TBriefEvaluation:简要评价
///      TOverallEvaluation:总体评价
///      TIncome:设备收入
/// 		 TPersonTime:检查人次
///      TActualWorkLoad:实际工作量
///      TPositiveCases:阳性例数
///      TRunTime:开机时间
///      TFailureTimes:故障次数
///      TMaintTimes:维修次数
///      TPMTimes:保养次数
///      TDetectionTimes:检测次数
///      TWaitingTimes:预约等待时间
///      TAverageWorkHour:平均工作小时/日
///      TActualWorkDays:实际工作天数
///      TFailureDays:故障天数（0.5天起计算）
///      保留字段:TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5
/// 使用该query的报表:医疗设备科室使用评价,附件3：经济效益,附件1：设备使用情况      
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","BenefitAnalysis",2017,"","","","","","","","Y")
Query BenefitAnalysis(pYear As %String = "", pMonthStr As %String = "", pLocDR As %String = "", pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "", YearReport As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TEquipDR:%String,TExpectedSatis:%String,TActualSatis:%String,TPatientSatis:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,TTotalScore:%String,TBenefitAnalysis:%String,TUseEvaluation:%String,TBriefEvaluation:%String,TOverallEvaluation:%String,TIncome:%String,TPersonTime:%String,TActualWorkLoad:%String,TPositiveCases:%String,TRunTime:%String,TFailureTimes:%String,TMaintTimes:%String,TPMTimes:%String,TDetectionTimes:%String,TWaitingTimes:%String,TAverageWorkHour:%String,TActualWorkDays:%String,TFailureDays:%String,TUCHold1:%String,TUCHold2:%String,TUCHold3:%String,TUCHold4:%String,TUCHold5:%String") [ SqlProc ]
{
}

ClassMethod BenefitAnalysisExecute(ByRef qHandle As %Binary, pYear As %String = "", pMonthStr As %String = "", pLocDR As %String = "", pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "", YearReport As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s (Year,Month)=""
 	s Year=pYear
 	if (pMonthStr'="")
 	{
	 	s Year=$p(pMonthStr,"-",1)
	 	s Month=$p(pMonthStr,"-",2)
	}
	if Year="" Quit $$$OK
	
	s EquipID=0
 	f  s EquipID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID)) q:EquipID=""  d
	.q:(pEquipDR'="")&&(pEquipDR'=EquipID)
 	.//s BELRowID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID,0))
 	.//s TInitYear=""
 	.//i BELRowID'="" s TInitYear=+$p($g(^DHCEQBenefitEquipList(BELRowID)),"^",2)                    //分析初始年度
	.s UCYear=0
	.f  s UCYear=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear)) q:UCYear=""  d
	..q:(Year'="")&&(+UCYear'=+Year)
	..s UCMonth=""
	..f  s UCMonth=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth)) q:UCMonth=""  d
	...q:(Month'="")&&(+UCMonth'=+Month)
	...s UCRowID=0
	...f  s UCRowID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth,UCRowID)) q:UCRowID=""  d
	....s UseContextData=$g(^DHCEQUseContext(UCRowID))
	....d BuildBenefitAnalysis
	
 	Quit $$$OK
 	
BuildBenefitAnalysis 
 	d ResetVariablesBenefitAnalysis
 	q:$p(UseContextData,"^",44)="Y"
 	q:$p(UseContextData,"^",45)'="2"
 	s TRowID=UCRowID
 	s TSummaryDR=$p(UseContextData,"^",1)
 	q:(YearReport="Y")&&(TSummaryDR="") 
 	s TEquipDR=$p(UseContextData,"^",2)
 	s TYear=$p(UseContextData,"^",3)                                   //输出统计年度
 	s TMonth=$p(UseContextData,"^",4)                                  //输出统计月份
 	s TExpectedSatis=$p(UseContextData,"^",5)                          //预期满意度
 	s TActualSatis=$p(UseContextData,"^",6)                            //实际满意度
 	s TPatientSatis=$p(UseContextData,"^",7)                           //患者满意度
 	s TNewFunction=$p(UseContextData,"^",8)          //填补诊治空白
 	s TSpecialService=$p(UseContextData,"^",9)    //服务特殊人群
 	s TOtherSocial=$p(UseContextData,"^",10)         //其他社会效益
 	s TGraduateNum=$p(UseContextData,"^",11)         //培养研究生数量
 	s TStaffNum=$p(UseContextData,"^",12)               //培养进修人员数量
 	s TOtherTasks=$p(UseContextData,"^",13)           //承担的其他科研教学任务
 	s TTotalScore=$p(UseContextData,"^",14)                            //总分(得分)
 	s TBenefitAnalysis=$p(UseContextData,"^",15)                       //经济效益分析
 	s TUseEvaluation=$p(UseContextData,"^",16)                         //使用评价（维修维护、运行情况）
 	s TBriefEvaluation=$p(UseContextData,"^",17)                       //简要评价
 	s TOverallEvaluation=$p(UseContextData,"^",18)                     //总体评价
 	s TIncome=$p(UseContextData,"^",19)                                //设备收入
 	s TPersonTime=$p(UseContextData,"^",20)                            //检查人次
 	s TActualWorkLoad=$p(UseContextData,"^",21)                        //实际工作量
 	s TPositiveCases=$p(UseContextData,"^",22)                         //阳性例数
 	s TRunTime=$p(UseContextData,"^",23)                               //开机时间
 	s TFailureTimes=$p(UseContextData,"^",24)                          //故障次数
 	s TMaintTimes=$p(UseContextData,"^",25)                            //维修次数
 	s TPMTimes=$p(UseContextData,"^",26)                               //保养次数
 	s TDetectionTimes=$p(UseContextData,"^",27)                        //检测次数
 	s TWaitingTimes=$p(UseContextData,"^",28)                          //预约等待时间
 	s TAverageWorkHour=$p(UseContextData,"^",29)                       //平均工作小时/日
 	s TActualWorkDays=$p(UseContextData,"^",30)                        //实际工作天数
 	s TFailureDays=$p(UseContextData,"^",31)                           //故障天数（0.5天起计算）
 	s TUCHold1=$p(UseContextData,"^",46)
 	s TUCHold2=$p(UseContextData,"^",47)
 	s TUCHold3=$p(UseContextData,"^",48)
 	s TUCHold4=$p(UseContextData,"^",49)
 	s TUCHold5=$p(UseContextData,"^",50)
 	d OutputRowBenefitAnalysis
	quit
OutputRowBenefitAnalysis
	s Data=$lb(TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBenefitAnalysis
	s (TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)=""
 	quit
}

ClassMethod BenefitAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenefitAnalysisExecute ]
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

ClassMethod BenefitAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenefitAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备具备主要功能
/// add by QW 2017-08-30
/// 入参：SourceType:业务类型(暂定为1)  2 设备  3  年度评价表
///       SourceID:  业务ID(指向BuyRequest)  DHC_EQEquip   DHC_EQUseContext
/// 输出:TCode:功能开发代码
/// 	     TDesc:功能开发描述
/// 		 TPrice:功能收入
/// 	     TCost:功能成本
/// 	     TWorkLoadNum:预计工作量
/// 	     TUsedFlag:是否已使用
/// 	     TDevelopStatus:新开发功能标记 0：原有功能；1：可开发功能；2；已开发功能
/// 使用该query的报表:附件2：功能开发、社会效益、科研教学      
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","BillItemList","1935")
Query BillItemList(SourceID As %String = "", SourceType As %String = "2", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TCode:%String,TDesc:%String,TPrice:%String,TCost:%String,TWorkLoadNum:%String,TUsedFlag:%String,TDevelopStatus:%String") [ SqlProc ]
{
}

ClassMethod BillItemListExecute(ByRef qHandle As %Binary, SourceID As %String = "", SourceType As %String = "2", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	i SourceID=""  d
 	.s SourceID=0
 	.f  s SourceID=$o(^DHCEQBillItem(0,"Source",SourceType,SourceID)) q:SourceID=""  d
 	..d GetBillItemList
 	e  d
 	.d GetBillItemList
 	
 	Quit $$$OK
GetBillItemList              
	s BIRowID=0 
 	f  s BIRowID=$o(^DHCEQBillItem(0,"Source",SourceType,SourceID,BIRowID)) q:BIRowID=""  d
	.d ResetVariablesBillItemList
	.q:$p($g(^DHCEQBillItem(BIRowID)),"^",12)="Y"
	.s TRowID=BIRowID
	.s TSourceType=$p($g(^DHCEQBillItem(BIRowID)),"^",1)
	.s TSourceID=$p($g(^DHCEQBillItem(BIRowID)),"^",2)
	.s TCode=$p($g(^DHCEQBillItem(BIRowID)),"^",3)
	.s TDesc=$p($g(^DHCEQBillItem(BIRowID)),"^",4)
	.s TPrice=$p($g(^DHCEQBillItem(BIRowID)),"^",5)
	.s TCost=$p($g(^DHCEQBillItem(BIRowID)),"^",6)
	.s TWorkLoadNum=$p($g(^DHCEQBillItem(BIRowID)),"^",7)
	.s TUsedFlag=$p($g(^DHCEQBillItem(BIRowID)),"^",10)
	.s TDevelopStatus=$p($g(^DHCEQBillItem(BIRowID)),"^",11)
 	.d OutputRowBillItemList
	quit
OutputRowBillItemList
	s Data=$lb(TRowID,TSourceType,TSourceID,TCode,TDesc,TPrice,TCost,TWorkLoadNum,TUsedFlag,TDevelopStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBillItemList
	s (TRowID,TSourceType,TSourceID,TCode,TDesc,TPrice,TCost,TWorkLoadNum,TUsedFlag,TDevelopStatus)=""
	quit
}

ClassMethod BillItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BillItemListExecute ]
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

ClassMethod BillItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BillItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备论文或科研项目
/// add by QW 2017-08-30
/// 入参：pEquipDR:设备ID
///      
/// 输出:	TRowID:DHCEQResearch的id
/// 		TName:名称
/// 	     TType:类型 0：科研项目；1：论文
/// 		 TBeginDate:开始日期
/// 	     TEndDate:完成日期
/// 	     TUser:负责人
/// 	     TParticipant:参与人
/// 	     TLevel:级别
///      TRemark:备注 
/// 使用该query的报表:附件2：功能开发、社会效益、科研教学      
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","ResearchList","1935")
Query ResearchList(pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TName:%String,TType:%String,TBeginDate:%String,TEndDate:%String,TUser:%String,TParticipant:%String,TLevel:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod ResearchListExecute(ByRef qHandle As %Binary, pEquipDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	
 	i pEquipDR=""  d
 	.s pEquipDR=0
 	.f  s pEquipDR=$o(^DHCEQResearch(0,"EquipDR",pEquipDR)) q:pEquipDR=""  d
 	..d GetResearchList
 	e  d
 	.d GetResearchList
 	
 	Quit $$$OK
GetResearchList              
	s RRowID=0 
 	f  s RRowID=$o(^DHCEQResearch(0,"EquipDR",pEquipDR,RRowID)) q:RRowID=""  d
	.d ResetVariablesResearchList
	.s TRowID=RRowID
	.s TEquipDR=$p($g(^DHCEQResearch(RRowID)),"^",1)
	.s TName=$p($g(^DHCEQResearch(RRowID)),"^",2)
	.s TType=$p($g(^DHCEQResearch(RRowID)),"^",3)
	.s TBeginDate=$p($g(^DHCEQResearch(RRowID)),"^",4)
	.s TBeginDate=##class(web.DHCEQCommon).TransValueToPage(TBeginDate,"date")
	.s TEndDate=$p($g(^DHCEQResearch(RRowID)),"^",5)
	.s TEndDate=##class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	.s TUser=$p($g(^DHCEQResearch(RRowID)),"^",6)
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TUser)
	.s TParticipant=$p($g(^DHCEQResearch(RRowID)),"^",7)
	.s TLevel=$p($g(^DHCEQResearch(RRowID)),"^",8)
	.s TRemark=$p($g(^DHCEQResearch(RRowID)),"^",9)
 	.d OutputRowResearchList
	quit
OutputRowResearchList
	s Data=$lb(TRowID,TEquipDR,TName,TType,TBeginDate,TEndDate,TUser,TParticipant,TLevel,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesResearchList
	s (TRowID,TEquipDR,TName,TType,TBeginDate,TEndDate,TUser,TParticipant,TLevel,TRemark)=""
	quit
}

ClassMethod ResearchListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResearchListExecute ]
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

ClassMethod ResearchListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResearchListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备分析项目信息
/// add by zy 2017-09-05
/// 入参：pUseContextDR:效益评价信息表的id
///      
/// 输出:	 TRowID: 
/// 			 TUseContextDR  
/// 	     TBenefitItemDR 项目ID
/// 		 TBenefitItemCode  项目代码
/// 	     TBenefitItemDesc  项目名称
/// 	     TBenefitItemMinScore  项目最低分
/// 	     TBenefitItemMaxScore  项目最高分
/// 	     TScore		项目得分
///      	 TResume 	项目简述
///      	 TRemark 	备注
///      	 THold1 
///      	 THold2 
///      	 THold3 
///      	 THold4 
///      	 THold5 
/// 使用该query的报表:附件2：功能开发、社会效益、科研教学      
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","BenefitItemInfo","1")
Query BenefitItemInfo(pUseContextDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID,TUseContextDR,TBenefitItemDR,TBenefitItemCode,TBenefitItemDesc,TBenefitItemMinScore,TBenefitItemMaxScore:%String,TScore:%String,TResume:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod BenefitItemInfoExecute(ByRef qHandle As %Binary, pUseContextDR As %String = "", HospID As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	;s ^DHCEQTemp("QW","BenefitItemInfo")=pUseContextDR
 	;if pUseContextDR="" Quit $$$OK
 	;if '$Data(^DHCEQBenefitItemInfo(0,"UseContextDR",pUseContextDR)) Quit $$$OK
	s RowID=0 
 	f  s RowID=$o(^DHCEQBenefitItemInfo(RowID)) q:RowID=""  d
	.d ResetVariablesBenefitItemInfo
	.s DataList=$g(^DHCEQBenefitItemInfo(RowID))
	.s TRowID=RowID
	.s TUseContextDR=$p(DataList,"^",1)
	.s TBenefitItemDR=$p(DataList,"^",2)
	.s TBenefitItemCode=$p($g(^DHCEQCCode("DHCEQCBenefitItem",TBenefitItemDR)),"^",1)
	.s TBenefitItemDesc=$p($g(^DHCEQCCode("DHCEQCBenefitItem",TBenefitItemDR)),"^",2)
	.s TBenefitItemMinScore=$p($g(^DHCEQCCode("DHCEQCBenefitItem",TBenefitItemDR)),"^",3)
	.s TBenefitItemMaxScore=$p($g(^DHCEQCCode("DHCEQCBenefitItem",TBenefitItemDR)),"^",4)
	.s TScore=$p(DataList,"^",3)
	.s TResume=$p(DataList,"^",4)
	.s TRemark=$p(DataList,"^",5)
	.s THold1=$p(DataList,"^",6)
	.s THold2=$p(DataList,"^",7)
	.s THold3=$p(DataList,"^",8)
	.s THold4=$p(DataList,"^",9)
	.s THold5=$p(DataList,"^",10)
 	.d OutputRowBenefitItemInfo
 	Quit $$$OK
OutputRowBenefitItemInfo
	s Data=$lb(TRowID,TUseContextDR,TBenefitItemDR,TBenefitItemCode,TBenefitItemDesc,TBenefitItemMinScore,TBenefitItemMaxScore,TScore,TResume,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBenefitItemInfo
	s (TRowID,TUseContextDR,TBenefitItemDR,TBenefitItemCode,TBenefitItemDesc,TBenefitItemMinScore,TBenefitItemMaxScore,TScore,TResume,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BenefitItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BenefitItemInfoExecute ]
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

ClassMethod BenefitItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BenefitItemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQBenefitList","GetBenefitSummary","")
Query GetBenefitSummary(pYear As %String = "", pUserDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TSummary:%String,TUserDR:%String,TUser:%String,TDate:%String,TStatus:%String,TStatusdesc:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod GetBenefitSummaryExecute(ByRef qHandle As %Binary, pYear As %String = "", pUserDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	if pYear="" quit $$$OK
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitSummary(rowid))  quit:rowid=""  d
	.s (TRowID,TYear,TSummary,TUserDR,TUser,TDate,TStatus,TStatusdesc,THold1,THold2,THold3,THold4,THold5)=""
	.s DataList=$G(^DHCEQBenefitSummary(rowid))
    .s TRowID=rowid
    .q:$p(DataList,"^",15)="Y"
    .s TYear=$p(DataList,"^",1)
    .q:(pYear'="")&&(pYear'=TYear)
    .s TSummary=$p(DataList,"^",2)
    .s TUserDR=$p(DataList,"^",3)
    .q:(pUserDR'="")&&(pUserDR'=UserDR)
    .s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
    .s TDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",4),"date")
    .s TStatus=$p(DataList,"^",5)
    .s TStatusdesc=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
    .s THold1=$p(DataList,"^",16)
    .s THold2=$p(DataList,"^",17)
    .s THold3=$p(DataList,"^",18)
    .s THold4=$p(DataList,"^",19)
    .s THold5=$p(DataList,"^",20)
	.d OutputRowBenefitSummary
	
	quit $$$OK
OutputRowBenefitSummary
	s Data=$lb(TRowID,TYear,TSummary,TUserDR,TUser,TDate,TStatus,TStatusdesc,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitSummaryExecute ]
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

ClassMethod GetBenefitSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
