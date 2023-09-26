Import SQLUser

Class web.DHCEQLifeInfo Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 362;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "LI_RowID";

Parameter SQLDESCRIPTION = "LI_RowID";

Parameter SQLROWID = "LI_RowID";

/// 生命周期获取业务关键信息
/// add by mwz 20180523
/// 入参：来源类型SourceType，来源主单ID SourceID
ClassMethod GetKeyInfo(SourceType, SourceID)
{
	n TKeyInfo,StoreLoc,SubmitUser,InStockNo,ToStoreLoc,StoreMoveNo,FromLocDR
	s TKeyInfo=""
	i SourceType="11" //验收
	{
	// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
	q:SourceID=""
	s OCLNO=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",37)
	s SubmitUserDR=$p($g(^DHCEQOpenCheckRequest(SourceID)),"^",22)
	i SubmitUserDR '=""  d
	.s SubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",SubmitUserDR)
	s TKeyInfo="&emsp;验收人:"_SubmitUser_"，&emsp;验收单号:"_OCLNO	
	}
	i SourceType="21" //入库
	{
	// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
	s StoreLoc=$p($g(^DHCEQInStock(SourceID)),"^",2)
	s InStockNo=$p($g(^DHCEQInStock(SourceID)),"^",14)
	i StoreLoc'="" s ToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	i InStockNo'=""  s TKeyInfo="入库单号:"_InStockNo_"，&emsp;库房:"_ToStoreLoc
	}
	i SourceType="22" //转移
	{
	s FromLoc="" s ToLoc=""
	//start by csj 2020-08-20 需求号：1465461,1465482
#;	s SMRowID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",1)
	s StoreMoveNo = $p($g(^DHCEQStoreMove(SourceID)),"^",1)
	s FromLocDR = $p($g(^DHCEQStoreMove(SourceID)),"^",2)
	i FromLocDR '=""   s FromLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocDR)
	s ToLocDR = $p($g(^DHCEQStoreMove(SourceID)),"^",3)
	//end by csj 2020-08-20
	i ToLocDR '=""   s ToLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocDR)
	i StoreMoveNo'="" s TKeyInfo="&emsp;转移单号:"_StoreMoveNo_"，&emsp;从:"_FromLoc_"&emsp;到:"_ToLoc
	}
	i SourceType="23" //减少
	{
		
	}
	i SourceType="31" //维修
	{
	;维修信息	 MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
	s FaultCase="",FaultReason=""
	s AcceptUserDR=$p($g(^DHCEQMMaintRequest(SourceID)),"^",26)
	i AcceptUserDR '=""  d
	.s AcceptUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",AcceptUserDR)
	s FaultCaseDR = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",10)
	i FaultCaseDR '=""  s FaultCase = $Piece($Get(^DHCEQCCode("DHCEQMCFaultCase",FaultCaseDR)),"^",2)
	s FaultReasonDR = $Piece($Get(^DHCEQMMaintRequest(SourceID)),"^",12)
	i FaultReasonDR '="" s FaultReason = $Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",FaultReasonDR)),"^",2)
	s TKeyInfo=" 维修负责人："_AcceptUser_"，&emsp;故障现象："_FaultCase_"，&emsp;故障原因："_FaultReason
	}
	i SourceType="32" //保养
	{
		
	}
	i SourceType="33" //检查
	{
		
	}
	i SourceType="34" //报废
	{
		
	}
	i SourceType="94" //合同
	{
		// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
		s ContractName=$p($g(^DHCEQContract(SourceID)),"^",1)
		s ContractNo=$p($g(^DHCEQContract(SourceID)),"^",2)	
		s TKeyInfo="&emsp;合同名称:"_ContractName_",&emsp;合同号:"_ContractNo
	}
	i SourceType="91" //采购申请
	{
		// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
		s BuyRequestName=$p($g(^DHCEQBuyRequest(SourceID)),"^",1)
		s BuyRequestNo=$p($g(^DHCEQBuyRequest(SourceID)),"^",35)	 //modifed by wy 2019-3-29
		s TKeyInfo="&emsp;采购申请:"_BuyRequestName_",&emsp;采购申请单号:"_BuyRequestNo
	}
	i SourceType="92" //计划
	{
		// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
		s BuyPlanName=$p($g(^DHCEQBuyPlan(SourceID)),"^",1)
		s BuyPlanNo=$p($g(^DHCEQBuyPlan(SourceID)),"^",25)	
		s TKeyInfo="&emsp;采购计划:"_BuyPlanName_",&emsp;计划单号:"_BuyPlanNo
	}
	i SourceType="93" //招标
	{
		// MZY0099	2224043,2224099		2021-11-13	修正TSourceID参数
		s IFBName=$p($g(^DHCEQIFB(SourceID)),"^",1)
		s IFBNo=$p($g(^DHCEQIFB(SourceID)),"^",3)	
		s TKeyInfo="&emsp;招标记录:"_IFBName_",&emsp;招标编号:"_IFBNo
	}
	q TKeyInfo
}

