Class web.DHCEQ.BA.BUSBenefitAnalyReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by czf 2020-80-05
/// 将效益分析数据存在临时global中
/// w ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnalyInfo("3188","2020-01","2020-08","78","202","85")
ClassMethod GetBenefitAnalyInfo(Job As %String = "", StartDate As %String = "", EndDate As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "")
{
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	
	s Date=+$h
	i Job="" s Job=$J
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	//s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	
	i CurUser="" Quit $$$OK
	i CurLocID="" s CurLocID=%session.Get("LOGON.CTLOCID")
	//s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)
	
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	i (StartDate="")||(EndDate="") Quit $$$OK
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit $$$OK
	
	s (FactualWorkLoadAmount,WorkLoadAmount,InComeAmount,ConsumableFeeAmount,PersonFeeAmount,WaterFeeAmount,ElectricFeeAmount,WEFeeAmount,HouseFeeAmount,MaintFeeAmount,MaintainFeeAmount,InSpectFeeAmount,MaintenanceFeeAmount,DepreFeeAmount,OutFeeAmount,InComeAmount,NumAmount,OriginalFeeAmount)=0
	s rowid=0
 	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.q:(##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)'=1) //只显示效益分析设备
	.s StoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:StoreLocDR=""
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s EQName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s EQItemDR=$p($g(^DHCEQEquip(rowid)),"^",7)
	.q:EQItemDR=""
	.s EQStatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.q:EQStatCatDR=""
	.s EquipCatDR=$p($g(^DHCEQEquip(rowid)),"^",4)
	.q:EquipCatDR=""
	.s EQOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	.s EQNum=1
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)
	..s TUseRate=0
	..i TWorkLoadPerMonth'=0  d
	...s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	..s TCount=TFactualWorkLoad
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"14",TMonth,TMonth)
	..s TPersonFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"01",TMonth,TMonth)
	..s TWaterFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"03",TMonth,TMonth)		//水费
	..s TElectricFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"04",TMonth,TMonth)	//电费
	..s TWEFee=TWaterFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"04",TMonth,TMonth)	//水电
	..s THouseFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"06",TMonth,TMonth)
	..s TMaintFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"07",TMonth,TMonth)		//维修
	..s TMaintainFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"09",TMonth,TMonth)	//保养
	..s TInSpectFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"10",TMonth,TMonth)	//检查
	..s TMaintenanceFee=TMaintFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"08",TMonth,TMonth)		//	维保费
	..s TDepreFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"05",TMonth,TMonth)
	..s TOutFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	..i TOutFee'=0  d
	...s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	..s BenefitList=TFactualWorkLoad_"^"_TWorkLoadPerMonth_"^"_TInCome_"^"_TConsumableFee_"^"_TPersonFee_"^"_TWEFee_"^"_THouseFee_"^"_TMaintFee_"^"_TMaintainFee_"^"_TInSpectFee_"^"_TMaintenanceFee_"^"_TDepreFee_"^"_TOutFee_"^"_EQOriginalFee_"^"_EQNum_"^"_TWaterFee_"^"_TElectricFee
	..i $d(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemDR,TMonth)) d		//按设备项汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,StoreLocDR,TMonth)) d		//按科室汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,StoreLocDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,StoreLocDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,StoreLocDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatDR,TMonth)) d		//按设备类型汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatDR,TMonth)=BenefitList
	..i $d(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatDR,TMonth)) d		//按设备分类汇总每月效益分析信息
	...s BenefitInfo=$g(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatDR,TMonth))
	...d GetBenefitSummary
	...s ^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatDR,TMonth)=BenefitInfo
	..e  d
	...s ^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatDR,TMonth)=BenefitList
	..s FactualWorkLoadAmount=FactualWorkLoadAmount+TFactualWorkLoad
	..s WorkLoadAmount=WorkLoadAmount+TWorkLoadPerMonth
	..s InComeAmount=InComeAmount+TInCome
	..s ConsumableFeeAmount=ConsumableFeeAmount+TConsumableFee
	..s PersonFeeAmount=PersonFeeAmount+TPersonFee
	..s WaterFeeAmount=WaterFeeAmount+TWaterFee
	..s ElectricFeeAmount=ElectricFeeAmount+TElectricFee
	..s WEFeeAmount=WEFeeAmount+TWEFee
	..s HouseFeeAmount=HouseFeeAmount+THouseFee
	..s MaintFeeAmount=MaintFeeAmount+TMaintFee
	..s MaintainFeeAmount=MaintainFeeAmount+TMaintainFee
	..s InSpectFeeAmount=InSpectFeeAmount+TInSpectFee
	..s MaintenanceFeeAmount=MaintenanceFeeAmount+TMaintenanceFee
	..s DepreFeeAmount=DepreFeeAmount+TDepreFee
	..s OutFeeAmount=OutFeeAmount+TOutFee
	.s NumAmount=NumAmount+1
	.s OriginalFeeAmount=OriginalFeeAmount+EQOriginalFee
	
	;效益分析汇总信息
	s OriginalFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OriginalFeeAmount,"",2)
	s InComeAmount=##Class(web.DHCEQCommon).FormatNumber(InComeAmount,"",2)
	s OutFeeAmount=##Class(web.DHCEQCommon).FormatNumber(OutFeeAmount,"",2)
	s ^TempDHCEQ(nodestr,"BenefitEQSummary",Date,Job,CurUser)=FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount
	
	Quit $$$OK
	
