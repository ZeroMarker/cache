/// Creator:add by czf
/// CreateDate:2021-08-31
/// Descrition:效益分析图表
Class web.DHCEQ.BA.RPTEchart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by czf 2020-08-05
/// 效益分析首页图表
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	PeriodType:期间类型(YearFlag:年度 HalfYear:半年度 Quarter:季度 MonthFlag:月度)
/// 	ChartStr:界面要展示的图表串
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetBenefitAnaly("web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","124596","2021-09","2021-09","5313","409","85","MonthFlag","LocEquipNums^StatCatEquipAmount^EquipOutFeeInfo^LocInComeQoY^InComeTypeQoYRate")
ClassMethod GetBenefitAnaly(nodestr As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vPeriodType As %String = "", ChartStr As %String = "")
{
	s EQBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo(nodestr,Job,vStartDate,vEndDate,vCurUserID,vCurLocID,vCurGroupID,vPeriodType)
	s BenefitAmountInfo=$g(^TempDHCEQ(nodestr,"BenefitEQSummary",Date,Job,vCurUserID))

	;设备项效益信息
	s (OneItemEquipNums,OneItemEquipAmount,OneItemInComeInfo,OneItemOutFeeInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s OneItemBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneItemInOutRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneItemCheckPeron=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneItemExposureNum=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneItemWorkLoad=##class(web.DHCEQ.Plat.JsonObject).%New()		//工作量
	s (BenefitDetail,EQItemIDs,EQItems)=""

	s countNum=0
	s EQItemID=0
	f  s EQItemID=$o(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,vCurUserID,EQItemID)) q:EQItemID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>15		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,vCurUserID,EQItemID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,vCurUserID,EQItemID,month))
	..d GetBenefitDetail
	.;i InCome>0 s countNum=countNum+1
	.d OneItemEquipNums.%Set(EQItemID_"-0",EQNums)
	.d OneItemEquipAmount.%Set(EQItemID_"-1",OriginalFee)
	.d OneItemInComeInfo.%Set("0-"_EQItemID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))	//czf 2021-10-21
	.d OneItemOutFeeInfo.%Set("1-"_EQItemID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneItemBenefitInfo.%Set("0-"_EQItemID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))
	.d OneItemBenefitInfo.%Set("1-"_EQItemID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneItemBenefitInfo.%Set("2-"_EQItemID,##Class(web.DHCEQCommon).FormatNumber((InCome-OutFee)/10000,"",4))
	.;收支比
	.s ItemInOutRate=0
	.i +OutFee'=0 s ItemInOutRate=##Class(web.DHCEQCommon).FormatNumber(((InCome/OutFee)*100),"",2)
	.d OneItemInOutRate.%Set("0-"_EQItemID,ItemInOutRate)
	.;检查次数
	.d OneItemCheckPeron.%Set("0-"_EQItemID,CheckPerson)
	.;曝光次数
	.d OneItemExposureNum.%Set("0-"_EQItemID,ExposureNum)
	.;工作量
	.d OneItemWorkLoad.%Set("0-"_EQItemID,FactualWorkLoad)
	.s EQItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",EQItemID)
	.i EQItemIDs'="" s EQItemIDs=EQItemIDs_"^"
	.s EQItemIDs=EQItemIDs_EQItemID
	.i EQItems'="" s EQItems=EQItems_"^"
	.s EQItems=EQItems_EQItem
	
	i (("^"_ChartStr_"^")["^ItemEquipNums^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemEquipNums",EQItemIDs,EQItems,"0","数量",OneItemEquipNums,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemEquipAmount^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemEquipAmount",EQItemIDs,EQItems,"1","金额",OneItemEquipAmount,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemInComeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemInComeInfo","0","收入",EQItemIDs,EQItems,OneItemInComeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemOutFeeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemOutFeeInfo","1","支出",EQItemIDs,EQItems,OneItemOutFeeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemBenefitInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemBenefitInfo","0^1^2","收入^支出^收支差",EQItemIDs,EQItems,OneItemBenefitInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemInOutRate^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemInOutRate","0","收支比",EQItemIDs,EQItems,OneItemInOutRate,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemCheckPeron^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemCheckPeron","0","检查次数",EQItemIDs,EQItems,OneItemCheckPeron,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemExposureNum^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemExposureNum","0","曝光次数",EQItemIDs,EQItems,OneItemExposureNum,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^ItemWorkLoad^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemWorkLoad","0","工作量",EQItemIDs,EQItems,OneItemWorkLoad,EQBenefitInfo)
	
	;科室效益信息
	s (OneLocEquipAmount,OneLocInComeInfo,OneLocOutFeeInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocEquipNums=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocInOutRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocOutItemInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocInComeQoY=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocOutFeeQoY=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLocCheckPerson=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (BenefitDetail,EQLocIDs,EQLocs)=""
	
	s countNum=0
	s EQLocID=""
	f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,vCurUserID,EQLocID)) q:EQLocID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>15		//统计近15
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,vCurUserID,EQLocID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,vCurUserID,EQLocID,month))
	..d GetBenefitDetail
	.;i InCome>0 s countNum=countNum+1
	.d OneLocEquipNums.%Set(EQLocID_"-0",EQNums)
	.d OneLocEquipAmount.%Set(EQLocID_"-1",OriginalFee)
	.;收支情况、收支比
	.d OneLocInComeInfo.%Set("0-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))	//czf 2021-10-21 改为万元为单位
	.d OneLocOutFeeInfo.%Set("1-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneLocBenefitInfo.%Set("0-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))
	.d OneLocBenefitInfo.%Set("1-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneLocBenefitInfo.%Set("2-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber((InCome-OutFee)/10000,"",4))
	.s LocInOutRate=0
	.i +OutFee'=0 s LocInOutRate=##Class(web.DHCEQCommon).FormatNumber(((InCome/OutFee)*100),"",2)
	.d OneLocInOutRate.%Set("0-"_EQLocID,LocInOutRate)
	.;科室支出项统计
	.d OneLocOutItemInfo.%Set("0-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(ConsumableFee/10000,"",4))	;耗材
	.d OneLocOutItemInfo.%Set("1-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(PersonFee/10000,"",4))		;人员工资
	.d OneLocOutItemInfo.%Set("2-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(WEFee/10000,"",4))			;水电
	.d OneLocOutItemInfo.%Set("3-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(HouseFee/10000,"",4))		;房屋折旧
	.;d OneLocOutItemInfo.%Set("4-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(MaintFee/10000,"",4))		;维修
	.;d OneLocOutItemInfo.%Set("5-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(MaintainFee/10000,"",4))	;保养
	.;d OneLocOutItemInfo.%Set("6-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(InSpectFee/10000,"",4))	;检查
	.d OneLocOutItemInfo.%Set("7-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(MaintenanceFee/10000,"",4))	;维保
	.d OneLocOutItemInfo.%Set("8-"_EQLocID,##Class(web.DHCEQCommon).FormatNumber(DepreFee/10000,"",4))		;折旧
	.s vLocBenefitInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(vStartDate,vEndDate,"",EQLocID,"","","")
	.;科室收入、支出环比、同比统计
	.s LocQoQInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAQoQRate(vStartDate,vEndDate,"",EQLocID,"","","",vLocBenefitInfo,vPeriodType)
	.d OneLocInComeQoY.%Set("0-"_EQLocID,$p(LocQoQInfo,"^",1))		;环比
	.d OneLocOutFeeQoY.%Set("2-"_EQLocID,$p(LocQoQInfo,"^",2))		;环比
	.s LocYoYInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAYoYRate(vStartDate,vEndDate,"",EQLocID,"","","",vLocBenefitInfo,vPeriodType)
	.d OneLocInComeQoY.%Set("1-"_EQLocID,$p(LocYoYInfo,"^",1))		;同比
	.d OneLocOutFeeQoY.%Set("3-"_EQLocID,$p(LocYoYInfo,"^",2))		;同比
	.;科室服务人次对比
	.d OneLocCheckPerson.%Set("0-"_EQLocID,CheckPerson)	;服务人次
	.s EQLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",EQLocID)
	.i EQLocIDs'="" s EQLocIDs=EQLocIDs_"^"
	.s EQLocIDs=EQLocIDs_EQLocID
	.i EQLocs'="" s EQLocs=EQLocs_"^"
	.s EQLocs=EQLocs_EQLoc
	s ResourceTypeIDs="0^1^2^3^7^8"
	s ResourceTypes="耗材^人员经费^水电^房屋折旧^维保^折旧"
	
	i (("^"_ChartStr_"^")["^LocEquipNums^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipNums",EQLocIDs,EQLocs,"0","数量",OneLocEquipNums,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocEquipAmount^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipAmount",EQLocIDs,EQLocs,"1","金额",OneLocEquipAmount,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocInComeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocInComeInfo","0","收入",EQLocIDs,EQLocs,OneLocInComeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocOutFeeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocOutFeeInfo","1","支出",EQLocIDs,EQLocs,OneLocOutFeeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocBenefitInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocBenefitInfo","0^1^2","收入^支出^收支差",EQLocIDs,EQLocs,OneLocBenefitInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocInComeRate^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocInComeRate","0","收支比",EQLocIDs,EQLocs,OneLocInOutRate,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocOutItemInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocOutItemInfo",ResourceTypeIDs,ResourceTypes,EQLocIDs,EQLocs,OneLocOutItemInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocInComeQoY^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocInComeQoY","0^1","收入环比^收入同比",EQLocIDs,EQLocs,OneLocInComeQoY,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocOutFeeQoY^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocOutFeeQoY","2^3","支出环比^支出同比",EQLocIDs,EQLocs,OneLocOutFeeQoY,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^LocCheckPerson^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocCheckPerson","0","人次",EQLocIDs,EQLocs,OneLocCheckPerson,EQBenefitInfo)

	;设备类型效益信息
	s OneStatCatEquipAmount=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneStatCatInComeInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   
	s OneStatCatOutFeeInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   
	s OneStatCatEquipNums=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneStatCatBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneSCInOutRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	s (BenefitDetail,EQStatCatIDs,EQStatCats)=""
	s countNum=0
	s EQStatCatID=""
	f  s EQStatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,vCurUserID,EQStatCatID)) q:EQStatCatID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.;q:countNum>10		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,vCurUserID,EQStatCatID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,vCurUserID,EQStatCatID,month))
	..d GetBenefitDetail
	.d OneStatCatEquipNums.%Set(EQStatCatID_"-0",EQNums)
	.d OneStatCatEquipAmount.%Set(EQStatCatID_"-1",##Class(web.DHCEQCommon).FormatNumber(OriginalFee/10000,"",4))	//czf 2021-10-21 改为万元计
	.d OneStatCatInComeInfo.%Set("0-"_EQStatCatID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))
	.d OneStatCatOutFeeInfo.%Set("1-"_EQStatCatID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneStatCatBenefitInfo.%Set("0-"_EQStatCatID,##Class(web.DHCEQCommon).FormatNumber(InCome/10000,"",4))
	.d OneStatCatBenefitInfo.%Set("1-"_EQStatCatID,##Class(web.DHCEQCommon).FormatNumber(OutFee/10000,"",4))
	.d OneStatCatBenefitInfo.%Set("2-"_EQStatCatID,##Class(web.DHCEQCommon).FormatNumber((InCome-OutFee)/10000,"",4))
	.s SCInOutRate=0
	.i +OutFee'=0 s SCInOutRate=##Class(web.DHCEQCommon).FormatNumber(((InCome/OutFee)*100),"",2)
	.d OneSCInOutRate.%Set("0-"_EQStatCatID,SCInOutRate)
	.s EQStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",EQStatCatID)
	.i EQStatCatIDs'="" s EQStatCatIDs=EQStatCatIDs_"^"
	.s EQStatCatIDs=EQStatCatIDs_EQStatCatID
	.i EQStatCats'="" s EQStatCats=EQStatCats_"^"
	.s EQStatCats=EQStatCats_EQStatCat
	
	i (("^"_ChartStr_"^")["^StatCatEquipNums^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatEquipNums",EQStatCatIDs,EQStatCats,"0","数量",OneStatCatEquipNums,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^StatCatEquipAmount^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatEquipAmount",EQStatCatIDs,EQStatCats,"1","金额",OneStatCatEquipAmount,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^StatCatInComeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatInComeInfo","0","收入",EQStatCatIDs,EQStatCats,OneStatCatInComeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^StatCatOutFeeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatOutFeeInfo","1","支出",EQStatCatIDs,EQStatCats,OneStatCatOutFeeInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^StatCatBenefitInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatBenefitInfo","0^1^2","收入^支出^收支差",EQStatCatIDs,EQStatCats,OneStatCatBenefitInfo,EQBenefitInfo)
	i (("^"_ChartStr_"^")["^StatCatInOutRate^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatInOutRate","0","收支比",EQStatCatIDs,EQStatCats,OneSCInOutRate,EQBenefitInfo)
	
	;设备分类效益信息
	i (("^"_ChartStr_"^")[("EquipCat"))
	{
		s (OneEquipCatEquipNums,OneEquipCatEquipAmount,OneEquipCatInComeInfo,OneEquipCatOutFeeInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		s OneEquipCatBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
		s (BenefitDetail,EquipCatIDs,EquipCats)=""
		s countNum=0
		s EquipCatID=""
		f  s EquipCatID=$o(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,vCurUserID,EquipCatID)) q:EquipCatID=""  d
		.d ResetBenefitDetail
		.s countNum=countNum+1
		.q:countNum>10		//统计近10
		.s month=""
		.f  s month=$o(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,vCurUserID,EquipCatID,month)) q:month=""  d
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,vCurUserID,EquipCatID,month))
		..d GetBenefitDetail
		.d OneEquipCatEquipNums.%Set(EquipCatID_"-0",EQNums)
		.d OneEquipCatEquipAmount.%Set(EquipCatID_"-1",OriginalFee)
		.d OneEquipCatInComeInfo.%Set("0-"_EquipCatID,InCome)
		.d OneEquipCatOutFeeInfo.%Set("1-"_EquipCatID,OutFee)
		.d OneEquipCatBenefitInfo.%Set("0-"_EquipCatID,InCome)
		.d OneEquipCatBenefitInfo.%Set("1-"_EquipCatID,OutFee)
		.s EquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",EquipCatID)
		.i EquipCatIDs'="" s EquipCatIDs=EquipCatIDs_"^"
		.s EquipCatIDs=EquipCatIDs_EquipCatID
		.i EquipCats'="" s EquipCats=EquipCats_"^"
		.s EquipCats=EquipCats_EquipCat
		
		d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipCatEquipNums",EquipCatIDs,EquipCats,"0","数量",OneEquipCatEquipNums,EQBenefitInfo)
		d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipCatEquipAmount",EquipCatIDs,EquipCats,"1","金额",OneEquipCatEquipAmount,EQBenefitInfo)
		d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipCatInComeInfo","0","收入",EquipCatIDs,EquipCats,OneEquipCatInComeInfo,EQBenefitInfo)
		d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipCatOutFeeInfo","1","支出",EquipCatIDs,EquipCats,OneEquipCatOutFeeInfo,EQBenefitInfo)
		d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipCatBenefitInfo","0^1","收入^支出",EquipCatIDs,EquipCats,OneEquipCatBenefitInfo,EQBenefitInfo)
	}
	;全院各项支出统计
	;		1						2					3					4					5					6				7					8					9					10						11						12				13					14					15				16					17					18						19				20						21				22				23					24				25				26				27				28				29					30						31						32						33
	;FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount_"^"_OtherIncomeAmount_"^"_OutIncomeAmount_"^"_InIncomeAmount_"^"_EmergencyAmount_"^"_NewBornAmount_"^"_HealthAmount_"^"_PerDayInCome_"^"_PerDayOutFee_"^"_InOutRate_"^"_CheckPerson_"^"_ExposureNum_"^"_InComeChainRatio_"^"_OutFeeChainRatio_"^"_InComeYearOnYearRate_"^"_OutFeeYearOnYearRate_"^"_PerDayCheckPerson
	s OneOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
	/*
	s ResourceTypeID=0
	f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)) q:ResourceTypeID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",4)="Y"
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",2)
	.s ResourceCode=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
	.i ResourceCode="14" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",4))	;耗材
	.i ResourceCode="01" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",5))	;人员工资
	.i ResourceCode="03" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",16))	;水
	.i ResourceCode="04" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",17))	;电
	.i ResourceCode="06" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",7))	;房屋折旧
	.i ResourceCode="07" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",8))	;维修
	.i ResourceCode="09" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",9))	;保养
	.i ResourceCode="10" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",10))	;检查
	.i ResourceCode="08" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",11))	;维保
	.i ResourceCode="05" d OneOutFeeAmountInfo.%Set("1-"_ResourceTypeID,$p(BenefitAmountInfo,"^",12))	;折旧
	.i ResourceTypeIDs'="" s ResourceTypeIDs=ResourceTypeIDs_"^"
	.s ResourceTypeIDs=ResourceTypeIDs_ResourceTypeID
	.i ResourceTypes'="" s ResourceTypes=ResourceTypes_"^"
	.s ResourceTypes=ResourceTypes_ResourceType
	*/
	//改为汇总输出 czf 2021-10-08
	s CurConsumeAmount=$p(BenefitAmountInfo,"^",4)+$p(BenefitAmountInfo,"^",34)+$p(BenefitAmountInfo,"^",35)	//资源消耗+服务项消耗+消耗性材料
	s CurPersonAmount=$p(BenefitAmountInfo,"^",5)+$p(BenefitAmountInfo,"^",36)		//工资+培训
	s CurMaintainceAmount=$p(BenefitAmountInfo,"^",8)+$p(BenefitAmountInfo,"^",9)+$p(BenefitAmountInfo,"^",10)+$p(BenefitAmountInfo,"^",11)+$p(BenefitAmountInfo,"^",37)+$p(BenefitAmountInfo,"^",38)	//总维保费=维保费+维修费+保养+计量+检查+质控费
	
	d OneOutFeeAmountInfo.%Set("1-1",##Class(web.DHCEQCommon).FormatNumber(CurConsumeAmount/10000,"",4))		//耗材
	d OneOutFeeAmountInfo.%Set("1-2",##Class(web.DHCEQCommon).FormatNumber(CurPersonAmount/10000,"",4))			//人工费
	d OneOutFeeAmountInfo.%Set("1-3",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",6)/10000,"",4))		//水电
	d OneOutFeeAmountInfo.%Set("1-4",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",7)/10000,"",4))		//房屋折旧
	d OneOutFeeAmountInfo.%Set("1-5",##Class(web.DHCEQCommon).FormatNumber(CurMaintainceAmount/10000,"",4))	//维保
	d OneOutFeeAmountInfo.%Set("1-6",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",12)/10000,"",4))	//折旧
	s ResourceTypeIDs="1^2^3^4^5^6"
	s ResourceTypes="耗材^人员经费^水电^房屋折旧^维保^折旧"
	 
	i (("^"_ChartStr_"^")["^EquipOutFeeInfo^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipOutFeeInfo","1","支出",ResourceTypeIDs,ResourceTypes,OneOutFeeAmountInfo,EQBenefitInfo)
	
	;全院设备支出项同比、环比
	s OneEquipOutFeeQOY=##class(web.DHCEQ.Plat.JsonObject).%New()
	;同比
	s LastYOYSPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,vStartDate)
	s LastYOYEPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,vEndDate)
	s LastYOYRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastYOYSPeriod,LastYOYEPeriod,"","","","","")
	
	s (ComsumeFeeYoYRate,PersonFeeYoYRate,WFeeYoYRate,HouseDepreYoYRate,MaintainFeeYoYRate,DepreFeeYoYRate)=0
	s LastYoYComsumeAmount=$p(LastYOYRtnStr,"^",4)+$p(LastYOYRtnStr,"^",29)+$p(LastYOYRtnStr,"^",30)
	s LastYoYPersonFee=$p(LastYOYRtnStr,"^",5)+$p(LastYOYRtnStr,"^",31)
	s LastYoYMaintainceAmount=$p(LastYOYRtnStr,"^",8)+$p(LastYOYRtnStr,"^",9)+$p(LastYOYRtnStr,"^",10)+$p(LastYOYRtnStr,"^",11)+$p(LastYOYRtnStr,"^",32)+$p(LastYOYRtnStr,"^",33)

	i LastYoYComsumeAmount'=0 s ComsumeFeeYoYRate=##Class(web.DHCEQCommon).FormatNumber(((CurConsumeAmount-LastYoYComsumeAmount)/$ZABS(LastYoYComsumeAmount)*100),"",2)
	i LastYoYPersonFee'=0 s PersonFeeYoYRate=##Class(web.DHCEQCommon).FormatNumber(((CurPersonAmount-LastYoYPersonFee)/$ZABS(LastYoYPersonFee)*100),"",2)
	i +$p(LastYOYRtnStr,"^",6)'=0 s WFeeYoYRate=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",6)-$p(LastYOYRtnStr,"^",6))/$ZABS($p(LastYOYRtnStr,"^",6))*100),"",2)
	i +$p(LastYOYRtnStr,"^",7)'=0 s HouseDepreYoYRate=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",7)-$p(LastYOYRtnStr,"^",7))/$ZABS($p(LastYOYRtnStr,"^",7))*100),"",2)
	i LastYoYMaintainceAmount'=0 s MaintainFeeYoYRate=##Class(web.DHCEQCommon).FormatNumber(((CurMaintainceAmount-LastYoYMaintainceAmount)/$ZABS(LastYoYMaintainceAmount)*100),"",2)
	i +$p(LastYOYRtnStr,"^",12)'=0 s DepreFeeYoYRate=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",12)-$p(LastYOYRtnStr,"^",12))/$ZABS($p(LastYOYRtnStr,"^",12))*100),"",2)
	
	d OneEquipOutFeeQOY.%Set("0-1",ComsumeFeeYoYRate)
	d OneEquipOutFeeQOY.%Set("0-2",PersonFeeYoYRate)
	d OneEquipOutFeeQOY.%Set("0-3",WFeeYoYRate)
	d OneEquipOutFeeQOY.%Set("0-4",HouseDepreYoYRate)
	d OneEquipOutFeeQOY.%Set("0-5",MaintainFeeYoYRate)
	d OneEquipOutFeeQOY.%Set("0-6",DepreFeeYoYRate)
	
	;环比
	s PeriodDate=##class(web.DHCEQ.BA.RPTCommon).GetPeriodDate(vStartDate,vEndDate,vPeriodType)
	s LastQOQRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr($p(PeriodDate,"^",1),$p(PeriodDate,"^",2),"","","","","")
	s (ComsumeFeeRatio,PersonFeeRatio,WFeeRatio,HouseDepreRatio,MaintainFeeRatio,DepreFeeRatio)=0
	s LastQOQComsumeAmount=$p(LastQOQRtnStr,"^",4)+$p(LastQOQRtnStr,"^",29)+$p(LastQOQRtnStr,"^",30)
	s LastQOQPersonFee=$p(LastQOQRtnStr,"^",5)+$p(LastQOQRtnStr,"^",31)
	s LastQOQMaintainceAmount=$p(LastQOQRtnStr,"^",8)+$p(LastQOQRtnStr,"^",9)+$p(LastQOQRtnStr,"^",10)+$p(LastQOQRtnStr,"^",11)+$p(LastQOQRtnStr,"^",32)+$p(LastQOQRtnStr,"^",33)
	
	i LastQOQComsumeAmount'=0 s ComsumeFeeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurConsumeAmount-LastQOQComsumeAmount)/$ZABS(LastQOQComsumeAmount)*100),"",2)
	i LastQOQPersonFee'=0 s PersonFeeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurPersonAmount-LastQOQPersonFee)/$ZABS(LastQOQPersonFee)*100),"",2)
	i +$p(LastQOQRtnStr,"^",6)'=0 s WFeeRatio=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",6)-$p(LastQOQRtnStr,"^",6))/$ZABS($p(LastQOQRtnStr,"^",6))*100),"",2)
	i +$p(LastQOQRtnStr,"^",7)'=0 s HouseDepreRatio=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",7)-$p(LastQOQRtnStr,"^",7))/$ZABS($p(LastQOQRtnStr,"^",7))*100),"",2)
	i LastQOQMaintainceAmount'=0 s MaintainFeeRatio=##Class(web.DHCEQCommon).FormatNumber(((CurMaintainceAmount-LastQOQMaintainceAmount)/$ZABS(LastQOQMaintainceAmount)*100),"",2)
	i +$p(LastQOQRtnStr,"^",12)'=0 s DepreFeeRatio=##Class(web.DHCEQCommon).FormatNumber((($p(BenefitAmountInfo,"^",12)-$p(LastQOQRtnStr,"^",12))/$ZABS($p(LastQOQRtnStr,"^",12))*100),"",2)
	
	d OneEquipOutFeeQOY.%Set("2-1",ComsumeFeeRatio)
	d OneEquipOutFeeQOY.%Set("2-2",PersonFeeRatio)
	d OneEquipOutFeeQOY.%Set("2-3",WFeeRatio)
	d OneEquipOutFeeQOY.%Set("2-4",HouseDepreRatio)
	d OneEquipOutFeeQOY.%Set("2-5",MaintainFeeRatio)
	d OneEquipOutFeeQOY.%Set("2-6",DepreFeeRatio)

	i (("^"_ChartStr_"^")["^EquipOutFeeQOY^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipOutFeeQOY","0^2","同比^环比",ResourceTypeIDs,ResourceTypes,OneEquipOutFeeQOY,EQBenefitInfo)
	
	;收入类别统计
	s InComeTypeInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (InComeTypeIDs,InComeTypes)=""
	d InComeTypeInfo.%Set("1-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",18)/10000,"",4))	;其他
	d InComeTypeInfo.%Set("2-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",19)/10000,"",4))	;门诊
	d InComeTypeInfo.%Set("3-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",20)/10000,"",4))	;住院
	d InComeTypeInfo.%Set("4-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",21)/10000,"",4))	;急诊
	d InComeTypeInfo.%Set("5-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",22)/10000,"",4))	;新生儿
	d InComeTypeInfo.%Set("6-0",##Class(web.DHCEQCommon).FormatNumber($p(BenefitAmountInfo,"^",23)/10000,"",4))	;体检
	s InComeTypeIDs="1^2^3^4^5^6"
	s InComeTypes="其他^门诊^住院^急诊^新生儿^体检"
	
	i (("^"_ChartStr_"^")["^InComeTypeAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("InComeTypeAnaly",InComeTypeIDs,InComeTypes,"0","收入来源",InComeTypeInfo,EQBenefitInfo)
	
	;收入类别环比、同比分析
	s InComeTypeQoYRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s InComeTypeQoQInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAQoQRate(vStartDate,vEndDate,"","","","","",BenefitAmountInfo,vPeriodType)
	d InComeTypeQoYRate.%Set("0-1",$p(InComeTypeQoQInfo,"^",3))	;其他环比
	d InComeTypeQoYRate.%Set("0-2",$p(InComeTypeQoQInfo,"^",4))	;门诊环比
	d InComeTypeQoYRate.%Set("0-3",$p(InComeTypeQoQInfo,"^",5))	;住院环比
	d InComeTypeQoYRate.%Set("0-4",$p(InComeTypeQoQInfo,"^",6))	;急诊环比
	d InComeTypeQoYRate.%Set("0-5",$p(InComeTypeQoQInfo,"^",7))	;新生儿环比
	d InComeTypeQoYRate.%Set("0-6",$p(InComeTypeQoQInfo,"^",8))	;体检环比
	
	s InComeTypeYoYInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBAYoYRate(vStartDate,vEndDate,"","","","","",BenefitAmountInfo,vPeriodType)
	d InComeTypeQoYRate.%Set("1-1",$p(InComeTypeYoYInfo,"^",3))	;其他同比
	d InComeTypeQoYRate.%Set("1-2",$p(InComeTypeYoYInfo,"^",4))	;门诊同比
	d InComeTypeQoYRate.%Set("1-3",$p(InComeTypeYoYInfo,"^",5))	;住院同比
	d InComeTypeQoYRate.%Set("1-4",$p(InComeTypeYoYInfo,"^",6))	;急诊同比
	d InComeTypeQoYRate.%Set("1-5",$p(InComeTypeYoYInfo,"^",7))	;新生儿同比
	d InComeTypeQoYRate.%Set("1-6",$p(InComeTypeYoYInfo,"^",8))	;体检同比

	i (("^"_ChartStr_"^")["^InComeTypeQoYRate^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("InComeTypeQoYRate","0^1","环比^同比",InComeTypeIDs,InComeTypes,InComeTypeQoYRate,EQBenefitInfo)
	
	;收入类别服务人次分析

	;效益分析汇总信息
	s EQCount=$p(BenefitAmountInfo,"^",15)
	s EQAmount=$p(BenefitAmountInfo,"^",14)
	s InComeAmount=$p(BenefitAmountInfo,"^",3)
	s OutFeeAmount=$p(BenefitAmountInfo,"^",13)
	s PerDayInCome=$p(BenefitAmountInfo,"^",24)
	s PerDayOutFee=$p(BenefitAmountInfo,"^",25)
	s PersonNum=$p(BenefitAmountInfo,"^",27)	//总服务人次
	s ExposureNum=$p(BenefitAmountInfo,"^",28)
	s InComeChaiaRatio=$p(BenefitAmountInfo,"^",29)
	s OutFeeChainRatio=$p(BenefitAmountInfo,"^",30)
	s InComeYearOnYearRate=$p(BenefitAmountInfo,"^",31)
	s OutFeeYearOnYearRate=$p(BenefitAmountInfo,"^",32)
	s PerDayCheckPerson=$p(BenefitAmountInfo,"^",33)	//日均服务人次

	;效益分析卡片信息
	s BAEQNumAmountStr="<div><span>资产数量</span><span>"_EQCount_"</span><span>台</span></div><div><span>资产金额</span><span>"_##Class(web.DHCEQCommon).FormatNumber(EQAmount/10000,"",4)_"</span><span>万元</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQNumAmount","","","","",BAEQNumAmountStr,EQBenefitInfo)
	
	s BAInComeAmountStr="<div><span>总收入</span><span>"_##Class(web.DHCEQCommon).FormatNumber(InComeAmount/10000,"",4)_"</span><span>万元</span></div><div><span>总支出</span><span>"_##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount/10000,"",4)_"</span><span>万元</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAInOutAmount","","","","",BAInComeAmountStr,EQBenefitInfo)

	s BAInComePerDayStr="<div><span>日均收入</span><span>"_##Class(web.DHCEQCommon).FormatNumber(PerDayInCome/10000,"",4)_"</span><span>万元</span></div><div><span>日均支出</span><span>"_##Class(web.DHCEQCommon).FormatNumber(PerDayOutFee/10000,"",4)_"</span><span>万元</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAInOutPerDay","","","","",BAInComePerDayStr,EQBenefitInfo)
	
	s BAInOutQoQStr="<div><span style='float:left'>收入环比</span><span style='float:right'>"_InComeChaiaRatio_"</span></div><div><span style='float:left'>支出同比</span><span style='float:right'>"_OutFeeChainRatio_"</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAInOutQoQ","","","","",BAInOutQoQStr,EQBenefitInfo)

	s BAInOutYoYStr="<div><span style='float:left'>收入同比</span><span style='float:right'>"_InComeYearOnYearRate_"</span></div><div><span style='float:left'>支出同比</span><span style='float:right'>"_OutFeeYearOnYearRate_"</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAInOutYoY","","","","",BAInOutYoYStr,EQBenefitInfo)
	
	s BACheckPersonStr="<div><span>服务人次</span><span>"_PersonNum_"</span><span>人次</span></div><div><span>日均人次</span><span>"_PerDayCheckPerson_"</span><span>人次</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BACheckPerson","","","","",BACheckPersonStr,EQBenefitInfo)
		
	q EQBenefitInfo
	
ResetBenefitDetail
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee,InOutDiffer,InOutRate,CheckPerson,ExposureNum,PositiveNum,PositiveRate,ExposureRate)=0
	quit
	
GetBenefitDetail
	s FactualWorkLoad=FactualWorkLoad+$p(BenefitDetail,"^",1)
	s WorkLoadPerMonth=WorkLoadPerMonth+$p(BenefitDetail,"^",2)
	s InCome=InCome+$p(BenefitDetail,"^",3)
	s ConsumableFee=ConsumableFee+$p(BenefitDetail,"^",4)
	s PersonFee=PersonFee+$p(BenefitDetail,"^",5)
	s WEFee=WEFee+$p(BenefitDetail,"^",6)
	s HouseFee=HouseFee+$p(BenefitDetail,"^",7)
	s MaintFee=MaintFee+$p(BenefitDetail,"^",8)
	s MaintainFee=MaintainFee+$p(BenefitDetail,"^",9)
	s InSpectFee=InSpectFee+$p(BenefitDetail,"^",10)
	s MaintenanceFee=MaintenanceFee+$p(BenefitDetail,"^",11)
	s DepreFee=DepreFee+$p(BenefitDetail,"^",12)
	s OutFee=OutFee+$p(BenefitDetail,"^",13)
	s OriginalFee=$p(BenefitDetail,"^",14)
	s EQNums=$p(BenefitDetail,"^",15)
	s WaterFee=WaterFee+$p(BenefitDetail,"^",15)
	s ElectricFee=ElectricFee+$p(BenefitDetail,"^",16)
	s CheckPerson=CheckPerson+$p(BenefitDetail,"^",24)
	s ExposureNum=ExposureNum+$p(BenefitDetail,"^",25)
	s PositiveNum=PositiveNum+$p(BenefitDetail,"^",26)
	i +CheckPerson'=0 d
	.s PositiveRate=##Class(web.DHCEQCommon).FormatNumber((PositiveNum/CheckPerson)*100,"",2)
	.;s ExposureRate=##Class(web.DHCEQCommon).FormatNumber((ExposureNum/CheckPerson)*100,"",2)
	s InOutDiffer=InCome-OutFee		//收支差
	i +OutFee'=0 s InOutRate=##Class(web.DHCEQCommon).FormatNumber((InCome/OutFee)*100,"",2)	//收支比
	
	quit
}

/// czf 2021-09-22
/// 获取近5年效益信息
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetLatelyYearsBA("web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","19616","78")
ClassMethod GetLatelyYearsBA(nodestr As %String = "", vJob As %String = "", vCurUserID As %String = "")
{
	//s ^tempczf("ded")=$lb(nodestr,vJob,vCurUserID)
	i nodestr="" q ""
	i vJob="" s vJob=$J
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^TempDHCEQ(nodestr,vJob,vCurUserID)
	
	s ChartObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s Date=+$h
	s CurYear=$p($zd(Date,3),"-",1)
	f Year=(CurYear-4):1:CurYear d		//近5年
	.s StartDate=Year_"-01"
	.s EndDate=Year_"-12"
	.s YearBenefitInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(StartDate,EndDate,"","","","","")
	.s YearInCome=$p(YearBenefitInfo,"^",3)
	.s YearOutFee=$p(YearBenefitInfo,"^",13)
	.s YearCheckPerson=$p(YearBenefitInfo,"^",27)
	.s Profit=YearInCome-YearOutFee
	.s ^TempDHCEQ(nodestr,vJob,vCurUserID,Year)=YearInCome_"^"_YearOutFee_"^"_Profit_"^"_YearCheckPerson
	
	s OneHospLatelyInOut=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneHospInOutYOYRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneHospLatelyOutFee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneLatelyCheckPerson=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (YearIDs,Years)=""
	
	s countnum=0
	s Year=0
	f  s Year=$o(^TempDHCEQ(nodestr,vJob,vCurUserID,Year)) q:Year=""  d
	.s YearBenefitInfo=$g(^TempDHCEQ(nodestr,vJob,vCurUserID,Year))
	.s YearInCome=$p(YearBenefitInfo,"^",1)
	.s YearOutFee=$p(YearBenefitInfo,"^",2)
	.s YearProfit=$p(YearBenefitInfo,"^",3)
	.s YearCheckPerson=$p(YearBenefitInfo,"^",4)
	.s LastYearBAInfo=$g(^TempDHCEQ(nodestr,vJob,vCurUserID,Year-1))
	.i LastYearBAInfo="" d
	..s LastYearBAInfo=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr((Year-1)_"-01",(Year-1)_"-12","","","","","")
	.s LastYearProfit=$p(LastYearBAInfo,"^",3)
	.s YearOnYearRate=0
	.i +LastYearProfit'=0 s YearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(((YearProfit-LastYearProfit)/$ZABS(LastYearProfit))*100,"",2)
	.s countnum=countnum+1
	.d OneHospLatelyInOut.%Set("0-"_countnum,##Class(web.DHCEQCommon).FormatNumber(YearProfit/10000,"",4))	//czf 2021-10-21
	.d OneHospInOutYOYRate.%Set("0-"_countnum,YearOnYearRate)
	.d OneHospLatelyOutFee.%Set("0-"_countnum,##Class(web.DHCEQCommon).FormatNumber(YearOutFee/10000,"",4))	//czf 2021-11-23
	.d OneLatelyCheckPerson.%Set("0-"_countnum,YearCheckPerson)
	.i YearIDs'="" s YearIDs=YearIDs_"^"
	.s YearIDs=YearIDs_countnum
	.i Years'="" s Years=Years_"^"
	.s Years=Years_Year
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LatelyInOut","0","近年效益统计",YearIDs,Years,OneHospLatelyInOut,ChartObj)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LatelyInOutYOYRate","0","近年效益同比",YearIDs,Years,OneHospInOutYOYRate,ChartObj)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LatelyOutFee","0","近年总支出统计",YearIDs,Years,OneHospLatelyOutFee,ChartObj)	//czf 2021-11-23
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LatelyCheckPerson","0","近年总支出统计",YearIDs,Years,OneLatelyCheckPerson,ChartObj)	//czf 2021-11-23
	q ChartObj
}

/// czf 2020-08-07
/// 获取科室效益分析明细信息
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	PeriodType:期间类型(YearFlag:年度 HalfYear:半年度 Quarter:季度 MonthFlag:月度)
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetLocBenefit("3396","2020-01","2020-08","12214","202","85","2")
ClassMethod GetLocBenefit(nodestr As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vLocDR As %String = "")
{
	s LocBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="")||(vLocDR="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo(nodestr,Job,vStartDate,vEndDate,vCurUserID,vCurLocID,vCurGroupID)
	
	s OnePerMonthLocInCome=##class(web.DHCEQ.Plat.JsonObject).%New() 
	s OnePerMonthLocOutFee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OnePerMonthLocBenefit=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OnePerMonthLocWorkLoad=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	s (BenefitDetail,MonthIDs,MonthStrs)=""
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee)=0
	s (ConsumeMaterialFee,ServeConsumeFee,TrainFee,MeasureFee,QualityControlFee)=0
	s countNum=0
	s Month=""
	f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,vCurUserID,vLocDR,Month)) q:Month=""  d
	.s countNum=countNum+1
	.s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,vCurUserID,vLocDR,Month))
	.s FactualWorkLoad=$p(BenefitDetail,"^",1)
	.s WorkLoadPerMonth=$p(BenefitDetail,"^",2)
	.s InCome=$p(BenefitDetail,"^",3)	//每月收入
	.s ConsumableFee=ConsumableFee+$p(BenefitDetail,"^",4)
	.s ConsumeMaterialFee=ConsumeMaterialFee+$p(BenefitDetail,"^",27)
	.s ServeConsumeFee=ServeConsumeFee+$p(BenefitDetail,"^",28)
	.s PersonFee=PersonFee+$p(BenefitDetail,"^",5)
	.s TrainFee=TrainFee+$p(BenefitDetail,"^",29)
	.s WEFee=WEFee+$p(BenefitDetail,"^",6)
	.s HouseFee=HouseFee+$p(BenefitDetail,"^",7)
	.s MaintFee=MaintFee+$p(BenefitDetail,"^",8)
	.s MaintainFee=MaintainFee+$p(BenefitDetail,"^",9)
	.s InSpectFee=InSpectFee+$p(BenefitDetail,"^",10)
	.s MeasureFee=MeasureFee+$p(BenefitDetail,"^",30)
	.s QualityControlFee=QualityControlFee+$p(BenefitDetail,"^",31)
	.s MaintenanceFee=MaintenanceFee+$p(BenefitDetail,"^",11)
	.s DepreFee=DepreFee+$p(BenefitDetail,"^",12)
	.s OutFee=$p(BenefitDetail,"^",13)		//每月支出
	.s OriginalFee=$p(BenefitDetail,"^",14)
	.s EQNums=$p(BenefitDetail,"^",15)
	.s WaterFee=WaterFee+$p(BenefitDetail,"^",16)
	.s ElectricFee=ElectricFee+$p(BenefitDetail,"^",17)
	.d OnePerMonthLocInCome.%Set("0-"_countNum,InCome)
	.d OnePerMonthLocOutFee.%Set("1-"_countNum,OutFee)
	.d OnePerMonthLocWorkLoad.%Set("2-"_countNum,FactualWorkLoad)		//实际工作量
	.;d OnePerMonthLocWorkLoad.%Set("3-"_countNum,WorkLoadPerMonth)		//预计工作量
	.d OnePerMonthLocBenefit.%Set("0-"_countNum,InCome)
	.d OnePerMonthLocBenefit.%Set("1-"_countNum,OutFee)
	.d OnePerMonthLocBenefit.%Set("2-"_countNum,InCome-OutFee)
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_Month
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthInCome","0","收入",MonthIDs,MonthStrs,OnePerMonthLocInCome,LocBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthOutFee","1","支出",MonthIDs,MonthStrs,OnePerMonthLocOutFee,LocBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthFacWorkLoad","2","实际工作量",MonthIDs,MonthStrs,OnePerMonthLocWorkLoad,LocBenefitInfo)	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthBenefit","0^1^2","收入^支出^收支差",MonthIDs,MonthStrs,OnePerMonthLocBenefit,LocBenefitInfo)
	
	;科室各项支出统计
	s OneLocOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
	/*
	s ResourceTypeID=0
	f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)) q:ResourceTypeID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",4)="Y"
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",2)
	.s ResourceCode=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
	.i ResourceCode="14" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,ConsumableFee)
	.i ResourceCode="01" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,PersonFee)
	.i ResourceCode="03" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,WaterFee)
	.i ResourceCode="04" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,ElectricFee)
	.i ResourceCode="06" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,HouseFee)
	.i ResourceCode="07" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,MaintFee)
	.i ResourceCode="09" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,MaintainFee)
	.i ResourceCode="10" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,InSpectFee)
	.i ResourceCode="08" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,MaintenanceFee)
	.i ResourceCode="05" d OneLocOutFeeAmountInfo.%Set("1-"_ResourceTypeID,DepreFee)
	.i ResourceTypeIDs'="" s ResourceTypeIDs=ResourceTypeIDs_"^"
	.s ResourceTypeIDs=ResourceTypeIDs_ResourceTypeID
	.i ResourceTypes'="" s ResourceTypes=ResourceTypes_"^"
	.s ResourceTypes=ResourceTypes_ResourceType 
	*/
	//改为汇总输出 czf 2021-10-08
	d OneLocOutFeeAmountInfo.%Set("1-1",ConsumableFee+ConsumeMaterialFee+ServeConsumeFee)	//耗材
	d OneLocOutFeeAmountInfo.%Set("1-2",PersonFee+TrainFee)	//人员经费
	d OneLocOutFeeAmountInfo.%Set("1-3",WEFee)				//水电
	d OneLocOutFeeAmountInfo.%Set("1-4",HouseFee)			//房屋折旧
	d OneLocOutFeeAmountInfo.%Set("1-5",MaintenanceFee+MaintFee+MaintainFee+InSpectFee+MeasureFee+QualityControlFee)	//维保
	d OneLocOutFeeAmountInfo.%Set("1-6",DepreFee)			//折旧
	
	s ResourceTypeIDs="1^2^3^4^5^6"
	s ResourceTypes="耗材^人员经费^水电^房屋折旧^维保^折旧"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipOutFeeInfo","1","支出",ResourceTypeIDs,ResourceTypes,OneLocOutFeeAmountInfo,LocBenefitInfo)
	
	q LocBenefitInfo
}

/// czf 2020-08-07
/// 获取设备类型效益分析明细信息
/// w ##class(web.DHCEQ.BA.RPTEchart).GetStatCatBenefit("web.DHCEQ.BA.RPTEchart_StatGetBenefitAnaly","30856","2019-01","2019-12","12214","202","78","7")
ClassMethod GetStatCatBenefit(nodestr As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vStatCatDR As %String = "")
{
	s StatCatBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="")||(vStatCatDR="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo(nodestr,Job,vStartDate,vEndDate,vCurUserID,vCurLocID,vCurGroupID)
	
	s OnePerMonthSCInCome=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OnePerMonthSCOutFee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OnePerMonthSCWorkLoad=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OnePerMonthSCBenefit=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	s (BenefitDetail,MonthIDs,MonthStrs)=""
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee)=0
	s (ConsumeMaterialFee,ServeConsumeFee,TrainFee,MeasureFee,QualityControlFee)=0
	
	s countNum=0
	s Month=""
	f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,vCurUserID,vStatCatDR,Month)) q:Month=""  d
	.s countNum=countNum+1
	.s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,vCurUserID,vStatCatDR,Month))
	.s FactualWorkLoad=$p(BenefitDetail,"^",1)
	.s WorkLoadPerMonth=$p(BenefitDetail,"^",2)
	.s InCome=$p(BenefitDetail,"^",3)	//每月收入
	.s ConsumableFee=ConsumableFee+$p(BenefitDetail,"^",4)
	.s ConsumeMaterialFee=ConsumeMaterialFee+$p(BenefitDetail,"^",27)
	.s ServeConsumeFee=ServeConsumeFee+$p(BenefitDetail,"^",28)
	.s PersonFee=PersonFee+$p(BenefitDetail,"^",5)
	.s TrainFee=TrainFee+$p(BenefitDetail,"^",29)
	.s WEFee=WEFee+$p(BenefitDetail,"^",6)
	.s HouseFee=HouseFee+$p(BenefitDetail,"^",7)
	.s MaintFee=MaintFee+$p(BenefitDetail,"^",8)
	.s MaintainFee=MaintainFee+$p(BenefitDetail,"^",9)
	.s InSpectFee=InSpectFee+$p(BenefitDetail,"^",10)
	.s MeasureFee=MeasureFee+$p(BenefitDetail,"^",30)
	.s QualityControlFee=QualityControlFee+$p(BenefitDetail,"^",31)
	.s MaintenanceFee=MaintenanceFee+$p(BenefitDetail,"^",11)
	.s DepreFee=DepreFee+$p(BenefitDetail,"^",12)
	.s OutFee=$p(BenefitDetail,"^",13)		//每月支出
	.s OriginalFee=$p(BenefitDetail,"^",14)
	.s EQNums=$p(BenefitDetail,"^",15)
	.s WaterFee=WaterFee+$p(BenefitDetail,"^",16)
	.s ElectricFee=ElectricFee+$p(BenefitDetail,"^",17)
	.d OnePerMonthSCInCome.%Set("0-"_countNum,InCome)
	.d OnePerMonthSCOutFee.%Set("1-"_countNum,OutFee)
	.d OnePerMonthSCWorkLoad.%Set("2-"_countNum,FactualWorkLoad)		//实际工作量
	.;d OnePerMonthSCWorkLoad.%Set("3-"_countNum,WorkLoadPerMonth)		//预计工作量
	.d OnePerMonthSCBenefit.%Set("0-"_countNum,InCome)
	.d OnePerMonthSCBenefit.%Set("1-"_countNum,OutFee)
	.d OnePerMonthSCBenefit.%Set("2-"_countNum,InCome-OutFee)
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_Month
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthInCome","0","收入",MonthIDs,MonthStrs,OnePerMonthSCInCome,StatCatBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthOutFee","1","支出",MonthIDs,MonthStrs,OnePerMonthSCOutFee,StatCatBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthFacWorkLoad","2","实际工作量",MonthIDs,MonthStrs,OnePerMonthSCWorkLoad,StatCatBenefitInfo)	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthBenefit","0^1^2","收入^支出^收支差",MonthIDs,MonthStrs,OnePerMonthSCBenefit,StatCatBenefitInfo)
	
	;类型各项支出统计
	s OneSCOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
	/*
	s ResourceTypeID=0
	f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)) q:ResourceTypeID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",4)="Y"
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",2)
	.s ResourceCode=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
	.i ResourceCode="14" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",ConsumableFee)
	.i ResourceCode="01" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",PersonFee)
	.i ResourceCode="03" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",WaterFee)
	.i ResourceCode="04" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",ElectricFee)
	.i ResourceCode="06" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",HouseFee)
	.i ResourceCode="07" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",MaintFee)
	.i ResourceCode="09" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",MaintainFee)
	.i ResourceCode="10" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",InSpectFee)
	.i ResourceCode="08" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",MaintenanceFee)
	.i ResourceCode="05" d OneSCOutFeeAmountInfo.%Set(ResourceTypeID_"-1",DepreFee)
	.i ResourceTypeIDs'="" s ResourceTypeIDs=ResourceTypeIDs_"^"
	.s ResourceTypeIDs=ResourceTypeIDs_ResourceTypeID
	.i ResourceTypes'="" s ResourceTypes=ResourceTypes_"^"
	.s ResourceTypes=ResourceTypes_ResourceType 
	*/
	//改为汇总输出 czf 2021-10-08
	d OneSCOutFeeAmountInfo.%Set("1-1",ConsumableFee+ConsumeMaterialFee+ServeConsumeFee)		//耗材
	d OneSCOutFeeAmountInfo.%Set("2-1",PersonFee+TrainFee)	//人员工资=人员工资+培训费
	d OneSCOutFeeAmountInfo.%Set("3-1",WEFee)				//水电
	d OneSCOutFeeAmountInfo.%Set("4-1",HouseFee)			//房屋折旧
	d OneSCOutFeeAmountInfo.%Set("5-1",MaintenanceFee+MaintFee+MaintainFee+InSpectFee+MeasureFee+QualityControlFee)		//维保
	d OneSCOutFeeAmountInfo.%Set("6-1",DepreFee)			//折旧
	s ResourceTypeIDs="1^2^3^4^5^6"
	s ResourceTypes="耗材^人员经费^水电^房屋折旧^维保^折旧"
	;饼图
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCEquipOutFeeInfo",ResourceTypeIDs,ResourceTypes,"1","支出",OneSCOutFeeAmountInfo,StatCatBenefitInfo)
	
	q StatCatBenefitInfo
}