/// w ##Class(%ResultSet).RunQuery("web.DHCEQLifeInfo","LifeInfo","999")
/// modifed by wy 2019-3-29 需求：
Query LifeInfo(EquipDR, LocDR, EquipTypeDR, LifeTypeDR, StartDate, EndDate, SourceTypeDR, QXType As %String = "") As %Query(ROWSPEC = "TEquip:%String,TGroup:%String,TFromUseLoc:%String,TFromManagerLoc:%String,TFromStoreLoc:%String,TFromOriginalFee:%String,TFromNetFee:%String,TToUseLoc:%String,TToManagerLoc:%String,TToStoreLoc:%String,TToOriginalFee:%String,TToNetFee:%String,TChangeReason:%String,TChangeDesc:%String,TChangeDate:%String,TChangeTime:%String,TUsedFee:%String,TLifeType:%String,TSourceType:%String,TSourceID:%String,TAppendType:%String,TRemark:%String,TSourceTypeDR:%String,TEquipNo:%String,TRow:%String,TKeyInfo:%String")
{
}

ClassMethod LifeInfoExecute(ByRef qHandle As %Binary, EquipDR As %String = "", LocDR As %String = "", EquipTypeDR As %String = "", LifeTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", SourceTypeDR As %String = "", QXType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	s EQRowID=0
	s TKeyInfo=""
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i EquipDR="" Quit $$$OK
	
	s GetSysInfo=##class(web.DHCEQCommon).GetSysInfo("201003")
	f  s EQRowID=$o(^DHCEQEquip(EQRowID)) q:EQRowID=""  d
	.d ResetVariablesGetLifeInfo
	.s TEquip=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	.q:(EquipDR'="")&&(EQRowID'=EquipDR)
	.s EquipType=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType)) //2010-12-29 DJ
	.q:(EquipTypeDR'="")&&(EquipType'=EquipTypeDR)
	.s SourceID=$p($g(^DHCEQEquip(EQRowID)),"^",77)
	.s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.s ISLRowID=$p($g(^DHCEQEquip(EQRowID)),"^",70)
	.;设备合同生命周期	//add by ZY0165 2018-04-26  生命周期增加合同的节点
	.;通过合同明细ID找前面的招标、计划、申请的ID
	.s ContractListID=$p($g(^DHCEQEquip(EQRowID)),"^",32)
	.s (CTListSourceType,CTListSourceID,BYID,BPID,IFBID)=""
	.i ContractListID'="" d
	..s CTListSourceType=$p($g(^DHCEQContractList(ContractListID)),"^",5)
	..s CTListSourceID=$p($g(^DHCEQContractList(ContractListID)),"^",17)
	..//CTListSourceType:1-计划;  2-招标
	..i CTListSourceType=1 d
	...s BPID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",1)
	...s BYListID=$p($g(^DHCEQBuyPlanList(CTListSourceID)),"^",10)
	...i BYListID'="" s BYID=$p($g(^DHCEQBuyRequestList(BYListID)),"^",1)
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
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="94"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="94")))  d
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
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQContract(CTRowID)),"^",51)
	...s StoreLoc=$p($g(^DHCEQContract(CTRowID)),"^",8)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(ContractListID)),"^",6),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=""
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(CTRowID)),"^",34),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="91"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="91")))  d
	..s TLifeType="C"
	..s TSourceType="91"
	..s TSourceTypeDR="91"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i ContractListID'="" d
	...;Mozy	612287	2018-11-30
	...q:BYID=""
	...s TSourceID=BYID
	...s UseLoc=""
	...s TChangeDate=$p($g(^DHCEQBuyRequest(TSourceID)),"^",14)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=""
	...s StoreLoc=""
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyRequest(TSourceID)),"^",9)/$p($g(^DHCEQBuyRequest(TSourceID)),"^",8),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=""
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",15),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="92"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="92")))  d
	..s TLifeType="C"
	..s TSourceType="92"
	..s TSourceTypeDR="92"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i ContractListID'="" d
	...;Mozy	612287	2018-11-30
	...q:BPID=""
	...s TSourceID=BPID
	...s UseLoc=""
	...s TChangeDate=$p($g(^DHCEQBuyPlan(TSourceID)),"^",17)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=""
	...s StoreLoc=""
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc="")))
	...s TQuantityNum=$p($g(^DHCEQBuyPlan(TSourceID)),"^",2)
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQBuyPlan(TSourceID)),"^",3)/$p($g(^DHCEQBuyPlan(TSourceID)),"^",2),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=""
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",18),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="93"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="93")))  d
	..s TLifeType="C"
	..s TSourceType="93"
	..s TSourceTypeDR="93"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i ContractListID'="" d
	...;Mozy	612287	2018-11-30
	...q:IFBID=""
	...s TSourceID=IFBID
	...s UseLoc=""
	...s TChangeDate=$p($g(^DHCEQIFB(TSourceID)),"^",48)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=""
	...s StoreLoc=""
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
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
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQBuyPlan(TSourceID)),"^",49),"time")
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	...d OutputRowGetLifeInfo
	.
	.;验收设备生命周期
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="11"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="11")))  d
	..s TLifeType="C"
	..s TSourceType="11"
	..s TSourceTypeDR="11"
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..i SourceID'="" d //批量验收
	...;;;s TSourceID=SourceID
	...s UseLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",33)
	...s OCRRowID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",1)
	...q:OCRRowID=""
	...s TSourceID=OCRRowID		// MZY0099	2224043,2224099		2021-11-13	
	...s TChangeDate=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",32)
	...s StoreLoc=$p($g(^DHCEQOpenCheckList(SourceID)),"^",31)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR))
	...s Flag=0 //2010-10-28 DJ begin
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (StoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc=""))) //2010-10-2 DJ end
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(SourceID)),"^",17),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(SourceID)),"^",18),"")
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	...//s TChangeDate=$ZD(TChangeDate)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",27),"time") ;Modified by QW20170302日期格式统一调整 原s TChangeTime=$ZT($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",27))
	...s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)	// MZY0099	2224043,2224099		2021-11-13
	...d OutputRowGetLifeInfo
	..else  d //单设备验收
	...s OCRowID=$o(^DHCEQOpenCheck(0,"Equip",EQRowID,0))
	...q:OCRowID=""
	...s TSourceID=OCRowID
	...s UseLoc=$p($g(^DHCEQOpenCheck(OCRowID)),"^",4)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (TToStoreLoc=LocDR))
	...s Flag=0 //2010-10-28 DJ begin
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (TToStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToStoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(TToStoreLoc=""))) //2010-10-2 DJ end
	...s TChangeDate=$p($g(^DHCEQOpenCheck(OCRowID)),"^",18)
	...q:(StartDate'="")&&(TChangeDate<StartDate)
	...q:(EndDate'="")&&(TChangeDate>EndDate)
	...s ManagerLoc=$p($g(^DHCEQOpenCheck(OCRowID)),"^",3)
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheck(OCRowID)),"^",45),"")
	...s TFromOriginalFee=TToOriginalFee
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheck(OCRowID)),"^",46),"")
	...i UseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...i ManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...//s TChangeDate=$ZD(TChangeDate)
	...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheck(OCRowID)),"^",19),"time") ;Modified by QW20170302日期格式统一调整 原s TChangeTime=$ZT($p($g(^DHCEQOpenCheck(OCRowID)),"^",19))
	...d OutputRowGetLifeInfo
	.;入库设备生命周期
	.i ((LifeTypeDR="") && ((SourceTypeDR="") || (SourceTypeDR="21"))) || ((LifeTypeDR="C") && ((SourceTypeDR="") || (SourceTypeDR="21")))  d
	..;Mozy0098		2013-4-19	过滤导入设备的入库记录
	..Set InputFlag=$Piece($Get(^DHCEQEquip(EQRowID)),"^",47)
	..Quit:InputFlag="Y"
	..q:ISLRowID=""
	..s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	..q:ISRowID=""
	..s TLifeType="C"
	..s TSourceType="21"
	..s TSourceTypeDR="21"
	..s TSourceID=ISRowID		// MZY0099	2224043,2224099		2021-11-13
	..s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	..s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	..s TAppendType=TSourceType
	..s TChangeDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..s (TFromStoreLoc,TToUseLoc,TToManagerLoc,TToStoreLoc,TToNetFee)="" //2010-10-28 DJ
	..s StoreLoc=$p($g(^DHCEQInStock(ISRowID)),"^",2)
	..q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (StoreLoc=LocDR)) //2010-10-28 DJ
	..s Flag=0
	..i (TFromStoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	..i (StoreLoc'="")  d
	...i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc))) s Flag=1
	..q:'((Flag=1)||((TFromStoreLoc="")&&(StoreLoc=""))) //2010-10-2 DJ end
	..i StoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
	..s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"")
	..s TToNetFee=##Class(web.DHCEQCommon).FormatNumber(TToOriginalFee,"")
	..//s TChangeDate=$ZD(TChangeDate)
	..s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	..s TChangeTime=""
	..s TKeyInfo=..GetKeyInfo(TSourceTypeDR, TSourceID)
	..d OutputRowGetLifeInfo
	.;设备生命周期信息(包括:维修,转移,减少,保养,检查,报废,折旧,使用,设备调账)
	.s LIChangeDate=0
	.f  s LIChangeDate=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate)) q:LIChangeDate=""  d
	..s LIRowID=0
	..s TChangeDate=LIChangeDate
	..q:(StartDate'="")&&(TChangeDate<StartDate)
	..q:(EndDate'="")&&(TChangeDate>EndDate)
	..f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",EQRowID,LIChangeDate,LIRowID)) q:LIRowID=""  d
	...q:$p($g(^DHCEQLifeInfo(LIRowID)),"^",30)="Y"   ///Modefied by ZC0081 2020-09-07  生命周期无效过滤
	...s TLifeType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",18)
	...q:(LifeTypeDR'="")&&(TLifeType'=LifeTypeDR)
	...s TSourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	...q:(SourceTypeDR'="")&&(TSourceType'=SourceTypeDR)
	...s TChangeDate=##class(web.DHCEQCommon).TransValueToPage(LIChangeDate,"date") ;Modified by QW20170302日期格式统一调整 原$ZD(LIChangeDate,4)
	...//s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	...s TFromUseLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",3)
	...s TToUseLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",8)
	...s TGroup=$p($g(^DHCEQLifeInfo(LIRowID)),"^",2)	
	...s TFromManagerLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",4)
	...s TFromStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",5)
	...s TFromOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",6),"")
	...s TFromNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",7),"")
	...s TToManagerLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",9)
	...s TToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	...q:(LocDR'="")&&'((TFromStoreLoc=LocDR) || (TToStoreLoc=LocDR)) //2010-10-28 DJ
	...s Flag=0 //2010-10-28 DJ begin
	...i (TFromStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromStoreLoc))) s Flag=1
	...i (TToStoreLoc'="")  d
	....i (1'=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToStoreLoc))) s Flag=1
	...q:'((Flag=1)||((TFromStoreLoc="")&&(TToStoreLoc=""))) //2010-10-2 DJ end
	...s TToOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",11),"")
	...s TToNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQLifeInfo(LIRowID)),"^",12),"")
	...s TChangeReason=$p($g(^DHCEQLifeInfo(LIRowID)),"^",13)
	...s TChangeDesc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",14)
	...s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQLifeInfo(LIRowID)),"^",16),"time") ;Modified by QW20170302日期格式统一调整 原s TChangeTime=$ZT($p($g(^DHCEQLifeInfo(LIRowID)),"^",16))
	...s TUsedFee=$p($g(^DHCEQLifeInfo(LIRowID)),"^",17)	
	...s TSourceID=##Class(web.DHCEQLifeInfo).GetBussIDBySource(TSourceType, $p($g(^DHCEQLifeInfo(LIRowID)),"^",20))	// MZY0099	2224043,2224099		2021-11-13	将BussID转换成SourceID
	...;i TSourceType="22" s TSourceID=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",1) //add by csj 2020-05-07 取转移主表ID 需求号：1192717 //czf 1758968 2021-02-19
	...s TKeyInfo=..GetKeyInfo(TSourceType, TSourceID)
	...s TLifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(TLifeType)
	...s TAppendType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",21)
	...i TAppendType'="" s TAppendType=..GetEditAppendTypeDisplay(TAppendType,TSourceType)
	...s TSourceTypeDR=TSourceType
	...i TSourceType'="41"  d
	....s TSourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(TSourceType)
	...e  d
	....s TSourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",13)
	...i TAppendType="" s TAppendType=TSourceType	
	...s TRemark=$p($g(^DHCEQLifeInfo(LIRowID)),"^",22)
	...i TGroup'="" s TGroup=$p($g(^DHCEQGroup(TGroup)),"^",2)
	...i TFromUseLoc'="" s TFromUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromUseLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i TFromManagerLoc'="" s TFromManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i TFromStoreLoc'="" s TFromStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromStoreLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i TToUseLoc'="" s TToUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToUseLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i TToManagerLoc'="" s TToManagerLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToManagerLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...i TToStoreLoc'="" s TToStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToStoreLoc)  //modify by jyp 2019-10-18 CTLOC调整
	...d OutputRowGetLifeInfo
	Quit $$$OK