GetBenefitSummary
	s $p(BenefitInfo,"^",1)=$p(BenefitInfo,"^",1)+TFactualWorkLoad	//实际工作量
	s $p(BenefitInfo,"^",2)=$p(BenefitInfo,"^",2)+TWorkLoadPerMonth	//总工作量
	s $p(BenefitInfo,"^",3)=$p(BenefitInfo,"^",3)+TInCome			//收入
	s $p(BenefitInfo,"^",4)=$p(BenefitInfo,"^",4)+TConsumableFee	//耗材
	s $p(BenefitInfo,"^",5)=$p(BenefitInfo,"^",5)+TPersonFee		//人员
	s $p(BenefitInfo,"^",6)=$p(BenefitInfo,"^",6)+TWEFee			//水电
	s $p(BenefitInfo,"^",7)=$p(BenefitInfo,"^",7)+THouseFee			//房屋折旧
	s $p(BenefitInfo,"^",8)=$p(BenefitInfo,"^",8)+TMaintFee			//维修
	s $p(BenefitInfo,"^",9)=$p(BenefitInfo,"^",9)+TMaintainFee		//保养
	s $p(BenefitInfo,"^",10)=$p(BenefitInfo,"^",10)+TInSpectFee		//巡检
	s $p(BenefitInfo,"^",11)=$p(BenefitInfo,"^",11)+TMaintenanceFee	//维保
	s $p(BenefitInfo,"^",12)=$p(BenefitInfo,"^",12)+TDepreFee		//折旧费
	s $p(BenefitInfo,"^",13)=$p(BenefitInfo,"^",13)+TOutFee			//支出
	s $p(BenefitInfo,"^",14)=$p(BenefitInfo,"^",14)+EQOriginalFee	//金额
	s $p(BenefitInfo,"^",15)=$p(BenefitInfo,"^",15)+EQNum			//数量
	s $p(BenefitInfo,"^",16)=$p(BenefitInfo,"^",16)+TWaterFee		//水
	s $p(BenefitInfo,"^",17)=$p(BenefitInfo,"^",17)+TElectricFee	//电
	quit
}