/// czf 2020-09-19
/// 获取设备效益分析信息，^TempDHCEQ(nodestr,"EquipBenefitSummary",Date,Job,CurUserID)记录设备汇总效益信息
/// w ##class(web.DHCEQ.BA.RPTEchart).GetEquipBenefit("web.DHCEQ.BA.RPTEchart_GetEquipBenefit","2660","2019-01","2019-12","12214","202","85","13383")
ClassMethod GetEquipBenefit(nodestr As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vEquipDR As %String = "")
{
	//s ^tempczf("dea")=$lb(nodestr,vJob,vStartDate,vEndDate,vCurUserID,vCurLocID,vCurGroupID,vEquipDR)
	i vEquipDR="" q ""
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	i $o(^DHCEQBenefitEquipList(0,"Equip",vEquipDR,""))="" q ""		//非效益分析设备
	
	;调用方法将数据存储在临时global中	
	;d ##Class(web.DHCEQ.BA.RPTCommon).GetBenefitAnalyInfo(nodestr,Job,vStartDate,vEndDate,vCurUserID,vCurLocID,vCurGroupID)
	
	s (FactualWorkLoadAmount,WorkLoadAmount,InComeAmount,ConsumableFeeAmount,PersonFeeAmount,WaterFeeAmount,ElectricFeeAmount,WEFeeAmount,HouseFeeAmount,MaintFeeAmount,MaintainFeeAmount,InSpectFeeAmount,MaintenanceFeeAmount,DepreFeeAmount,OutFeeAmount,InComeAmount,NumAmount,OriginalFeeAmount)=0
 	s (DaysNum,OtherIncomeAmount,OtherIncomeAmount,OutIncomeAmount,InIncomeAmount,EmergencyAmount,NewBornAmount,HealthAmount,PerDayInCome,PerDayOutFee,InOutRate,CheckPerson,ExposureNum,PerDayCheckPerson)=0
	s (PositiveAmount,PositiveRate,FixedCostAmount,VariableCostAmount)=0
	s (ServeConsumeAmount,ConsumeMaterialAmount,TrainFeeAmount,MeasureFeeAmount,QualityControlAmount)=0		//czf 2021-11-04
	s countNum=0
	s (MonthIDs,MonthStrs)=""
	s EquipBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthInOut=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthWorkLoad=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthCheckPerson=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthExposure=##class(web.DHCEQ.Plat.JsonObject).%New()
	//Modify by zx 2021-09-23
	s OneEQMonthServiceIncome=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthMaterialIncome=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthMaintFee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthFeeOfEmployee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneEQMonthMaterialFee=##class(web.DHCEQ.Plat.JsonObject).%New()
	s DaysNum=##Class(web.DHCEQCommon).GetMonthDateNum(vStartDate,vEndDate,"1")
	
	s rowid=vEquipDR
	s vStart=$ZDH(vStartDate_"-01",3)
	s vEnd=$ZDH(vEndDate_"-01",3)
	f ID=vStart:1:vEnd  d
	.s TMonth=$E($ZD(ID,3),1,7)
	.s TFactualWorkLoad=+##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	.s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	.s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)	//标准使用率
	.s TUseRate=0
	.i TWorkLoadPerMonth'=0  s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	.s TIncomeInfo=##Class(web.DHCEQ.BA.RPTCommon).AllInCome(rowid,TMonth,TMonth,"",vCurLocID,vCurGroupID)
	.s TInCome=+$p(TIncomeInfo,"^",1)		;总收入
	.s TOtherIncome=+$p(TIncomeInfo,"^",2)	;其他收入
	.s TOutIncome=+$p(TIncomeInfo,"^",3)	;门诊收入
	.s TInIncome=+$p(TIncomeInfo,"^",4)		;住院收入
	.s TEmergencyIncome=+$p(TIncomeInfo,"^",5)	;急诊收入
	.s TNewBornIncome=+$p(TIncomeInfo,"^",6)	;
	.s THealthIncome=+$p(TIncomeInfo,"^",7)	;体检收入
	.s TCheckPerson=+$p(TIncomeInfo,"^",8)		;人次
	.s TExposureNum=+$p(TIncomeInfo,"^",9)		;曝光次数
	.s TPositiveNum=+$p(TIncomeInfo,"^",10)	;阳性例数
	.s TWorkLoadNum=+$p(TIncomeInfo,"^",12)	;工作量
	.s TServeConsumeFee=+$p(TIncomeInfo,"^",11)	;服务项使用消耗
	.i DaysNum=0 s TPerDayIncome=0
	.e  s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/DaysNum,"",2)	;日均收入
	.s TResourceInfo=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth,nodestr,Job,vCurUserID)
	.s TConsumeMaterialFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"13"))	//消耗性材料
	.s TConsumableFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"14"))		//资源消耗耗材费
	.s TSumConsumableFee=TConsumableFee+TConsumeMaterialFee+TServeConsumeFee				//总耗材=耗材费+消耗性材料+服务项消耗
	.s TPersonFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"01"))		//人员工资
	.s TTrainFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"02"))			//培训费
	.s TPersonnelCost=TPersonFee+TTrainFee		//人员经费
	.s TWaterFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"03"))			//水费
	.s TElectricFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"04"))		//电费
	.s TWEFee=TWaterFee+TElectricFee	//水电
	.s THouseFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"06"))			//房屋折旧
	.s TMaintFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"07"))			//维修
	.i TMaintFee=0 s TMaintFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"31", "",vCurLocID,vCurGroupID)
	.s TMaintainFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"09"))		//保养
	.i TMaintainFee=0 s TMaintainFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"32", "",vCurLocID,vCurGroupID)
	.s TInSpectFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"10"))		//检查
	.i TInSpectFee=0 s TInSpectFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",vCurLocID,vCurGroupID,"4")
	.s TMeasureFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"11"))		//计量费
	.s TMeasureFee=0 s TMeasureFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",vCurLocID,vCurGroupID,"5")
	.s TQualityControlFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"12"))	//质控费
	.s TMaintenanceFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"08"))	//维保费	
	.s TSumMaintenanceFee=TMaintenanceFee+TMaintFee+TMaintainFee+TInSpectFee+TMeasureFee+TQualityControlFee	//维保费=资源消耗维保费+维修费+保养+计量+检查+质控费
	.s TDepreFee=+$g(^TempDHCEQ(nodestr,"EQResource",Date,Job,vCurUserID,"05"))			//折旧费
	.i TDepreFee=0 s TDepreFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"35", "",vCurLocID,vCurGroupID)
	.s TEquipResourceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth,"",Job,vCurUserID)	//总资源费
	.s TOutFee=TSumConsumableFee+TPersonnelCost+TWEFee+THouseFee+TSumMaintenanceFee+TDepreFee	//总支出=耗材费+人员经费+水电+房屋折旧+维保费+折旧费
	.i DaysNum=0 s TPerDayOutFee=0
	.e  s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/DaysNum,"",2)	;日均支出
	.;s (TConsumableRate,TPersonRate,TWERate,TMaintRate,TMaintainRate,TInSpectRate,TDepreRate,THouseRate,TInOutRate,TPositiveRate)=0
	.;i TOutFee'=0  d
	..;s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	..;s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	..;s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	..;s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	..;s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	..;s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	..;s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	..;s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	..;s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)		//收支比
	.i +TWorkLoadNum'=0 s TPositiveRate=##Class(web.DHCEQCommon).FormatNumber(TPositiveNum/TWorkLoadNum,"",2)	;阳性率
	.s vYear=$E($ZD(ID,3),1,4)
	.s vMonth=$E($ZD(ID,3),6,7)
	.i vMonth=12  d
	..s vYear=vYear+1
	..s vMonth=1
	.e  d
	..s vMonth=vMonth+1
	.s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	.s FactualWorkLoadAmount=FactualWorkLoadAmount+TFactualWorkLoad
	.s WorkLoadAmount=WorkLoadAmount+TWorkLoadNum
	.s InComeAmount=InComeAmount+TInCome
	.s OtherIncomeAmount=OtherIncomeAmount+TOtherIncome
	.s OutIncomeAmount=OutIncomeAmount+TOutIncome
	.s InIncomeAmount=InIncomeAmount+TInIncome
	.s EmergencyAmount=EmergencyAmount+TEmergencyIncome
	.s NewBornAmount=NewBornAmount+TNewBornIncome
	.s HealthAmount=HealthAmount+THealthIncome
	.s CheckPerson=CheckPerson+TCheckPerson
	.s ExposureNum=ExposureNum+TExposureNum
	.s ServeConsumeAmount=ServeConsumeAmount+TServeConsumeFee	//服务项消耗
	.s ConsumeMaterialAmount=ConsumeMaterialAmount+TConsumeMaterialFee	//消耗性材料
	.s ConsumableFeeAmount=ConsumableFeeAmount+TConsumableFee	//资源消耗
	.s PersonFeeAmount=PersonFeeAmount+TPersonFee				//人工工资
	.s TrainFeeAmount=TrainFeeAmount+TTrainFee					//培训费
	.s WaterFeeAmount=WaterFeeAmount+TWaterFee
	.s ElectricFeeAmount=ElectricFeeAmount+TElectricFee
	.s WEFeeAmount=WEFeeAmount+TWEFee					//水电
	.s HouseFeeAmount=HouseFeeAmount+THouseFee			//房屋折旧
	.s MaintFeeAmount=MaintFeeAmount+TMaintFee			//维修
	.s MaintainFeeAmount=MaintainFeeAmount+TMaintainFee	//保养
	.s InSpectFeeAmount=InSpectFeeAmount+TInSpectFee	//巡检
	.s MeasureFeeAmount=MeasureFeeAmount+TMeasureFee	//计量
	.s QualityControlAmount=QualityControlAmount+TQualityControlFee	//质控费
	.s MaintenanceFeeAmount=MaintenanceFeeAmount+TMaintenanceFee	//维保费
	.s DepreFeeAmount=DepreFeeAmount+TDepreFee
	.s OutFeeAmount=OutFeeAmount+TOutFee
	.s FixedCostAmount=FixedCostAmount+TPersonnelCost+TWEFee+THouseFee+TDepreFee	//固定成本=人员经费+水电费+房屋折旧+折旧
	.s VariableCostAmount=VariableCostAmount+TSumConsumableFee+TSumMaintenanceFee  //变动成本=总耗材+总维保费
	.s PositiveAmount=PositiveAmount+TPositiveNum		;阳性例数
	.s countNum=countNum+1
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_TMonth
	.;//Modify by zx 2021-09-23 预期数据
	.s TEconCalcInfo=##class(web.DHCEQ.BA.RPTCommon).GetEconCalc(rowid,$e(TMonth,1,4))
	.s TEconCalcWorkLoadNum=$p(TEconCalcInfo,"^",1)  	//预测工作量
	.s TEconCalcServiceIncome=$p(TEconCalcInfo,"^",2)  	//预测检查收入
	.s TEconCalcMaterialIncome=$p(TEconCalcInfo,"^",3)  //预测材料收入
	.s TEconCalcMaintFee=$p(TEconCalcInfo,"^",4)  		//预测维修费
	.s TEconCalcFeeOfEmployee=$p(TEconCalcInfo,"^",5)  	//预测人员费
	.s TEconCalcMaterialFee=$p(TEconCalcInfo,"^",6)		//预计耗材费
	.;资产收支统计
	.d OneEQMonthInOut.%Set("0-"_countNum,TInCome)
	.d OneEQMonthInOut.%Set("1-"_countNum,TOutFee)
	.d OneEQMonthInOut.%Set("2-"_countNum,TInCome-TOutFee)
	.;检查人次统计
	.d OneEQMonthCheckPerson.%Set("0-"_countNum,TCheckPerson)
	.;曝光次数统计
	.d OneEQMonthExposure.%Set("0-"_countNum,TExposureNum)
	.;工作量统计
	.d OneEQMonthWorkLoad.%Set("0-"_countNum,TFactualWorkLoad)
	.d OneEQMonthWorkLoad.%Set("1-"_countNum,TEconCalcWorkLoadNum)
	.;检查收入
	.d OneEQMonthServiceIncome.%Set("0-"_countNum,TInCome)
	.d OneEQMonthServiceIncome.%Set("1-"_countNum,TEconCalcServiceIncome)
	.;耗材收入
	.d OneEQMonthMaterialIncome.%Set("0-"_countNum,0)
	.d OneEQMonthMaterialIncome.%Set("1-"_countNum,TEconCalcMaterialIncome)
	.;维修费
	.d OneEQMonthMaintFee.%Set("0-"_countNum,TMaintFee)
	.d OneEQMonthMaintFee.%Set("1-"_countNum,TEconCalcMaintFee)
	.;人员经费
	.d OneEQMonthFeeOfEmployee.%Set("0-"_countNum,TPersonFee+TTrainFee) //czf 20211104
	.d OneEQMonthFeeOfEmployee.%Set("1-"_countNum,TEconCalcFeeOfEmployee)
	.;耗材费
	.d OneEQMonthMaterialFee.%Set("0-"_countNum,TSumConsumableFee)		//czf 20211104
	.d OneEQMonthMaterialFee.%Set("1-"_countNum,TEconCalcMaterialFee)
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQMonthInOut","0^1^2","收入^支出^收支差",MonthIDs,MonthStrs,OneEQMonthInOut,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQMonthWorkLoad","0^1","实际工作量^预计工作量",MonthIDs,MonthStrs,OneEQMonthWorkLoad,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQMonthCheckPerson","0","检查人次",MonthIDs,MonthStrs,OneEQMonthCheckPerson,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQMonthExposure","0","曝光次数",MonthIDs,MonthStrs,OneEQMonthExposure,EquipBenefitInfo)
	
	//Modify by zx 2021-09-23 预期-实际对比
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("CompareServiceIncome","0^1","实际检查收入^预计检查收入",MonthIDs,MonthStrs,OneEQMonthServiceIncome,EquipBenefitInfo)
	//d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("CompareMaterialIncome","0^1","实际耗材收入^预计耗材收入",MonthIDs,MonthStrs,OneEQMonthMaterialIncome,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("CompareMaintFee","0^1","实际维修费^预计维修费",MonthIDs,MonthStrs,OneEQMonthMaintFee,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("CompareFeeOfEmployee","0^1","实际人员费^预计人员费",MonthIDs,MonthStrs,OneEQMonthFeeOfEmployee,EquipBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("CompareMaterialFee","0^1","实际耗材费^预计耗材费",MonthIDs,MonthStrs,OneEQMonthMaterialFee,EquipBenefitInfo)
	
	;投资收益率
	s OriginalFee=$p(^DHCEQEquip(rowid),"^",27)
	s LimitYearsNum=$p(^DHCEQEquip(rowid),"^",31)
	s interval=##Class(web.DHCEQCommon).DateDiff("yyyy",$zd($zdh(vStartDate_"-01",3),1),$zd($zdh(vEndDate_"-01",3),1))+1
	s interval=interval/12
	s Profits=InComeAmount-OutFeeAmount
	s InvestBenefitRate=0
	s PaybackTime=LimitYearsNum		//回收期初始默认为使用年限
	i (Profits>0)&&(OriginalFee>0) s InvestBenefitRate=((Profits/interval)/OriginalFee)*100
	i +InvestBenefitRate'=0 Set PaybackTime=100/InvestBenefitRate
	s InvestBenefitRate=##Class(web.DHCEQCommon).FormatNumber(InvestBenefitRate,"",2)	;投资收益率
	s PaybackTime=##Class(web.DHCEQCommon).FormatNumber(PaybackTime,"",2)		;投资回收期
	
	;资产卡片信息
	i +WorkLoadAmount'=0 s PositiveRate=##Class(web.DHCEQCommon).FormatNumber((PositiveAmount/WorkLoadAmount)*100,"",2)
	s BAInOutStr="<div><span>总收入</span><span style='width:45%'>"_InComeAmount_"</span><span style='width:10%'>元</span></div><div><span>总支出</span><span style='width:45%'>"_OutFeeAmount_"</span><span style='width:10%'>元</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQInOutAmount","","","","",BAInOutStr,EquipBenefitInfo)
	
	s BACheckPersonStr="<div><span>服务人次</span><span>"_CheckPerson_"</span><span>人次</span></div><div><span>投资收益率</span><span>"_InvestBenefitRate_"</span><span>%</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQCheckPerson","","","","",BACheckPersonStr,EquipBenefitInfo)

	s BAWorkStr="<div><span style='float:left'>工作量</span><span style='float:right;margin-right:4px;'>"_FactualWorkLoadAmount_"</span></div><div><span style='float:left'>阳性率</span><span style='float:right;margin-right:4px;'>"_PositiveRate_"%"_"</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQWorkAmount","","","","",BAWorkStr,EquipBenefitInfo)
	
	s BACostStr="<div><span>固定成本</span><span style='width:45%'>"_FixedCostAmount_"</span><span style='width:10%'>元</span></div><div><span>变动成本</span><span style='width:45%'>"_VariableCostAmount_"</span><span style='width:10%'>元</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQCostAmount","","","","",BACostStr,EquipBenefitInfo)
	
	s MaintNum=##class(web.DHCEQ.EM.BUSMMaintRequest).GetEQMaintRequestNum(vEquipDR,vStartDate,vEndDate)
	s MaintenanceNum=##class(web.DHCEQ.EM.BUSMaint).GetEQMaintNum(vEquipDR,vStartDate,vEndDate)
	s BAMaintStr="<div><span>维修次数</span><span style='width:46%'>"_MaintNum_"</span><span style='width:9%'>次</span></div><div><span>维保次数</span><span style='width:46%'>"_MaintenanceNum_"</span><span style='width:9%'>次</span></div>"
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BAEQMaintAmount","","","","",BAMaintStr,EquipBenefitInfo)
	
	;固定成本分布
	s OneEQFixedCost=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (ResourceTypeIDs,ResourceTypes)=""
	s ResourceTypeID=0
	f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)) q:ResourceTypeID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",4)="Y"
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",2)
	.s ResourceCode=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
	.i ResourceCode="01" d OneEQFixedCost.%Set(ResourceTypeID_"-0",PersonFeeAmount)		//人员工资
	.i ResourceCode="02" d OneEQFixedCost.%Set(ResourceTypeID_"-0",TrainFeeAmount)		//培训费
	.i ResourceCode="03" d OneEQFixedCost.%Set(ResourceTypeID_"-0",WaterFeeAmount)		//水费
	.i ResourceCode="04" d OneEQFixedCost.%Set(ResourceTypeID_"-0",ElectricFeeAmount)	//电费
	.i ResourceCode="06" d OneEQFixedCost.%Set(ResourceTypeID_"-0",HouseFeeAmount)		//房屋折旧
	.i ResourceCode="05" d OneEQFixedCost.%Set(ResourceTypeID_"-0",DepreFeeAmount)		//折旧费
	.i ResourceTypeIDs'="" s ResourceTypeIDs=ResourceTypeIDs_"^"
	.s ResourceTypeIDs=ResourceTypeIDs_ResourceTypeID
	.i ResourceTypes'="" s ResourceTypes=ResourceTypes_"^"
	.s ResourceTypes=ResourceTypes_ResourceType
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQFixedCost",ResourceTypeIDs,ResourceTypes,"0","固定成本",OneEQFixedCost,EquipBenefitInfo)
	
	;变动成本分布
	s OneEQVariableCost=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (ResourceTypeIDs,ResourceTypes)=""
	s ResourceTypeID=0
	f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)) q:ResourceTypeID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",4)="Y"
	.s ResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",2)
	.s ResourceCode=$p($g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID)),"^",1)
	.i ResourceCode="07" d OneEQVariableCost.%Set(ResourceTypeID_"-1",MaintFeeAmount)		//维修
	.i ResourceCode="09" d OneEQVariableCost.%Set(ResourceTypeID_"-1",MaintainFeeAmount)	//保养
	.i ResourceCode="10" d OneEQVariableCost.%Set(ResourceTypeID_"-1",InSpectFeeAmount)		//巡检
	.i ResourceCode="11" d OneEQVariableCost.%Set(ResourceTypeID_"-1",MeasureFeeAmount)		//计量
	.i ResourceCode="12" d OneEQVariableCost.%Set(ResourceTypeID_"-1",QualityControlAmount)	//质控
	.i ResourceCode="13" d OneEQVariableCost.%Set(ResourceTypeID_"-1",ConsumeMaterialAmount)	//消耗性材料
	.i ResourceCode="14" d OneEQVariableCost.%Set(ResourceTypeID_"-1",ConsumableFeeAmount+ServeConsumeAmount)	//耗材费=资源消耗耗材+服务项消耗
	.i ResourceCode="08" d OneEQVariableCost.%Set(ResourceTypeID_"-1",MaintenanceFeeAmount)	//维护
	.i ResourceTypeIDs'="" s ResourceTypeIDs=ResourceTypeIDs_"^"
	.s ResourceTypeIDs=ResourceTypeIDs_ResourceTypeID
	.i ResourceTypes'="" s ResourceTypes=ResourceTypes_"^"
	.s ResourceTypes=ResourceTypes_ResourceType
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EQVariableCost",ResourceTypeIDs,ResourceTypes,"1","变动成本",OneEQVariableCost,EquipBenefitInfo)
	
	;近年同期收益比
	
	//s ^TempDHCEQ(nodestr,"EquipBenefitSummary",Date,Job,vCurUserID)=FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount_"^"_OtherIncomeAmount_"^"_OutIncomeAmount_"^"_InIncomeAmount_"^"_EmergencyAmount_"^"_NewBornAmount_"^"_HealthAmount_"^"_PerDayInCome_"^"_PerDayOutFee_"^"_InOutRate_"^"_CheckPerson_"^"_ExposureNum_"^"_InComeChainRatio_"^"_OutFeeChainRatio_"^"_InComeYearOnYearRate_"^"_OutFeeYearOnYearRate_"^"_PerDayCheckPerson
	
	q EquipBenefitInfo
}

