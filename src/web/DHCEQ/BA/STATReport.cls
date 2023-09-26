/// add by ZY0208 2020-02-27
Class web.DHCEQ.BA.STATReport Extends (%Library.RegisteredObject, websys.Abstract, web.DHCEQCommon) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 获取一个设备一段时间内的使用数据
/// add by zy 2020-02-18
/// w ##Class(web.DHCEQ.BA.STATReport).EquipUseContext()
ClassMethod EquipUseContext(EquipDR As %String = "", Type As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	new start,end,Year,Month,MonthDate,rowid,datalist,value
	i EquipDR=""  q ""
	i $ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3) q 0
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	s end=$ZDH(EndDate_"-01",3)
	s (Year,value)=0
 	f  s Year=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year)) q:Year=""  d
 	.s Month=0
 	.f  s Month=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month)) q:Month=""  d
	..s MonthDate=$ZDH(Year_"-"_Month_"-01",3)
	..q:(start>MonthDate)||(end<MonthDate)
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month,rowid)) q:rowid=""  d
 	...s datalist=$g(^DHCEQUseContext(rowid))
 	...q:$p(datalist,"^",44)="Y"
 	...i Type="InCome" d
 	....s value=value+$p(datalist,"^",19)
 	...e  i Type="Workload"  d
 	....s value=value+$p(datalist,"^",21)
	...///modified by ZY 20221206 bug:3102745
 	...e  i Type="Positive"  d
 	....s value=value+$p(datalist,"^",22)
 	
 	q value
}

/// 获取一个设备一段时间内的消耗资源费
/// add by zy 2020-02-18
/// w ##Class(web.DHCEQ.BA.STATReport).EquipResourceFee()
ClassMethod EquipResourceFee(EquipDR As %String = "", ResourceType As %String = "", StartDate As %String = "", EndDate As %String = "")
{
	new start,end,Year,Month,MonthDate,rowid,datalist
	i EquipDR=""  q ""
	i $ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3) q 0
	i StartDate=""  d
	.s start=0
	e  d
	.s start=$ZDH(StartDate_"-01",3)
	s end=$ZDH(EndDate_"-01",3)
	
	;^DHCEQUsedResource(0,"SourceDate",{UR_Status},{UR_SourceType},{UR_SourceID},{UR_Year},{UR_Month},{UR_RowID})
	
	s (Year,value)=0
	f  s Year=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year))  q:(Year="")  d
	.s Month=0
	.f  s Month=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month)) q:Month=""  d
	..s MonthDate=$ZDH(Year_"-"_Month_"-01",3)
	..q:(start>MonthDate)||(end<MonthDate)
	..s rowid=0
	..f  s rowid=$o(^DHCEQUsedResource(0,"SourceDate",2,1,EquipDR,Year,Month,rowid))  q:rowid=""  d
	...s Find=0
	...//s UseLoc=$p($g(^DHCEQUsedResource(rowid)),"^",10)
	...//i UseLoc'=""  d
	...//.s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLoc,CTLocID,CurGroupID)
	...//q:Find'=0
	...i ResourceType'=""  d
	....s RSTDR=$p($g(^DHCEQUsedResource(rowid)),"^",5)
	....i RSTDR'="" s RSTDR=$p($g(^DHCEQCCode("DHCEQCResourceType",RSTDR)),"^",1)
	....i (RSTDR="")||($e(RSTDR,1,$l(ResourceType))'=ResourceType) s Find=1
	...q:Find'=0
	...s value=value+$p($g(^DHCEQUsedResource(rowid)),"^",9)
	q value
}