OutputRowGetLifeInfo
	Set Data=$lb(TEquip,TGroup,TFromUseLoc,TFromManagerLoc,TFromStoreLoc,TFromOriginalFee,TFromNetFee,TToUseLoc,TToManagerLoc,TToStoreLoc,TToOriginalFee,TToNetFee,TChangeReason,TChangeDesc,TChangeDate,TChangeTime,TUsedFee,TLifeType,TSourceType,TSourceID,TAppendType,TRemark,TSourceTypeDR,TEquipNo,TRow,TKeyInfo) //2009-08-11 党军
	Set ^CacheTemp(repid,index)=Data
	Set TKeyInfo=""
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetLifeInfo
	s (TEquip,TGroup,TFromUseLoc,TFromManagerLoc,TFromStoreLoc,TFromOriginalFee,TFromNetFee,TToUseLoc,TToManagerLoc,TToStoreLoc,TToOriginalFee,TToNetFee,TChangeReason,TChangeDesc,TChangeDate,TChangeTime,TUsedFee,TLifeType,TSourceType,TSourceID,TAppendType,TRemark,TSourceTypeDR,TEquipNo,TKeyInfo)="" //2009-08-11 党军
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

/****************************************************************************/
Query GetLifeType() As %Query(ROWSPEC = "LifeType:%String:类型,ID:%String")
{
}