/// add by czf 20200808
/// 获取临时global数据
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetTempInfo("web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","LocBenefit","","25032","12214","2","")
ClassMethod GetTempInfo(node1 As %String = "", node2 As %String = "", Date As %String = "", Job As %String = "", vCurUserID As %String = "", SourceID As %String = "", vMonth As %String = "")
{
	i Date="" s Date=+$h
	i Job="" q ""
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	i node1="web.DHCEQ.BA.RPTEchart_GetBenefitAnaly"
	{
		i node2="BenefitEQSummary"
		{
			q $g(^TempDHCEQ(node1,node2,Date,Job,vCurUserID))
		}
		else
		{
			s (DaysNum,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TWaterFee,TElectricFee,TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TCheckPerson,TExposureNum,TPerDayPersonNum)=0
			i SourceID="" q ""
			s month=""
			f  s month=$o(^TempDHCEQ(node1,node2,Date,Job,vCurUserID,SourceID,month)) q:month=""  d
			.q:(vMonth'="")&&(vMonth'=month)
			.s DaysNum=DaysNum+##class(web.DHCEQCommon).GetMonthEndDate(month,"1")
			.s BenefitDetail=$g(^TempDHCEQ(node1,node2,Date,Job,vCurUserID,SourceID,month))
			.s TFactualWorkLoad=TFactualWorkLoad+$p(BenefitDetail,"^",1)
			.s TWorkLoadPerMonth=TWorkLoadPerMonth+$p(BenefitDetail,"^",2)
			.s TInCome=TInCome+$p(BenefitDetail,"^",3)
			.s TConsumableFee=TConsumableFee+$p(BenefitDetail,"^",4)
			.s TPersonFee=TPersonFee+$p(BenefitDetail,"^",5)
			.s TWEFee=TWEFee+$p(BenefitDetail,"^",6)
			.s THouseFee=THouseFee+$p(BenefitDetail,"^",7)
			.s TMaintFee=TMaintFee+$p(BenefitDetail,"^",8)
			.s TMaintainFee=TMaintainFee+$p(BenefitDetail,"^",9)
			.s TInSpectFee=TInSpectFee+$p(BenefitDetail,"^",10)
			.s TMaintenanceFee=TMaintenanceFee+$p(BenefitDetail,"^",11)
			.s TDepreFee=TDepreFee+$p(BenefitDetail,"^",12)
			.s TOutFee=TOutFee+$p(BenefitDetail,"^",13)
			.s TOriginalAmount=$p(BenefitDetail,"^",14)
			.s TEQNum=$p(BenefitDetail,"^",15)
			.s TWaterFee=TWaterFee+$p(BenefitDetail,"^",16)
			.s TElectricFee=TElectricFee+$p(BenefitDetail,"^",17)
			.s TOtherIncome=TOtherIncome+$p(BenefitDetail,"^",18)			//其他收入
			.s TOutIncome=TOutIncome+$p(BenefitDetail,"^",19)				//门诊收入
			.s TInIncome=TInIncome+$p(BenefitDetail,"^",20)					//住院收入
			.s TEmergencyIncome=TEmergencyIncome+$p(BenefitDetail,"^",21)	//急诊收入
			.s TNewBornIncome=TNewBornIncome+$p(BenefitDetail,"^",22)		//新生儿
			.s THealthIncome=THealthIncome+$p(BenefitDetail,"^",23)			//体检收入
			.s TCheckPerson=TCheckPerson+$p(BenefitDetail,"^",27)			//人次
			.s TExposureNum=TExposureNum+$p(BenefitDetail,"^",28)			//曝光次数
			
			i DaysNum'=0 d
			.s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/DaysNum,"",2)	//日均收入
			.s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/DaysNum,"",2)		//日均支出
			.s TPerDayPersonNum=##Class(web.DHCEQCommon).FormatNumber(TCheckPerson/DaysNum,"",2)	//日均服务人次
			i TOutFee'=0 s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)	//收支比
			q TFactualWorkLoad_"^"_TWorkLoadPerMonth_"^"_TInCome_"^"_TConsumableFee_"^"_TPersonFee_"^"_TWEFee_"^"_THouseFee_"^"_TMaintFee_"^"_TMaintainFee_"^"_TInSpectFee_"^"_TMaintenanceFee_"^"_TDepreFee_"^"_TOutFee_"^"_TOriginalAmount_"^"_TEQNum_"^"_TWaterFee_"^"_TElectricFee_"^"_TOtherIncome_"^"_TOutIncome_"^"_TInIncome_"^"_TEmergencyIncome_"^"_TNewBornIncome_"^"_THealthIncome_"^"_TPerDayIncome_"^"_TPerDayOutFee_"^"_TInOutRate_"^"_TCheckPerson_"^"_TExposureNum_"^"_TPerDayPersonNum
		}
	}
}