/// add by czf 2020-80-05
/// 效益分析图表
/// w ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnaly(3528,"2020-08","2020-08",12214,202,85)
ClassMethod GetBenefitAnaly(vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "")
{
	s EQBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",vCurUserID)
	
	i vCurLocID="" s vCurLocID=%session.Get("LOGON.CTLOCID")
	s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",vCurLocID)
	
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (CurUser="")||(vCurLocID="") Quit $$$OK
	i (vStartDate="")||(vEndDate="") Quit $$$OK
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit $$$OK
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnalyInfo(Job,vStartDate,vEndDate,CurUser,vCurLocID,vCurGroupID)
	
	;设备项效益信息
	s (OneItemEquipNums,OneItemEquipAmount,OneItemInComeInfo,OneItemOutFeeInfo,OneItemBenefitInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,EQItemIDs,EQItems)=""
	s countNum=0
	s EQItemID=""
	f  s EQItemID=$o(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemID)) q:EQItemID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"EQItemBenefit",Date,Job,CurUser,EQItemID,month))
	..d GetBenefitDetail
	.d OneItemEquipNums.%Set(EQItemID_"-0",EQNums)
	.d OneItemEquipAmount.%Set(EQItemID_"-1",OriginalFee)
	.d OneItemInComeInfo.%Set("0-"_EQItemID,InCome)
	.d OneItemOutFeeInfo.%Set("1-"_EQItemID,OutFee)
	.d OneItemBenefitInfo.%Set("0-"_EQItemID,InCome)
	.d OneItemBenefitInfo.%Set("1-"_EQItemID,OutFee)
	.s EQItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",EQItemID)
	.i EQItemIDs'="" s EQItemIDs=EQItemIDs_"^"
	.s EQItemIDs=EQItemIDs_EQItemID
	.i EQItems'="" s EQItems=EQItems_"^"
	.s EQItems=EQItems_EQItem
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemEquipNums",EQItemIDs,EQItems,"0","数量",OneItemEquipNums,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemEquipAmount",EQItemIDs,EQItems,"1","金额",OneItemEquipAmount,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemInComeInfo","0","收入",EQItemIDs,EQItems,OneItemInComeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemOutFeeInfo","1","支出",EQItemIDs,EQItems,OneItemOutFeeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("ItemBenefitInfo","0^1","收入^支出",EQItemIDs,EQItems,OneItemBenefitInfo,EQBenefitInfo)
	
	;科室效益信息
	s (OneLocEquipNums,OneLocEquipAmount,OneLocInComeInfo,OneLocOutFeeInfo,OneLocBenefitInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,EQLocIDs,EQLocs)=""
	s countNum=0
	s EQLocID=""
	f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,EQLocID)) q:EQLocID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,EQLocID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,EQLocID,month))
	..d GetBenefitDetail
	.d OneLocEquipNums.%Set(EQLocID_"-0",EQNums)
	.d OneLocEquipAmount.%Set(EQLocID_"-1",OriginalFee)
	.d OneLocInComeInfo.%Set("0-"_EQLocID,InCome)
	.d OneLocOutFeeInfo.%Set("1-"_EQLocID,OutFee)
	.d OneLocBenefitInfo.%Set("0-"_EQLocID,InCome)
	.d OneLocBenefitInfo.%Set("1-"_EQLocID,OutFee)
	.s EQLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",EQLocID)
	.i EQLocIDs'="" s EQLocIDs=EQLocIDs_"^"
	.s EQLocIDs=EQLocIDs_EQLocID
	.i EQLocs'="" s EQLocs=EQLocs_"^"
	.s EQLocs=EQLocs_EQLoc
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipNums",EQLocIDs,EQLocs,"0","数量",OneLocEquipNums,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipAmount",EQLocIDs,EQLocs,"1","金额",OneLocEquipAmount,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocInComeInfo","0","收入",EQLocIDs,EQLocs,OneLocInComeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocOutFeeInfo","1","支出",EQLocIDs,EQLocs,OneLocOutFeeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocBenefitInfo","0^1","收入^支出",EQLocIDs,EQLocs,OneLocBenefitInfo,EQBenefitInfo)

	;设备类型效益信息
	s (OneStatCatEquipNums,OneStatCatEquipAmount,OneStatCatInComeInfo,OneStatCatOutFeeInfo,OneStatCatBenefitInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,EQStatCatIDs,EQStatCats)=""
	s countNum=0
	s EQStatCatID=""
	f  s EQStatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatID)) q:EQStatCatID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,EQStatCatID,month))
	..d GetBenefitDetail
	.d OneStatCatEquipNums.%Set(EQStatCatID_"-0",EQNums)
	.d OneStatCatEquipAmount.%Set(EQStatCatID_"-1",OriginalFee)
	.d OneStatCatInComeInfo.%Set("0-"_EQStatCatID,InCome)
	.d OneStatCatOutFeeInfo.%Set("1-"_EQStatCatID,OutFee)
	.d OneStatCatBenefitInfo.%Set("0-"_EQStatCatID,InCome)
	.d OneStatCatBenefitInfo.%Set("1-"_EQStatCatID,OutFee)
	.s EQStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",EQStatCatID)
	.i EQStatCatIDs'="" s EQStatCatIDs=EQStatCatIDs_"^"
	.s EQStatCatIDs=EQStatCatIDs_EQStatCatID
	.i EQStatCats'="" s EQStatCats=EQStatCats_"^"
	.s EQStatCats=EQStatCats_EQStatCat
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatEquipNums",EQStatCatIDs,EQStatCats,"0","数量",OneStatCatEquipNums,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatEquipAmount",EQStatCatIDs,EQStatCats,"1","金额",OneStatCatEquipAmount,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatInComeInfo","0","收入",EQStatCatIDs,EQStatCats,OneStatCatInComeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatOutFeeInfo","1","支出",EQStatCatIDs,EQStatCats,OneStatCatOutFeeInfo,EQBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("StatCatBenefitInfo","0^1","收入^支出",EQStatCatIDs,EQStatCats,OneStatCatBenefitInfo,EQBenefitInfo)
	
	;设备分类效益信息
	s (OneEquipCatEquipNums,OneEquipCatEquipAmount,OneEquipCatInComeInfo,OneEquipCatOutFeeInfo,OneEquipCatBenefitInfo)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,EquipCatIDs,EquipCats)=""
	s countNum=0
	s EquipCatID=""
	f  s EquipCatID=$o(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatID)) q:EquipCatID=""  d
	.d ResetBenefitDetail
	.s countNum=countNum+1
	.q:countNum>10		//统计近10
	.s month=""
	.f  s month=$o(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatID,month)) q:month=""  d
	..s BenefitDetail=$g(^TempDHCEQ(nodestr,"EquipCatBenefit",Date,Job,CurUser,EquipCatID,month))
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
	
	;全院各项支出统计
	;FactualWorkLoadAmount_"^"_WorkLoadAmount_"^"_InComeAmount_"^"_ConsumableFeeAmount_"^"_PersonFeeAmount_"^"_WEFeeAmount_"^"_HouseFeeAmount_"^"_MaintFeeAmount_"^"_MaintainFeeAmount_"^"_InSpectFeeAmount_"^"_MaintenanceFeeAmount_"^"_DepreFeeAmount_"^"_OutFeeAmount_"^"_OriginalFeeAmount_"^"_NumAmount_"^"_WaterFeeAmount_"^"_ElectricFeeAmount
	s OneOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
	s BenefitAmountInfo=$g(^TempDHCEQ(nodestr,"BenefitEQSummary",Date,Job,CurUser))
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
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("EquipOutFeeInfo","1","支出",ResourceTypeIDs,ResourceTypes,OneOutFeeAmountInfo,EQBenefitInfo)
	
	//d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	q EQBenefitInfo
	
ResetBenefitDetail
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee)=0
	quit
	