ClassMethod GetLifeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	d BuildDataGetLifeType
	Quit $$$OK
BuildDataGetLifeType
	s ID="I"
	s LifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(ID)
	d OutputRowGetLifeType
	s ID="P"
	s LifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(ID)
	d OutputRowGetLifeType
	s ID="C"
	s LifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(ID)
	d OutputRowGetLifeType
	s ID="O"
	s LifeType=##Class(web.DHCEQCommon).GetEditLifeTypeDisplay(ID)
	d OutputRowGetLifeType
	quit
OutputRowGetLifeType
	s Data=$lb(LifeType,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLifeType
	s (LifeType,ID)=""
	quit
}

ClassMethod GetLifeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLifeTypeExecute ]
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

ClassMethod GetLifeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLifeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/***********************************************************************/
Query GetLifeSourceType() As %Query(ROWSPEC = "SourceType:%String:类型,ID:%String")
{
}

ClassMethod GetLifeSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	d BuildDataGetLifeSourceType
	Quit $$$OK
BuildDataGetLifeSourceType
	s ID="11"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="12"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="21"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="22"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="23"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="31"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="32"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="33"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="34"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="35"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="41"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	s ID="51"
	s SourceType=##Class(web.DHCEQCommon).GetEditLifeSourceTypeDisplay(ID)
	d OutputRowGetLifeSourceType
	quit