/// add by ZY0271 20210918
/// 根据医生开单阳性例数算阳性率
/// 参数说明： vData 	可为空 "^DoctorDR=1^RequestDeptDR="  
/// 		   NodeStr	不能为空
/// w ##Class(web.DHCEQ.BA.RPTEchart).DoctorPositiveRate("","DoctorPositiveRate^65988,62871^1532")
ClassMethod DoctorPositiveRate(vData As %String = "", Node As %String = "", Job As %String = "")
{
	s DoctorPositiveRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	i Node="" q ""
	s CurTime=+$h
	i Job="" s Job=$J
	s NodeStr=Node_"^"_CurTime_"^"_Job
	k ^TempDHCEQ(Node)
 	s result=##Class(web.DHCEQ.BA.RPTCommon).GetDoctorPositiveNum(vData,NodeStr)
 	i result'=0 q ""
	
	s OneDoctorPositiveRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (DoctorDRs,Doctors)=""
	s TDoctoreDR=0
	f  s TDoctoreDR=$o(^TempDHCEQ(Node,CurTime,Job,TDoctoreDR))  q:TDoctoreDR=""  d
	.s (TmpDataList,TDoctore,TWorkLoadNum,TPositiveNum,TPositiveRate)=""
	.s TmpDataList=$g(^TempDHCEQ(Node,CurTime,Job,TDoctoreDR))
	.s TDoctore=##Class(web.DHCEQCommon).GetTrakNameByID("user",TDoctoreDR)
	.s TWorkLoadNum=+$p(TmpDataList,"^",1)
	.s TPositiveNum=+$p(TmpDataList,"^",2)
	.s TPositiveRate=""
	.i TWorkLoadNum>0 s TPositiveRate=##Class(web.DHCEQCommon).FormatNumber(TPositiveNum/TWorkLoadNum,"")
	.s TPositiveRate=##Class(web.DHCEQCommon).FormatNumber($Random(100)/100,"")
	.d OneDoctorPositiveRate.%Set("1-"_TDoctoreDR,TPositiveRate)	;阳性例数
	.i DoctorDRs'="" s DoctorDRs=DoctorDRs_"^"
	.s DoctorDRs=DoctorDRs_TDoctoreDR
	.i Doctors'="" s Doctors=Doctors_"^"
	.s Doctors=Doctors_TDoctore
	
	k ^TempDHCEQ(Node,CurTime,Job)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("DoctorPositiveRate","1","阳性率",DoctorDRs,Doctors,OneDoctorPositiveRate,DoctorPositiveRate)
	
	q DoctorPositiveRate
}