/// 取效益设备消息的基本信息
/// add by zy 2020-02-18
/// 入参：pEquipDR
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","BAEquipList")
Query BAEquipList(pEquipDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", EquipCatID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TModel:%String,TNo:%String,TStartdate:%String,TUseLoc:%String,TManuFactory:%String,TOriginalFee:%String,TTransAssetDate:%String,TPurposeType:%String,TRegistrationNo:%String,TFunds:%String,TInitYear:%String,TPreWorkLoad:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod BAEquipListExecute(ByRef qHandle As %Binary, pEquipDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", EquipCatID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	/// modified by ZY0260 20210428
 	if (EquipCatID="")&&(pEquipDR="") Quit $$$OK
 	d ##Class(web.DHCEQCommon).KillTempGlobal("BAEquipList")
 	if pEquipDR'=""
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(0,"Equip",pEquipDR,rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
 	else
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
 	
 	Quit $$$OK
BAEquipList 	
 	d ResetVariablesBAEquipList
 	s BenefitEquipListData=$g(^DHCEQBenefitEquipList(rowid))
 	s TRowID=rowid
 	s TEquipDR=$p(BenefitEquipListData,"^",1)
 	s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)		             //设备名称
 	s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)		                 //规格型号
 	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	/// modified by ZY0260 20210428
	s TEquiCatDR = $p($g(^DHCEQEquip(TEquipDR)),"^",4)
	q:(EquipCatID'="")&&(EquipCatID'=TEquiCatDR)&&(##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatID,TEquiCatDR)=0)
	
 	s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)	             //出厂编号
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
 	d OutputRowBAEquipList
 	quit