GetBenefitDetail
	s FactualWorkLoad=$p(BenefitDetail,"^",1)
	s WorkLoadPerMonth=$p(BenefitDetail,"^",2)
	s InCome=$p(BenefitDetail,"^",3)
	s ConsumableFee=$p(BenefitDetail,"^",4)
	s PersonFee=$p(BenefitDetail,"^",5)
	s WEFee=$p(BenefitDetail,"^",6)
	s HouseFee=$p(BenefitDetail,"^",7)
	s MaintFee=$p(BenefitDetail,"^",8)
	s MaintainFee=$p(BenefitDetail,"^",9)
	s InSpectFee=$p(BenefitDetail,"^",10)
	s MaintenanceFee=$p(BenefitDetail,"^",11)
	s DepreFee=$p(BenefitDetail,"^",12)
	s OutFee=$p(BenefitDetail,"^",13)
	s OriginalFee=$p(BenefitDetail,"^",14)
	s EQNums=$p(BenefitDetail,"^",15)
	s WaterFee=$p(BenefitDetail,"^",15)
	s ElectricFee=$p(BenefitDetail,"^",16)
	quit
}

/// czf 2020-08-07
/// 获取科室效益分析明细信息
/// w ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetLocBenefit("3396","2020-01","2020-08","12214","202","85","2")
ClassMethod GetLocBenefit(vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vLocDR As %String = "")
{
	s LocBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",vCurUserID)
	
	i vCurLocID="" s vCurLocID=%session.Get("LOGON.CTLOCID")
	s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",vCurLocID)
	
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (CurUser="")||(vCurLocID="")||(vLocDR="") Quit $$$OK
	i (vStartDate="")||(vEndDate="") Quit $$$OK
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit $$$OK
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnalyInfo(Job,vStartDate,vEndDate,CurUser,vCurLocID,vCurGroupID)
	
	s (OnePerMonthLocInCome,OnePerMonthLocOutFee,OnePerMonthLocBenefit,OnePerMonthLocWorkLoad)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,MonthIDs,MonthStrs)=""
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee)=0
	s countNum=0
	s Month=""
	f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,vLocDR,Month)) q:Month=""  d
	.s countNum=countNum+1
	.s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,Job,CurUser,vLocDR,Month))
	.s FactualWorkLoad=$p(BenefitDetail,"^",1)
	.s WorkLoadPerMonth=$p(BenefitDetail,"^",2)
	.s InCome=$p(BenefitDetail,"^",3)	//每月收入
	.s ConsumableFee=ConsumableFee+$p(BenefitDetail,"^",4)
	.s PersonFee=PersonFee+$p(BenefitDetail,"^",5)
	.s WEFee=WEFee+$p(BenefitDetail,"^",6)
	.s HouseFee=HouseFee+$p(BenefitDetail,"^",7)
	.s MaintFee=MaintFee+$p(BenefitDetail,"^",8)
	.s MaintainFee=MaintainFee+$p(BenefitDetail,"^",9)
	.s InSpectFee=InSpectFee+$p(BenefitDetail,"^",10)
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
	.d OnePerMonthLocWorkLoad.%Set("3-"_countNum,WorkLoadPerMonth)		//总工作量
	.d OnePerMonthLocBenefit.%Set("0-"_countNum,InCome)
	.d OnePerMonthLocBenefit.%Set("1-"_countNum,OutFee)
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_Month
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthInCome","0","收入",MonthIDs,MonthStrs,OnePerMonthLocInCome,LocBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthOutFee","1","支出",MonthIDs,MonthStrs,OnePerMonthLocOutFee,LocBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthFacWorkLoad","2^3","实际工作量^总工作量",MonthIDs,MonthStrs,OnePerMonthLocWorkLoad,LocBenefitInfo)	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocPerMonthBenefit","0^1","收入^支出",MonthIDs,MonthStrs,OnePerMonthLocBenefit,LocBenefitInfo)
	
	;科室各项支出统计
	s OneLocOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
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
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("LocEquipOutFeeInfo","1","支出",ResourceTypeIDs,ResourceTypes,OneLocOutFeeAmountInfo,LocBenefitInfo)
	
	q LocBenefitInfo
}