/// add by ZY0271 20210918
/// 统计同一天同内每个病人平均用时
/// 参数说明： vData 	不能为空,只能查一个设备一段时间内的数据 "^EquipID=13382^StartDate=2019-01-01^EndDate=2019-01-10"  
/// 		   NodeStr	不能为空,用于临时golable的节点 "Node^$H^Job" 	"DoctorPositiveRate^65988,62871^1532"
/// w ##Class(web.DHCEQ.BA.RPTEchart).PersonTimes("^EquipID=13383^StartDate=2019-01-01^EndDate=2019-12-28","web.DHCEQ.BA.RPTEchart_PersonTimes","2660")
ClassMethod PersonTimes(vData As %String = "", Node As %String = "", Job As %String = "")
{
	s ChartObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	i Node="" q ""
	s CurTime=+$h
	i Job="" s Job=$J
	s NodeStr=Node_"^"_CurTime_"^"_Job
	k ^TempDHCEQ(Node)
	
 	s result=##Class(web.DHCEQ.BA.RPTCommon).GetPersonTimes(vData,NodeStr)
 	i result'=0 q ""
	
	s SeriesDataObjPatientNum=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SeriesDataObjAvgTime=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	s countNum=0
	s (MonthIDs,MonthStrs)=""
	s TMonth=0
	f  s TMonth=$o(^TempDHCEQ(Node,CurTime,Job,TMonth)) Q:TMonth=""  d
	.s (totalPersonTime,PatientNum)=0  //modfied by wy 2021-10-13
	.s vDate=0
	.f  s vDate=$o(^TempDHCEQ(Node,CurTime,Job,TMonth,vDate)) Q:vDate=""  d
	..s PatientID=""
	..f  s PatientID=$o(^TempDHCEQ(Node,CurTime,Job,TMonth,vDate,PatientID)) Q:PatientID=""  d
	...s OnePersonTime=$g(^TempDHCEQ(Node,CurTime,Job,TMonth,vDate,PatientID))
	...s totalPersonTime=totalPersonTime+OnePersonTime	//月扫描时长
	...s PatientNum=PatientNum+1		//月就诊病人数(同一天同一病人算一个人)
	.s countNum=countNum+1
	.s AvgTime=0
	.i PatientNum>0 s AvgTime=##Class(web.DHCEQCommon).FormatNumber(totalPersonTime/PatientNum,"")
	.d SeriesDataObjPatientNum.%Set("1-"_countNum,PatientNum)
	.d SeriesDataObjAvgTime.%Set("1-"_countNum,AvgTime)
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_TMonth
	
	k ^TempDHCEQ(Node,CurTime,Job)	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("PatientNum","1","患者数量",MonthIDs,MonthStrs,SeriesDataObjPatientNum,ChartObj)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("AvgTime","1","平均扫描时长",MonthIDs,MonthStrs,SeriesDataObjAvgTime,ChartObj)
	
	q ChartObj
}