OutputRowBAEquipList
	s Data=$lb(TRowID,TEquipDR,TEquipName,TModel,TNo,TStartdate,TUseLoc,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeType,TRegistrationNo,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBAEquipList
	s (TRowID,TEquipDR,TEquipName,TModelDR,TModel,TNo,TStartdate,TUseLocDR,TUseLoc,TManuFactoryDR,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeTypeDR,TPurposeType,TRegistrationNo,Funds,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BAEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BAEquipListExecute ]
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

ClassMethod BAEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BAEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备效益分析记录
/// add by zy 2020-02-18
/// 入参：Year:YYYY    年度
///       MonthStr:YYYY-MM  年月
///       pLocDR            科室id
///       pEquipDR           设备id
/// 使用该query的报表:医疗设备科室使用评价,附件3：经济效益,附件1：设备使用情况
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","UseContextList","")
Query UseContextList(pYear As %String = "", pMonth As %String = "", pEquipDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", YearReport As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TEquipDR:%String,TExpectedSatis:%String,TActualSatis:%String,TPatientSatis:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,TTotalScore:%String,TBenefitAnalysis:%String,TUseEvaluation:%String,TBriefEvaluation:%String,TOverallEvaluation:%String,TIncome:%String,TPersonTime:%String,TActualWorkLoad:%String,TPositiveCases:%String,TRunTime:%String,TFailureTimes:%String,TMaintTimes:%String,TPMTimes:%String,TDetectionTimes:%String,TWaitingTimes:%String,TAverageWorkHour:%String,TActualWorkDays:%String,TFailureDays:%String,TUCHold1:%String,TUCHold2:%String,TUCHold3:%String,TUCHold4:%String,TUCHold5:%String") [ SqlProc ]
{
}

ClassMethod UseContextListExecute(ByRef qHandle As %Binary, pYear As %String = "", pMonth As %String = "", pEquipDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", YearReport As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s (Year,Month)=""
 	s Year=pYear
 	s Month=pMonth
 	//if Year="" Quit $$$OK
	
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
	....d BuildUseContextList
	
 	Quit $$$OK
 	
BuildUseContextList 
 	d ResetVariablesUseContextList
 	//q:$p(UseContextData,"^",44)="Y"
 	//q:$p(UseContextData,"^",45)'="2"
 	s TRowID=UCRowID
 	s TSummaryDR=$p(UseContextData,"^",1)
 	//q:(YearReport="Y")&&(TSummaryDR="") 
 	s TEquipDR=$p(UseContextData,"^",2)
 	s TYear=+$p(UseContextData,"^",3)                                   //输出统计年度
 	s TMonth=+$p(UseContextData,"^",4)                                  //输出统计月份
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
 	d OutputRowUseContextList
	quit
OutputRowUseContextList
	s Data=$lb(TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUseContextList
	s (TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)=""
 	quit
}

ClassMethod UseContextListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UseContextListExecute ]
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

ClassMethod UseContextListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UseContextListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备对应成本数据
/// add by zy 2020-02-18
/// 入参：	SourceType:		YYYY
/// 		SourceID:	YYYY-MM
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","UsedResourceList")
Query UsedResourceList(pYear As %String = "", pMonthStr As %String = "", pSourceType As %String = "", pSourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TSourceType:%String,TSourceID:%String,TResourceTypeDR:%String,TPrice:%String,TQuantity:%String,TAmount:%String,TIsInputFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod UsedResourceListExecute(ByRef qHandle As %Binary, pYear As %String = "", pMonthStr As %String = "", pSourceType As %String = "", pSourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (pSourceType="")||(pSourceID="") d
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	e  d
	.q:'$Data(^DHCEQUsedResource(0,"Source",pSourceType,pSourceID))
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(0,"Source",pSourceType,pSourceID,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	Quit $$$OK
BuildDataList
	d ResetVariablesUsedResourceList
	q:$p(DataList,"^",18)'="2"
	s TRowID = rowid	//rowid
	s TYear=$p(DataList,"^",1)
	q:(pYear'="")&&(pYear'=TYear)
	s TMonth=$p(DataList,"^",2)
	q:(pMonthStr'="")&&(pMonthStr'=TMonth)
	s TSourceType=$p(DataList,"^",3)
	s TSourceID=$p(DataList,"^",4)
	s TResourceTypeDR=$p(DataList,"^",5)
	s TPrice=$p(DataList,"^",6)
	s TQuantity=$p(DataList,"^",8)
	s TAmount=$p(DataList,"^",9)
	s TRemark=$p(DataList,"^",29)
	s TIsInputFlag=$p(DataList,"^",30)
	s THold1=$p(DataList,"^",30)
	s THold2=$p(DataList,"^",31)
	s THold3=$p(DataList,"^",32)
	s THold4=$p(DataList,"^",33)
	s THold5=$p(DataList,"^",34)
	d OutputRowUsedResourceList
	quit
OutputRowUsedResourceList
	s Data=$lb(TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUsedResourceList
	s (TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod UsedResourceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UsedResourceListExecute ]
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

ClassMethod UsedResourceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UsedResourceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 取月份内的所有月份
/// add by zy 2020-02-18
/// 使用该query来设置效益分析报表的框架
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","MonthList","2018-12","2019-11")
Query MonthList(pStartMonth As %String = "", pEndMonth As %String = "") As %Query(ROWSPEC = "TYear:%String,TMonth:%String") [ SqlProc ]
{
}

ClassMethod MonthListExecute(ByRef qHandle As %Binary, pStartMonth As %String = "", pEndMonth As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i (pStartMonth="")||(pEndMonth="") Quit $$$OK
	
	s StartDate=$ZDH(pStartMonth_"-01",3)
	s EndDate=$ZDH(pEndMonth_"-01",3)
	i StartDate>EndDate Quit $$$OK
	
	f Date=StartDate:1:EndDate  d
	.s TYear=+$E($ZD(Date,3),1,4)
	.s TMonth=+$E($ZD(Date,3),6,7)
	.d OutputRowMonthList
	.i TMonth=12  d
	..s TYear=TYear+1
	..s TMonth=1
	.e  d
	..s TMonth=TMonth+1
	.s Date=$ZDH(TYear_"-"_TMonth_"-01",3) - 1
 	Quit $$$OK
OutputRowMonthList
	s Data=$lb(TYear,TMonth)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthListExecute ]
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

ClassMethod MonthListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
