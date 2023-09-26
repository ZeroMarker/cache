/// 名称: web.DHCEQ.EM.BUSEquip
/// 描述: 设备生命周期管理
/// 编写者：ZX
/// 编写日期: 2018-08-22
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSLifeInfo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-08-22
/// Description:   解析单条台账信息
/// Table：        DHC_EQLifeInfo
/// Input：        EquipDR：设备RowID
///                LocDR：变动科室
///                EquipTypeDR：设备类组
///                LifeTypeDR：生命周期类型
///                StartDate：开始日期
///                EndDate：结束日期
///                SourceTypeDR：业务类型
///                QXType：权限类型
/// Output： 
/// modifed by wy 2019-3-29 生命周期增加采购申请，计划，招标信息
/// Modify By zx 2020-08-14 ZX0101 移动端需要传入session值
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSLifeInfo","LifeInfo","9","","","","","","","","85","202")      
Query LifeInfo(EquipDR As %String, LocDR As %String, EquipTypeDR As %String, LifeTypeDR As %String, StartDate As %String, EndDate As %String, SourceTypeDR As %String, QXType As %String = "", GroupID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TEquip:%String,TGroup:%String,TFromUseLoc:%String,TFromManagerLoc:%String,TFromStoreLoc:%String,TFromOriginalFee:%String,TFromNetFee:%String,TToUseLoc:%String,TToManagerLoc:%String,TToStoreLoc:%String,TToOriginalFee:%String,TToNetFee:%String,TChangeReason:%String,TChangeDesc:%String,TChangeDate:%String,TChangeTime:%String,TUsedFee:%String,TLifeType:%String,TSourceType:%String,TSourceID:%String,TAppendType:%String,TRemark:%String,TSourceTypeDR:%String,TEquipNo:%String,TYear:%String,TKeyInfo:%String")
{
}

ClassMethod LifeInfoExecute(ByRef qHandle As %Binary, EquipDR As %String, LocDR As %String, EquipTypeDR As %String, LifeTypeDR As %String, StartDate As %String, EndDate As %String, SourceTypeDR As %String, QXType As %String = "", GroupID As %String = "", LocID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s EQRowID=0
	i EquipDR="" Quit $$$OK
	s GetSysInfo=##class(web.DHCEQCommon).GetSysInfo("201003")
	d BuildDataGetLifeInfo
	Quit $$$OK
BuildDataGetLifeInfo
	f  s EQRowID=$o(^DHCEQEquip(EQRowID)) q:EQRowID=""  d
	.d ResetVariablesGetLifeInfo
	.s TEquip=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.q:(EquipDR'="")&&(EQRowID'=EquipDR)
	.s EquipType=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	.// Modify By zx 2020-08-14 ZX0101
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,GroupID))
	.q:(EquipTypeDR'="")&&(EquipType'=EquipTypeDR)
	.s SourceID=$p($g(^DHCEQEquip(EQRowID)),"^",77)
	.s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s ISLRowID=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.;通过合同明细ID找前面的招标、计划、申请的ID
	.s ContractListID=$p($g(^DHCEQEquip(EQRowID)),"^",32)
	.s (CTListSourceType,CTListSourceID,BYID,BPID,IFBID)=""
	.i ContractListID'="" d
	..s CTListSourceType=$p($g(^DHCEQContractList(ContractListID)),"^",5)
	..s CTListSourceID=$p($g(^DHCEQContractList(ContractListID)),"^",17)
	..//CTListSourceType:1-计划;  2-招标
	..i CTListSourceType=1 d
	...s BPID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",1)
	...q:(BPID'="")&&($p($g(^DHCEQBuyPlan(BPID)),"^",46)="Y")    //add by wy 2020-4-1 需求1249940	
	...s BYListID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",10)
	...i BYListID'="" s BYID=$p($g(^DHCEQBuyPlanList(BYListID)),"^",1)
	..e  i CTListSourceType=2 d
	...s IFBID=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",1)
	...s IFBSourceType=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",9)
	...s IFBSourceID=$p($g(^DHCEQIFBBag(CTListSourceID)),"^",10)
	...//IFBSourceType:1-申请;  2-计划
	...i IFBSourceType=1 d
	....s BYID=$p($g(^DHCEQBuyRequestList(IFBSourceID)),"^",1)
	...e  i IFBSourceType=2 d
	....s BPID=$p($g(^DHCEQBuyPlanList(IFBSourceID)),"^",1)
	....s BYListID=$p($g(^DHCEQBuyPlanList(IFBSourceID)),"^",10)
	....i BYListID'="" s BYID=$p($g(^DHCEQBuyRequestList(BYListID)),"^",1)
	.e  d		//无合同ID时,验收来自计划 Modify DJ 2019-06-06
	..i SourceID'=""  d
	...s OCLSourceType=$p($g(^DHCEQOpenCheckList(SourceID)),"^",63)
	...i OCLSourceType=3  d		//验收来自计划
	....s BPListID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",64)
	....i BPListID'=""  d
	.....s BPID=$p($g(^DHCEQBuyPlanList(BPListID)),"^",1)
	.....q:(BPID'="")&&($p($g(^DHCEQBuyPlan(BPID)),"^",46)="Y")    //add by wy 2020-4-1 需求1249940	
	.....s BYListID=$p($g(^DHCEQBuyPlanList(BPListID)),"^",10)		//计划来自申请
	.....i BYListID'="" s BYID=$p($g(^DHCEQBuyRequestList(BYListID)),"^",1)
	.;采购申请
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["91"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["91")))  d
	..s TLifeType="C"
	..s TSourceType="91"
	..s TSourceTypeDR="91"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..;i ContractListID'="" d		//Modify DJ 2019-06-06 生命周期与是否存在合同ID无关
	..q:BYID=""
	..s TSourceID=BYID
	..s UseLoc=""
	..s TChangeDate=$p($g(^DHCEQBuyRequest(TSourceID)),"^",14)
	..q:$p($g(^DHCEQBuyRequest(TSourceID)),"^",45)="Y"    //add by wy 2020-4-1 需求1249940	
	..s TYear=$p($zd(TChangeDate,3),"-",1)
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..s ManagerLoc=""
	..s StoreLoc=""
	..q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	..s Flag=0
	..// Modify By zx 2020-08-14 ZX0101
	..i (TFromStoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	..i (StoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	..q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	..s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyRequest(TSourceID)),"^",9)/$p($g(^DHCEQBuyRequest(TSourceID)),"^",8),"")
	..s TFromOriginalFee=TToOriginalFee
	..s TToNetFee=""
	..i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	..i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)    //modify by jyp 2019-10-18 CTLOC调整
	..i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	..s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	..s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",15),"time")
	..s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	..d OutputRowGetLifeInfo
	.;采购计划
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["92"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["92")))  d
	..s TLifeType="C"
	..s TSourceType="92"
	..s TSourceTypeDR="92"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..;i ContractListID'="" d		//Modify DJ 2019-06-06 生命周期与是否存在合同ID无关
	..q:BPID=""
	..s TSourceID=BPID
	..s UseLoc=""
	..s TChangeDate=$p($g(^DHCEQBuyPlan(TSourceID)),"^",17)
	..q:$p($g(^DHCEQBuyPlan(TSourceID)),"^",46)="Y"   //add by wy 2020-4-1 需求1249940	
	..s TYear=$p($zd(TChangeDate,3),"-",1)
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..s ManagerLoc=""
	..s StoreLoc=""
	..q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	..s Flag=0
	..// Modify By zx 2020-08-14 ZX0101
	..i (TFromStoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	..i (StoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	..q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	..s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyPlan(TSourceID)),"^",3)/$p($g(^DHCEQBuyPlan(TSourceID)),"^",2),"")
	..s TFromOriginalFee=TToOriginalFee
	..s TToNetFee=""
	..i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	..i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)    //modify by jyp 2019-10-18 CTLOC调整
	..i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	..s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	..s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",18),"time")
	..s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	..d OutputRowGetLifeInfo
	.;招标
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["93"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["93")))  d
	..s TLifeType="C"
	..s TSourceType="93"
	..s TSourceTypeDR="93"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i ContractListID'="" d
	...q:IFBID=""
	...s TSourceID=IFBID
	...s UseLoc=""
	...s TChangeDate=$p($g(^DHCEQIFB(TSourceID)),"^",48)
	...s TYear=$p($zd(TChangeDate,3),"-",1)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=""
	...s StoreLoc=""
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...// Modify By zx 2020-08-14 ZX0101
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s (IFBBID,VFlag,OriginalFee)=0
	...f  s IFBBID=$o(^DHCEQIFBBag(0,"IFB",TSourceID,IFBBID)) q:(IFBBID="")||(VFlag=1)  d
	....s IFBBItemDR=$p($g(^DHCEQIFBBag(IFBBID)),"^",11)
	....i (IFBBItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)) d
	.....s VFlag=1
	.....s OriginalFee=$p($g(^DHCEQIFBBag(IFBBID)),"^",11)
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee,"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=""
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)    //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",49),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.;合同
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["94"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["94")))  d
	..s TLifeType="C"
	..s TSourceType="94"
	..s TSourceTypeDR="94"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i ContractListID'="" d
	...;Mozy	612287	2018-11-30
	...s CTRowID=$p($g(^DHCEQContractList(ContractListID)),"^",1)
	...q:CTRowID=""
	...s TSourceID=CTRowID
	...s UseLoc=""
	...s TChangeDate=$p($g(^DHCEQContract(CTRowID)),"^",33)
	...s TYear=$p($zd(TChangeDate,3),"-",1)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQContract(CTRowID)),"^",51)
	...s StoreLoc=$p($g(^DHCEQContract(CTRowID)),"^",8)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...// Modify By zx 2020-08-14 ZX0101
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(ContractListID)),"^",6),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=""
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)    //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(CTRowID)),"^",34),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.;验收设备生命周期
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["11"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["11")))  d
	..s TLifeType="C"
	..s TSourceType="11"
	..s TSourceTypeDR="11"
	..q:(SourceTypeDR'="")&&((","_SourceTypeDR_",")'[(","_TSourceTypeDR_","))  //add by zx 2019-04-02 ZX0062
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i SourceID'="" d //批量验收
	...s TSourceID=SourceID
	...s UseLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",33)
	...s OCRRowID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",1)
	...q:OCRRowID=""
	...s TChangeDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26)
	...q:$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)="Y"   //add by wy 2020-3-31	
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",32)
	...s StoreLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",31)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...// Modify By zx 2020-08-14 ZX0101
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(SourceID)),"^",17),"")
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(SourceID)),"^",18),"")
	...i UseLoc'="" s TToUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", ManagerLoc)
	...i StoreLoc'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLoc)
	...s TYear=$p($zd(TChangeDate,3),"-",1)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",27),"time")
	...s TKeyInfo=##Class(web.DHCEQ.EM.BUSLifeInfo).GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	..else  d //单设备验收
	...s OCRowID=$o(^DHCEQOpenCheck(0,"Equip",EQRowID,0))
	...q:OCRowID=""
	...s TSourceID=OCRowID
	...s UseLoc=$p($g(^DHCEQOpenCheck(OCRowID)),"^",4)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (TToStoreLoc=LocDR))
	...s Flag=0
	...// Modify By zx 2020-08-14 ZX0101
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	...i (TToStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToStoreLoc,LocID))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(TToStoreLoc=""))) //2010-10-2 DJ end
	...s TChangeDate=$p($g(^DHCEQOpenCheck(OCRowID)),"^",18)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQOpenCheck(OCRowID)),"^",3)
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheck(OCRowID)),"^",45),"")
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheck(OCRowID)),"^",46),"")
	...i UseLoc'="" s TToUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", ManagerLoc)
	...s TYear=$p($zd(TChangeDate,3),"-",1)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheck(OCRowID)),"^",19),"time")
	...s TKeyInfo=##Class(web.DHCEQ.EM.BUSLifeInfo).GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.;入库设备生命周期
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR["21"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR["21")))  d
	..Set InputFlag=$Piece($Get(^DHCEQEquip(EQRowID)),"^",47)
	..Quit:InputFlag="Y"
	..q:ISLRowID=""
	..s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	..q:ISRowID=""
	..s TLifeType="C"
	..s TSourceType="21"
	..s TSourceTypeDR="21"
	..q:(SourceTypeDR'="")&&((","_SourceTypeDR_",")'[(","_TSourceTypeDR_","))  //add by zx 2019-04-02 ZX0062
	..s TSourceID=ISLRowID
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..s TChangeDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..q:$p($g(^DHCEQInStock(ISRowID)),"^",25)="Y"  //add by wy 2020-4-1 需求1249940	
	..s (TFromStoreLoc,TToUseLoc,TToManagerLoc,TToStoreLoc,TToNetFee)=""
	..s StoreLoc=$p($g(^DHCEQInStock(ISRowID)),"^",2)
	..q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	..s Flag=0
	..// Modify By zx 2020-08-14 ZX0101
	..i (TFromStoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	..i (StoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc,LocID))) s Flag=1
	..q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	..i StoreLoc'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", StoreLoc)
	..s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"")
	..s TToNetFee=##Class(web.DHCEQCommon).FormatNumber(TToOriginalFee,"")
	..s TYear=$p($zd(TChangeDate,3),"-",1)
	..s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	..s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p(##Class(web.DHCEQ.EM.BUSLifeInfo).GetBussAduitTime(21,ISRowID),"^",2),"time")   //Modife by zc 2020-09-18 ZC0083 取入库审核时间
	..s TKeyInfo=##Class(web.DHCEQ.EM.BUSLifeInfo).GetKeyInfo(TSourceTypeDR, TSourceID)
	..d OutputRowGetLifeInfo
	.;设备生命周期信息(包括:维修,转移,减少,保养,检查,报废,折旧,使用,设备调账)
	.s LIChangeDate=0
	.f  s LIChangeDate=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate)) q:LIChangeDate=""  d
	..s LIRowID=0
	..s TChangeDate=LIChangeDate
	..s TYear=$p($zd(TChangeDate,3),"-",1)
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate,LIRowID)) q:LIRowID=""  d
	...q:$p($g(^DHCEQLifeInfo(LIRowID)),"^",30)="Y"    //add by wy 2020-4-1 需求1249940
	...s TLifeType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",18)     
	...q:(LifeTypeDR'="")&&(TLifeType'=LifeTypeDR)
	...s TSourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	...;q:(SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	...q:(SourceTypeDR'="")&&((","_SourceTypeDR_",")'[(","_TSourceType_","))  //add by zx 2019-04-02 ZX0062
	...s TChangeDate=##class(web.DHCEQCommon).TransValueToPage(LIChangeDate,"date")
	...s TFromUseLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",3)
	...s TToUseLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",8)
	...s TGroup=$p($g(^DHCEQLifeInfo(LIRowID)),"^",2)	
	...s TFromManagerLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",4)
	...s TFromStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",5)
	...s TFromOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",6),"")
	...s TFromNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",7),"")
	...s TToManagerLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",9)
	...s TToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (TToStoreLoc=LocDR))
	...s Flag=0
	...// Modify By zx 2020-08-14 ZX0101
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc,LocID))) s Flag=1
	...i (TToStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToStoreLoc,LocID))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(TToStoreLoc="")))
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",11),"")
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",12),"")
	...s TChangeReason=$p($g(^DHCEQLifeInfo(LIRowID)),"^",13)
	...s TChangeDesc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",14)
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQLifeInfo(LIRowID)),"^",16),"time")
	...s TUsedFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",17)
	...i TUsedFee'="" s TUsedFee=##class(web.DHCEQCommon).FormatNumber(TUsedFee,"")	//add by wl 2019-08-28 将折旧费格式转换	
	...s TSourceID=$p($g(^DHCEQLifeInfo(LIRowID)),"^",20)
	...s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	...s TAppendType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",21)
	...i TAppendType'="" s TAppendType=##Class(web.DHCEQ.EM.BUSLifeInfo).GetEditAppendTypeDisplay(TAppendType,TSourceType)
	...s TSourceTypeDR=TSourceType
	...s TKeyInfo=##Class(web.DHCEQ.EM.BUSLifeInfo).GetKeyInfo(TSourceTypeDR, TSourceID)
	...i TSourceType'="41"  d
	....s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	...e  d
	....s TSourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",13)
	...i (TSourceTypeDR=33)&&(TChangeReason'="") s TSourceType=TChangeReason		//modified by czf 1316899
	...i TAppendType="" s TAppendType=TSourceType	
	...s TRemark=$p($g(^DHCEQLifeInfo(LIRowID)),"^",22)
	...i TGroup'="" s TGroup=$p($g(^DHCEQGroup(TGroup)),"^",2)
	...i TFromUseLoc'="" s TFromUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromUseLoc)
	...i TFromManagerLoc'="" s TFromManagerLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromManagerLoc)
	...i TFromStoreLoc'="" s TFromStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromStoreLoc)
	...i TToUseLoc'="" s TToUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToUseLoc)
	...i TToManagerLoc'="" s TToManagerLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToManagerLoc)
	...i TToStoreLoc'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToStoreLoc)
	...d OutputRowGetLifeInfo
	quit
OutputRowGetLifeInfo
	s Data=$lb(TEquip,TGroup,TFromUseLoc,TFromManagerLoc,TFromStoreLoc,TFromOriginalFee,TFromNetFee,TToUseLoc,TToManagerLoc,TToStoreLoc,TToOriginalFee,TToNetFee,TChangeReason,TChangeDesc,TChangeDate,TChangeTime,TUsedFee,TLifeType,TSourceType,TSourceID,TAppendType,TRemark,TSourceTypeDR,TEquipNo,TYear,TKeyInfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLifeInfo
	s (TEquip,TGroup,TFromUseLoc,TFromManagerLoc,TFromStoreLoc,TFromOriginalFee,TFromNetFee,TToUseLoc,TToManagerLoc,TToStoreLoc,TToOriginalFee,TToNetFee,TChangeReason,TChangeDesc,TChangeDate,TChangeTime,TUsedFee,TLifeType,TSourceType,TSourceID,TAppendType,TRemark,TSourceTypeDR,TEquipNo,TYear,TKeyInfo)=""
	quit
}

ClassMethod LifeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LifeInfoExecute ]
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

