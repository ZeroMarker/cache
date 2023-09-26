Class web.DHCEQ.Interface.Inner.DHCEQFRTo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Add By DJ 2015-07-22
/// 描述:财务监审折旧接口 (上海公利)
ClassMethod uGetGDZCZJ(vStartDate, vEndDate)
{
	i ((vStartDate="")||(vEndDate="")) q ""
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	i SelfFundsFlag="" q "未设置自有资金参数"
	k ^BonusTempGDZC($J)
	s BeginDate=$ZDH(vStartDate,3)-1
	s EndDate=$ZDH(vEndDate,3)
	
	s MDAuditDate=BeginDate
	f  s MDAuditDate=$o(^DHCEQMonthDepre(0,"AuditDate","Y",MDAuditDate)) quit:((MDAuditDate="")||(MDAuditDate>EndDate))  d
	.s MDRowID=0
	.f  s MDRowID=$o(^DHCEQMonthDepre(0,"AuditDate","Y",MDAuditDate,MDRowID)) quit:MDRowID=""  d
	..s EquipDR=$p($g(^DHCEQMonthDepre(MDRowID)),"^",1)
	..s EquipTypeID=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	..s TEquipType=""
	..s TEquipTypeCode=""
	..i EquipTypeID'=""  d
	...s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
	...s TEquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
	..s TransAsSetDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
	..s TDateFlag=2
	..i TransAsSetDate<=62272 s TDateFlag=1
	..s LocID=$p($g(^DHCEQMonthDepre(MDRowID)),"^",33)
	..s LocName=""
	..;i LocID'="" s LocName=$p($g(^CTLOC(LocID)),"^",2)     //modify by jyp 2019-10-18 CTLOC调整
	..i LocID'="" s LocName=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)    //modify by jyp 2019-10-18 CTLOC调整
	..s DepreTypeDR=$p($g(^DHCEQMonthDepre(MDRowID)),"^",36)
	..s Fee=$fn($p($g(^DHCEQMonthDepre(MDRowID)),"^",14),"",2)
	..s CADCount=0
	..s CADRowID=0
	..f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID)) q:CADRowID=""  d
	...s CADCount=1
	...s CADType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",1)
	...q:CADType'=1
	...s LocID=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	...s LocName=""
	...;i LocID'="" s LocName=$p($g(^CTLOC(LocID)),"^",2)
	...i LocID'="" s LocName=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	...s FundsTypeID=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	...i FundsTypeID="" s FundsTypeID=SelfFundsFlag
	...i FundsTypeID'="" s FundsTypeID=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeID)),"^",1)
	...s Fee=$fn($p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5),"",2)
	...s ^BonusTempGDZC($J,FundsTypeID,TDateFlag,TEquipTypeCode_":"_TEquipType,LocID_":"_LocName)=Fee+$g(^BonusTempGDZC($J,FundsTypeID,TDateFlag,TEquipTypeCode_":"_TEquipType,LocID_":"_LocName))
	..i CADCount=0  d
	...s FundsTypeID=SelfFundsFlag
	...i FundsTypeID'="" s FundsTypeID=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeID)),"^",1)
	...s ^BonusTempGDZC($J,FundsTypeID,TDateFlag,TEquipTypeCode_":"_TEquipType,LocID_":"_LocName)=Fee+$g(^BonusTempGDZC($J,FundsTypeID,TDateFlag,TEquipTypeCode_":"_TEquipType,LocID_":"_LocName))
	
	q 1
}

}