/// czf 2020-08-07
/// 获取设备类型效益分析明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitAnalyReport","GetLocBenefit","","","")
ClassMethod GetStatCatBenefit(vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vStatCatDR As %String = "")
{
	s StatCatBenefitInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",vCurUserID)
	
	i vCurLocID="" s vCurLocID=%session.Get("LOGON.CTLOCID")
	s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",vCurLocID)
	
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (CurUser="")||(vCurLocID="")||(vStatCatDR="") Quit $$$OK
	i (vStartDate="")||(vEndDate="") Quit $$$OK
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit $$$OK
	
	;调用方法将数据存储在临时global中	
	d ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnalyInfo(Job,vStartDate,vEndDate,CurUser,vCurLocID,vCurGroupID)
	
	s (OnePerMonthSCInCome,OnePerMonthSCOutFee,OnePerMonthSCWorkLoad,OnePerMonthSCBenefit)=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (BenefitDetail,MonthIDs,MonthStrs)=""
	s (FactualWorkLoad,WorkLoadPerMonth,InCome,ConsumableFee,PersonFee,WEFee,HouseFee,MaintFee,MaintainFee,InSpectFee,MaintenanceFee,DepreFee,OutFee,OriginalFee,EQNums,WaterFee,ElectricFee)=0
	
	s countNum=0
	s Month=""
	f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,vStatCatDR,Month)) q:Month=""  d
	.s countNum=countNum+1
	.s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,Job,CurUser,vStatCatDR,Month))
	.s FactualWorkLoad=$p(BenefitDetail,"^",1)
	.s WorkLoadPerMonth=$p(BenefitDetail,"^",2)
	.s InCome=$p(BenefitDetail,"^",3)	//每月收入
	.s ConsumableFee=ConsumableFee+$p(BenefitDetail,"^",4)
	.s PersonFee=PersonFee+$p(BenefitDetail,"^",5)
	.s WEFee=WEFee+$p(BenefitDetail,"^",6)
	.s HouseFee=HouseFee+$p(BenefitDetail,"^",7)
	.s MaintFee=MaintFee+$p(BenefitDetail,"^",8)
	.s MaintainFee=MaintainFee+$p(BenefitDetail,"^",9)
	.s InSpectFee=InSpectFee+$p(BenefitDetail,"^",10)
	.s MaintenanceFee=MaintenanceFee+$p(BenefitDetail,"^",11)
	.s DepreFee=DepreFee+$p(BenefitDetail,"^",12)
	.s OutFee=$p(BenefitDetail,"^",13)		//每月支出
	.s OriginalFee=$p(BenefitDetail,"^",14)
	.s EQNums=$p(BenefitDetail,"^",15)
	.s WaterFee=WaterFee+$p(BenefitDetail,"^",16)
	.s ElectricFee=ElectricFee+$p(BenefitDetail,"^",17)
	.b ;11
	.d OnePerMonthSCInCome.%Set("0-"_countNum,InCome)
	.d OnePerMonthSCOutFee.%Set("1-"_countNum,OutFee)
	.d OnePerMonthSCWorkLoad.%Set("2-"_countNum,FactualWorkLoad)		//实际工作量
	.d OnePerMonthSCWorkLoad.%Set("3-"_countNum,WorkLoadPerMonth)		//总工作量
	.d OnePerMonthSCBenefit.%Set("0-"_countNum,InCome)
	.d OnePerMonthSCBenefit.%Set("1-"_countNum,OutFee)
	.i MonthIDs'="" s MonthIDs=MonthIDs_"^"
	.s MonthIDs=MonthIDs_countNum
	.i MonthStrs'="" s MonthStrs=MonthStrs_"^"
	.s MonthStrs=MonthStrs_Month
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthInCome","0","收入",MonthIDs,MonthStrs,OnePerMonthSCInCome,StatCatBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthOutFee","1","支出",MonthIDs,MonthStrs,OnePerMonthSCOutFee,StatCatBenefitInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthFacWorkLoad","2^3","实际工作量^总工作量",MonthIDs,MonthStrs,OnePerMonthSCWorkLoad,StatCatBenefitInfo)	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCPerMonthBenefit","0^1","收入^支出",MonthIDs,MonthStrs,OnePerMonthSCBenefit,StatCatBenefitInfo)
	
	;类型各项支出统计
	s OneSCOutFeeAmountInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (ResourceTypeIDs,ResourceTypes)=""
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
	
	;饼图
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("SCEquipOutFeeInfo",ResourceTypeIDs,ResourceTypes,"1","支出",OneSCOutFeeAmountInfo,StatCatBenefitInfo)
	
	q StatCatBenefitInfo
}

/// czf 2020-08-07
/// 获取科室效益分析明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitAnalyReport","GetLocBenefitInfo","3188","12214","5","1")
Query GetLocBenefitInfo(EJob As %String = "", CurUserID As %String = "", StoreLocDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Query(ROWSPEC = "TStoreLocID:%String,TStoreLoc:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String,TOriginalAmount:%String,TEQNum:%String,TMonth:%String")
{
}

ClassMethod GetLocBenefitInfoExecute(ByRef qHandle As %Binary, EJob As %String = "", CurUserID As %String = "", StoreLocDR As %String = "", Type As %String = "", vStartDate As %String = "", vEndDate As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	i EJob||CurUser="" Quit $$$OK
	
	;调用方法将数据存储在临时global中	
	//d ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetBenefitAnalyInfo(EJob,vStartDate,vEndDate,CurUser,"","")
	
	i (Type="")||(Type=0)		//首页汇总输出
	{
		s EQLocID=""
		f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID)) q:EQLocID=""  d
		.q:(StoreLocDR'="")&&(StoreLocDR'=EQLocID)
		.d ResetLocBenefitInfo
		.s TStoreLocID=EQLocID
		.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,Month)) q:Month=""  d
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,Month))
		..s TFactualWorkLoad=TFactualWorkLoad+$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=TWorkLoadPerMonth+$p(BenefitDetail,"^",2)
		..s TInCome=TInCome+$p(BenefitDetail,"^",3)
		..s TConsumableFee=TConsumableFee+$p(BenefitDetail,"^",4)
		..s TPersonFee=TPersonFee+$p(BenefitDetail,"^",5)
		..s TWEFee=TWEFee+$p(BenefitDetail,"^",6)
		..s THouseFee=THouseFee+$p(BenefitDetail,"^",7)
		..s TMaintFee=TMaintFee+$p(BenefitDetail,"^",8)
		..s TMaintainFee=TMaintainFee+$p(BenefitDetail,"^",9)
		..s TInSpectFee=TInSpectFee+$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=TMaintenanceFee+$p(BenefitDetail,"^",11)
		..s TDepreFee=TDepreFee+$p(BenefitDetail,"^",12)
		..s TOutFee=TOutFee+$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		.s TStartMonth=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,""))
		.s TEndMonth=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,""),-1)
		.i TStartMonth=TEndMonth s TMonth=TStartMonth
		.e  s TMonth=TStartMonth_"~"_TEndMonth
		.d OutPutLocBenefitInfo
	}
	i Type=1
	{
		s EQLocID=""
		f  s EQLocID=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID)) q:EQLocID=""  d
		.q:(StoreLocDR'="")&&(StoreLocDR'=EQLocID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,Month)) q:Month=""  d
		..d ResetLocBenefitInfo
		..s TStoreLocID=EQLocID
		..s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
		..s TMonth=Month
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"LocBenefit",Date,EJob,CurUser,EQLocID,Month))
		..s TFactualWorkLoad=$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=$p(BenefitDetail,"^",2)
		..s TInCome=$p(BenefitDetail,"^",3)
		..s TConsumableFee=$p(BenefitDetail,"^",4)
		..s TPersonFee=$p(BenefitDetail,"^",5)
		..s TWEFee=$p(BenefitDetail,"^",6)
		..s THouseFee=$p(BenefitDetail,"^",7)
		..s TMaintFee=$p(BenefitDetail,"^",8)
		..s TMaintainFee=$p(BenefitDetail,"^",9)
		..s TInSpectFee=$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=$p(BenefitDetail,"^",11)
		..s TDepreFee=$p(BenefitDetail,"^",12)
		..s TOutFee=$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		..d OutPutLocBenefitInfo
	}
	Quit $$$OK