OutputRowGetLifeSourceType
	s Data=$lb(SourceType,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLifeSourceType
	s (SourceType,ID)=""
	quit
}

ClassMethod GetLifeSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLifeSourceTypeExecute ]
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

ClassMethod GetLifeSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLifeSourceTypeExecute ]
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

/// add by ZY 2014-09-20  ZY0118
/// w ##Class(web.DHCEQLifeInfo).GetEquipLifeInfo(EquipID)
ClassMethod GetEquipLifeInfo(EquipID)
{
	new LifeInfo,LIChangeDate,LIRowID,TLifeType
	
	s LifeInfo=""
	s LIChangeDate=0
	f  s LIChangeDate=$o(^DHCEQLifeInfo(0,"Equip",EquipID,LIChangeDate)) q:LIChangeDate=""  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"Equip",EquipID,LIChangeDate,LIRowID)) q:LIRowID=""  d
	..s TLifeType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",18)
	..q:TLifeType'="C"
	..s TSourceType=$p($g(^DHCEQLifeInfo(LIRowID)),"^",19)
	..q:TSourceType'="22"
	..s TChangeDate=##class(web.DHCEQCommon).TransValueToPage(LIChangeDate,"date") ;Modified by QW20170302日期格式统一调整 原$ZD(LIChangeDate,3)
	..s TFromStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",5)
	..s TToStoreLoc=$p($g(^DHCEQLifeInfo(LIRowID)),"^",10)
	..i TFromStoreLoc'="" s TFromStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromStoreLoc)
	..i TToStoreLoc'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToStoreLoc)
	..i LifeInfo=""  d
	...s LifeInfo=TChangeDate_":"_TFromStoreLoc_"-"_TToStoreLoc
	..e  d
	...s LifeInfo=LifeInfo_","_TChangeDate_":"_TFromStoreLoc_"-"_TToStoreLoc
	q LifeInfo
}