ClassMethod LifeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LifeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEditAppendTypeDisplay(AppendType, SourceType)
{
	i +SourceType="22" //转移
	{
		s Type=$CASE(AppendType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义")
	}
	i +SourceType="23" //退货
	{
		s Type=$p($g(^DHCEQCCode("DHCEQCOutType",AppendType)),"^",2)
		i Type="" s Type="未定义"
	}
	q Type
}

/// 生命周期获取业务关键信息
/// add by mwz 20180523
/// 入参：来源类型SourceType，来源ID SourceID
/// w ##Class(web.DHCEQ.EM.BUSLifeInfo).GetKeyInfo("11", "476")
/// modifed by wy 2019-3-29 生命周期增加采购申请，计划，招标信息
ClassMethod GetKeyInfo(SourceType, SourceID)
{
	n TKeyInfo,StoreLoc,SubmitUser,InStockNo,ToStoreLoc,StoreMoveNo,FromLocDR
	s TKeyInfo=""
	i SourceType="11" //验收
	{
	s OCRRowID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",1)
	q:OCRRowID=""
	s OCLNO=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	s SubmitUserDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",22)
	i SubmitUserDR '=""  d
	.s SubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",SubmitUserDR)
	s TKeyInfo="验收人："_SubmitUser_"，验收单号："_OCLNO	
	}
	i SourceType="21" //入库
	{
	s ISRowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
	s StoreLoc=$p($g(^DHCEQInStock(ISRowID)),"^",2)
	s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	i StoreLoc'="" s ToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	i InStockNo'=""  s TKeyInfo="入库单号："_InStockNo_"，库房："_ToStoreLoc
	}
	i SourceType="22" //转移
	{
	s FromLoc="" s ToLoc=""
	s SMRowID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",1)
	s StoreMoveNo = $p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	s FromLocDR = $p($g(^DHCEQStoreMove(SMRowID)),"^",2)
	i FromLocDR '=""   s FromLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocDR)
	s ToLocDR = $p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	i ToLocDR '=""   s ToLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocDR)
	i StoreMoveNo'="" s TKeyInfo="转移单号："_StoreMoveNo_"，从："_FromLoc_"&emsp;到："_ToLoc
	}
	i SourceType="23" //减少
	{
		
	}
	i SourceType="31" //维修
	{
	;维修信息
	s FaultCase="",FaultReason=""
	s AcceptUserDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",26)
	i AcceptUserDR '=""  d
	.s AcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	s FaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",10)
	i FaultCaseDR '=""  s FaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",FaultCaseDR)),"^",2)
	s FaultReasonDR = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",12)
	i FaultReasonDR '="" s FaultReason = $Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",FaultReasonDR)),"^",2)
	s TKeyInfo="维修负责人："_AcceptUser_"，故障现象："_FaultCase_"，故障原因："_FaultReason
	}
	i SourceType="32" //保养
	{
		
	}
	i SourceType="33" //检查
	{
		
	}
	i SourceType="34" //报废
	{
	s RequestDR=$p(^DHCEQDisuseRequestList(SourceID),"^",1)
	s RequestNo=$p($g(^DHCEQDisuseRequest(RequestDR)),"^",33)
	s TKeyInfo=" 报废单号："_RequestNo
	}
		i SourceType="91" //采购申请
	{
		s BuyRequestName=$p($g(^DHCEQBuyRequest(TSourceID)),"^",1)
		s BuyRequestNo=$p($g(^DHCEQBuyRequest(TSourceID)),"^",35)	
		s TKeyInfo="&emsp;采购申请:"_BuyRequestName_",&emsp;采购申请单号:"_BuyRequestNo
	}
	i SourceType="92" //计划
	{
		s BuyPlanName=$p($g(^DHCEQBuyPlan(TSourceID)),"^",1)
		s BuyPlanNo=$p($g(^DHCEQBuyPlan(TSourceID)),"^",25)	
		s TKeyInfo="&emsp;采购计划:"_BuyPlanName_",&emsp;计划单号:"_BuyPlanNo
	}
	i SourceType="93" //招标
	{
		s IFBName=$p($g(^DHCEQIFB(TSourceID)),"^",1)
		s IFBNo=$p($g(^DHCEQIFB(TSourceID)),"^",3)	
		s TKeyInfo="&emsp;招标记录:"_IFBName_",&emsp;招标编号:"_IFBNo
	}

	i SourceType="94" //合同
	{
		//add by zx 2019-01-29 生命周期存合同主表信息  测试组需求号:821398
		s ContractName=$p($g(^DHCEQContract(SourceID)),"^",1)
		s ContractNo=$p($g(^DHCEQContract(SourceID)),"^",2)	
		s TKeyInfo="合同名称："_ContractName_"，合同号："_ContractNo
	}
	i SourceType="55" //拆分 czf 2021-07-28 2014955
	{
		s SplitNo=$p($g(^DHCEQSplit(SourceID)),"^",1)	
		s TKeyInfo="拆分单号："_SplitNo
	}
	q TKeyInfo
}

// Modife by zc 2020-09-18 ZC0083 根据业务类型与ID取最后一次消息处理的时间

/// 入参：来源类型vBussType，来源ID vBussID
/// w ##Class(web.DHCEQ.EM.BUSLifeInfo).GetBussAduitTime(21,2) 
ClassMethod GetBussAduitTime(vBussType, vBussID)
{
    i (vBussType="")||(vBussID="")  q "^"
    s MaxMessageDR=0
    s AduitTime=""
    s vMessageDR=""
    s vMessageID=0
	for  s vMessageID=$o(^DHCEQMessages(0,"MessageType",1,vBussType,vBussID,vMessageID)) q:vMessageID=""  d
    .s MessageDR=vMessageID
    .i MessageDR>MaxMessageDR d
	..s MaxMessageDR=MessageDR
	..s AduitTime=$p($g(^DHCEQMessages(MaxMessageDR)),"^",24)	
    q MaxMessageDR_"^"_AduitTime
}

}