ResetLocBenefitInfo
	s (TStoreLocID,TStoreLoc,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum)=0
	s TMonth=""
	quit
	
OutPutLocBenefitInfo
	s Data=$lb(TStoreLocID,TStoreLoc,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TMonth)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetLocBenefitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocBenefitInfoExecute ]
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

ClassMethod GetLocBenefitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocBenefitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2020-08-07
/// 获取设备类型效益分析明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitAnalyReport","GetStatCatBenefitInfo","3528","12214","")
Query GetStatCatBenefitInfo(EJob As %String = "", CurUserID As %String = "", StatCatDR As %String = "", Type As %String = "") As %Query(ROWSPEC = "TStatCatID:%String,TStatCat:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String,TOriginalAmount:%String,TEQNum:%String,TMonth:%String")
{
}

ClassMethod GetStatCatBenefitInfoExecute(ByRef qHandle As %Binary, EJob As %String = "", CurUserID As %String = "", StatCatDR As %String = "", Type As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	s nodestr="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	i EJob||CurUser="" Quit $$$OK
	
	i (Type="")||(Type=0)
	{
		s StatCatID=""
		f  s StatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID)) q:StatCatID=""  d
		.q:(StatCatDR'="")&&(StatCatDR'=StatCatID)
		.d ResetStatCatBenefitInfo
		.s TStatCatID=StatCatID
		.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,Month)) q:Month=""  d
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,Month))
		..s TFactualWorkLoad=TFactualWorkLoad+$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=TWorkLoadPerMonth+$p(BenefitDetail,"^",2)
		..s TInCome=TInCome+$p(BenefitDetail,"^",3)
		..s TConsumableFee=TConsumableFee+$p(BenefitDetail,"^",4)
		..s TPersonFee=TPersonFee+$p(BenefitDetail,"^",5)
		..s TWEFee=TWEFee+$p(BenefitDetail,"^",6)
		..s THouseFee=THouseFee+$p(BenefitDetail,"^",7)
		..s TMaintFee=TMaintFee+$p(BenefitDetail,"^",8)
		..s TMaintainFee=TMaintainFee+$p(BenefitDetail,"^",9)
		..s TInSpectFee=TInSpectFee+$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=TMaintenanceFee+$p(BenefitDetail,"^",11)
		..s TDepreFee=TDepreFee+$p(BenefitDetail,"^",12)
		..s TOutFee=TOutFee+$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		.s TStartMonth=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,""))
		.s TEndMonth=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,""),-1)
		.i TStartMonth=TEndMonth s TMonth=TStartMonth
		.e  s TMonth=TStartMonth_"~"_TEndMonth
		.d OutPutStatCatBenefitInfo
	}
	i Type=1
	{
		s StatCatID=""
		f  s StatCatID=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID)) q:StatCatID=""  d
		.q:(StatCatDR'="")&&(StatCatDR'=StatCatID)
		.s Month=""
		.f  s Month=$o(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,Month)) q:Month=""  d
		..d ResetStatCatBenefitInfo
		..s TMonth=Month
		..s TStatCatID=StatCatID
		..s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
		..s BenefitDetail=$g(^TempDHCEQ(nodestr,"StatCatBenefit",Date,EJob,CurUser,StatCatID,Month))
		..s TFactualWorkLoad=$p(BenefitDetail,"^",1)
		..s TWorkLoadPerMonth=$p(BenefitDetail,"^",2)
		..s TInCome=$p(BenefitDetail,"^",3)
		..s TConsumableFee=$p(BenefitDetail,"^",4)
		..s TPersonFee=$p(BenefitDetail,"^",5)
		..s TWEFee=$p(BenefitDetail,"^",6)
		..s THouseFee=$p(BenefitDetail,"^",7)
		..s TMaintFee=$p(BenefitDetail,"^",8)
		..s TMaintainFee=$p(BenefitDetail,"^",9)
		..s TInSpectFee=$p(BenefitDetail,"^",10)
		..s TMaintenanceFee=$p(BenefitDetail,"^",11)
		..s TDepreFee=$p(BenefitDetail,"^",12)
		..s TOutFee=$p(BenefitDetail,"^",13)
		..s TOriginalAmount=$p(BenefitDetail,"^",14)
		..s TEQNum=$p(BenefitDetail,"^",15)
		..d OutPutStatCatBenefitInfo
	}
	
	Quit $$$OK