/// 20190326 Mozy0222	增加动作信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQLifeInfo","GetDetailOperatorInfo","22","8")
Query GetDetailOperatorInfo(SourceType, SourceID) As %Query(ROWSPEC = "TRowID:%String,TOpinion:%String,TApproveRole:%String,TApproveUserDR:%String,TApproveDate:%String,TAction:%String")
{
}

ClassMethod GetDetailOperatorInfoExecute(ByRef qHandle As %Binary, SourceType, SourceID) As %Status
{
	new repid, index, rowid,info,ApproveType
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(SourceType)
	s ApproveID=##class(web.DHCEQLifeInfo).GetBussIDBySource(SourceType,SourceID)
	if ((ApproveType="")||(ApproveID="")) Quit $$$OK //add by lmm 2017-12-01 468578
	
	s rowid=0
	f  s rowid=$Order(^DHCEQApproveList(0,"Source",ApproveType,ApproveID,rowid)) Quit:rowid=""  Do
	.s (DataList,TRowID,TOpinion,TApproveUserDR,TApproveDate)=""
	.s DataList=$Get(^DHCEQApproveList(rowid))
	.s TRowID=rowid
	.s TOpinion=$Piece(DataList,"^",3)
	.i TOpinion="" s TOpinion="同意(默认)"
	.s TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",$Piece(DataList,"^",5))
	.i TApproveRole="" s TApproveRole="经办人"
	.s TApproveUserDR=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(DataList,"^",6))
	.s TApproveDate=##Class(web.DHCEQCommon).TransValueToPage($Piece(DataList,"^",7),"date")_" "_##Class(web.DHCEQCommon).TransValueToPage($Piece(DataList,"^",8),"time") //增加审核时间的显示
	.s ActionDR=$Piece(DataList,"^",11)
	.i ActionDR=0 d
	..s TAction="申请"
	.e  d
	..s TAction=$p(^DHCEQCCode("DHCEQCAction",+ActionDR),"^",2)
	.s OperateType=$Piece(DataList,"^",12)
	.i OperateType=1 s TAction="取消提交(拒绝)"
	.i TAction="" s TAction=TApproveRole
	.d OutputRowGetDetailOperatorInfo
	Quit $$$OK
OutputRowGetDetailOperatorInfo
	Set Data=$lb(TRowID,TOpinion,TApproveRole,TApproveUserDR,TApproveDate,TAction) 
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDetailOperatorInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailOperatorInfoExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDetailOperatorInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailOperatorInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2016-8-4 zy0083
/// desc:将BussID转换成SourceID
/// 入参：SourceType：来源类型
///       SourceID：来源ID
/// w ##Class(web.DHCEQLifeInfo).GetBussIDBySource("11","1")
ClassMethod GetBussIDBySource(SourceType, SourceID)
{
	new RowID
	s RowID=""
	i SourceType="11" //开箱验收
	{
		s RowID=$p($g(^DHCEQOpenCheckList(SourceID)),"^",1)
	}
	elseif SourceType="21" //入库
	{
		s RowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
	}
	elseif SourceType="22" //转移
	{
		s RowID=$p($g(^DHCEQStoreMoveList(SourceID)),"^",1)
	}	
	elseif SourceType="23" //减少
	{
		s RowID=$p($g(^DHCEQReturnList(SourceID)),"^",1)
	}
	elseif SourceType="34" //报废
	{
		;s RowID=$p($g(^DHCEQDisuseRequestList(SourceID)),"^",1)
		s RowID=SourceID	//20190326 Mozy0222
	}
	elseif SourceType="41" //使用
	{
		s RowID=SourceID	//20190326 Mozy0222
	}
	else
	{	
		s RowID=SourceID
	}
	quit RowID
}

}