/// Add by czf 2021-09-20
/// 获取同类设备效益信息
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetSameEQBAChart("web.DHCEQ.BA.RPTEchart_GetSameEQBAChart","263","","2019-01","2019-12","","12214","202","85")
ClassMethod GetSameEQBAChart(nodestr As %String = "", vItemDR As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "")
{
	s SameEQBAInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	i (nodestr="")||(vItemDR="")||(vStartDate="")||(vEndDate="") q ""
	
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.RPTCommon).GetSameEQBenefitInfo(nodestr,vItemDR,vStartDate,vEndDate,Job,QXType,vCurUserID,vCurLocID,vCurGroupID)
	//i '$d(^TempDHCEQ(nodestr,"Benefit",Date,Job,vCurUserID,vItemDR)) q ""
	
	s OneSameEQBAInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (ModelDRs,ModelDescs)=""
	s ManuFactoryDR=""
	f  s ManuFactoryDR=$o(^TempDHCEQ(nodestr,"Benefit",Date,Job,vCurUserID,vItemDR,ManuFactoryDR)) q:ManuFactoryDR=""  d
	.s ModelDR=""
	.f  s ModelDR=$o(^TempDHCEQ(nodestr,"Benefit",Date,Job,vCurUserID,vItemDR,ManuFactoryDR,ModelDR)) q:ModelDR=""  d
	..s SameEQInfo=$g(^TempDHCEQ(nodestr,"Benefit",Date,Job,vCurUserID,vItemDR,ManuFactoryDR,ModelDR))
	..s InComeAmount=$p(SameEQInfo,"^",1)
	..s OutFeeAmout=$p(SameEQInfo,"^",2)
	..s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	..i Model="" s Model="/"
	..i ModelDRs'="" s ModelDRs=ModelDRs_"^"
	..s ModelDRs=ModelDRs_ModelDR
	..i ModelDescs'="" s ModelDescs=ModelDescs_"^"
	..s ModelDescs=ModelDescs_Model
	..d OneSameEQBAInfo.%Set("0-"_ModelDR,##Class(web.DHCEQCommon).FormatNumber(InComeAmount/10000,"",4))	//czf 2021-10-21
	..d OneSameEQBAInfo.%Set("1-"_ModelDR,##Class(web.DHCEQCommon).FormatNumber(OutFeeAmout/10000,"",4))
	..d OneSameEQBAInfo.%Set("2-"_ModelDR,##Class(web.DHCEQCommon).FormatNumber((InComeAmount-OutFeeAmout)/10000,"",4))
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SameEQBAInfo","0^1^2","收入^支出^收支差",ModelDRs,ModelDescs,OneSameEQBAInfo,SameEQBAInfo)
	
	;同类设备不同科室效益分析
	s OneSameEQLocBAInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (StoreLocDRs,StoreLocs)=""
	s StoreLocDR=""
	f  s StoreLocDR=$o(^TempDHCEQ(nodestr,"LocItemBenefit",Date,Job,vCurUserID,vItemDR,StoreLocDR)) q:StoreLocDR=""  d
	.s SameEQLocInfo=$g(^TempDHCEQ(nodestr,"LocItemBenefit",Date,Job,vCurUserID,vItemDR,StoreLocDR))
	.s InComeAmount=$p(SameEQLocInfo,"^",1)
	.s OutFeeAmout=$p(SameEQLocInfo,"^",2)
	.s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.i StoreLocDRs'="" s StoreLocDRs=StoreLocDRs_"^"
	.s StoreLocDRs=StoreLocDRs_StoreLocDR
	.i StoreLocs'="" s StoreLocs=StoreLocs_"^"
	.s StoreLocs=StoreLocs_StoreLoc
	.d OneSameEQLocBAInfo.%Set("0-"_StoreLocDR,##Class(web.DHCEQCommon).FormatNumber(InComeAmount/10000,"",4))	//czf 2021-10-21
	.d OneSameEQLocBAInfo.%Set("1-"_StoreLocDR,##Class(web.DHCEQCommon).FormatNumber(OutFeeAmout/10000,"",4))
	.d OneSameEQLocBAInfo.%Set("2-"_StoreLocDR,##Class(web.DHCEQCommon).FormatNumber((InComeAmount-OutFeeAmout)/10000,"",4))
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SameEQLocBAInfo","0^1^2","收入^支出^收支差",StoreLocDRs,StoreLocs,OneSameEQLocBAInfo,SameEQBAInfo)
	
	q SameEQBAInfo
}

/// Add by czf 2021-09-20
/// 获取同类设备维修信息
/// w ##Class(web.DHCEQ.BA.RPTEchart).GetSameEQMaintChart("web.DHCEQ.BA.RPTEchart_GetSameEQMaintChart","263","","2019-01","2019-12","","12214","202","85")
ClassMethod GetSameEQMaintChart(nodestr As %String = "", vItemDR As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "")
{
	s SameEQMaintInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	i (nodestr="")||(vItemDR="")||(vStartDate="")||(vEndDate="") q ""
	
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.RPTCommon).GetSameEQMaintInfo(nodestr,vItemDR,vStartDate,vEndDate,Job,QXType,vCurUserID,vCurLocID,vCurGroupID)
	i '$d(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,vCurUserID,vItemDR)) q ""
	
	s OneSameEQMaintInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneSameEQMaintRate=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OneSameEQMaintTimeCost=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (ModelDRs,ModelDescs)=""
	s ManuFactoryDR=""
	f  s ManuFactoryDR=$o(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,vCurUserID,vItemDR,ManuFactoryDR)) q:ManuFactoryDR=""  d
	.s ModelDR=""
	.f  s ModelDR=$o(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,vCurUserID,vItemDR,ManuFactoryDR,ModelDR)) q:ModelDR=""  d
	..s SameEQInfo=$g(^TempDHCEQ(nodestr,"MaintInfo",Date,Job,vCurUserID,vItemDR,ManuFactoryDR,ModelDR))
	..s MaintTotalNum=$p(SameEQInfo,"^",1)
	..s EQTotalNum=$p(SameEQInfo,"^",2)
	..s MaintTotalHour=$p(SameEQInfo,"^",3)
	..s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	..i Model="" s Model="/"
	..i ModelDRs'="" s ModelDRs=ModelDRs_"^"
	..s ModelDRs=ModelDRs_ModelDR
	..i ModelDescs'="" s ModelDescs=ModelDescs_"^"
	..s ModelDescs=ModelDescs_Model
	..d OneSameEQMaintInfo.%Set("0-"_ModelDR,MaintTotalNum)
	..d OneSameEQMaintInfo.%Set("1-"_ModelDR,EQTotalNum)
	..s MaintRate=0
	..i +EQTotalNum'=0 s MaintRate=##Class(web.DHCEQCommon).FormatNumber((MaintTotalNum/EQTotalNum)*100,"",2)	//维修率
	..d OneSameEQMaintRate.%Set("0-"_ModelDR,MaintRate)
	..d OneSameEQMaintTimeCost.%Set("0-"_ModelDR,MaintTotalHour)	//维修时长
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SameEQMaintInfo","0^1","维修次数^设备数量",ModelDRs,ModelDescs,OneSameEQMaintInfo,SameEQMaintInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SameEQMaintRate","0","维修率",ModelDRs,ModelDescs,OneSameEQMaintRate,SameEQMaintInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SameEQMaintTimeCost","0","维修时长",ModelDRs,ModelDescs,OneSameEQMaintTimeCost,SameEQMaintInfo)
	
	q SameEQMaintInfo
}

}