ResetStatCatBenefitInfo
	s (TStatCatID,TStatCat,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum)=0
	s TMonth=""
	quit
	
OutPutStatCatBenefitInfo
	s Data=$lb(TStatCatID,TStatCat,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TMonth)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetStatCatBenefitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatCatBenefitInfoExecute ]
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

ClassMethod GetStatCatBenefitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatCatBenefitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by czf 20200808
/// 获取临时global数据
/// w ##Class(web.DHCEQ.BA.BUSBenefitAnalyReport).GetTempInfo("web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly","LocBenefit",65601,"3524","78","2")
ClassMethod GetTempInfo(node1 As %String = "", node2 As %String = "", Date As %String = "", Job As %String = "", CurUserID As %String = "", SourceID As %String = "", vMonth As %String = "")
{
	i Date="" s Date=+$h
	i Job="" q ""
	i CurUserID="" s CurUserID=%session.Get("LOGON.USERID")
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	
	i node1="web.DHCEQ.BA.BUSBenefitAnalyReport_GetBenefitAnaly"
	{
		i node2="BenefitEQSummary"
		{
			q $g(^TempDHCEQ(node1,node2,Date,Job,CurUser))
		}
		else
		{
			s (TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TOriginalAmount,TEQNum,TWaterFee,TElectricFee)=0
			i SourceID="" q ""
			s month=""
			f  s month=$o(^TempDHCEQ(node1,node2,Date,Job,CurUser,SourceID,month)) q:month=""  d
			.q:(vMonth'="")&&(vMonth'=month)
			.s BenefitDetail=$g(^TempDHCEQ(node1,node2,Date,Job,CurUser,SourceID,month))
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
			
			q TFactualWorkLoad_"^"_TWorkLoadPerMonth_"^"_TInCome_"^"_TConsumableFee_"^"_TPersonFee_"^"_TWEFee_"^"_THouseFee_"^"_TMaintFee_"^"_TMaintainFee_"^"_TInSpectFee_"^"_TMaintenanceFee_"^"_TDepreFee_"^"_TOutFee_"^"_TOriginalAmount_"^"_TEQNum_"^"_TWaterFee_"^"_TElectricFee
		}
	}
}

/// czf 2020-08-07
/// 获取效益分析设备明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitAnalyReport","GetBenefitEquip","2020-01","2020-08","")
/// 1733417  czf 2021-01-20 修改入参StatCatdR
Query GetBenefitEquip(StartDate As %String = "", EndDate As %String = "", StoreLocDR As %String = "", StatCatDR As %String = "") As %Query(ROWSPEC = "TMonth:%String,TRowID:%String,TName:%String,TEquipNo:%String,TStoreLoc:%String,TStatCat:%String,TEquipCat:%String,TItem:%String,TModel:%String,TOriginalFee:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String")
{
}

ClassMethod GetBenefitEquipExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", StoreLocDR As %String = "", StatCatDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i (StartDate="")||(EndDate="") Quit $$$OK
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit $$$OK
	
	s rowid=0
 	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
 	.d ResetGetBenefitEquip
 	.s TRowID=rowid
	.q:(##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)'=1) //只显示效益分析设备
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s TStoreLocID=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:(StoreLocDR'="")&&(StoreLocDR'=TStoreLocID)		//1733871  czf 2021-01-20
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
	.s TName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s TItemID=$p($g(^DHCEQEquip(rowid)),"^",7)
	.s TItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemID)
	.s TStatCatID=$p($g(^DHCEQEquip(rowid)),"^",75)
	.q:(StatCatDR'="")&&(StatCatDR'=TStatCatID)		//1733417  czf 2021-01-20
	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
	.s TEquipCatID=$p($g(^DHCEQEquip(rowid)),"^",4)
	.s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatID)
	.s TOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	.s TEQNum=1
	.s TEquipNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s TModelID=$p($g(^DHCEQEquip(rowid)),"^",3)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelID)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)
	..s TUseRate=0
	..i TWorkLoadPerMonth'=0  d
	...s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	..s TCount=TFactualWorkLoad
	..s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TConsumableFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"14",TMonth,TMonth)
	..s TPersonFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"01",TMonth,TMonth)
	..s TWaterFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"03",TMonth,TMonth)		//水费
	..s TElectricFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"04",TMonth,TMonth)	//电费
	..s TWEFee=TWaterFee+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"04",TMonth,TMonth)	//水电
	..s THouseFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"06",TMonth,TMonth)
	..s TMaintFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"07",TMonth,TMonth)		//维修
	..s TMaintainFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"09",TMonth,TMonth)	//保养
	..s TInSpectFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"10",TMonth,TMonth)	//检查
	..s TMaintenanceFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"08",TMonth,TMonth)		//	维保费  modified by ZY0276 20210720
	..s TDepreFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"05",TMonth,TMonth)
	..s TOutFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(rowid,"",TMonth,TMonth)
	..i TOutFee'=0  d
	...s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	..d OutPutGetBenefitEquip
	
	Quit $$$OK
ResetGetBenefitEquip
	s (TRowID,TName,TEquipNo,TStoreLocID,TStoreLoc,TStatCatID,TStatCat,TEquipCatID,TEquipCat,TItemID,TItem,TModelID,TModel,TOriginalFee)=""
	s (TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee)=0
	quit
	
OutPutGetBenefitEquip
	s Data=$lb(TMonth,TRowID,TName,TEquipNo,TStoreLoc,TStatCat,TEquipCat,TItem,TModel,TOriginalFee,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
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

ClassMethod GetBenefitEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by ZX 20230209 bug:3234076  
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitAnalyReport","GetEquipRateOfUtilization","404831","2022-01","2022-07","")
Query GetEquipRateOfUtilization(EquipID As %String = "", StartMonth As %String = "", EndMonth As %String = "", StandardWorkload As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TEQName:%String,TModel:%String,TTransAssetDate:%String,TOriginalFee:%String,TUseLoc:%String,TNo:%String,TMonth:%String,TFactualWorkLoad:%String,TInCome:%String,TOutFee:%String,TLimitYearsNum:%String,TResult:%String,TUnit:%String,TWorkLoadPerMonth:%String,TUseRate:%String") [ SqlProc ]
{
}

ClassMethod GetEquipRateOfUtilizationExecute(ByRef qHandle As %Binary, EquipID As %String = "", StartMonth As %String = "", EndMonth As %String = "", StandardWorkload As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i EquipID="" Quit $$$OK
	i (StartMonth="")||(EndMonth="") Quit $$$OK
	i ($ZDH(StartMonth_"-01",3)>$ZDH(EndMonth_"-01",3)) Quit $$$OK
	
	d ResetGetEquipRateOfUtilization
	s TEQName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TTransAssetDate=$p($g(^DHCEQEquip(EquipID)),"^",45)
	s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipID)),"^",27),"")
	s TUseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	s TLimitYearsNum=$p($g(^DHCEQEquip(EquipID)),"^",31)
	s TUnitDR=$p($g(^DHCEQEquip(EquipID)),"^",5)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom", TUnitDR)
	s TWorkLoadPerDate=$p($g(^DHCEQEquip(EquipID)),"^",84)
	
	s vStart=$ZDH(StartMonth_"-01",3)
	s vEnd=$ZDH(EndMonth_"-01",3)
	f ID=vStart:1:vEnd  d
	.;当前月份
	.s TMonth=$E($ZD(ID,3),1,7)
	.s TFactualWorkLoad=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(EquipID,"Workload",TMonth,TMonth)
	.q:TFactualWorkLoad=0
	.s TWorkLoadPerMonth=TWorkLoadPerDate*30
	.s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(EquipID,"InCome",TMonth,TMonth)
	.//平均单次收费
	.s TSingleItemPrice=$fn(TInCome/TFactualWorkLoad,"",3)
	.s TTheoryWorkLoadPerMonth=$fn(TOriginalFee/TLimitYearsNum/12/TSingleItemPrice,"",3)
	.s TUseRate=$fn((TFactualWorkLoad/TTheoryWorkLoadPerMonth)*100,"",2)
	.s TOutFee=+##Class(web.DHCEQ.BA.STATReport).EquipResourceFee(EquipID,"",TMonth,TMonth)
	.i TOutFee=0 s TResult="优秀"
	.e  d
	..s TOutFeeRate=TInCome/TOutFee
	..i TOutFeeRate<=1 d
	...s TResult="一般"
	..else  if (TOutFeeRate>1)&&(TOutFeeRate<=1.5) d
	...s TResult="良好"
	..e  d
	...s TResult="优秀"
	.d OutPutGetEquipRateOfUtilization
	.s vYear=$E($ZD(ID,3),1,4)
	.s vMonth=$E($ZD(ID,3),6,7)
	.i vMonth=12  d
	..s vYear=vYear+1
	..s vMonth=1
	.e  d
	..s vMonth=vMonth+1
	.s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
	
ResetGetEquipRateOfUtilization
	s (TEQName,TModelDR,TModel,TTransAssetDate,TOriginalFee,TUseLocDR,TUseLoc,TNo,TMonth,TFactualWorkLoad,TInCome,TOutFee,TOutFeeRate,TLimitYearsNum,TResult,TUnitDR,TUnit,TWorkLoadPerMonth,TWorkLoadPerDate,TUseRate)=""
	quit
	
OutPutGetEquipRateOfUtilization
	s Data=$lb(TEQName,TModel,TTransAssetDate,TOriginalFee,TUseLoc,TNo,TMonth,TFactualWorkLoad,TInCome,TOutFee,TLimitYearsNum,TResult,TUnit,TWorkLoadPerMonth,TUseRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEquipRateOfUtilizationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRateOfUtilizationExecute ]
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

ClassMethod GetEquipRateOfUtilizationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRateOfUtilizationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
