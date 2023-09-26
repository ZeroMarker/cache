/// Add By DJ 2019-10-10
/// 描述:新版HISUI付款业务
Class web.DHCEQ.EM.BUSPayRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2019-10-10
/// 描述:获取付款申请业务明细记录
/// Modified By QW20210422 BUG:QW0099 增加发票信息输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPayRequest","GetPayRecord","29","14")
/// Modified By QW20211112 BUG:QW0155 入库单增加库房参数vLocDR过滤
Query GetPayRecord(vPayRequestDR As %String = "", vSourceType As %String = "", vProviderDR As %String = "", vLocDR As %String = "") As %Query(ROWSPEC = "PRRowID:%String,PRPayRequestDR:%String,PRSourceType:%String,PRSourceID:%String,PREquipTypeDR:%String,PRPayPlanDR:%String,PRItem:%String,PRQuantity:%String,PRPrice:%String,PRPayType:%String,PRPayPercent:%String,PRPayFee:%String,PRCertificateDR:%String,PRRemark:%String,PRInvalidFlag:%String,PRHold1:%String,PRHold2:%String,PRHold3:%String,PRHold4:%String,PRHold5:%String,TAllAmount:%String,TPayAmount:%String,TNotPayAmount:%String,Opt:%String,TContractNo:%String,InvoiceNos:%String,InvoiceDate:%String,InvoiceFee:%String,InvoiceQty:%String")
{
}

ClassMethod GetPayRecordExecute(ByRef qHandle As %Binary, vPayRequestDR As %String = "", vSourceType As %String = "", vProviderDR As %String = "", vLocDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (vPayRequestDR="")&&((vSourceType="")||(vProviderDR=""))  Quit $$$OK
	
	i vPayRequestDR'=""  d
	.//已存在付款申请记录
	.s RowID=0
	.f  s RowID=$o(^DHCEQPayRecord(0,"PayRequest",vPayRequestDR,RowID))  q:RowID=""  d
	..d ResetVariablesGetPayRecord
	..s PRInvalidFlag=$p($g(^DHCEQPayRecord(RowID)),"^",14)
	..q:PRInvalidFlag="Y"
	..s PRRowID=RowID
	..s PRPayRequestDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",1)
	..s PRSourceType=$p($g(^DHCEQPayRecord(PRRowID)),"^",2)
	..s PRSourceID=$p($g(^DHCEQPayRecord(PRRowID)),"^",3)
	..s PREquipTypeDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",4)
	..s AccessoryFlag=0		//czf 1770138 2021-02-19 begin
	..i (PRSourceType="11")||(PRSourceType="21") d
	...s CTLRowID=""
	...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",PRSourceID,CTLRowID))  q:(CTLRowID="")||(AccessoryFlag=1)  d
	....s CTLSourceType = $p($g(^DHCEQContractList(CTLRowID)),"^",5)
	....s CTLSourceID = $p($g(^DHCEQContractList(CTLRowID)),"^",17)
	....i CTLSourceType=6 d
	.....s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",CTLSourceID)),"^",14)
	.....s AccessoryFlag=1
	..i (PRSourceType="12")||(PRSourceType="22")  d	
	...s CTLSourceType = $p($g(^DHCEQContractList(PRSourceID)),"^",5)
	...s CTLSourceID = $p($g(^DHCEQContractList(PRSourceID)),"^",17)
	...i CTLSourceType=6 d
	....s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",CTLSourceID)),"^",14)
	....s AccessoryFlag=1
	..;Add By QW20210422 BUG:QW0099 增加发票信息 begin
	..i (PRSourceType="14") d
	...s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,PRSourceID)
	...s TInvoiceNos=$p(return,"^",1)
	...s TInvoiceDate=$p(return,"^",2)
	...s TInvoiceFee=$p(return,"^",3)
	...s TInvoiceQty=$p(return,"^",6)
	..;Add By QW20210422 BUG:QW0099 增加发票信息 begin
	..q:(AccessoryFlag=1)&&(##Class(web.DHCEQACommon).AccessoryTypeIsIn(PREquipTypeDR)=1)
	..q:(AccessoryFlag=0)&&(##Class(web.DHCEQCommon).EquipTypeIsIn(PREquipTypeDR)=1)	//czf 1770138 2021-02-19 end
	..s PRPayPlanDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",5)
	..s PRItem=$p($g(^DHCEQPayRecord(PRRowID)),"^",6)
	..s PRQuantity=$p($g(^DHCEQPayRecord(PRRowID)),"^",7)
	..s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRecord(PRRowID)),"^",8))
	..s PRPayType=$p($g(^DHCEQPayRecord(PRRowID)),"^",9)
	..s PRPayPercent=$p($g(^DHCEQPayRecord(PRRowID)),"^",10)
	..s PRPayFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRecord(PRRowID)),"^",11))
	..s PRCertificateDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",12)
	..s PRRemark=$p($g(^DHCEQPayRecord(PRRowID)),"^",13)
	..s PRHold1=$p($g(^DHCEQPayRecord(PRRowID)),"^",15)
	..s PRHold2=$p($g(^DHCEQPayRecord(PRRowID)),"^",16)
	..s PRHold3=$p($g(^DHCEQPayRecord(PRRowID)),"^",17)
	..s PRHold4=$p($g(^DHCEQPayRecord(PRRowID)),"^",18)
	..s PRHold5=$p($g(^DHCEQPayRecord(PRRowID)),"^",19)
	..s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	..s TPayAmount=+..GetAllPayAmount(PRSourceType,PRSourceID,"","",vPayRequestDR)
	..s NotAmount=TAllAmount
	..i PRPayPlanDR'="" s NotAmount=$p($g(^DHCEQPayPlan(PRPayPlanDR)),"^",10)
	..s TNotPayAmount=..GetNotPayAmount(PRSourceType,PRSourceID,PRPayPlanDR,NotAmount,vPayRequestDR)
	..s Opt="Y"
	..i PRHold2'="" s TContractNo=$p($g(^DHCEQContract(PRHold2)),"^",2)
	..d OutputRowGetPayRecord
	e  d
	.//未生成付款申请记录,取各业务记录
	.;1:新购设备	(11:合同总单  12:合同明细  13:验收单 14:入库明细  15:首次出库明细(不推荐) 16:退货明细)
	.;2:维保合同	(21:维保合同总单 22:维保合同明细)
	.;3:配件		(31:配件入库  32:首次配件出库(不推荐) 33:配件退货)
	.;4:调账		(41:调账)
	.;5:维护费用	(51:保养  52:检查  53:维修)
	.;9:其它费用	(9+ID号：手工付款费用类型DHC_EQCPayCostType(动态9+ID号))
	.//11:合同总单 12:合同明细 21:维保合同总单 22:维保合同明细
	.i (vSourceType="11")||(vSourceType="12")||(vSourceType="21")||(vSourceType="22")  d
	..//0:采购合同,1:保修合同,2:协议合同,3:投放合同
	..s ContractType=""
	..f  s ContractType=$O(^DHCEQContract(0,"ContractType",ContractType))  q:ContractType=""  d
	...q:((vSourceType="11")||(vSourceType="12"))&&(ContractType'=0)
	...q:((vSourceType="21")||(vSourceType="22"))&&(ContractType'=1)
	...s CTRowID=0
	...f  s CTRowID=$o(^DHCEQContract(0,"ContractType",ContractType,CTRowID))  q:CTRowID=""  d
	....s CTStatus=$p($g(^DHCEQContract(CTRowID)),"^",24)
	....q:CTStatus'="2"
	....s CTProviderDR=$p($g(^DHCEQContract(CTRowID)),"^",18)
	....q:(vProviderDR'="")&&(CTProviderDR'=vProviderDR)
	....q:((vSourceType="11")||(vSourceType="12"))&&($D(^DHCEQPayRecordDetail(0,"Status","11",CTRowID,0,2)))
	....q:((vSourceType="21")||(vSourceType="22"))&&($D(^DHCEQPayRecordDetail(0,"Status","21",CTRowID,0,2)))
	....s CTLRowID=0
	....s (FirstEquipTypeDR,AccessoryTypeDR)=""
	....s (CTQuantity,CTAmount)=0
	....f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID))  q:CTLRowID=""  d
	.....d ResetVariablesGetPayRecord
	.....s PRSourceType=vSourceType
	.....s PRSourceID=CTLRowID
	.....s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	.....s PRHold3=$P(RetentionInfo,"^",1)
	.....s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	.....s PRHold1=$p($g(^DHCEQContract(CTRowID)),"^",2)
	.....s CTLSourceType = $p($g(^DHCEQContractList(CTLRowID)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细 6:配件项 7.验收单
 	.....s CTLSourceID = $p($g(^DHCEQContractList(CTLRowID)),"^",17)
 	.....i CTLSourceType=1 d
 	......s PREquipTypeDR=$p($g(^DHCEQBuyPlan($p($g(^DHCEQBuyPlanList(CTLSourceID)),"^",1))),"^",12)
 	.....else  if CTLSourceType=2 d
 	......s IFBBagItemDR = +$p($g(^DHCEQIFBBag(CTLSourceID)),"^",3)
	......s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
 	.....else  if CTLSourceType=3 d
 	......s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CTLSourceID)),"^",3)
 	.....else  if CTLSourceType=4 d
 	......s PREquipTypeDR=$p($g(^DHCEQEquip(CTLSourceID)),"^",63)
 	.....else  if CTLSourceType=5 d
 	......s PREquipTypeDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(CTLSourceID)),"^",1))),"^",20)
 	.....else  if CTLSourceType=6 d			//czf 1770138 2021-02-19 begin
 	......s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",CTLSourceID)),"^",14)
 	......s AccessoryTypeDR=PREquipTypeDR
 	......s PRAccessoryTypeDR=PREquipTypeDR
 	.....else  if CTLSourceType=7 d
 	......s PREquipTypeDR=$p($g(^DHCEQOpenCheckList(CTLSourceID)),"^",3)
 	.....q:(CTLSourceType=6)&&(##Class(web.DHCEQACommon).AccessoryTypeIsIn(PREquipTypeDR)=1)
 	.....q:(CTLSourceType'=6)&&(##Class(web.DHCEQCommon).EquipTypeIsIn(PREquipTypeDR)=1)
 	.....i FirstEquipTypeDR="" s FirstEquipTypeDR=PREquipTypeDR
 	.....i CTLSourceType=6 s FirstEquipTypeDR=""	//czf 1770138 2021-01-20 end
	.....s PRQuantity=$p($g(^DHCEQContractList(CTLRowID)),"^",7)
	.....s CTQuantity=CTQuantity+PRQuantity
	.....s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",6))
	.....s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",8))	//明细应付总金额
	.....s CTAmount=CTAmount+TAllAmount
	.....i (vSourceType="12")||(vSourceType="22")  d		//明细业务付款时输出
	......q:$D(^DHCEQPayRecordDetail(0,"Status",vSourceType,CTLRowID,0,2))
	......s PRItem=$p($g(^DHCEQContractList(CTLRowID)),"^",2)
	......s PRRemark=$p($g(^DHCEQContractList(CTLRowID)),"^",9)
	......s PRInvalidFlag="N"
	......s TPayAmount=+..GetAllPayAmount(vSourceType,CTLRowID)		//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,CTLRowID,"",TAllAmount)		//明细最大未付总金额
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......d OutputRowGetPayRecord
	....i (vSourceType="11")||(vSourceType="21")  d			//总单业务付款时输出
	.....d ResetVariablesGetPayRecord
	.....s PRSourceType=vSourceType
	.....s PRSourceID=CTRowID
	.....s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	.....s PRHold3=$P(RetentionInfo,"^",1)
	.....s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	.....s PRHold1=$p($g(^DHCEQContract(CTRowID)),"^",2)
	.....s PREquipTypeDR=FirstEquipTypeDR
	.....i PREquipTypeDR="" s PREquipTypeDR=AccessoryTypeDR
	.....q:(FirstEquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(PREquipTypeDR)=1)		//czf 1770138 2021-02-19
	.....q:(AccessoryTypeDR'="")&&(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR)=1)
	.....s PRItem=$p($g(^DHCEQContract(CTRowID)),"^",1)
	.....s PRRemark=$p($g(^DHCEQContract(CTRowID)),"^",25)
	.....s PRQuantity=1
	.....s PRPrice=CTAmount
	.....s TAllAmount=CTAmount
	.....s PRInvalidFlag="N"
	.....;检测是否存在付款计划,若存在付款计划则按照付款计划付款.
	.....s (PPRowID,PPFlag)=0
	.....f  s PPRowID=$o(^DHCEQPayPlan(0,"Source",1,CTRowID,PPRowID))  q:PPRowID=""  d
	......s PPFlag=1
	......q:$D(^DHCEQPayRecordDetail(0,"Status",vSourceType,CTRowID,PPRowID,2))
	......s PPPrice=$p($g(^DHCEQPayPlan(PPRowID)),"^",10)
	......s PPAllAmount=PPPrice
	......s TPayAmount=+..GetAllPayAmount(vSourceType,CTRowID)			//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,CTRowID,PPRowID,PPAllAmount)		//计划最大未付总金额
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRPayPlanDR=PPRowID
	......s PRPayType=$p($g(^DHCEQPayPlan(PPRowID)),"^",4)		//0:全款 1:预付款 2:期款 3:尾款
	......s PRPayPercent=$p($g(^DHCEQPayPlan(PPRowID)),"^",9)
	......s PRRemark=$p($g(^DHCEQPayPlan(PPRowID)),"^",11)
	......d OutputRowGetPayRecord
	.....i PPFlag=0  d		//无付款计划时按照合同总额付款
	......s TAllAmount=CTAmount		//合同总金额
	......s TPayAmount=+..GetAllPayAmount(vSourceType,CTRowID)			//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,CTRowID,"",TAllAmount)			//合同总单未付款金额
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......d OutputRowGetPayRecord
	.//13:验收单
	.i vSourceType="13"  d
	..s OCRCheckType=""
	..f  s OCRCheckType=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType))  q:OCRCheckType=""  d
	...s OCREquipTypeDR=0
	...f  s OCREquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR))  q:OCREquipTypeDR=""  d
	....q:##Class(web.DHCEQCommon).EquipTypeIsIn(OCREquipTypeDR)=1
	....s OCRRowID=0
	....f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR,2,OCRRowID))  q:OCRRowID=""  d
	.....s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	.....q:OCRInvalidFlag="Y"
	.....s OCRProviderDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",5)
	.....q:(vProviderDR'="")&&(OCRProviderDR'=vProviderDR)
	.....s OCLRowID=0
	.....f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID))  q:OCLRowID=""  d
	......d ResetVariablesGetPayRecord
	......q:$D(^DHCEQPayRecordDetail(0,"Status","13",OCLRowID,0,2))
	......s PRSourceType=vSourceType
	......s PRSourceID=OCLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=OCREquipTypeDR
	......s PRHold1=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)	
	......s PRItem=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)
	......s PRQuantity=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17))
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s PRRemark=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",21)
	......s PRInvalidFlag="N"
	......s TContractNo=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",36)	//czf 2021-02-19 1770138
	......;检测是否存在付款计划,若存在付款计划则按照付款计划付款.
	......s (PPRowID,PPFlag)=0
	......f  s PPRowID=$o(^DHCEQPayPlan(0,"Source",2,OCRRowID,PPRowID))  q:PPRowID=""  d
	.......s PPFlag=1
	.......q:$D(^DHCEQPayRecordDetail(0,"Status","13",OCLRowID,PPRowID,2))
	.......s PPPrice=$p($g(^DHCEQPayPlan(PPRowID)),"^",10)
	.......s PPAllAmount=PPPrice
	.......s TPayAmount=+..GetAllPayAmount(vSourceType,OCLRowID)			//已付总金额(指所有相关业务付款总额)
	.......s TNotPayAmount=..GetNotPayAmount(vSourceType,OCLRowID,PPRowID,PPAllAmount)		//计划最大未付总金额
	.......q:+TNotPayAmount=0
	.......s PRPayFee=TNotPayAmount
	.......s PRPayPlanDR=PPRowID
	.......s PRPayType=$p($g(^DHCEQPayPlan(PPRowID)),"^",4)		//0:全款 1:预付款 2:期款 3:尾款
	.......s PRPayPercent=$p($g(^DHCEQPayPlan(PPRowID)),"^",9)
	.......s PRRemark=$p($g(^DHCEQPayPlan(PPRowID)),"^",11)
	.......d OutputRowGetPayRecord
	......i PPFlag=0  d		//无付款计划时按照验收明细付款
	.......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	.......s TPayAmount=+..GetAllPayAmount(vSourceType,OCLRowID)
	.......s TNotPayAmount=..GetNotPayAmount(vSourceType,OCLRowID,"",TAllAmount)
	.......q:+TNotPayAmount=0
	.......s PRPayFee=TNotPayAmount
	.......d OutputRowGetPayRecord
	.//14:入库明细
	.i vSourceType="14"  d
	..s ISEquipTypeDR=0
	..f  s ISEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR))  q:ISEquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(ISEquipTypeDR)=1
	...s ISBillAuditDate=0
	...f  s ISBillAuditDate=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate))  q:ISBillAuditDate=""  d
	....s ISRowID=0
	....f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate,ISRowID))  q:ISRowID=""  d
	.....s ISInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	.....q:ISInStockNo=""
	.....s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.....q:ISStatus'="2"
	.....s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	.....q:ISInvalidFlag="Y"
	.....s ISProviderDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	.....q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	.....s ISLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
	.....q:(vLocDR'="")&&(ISLocDR'=vLocDR) //Add By QW20211112 BUG:QW0155 入库单增加库房参数vLocDR过滤
	.....s ISLRowID=0
	.....f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	......d ResetVariablesGetPayRecord
	......q:$p($g(^DHCEQInStockList(ISLRowID)),"^",22)'=""		;过滤附属设备
	......q:$D(^DHCEQPayRecordDetail(0,"Status","14",ISLRowID,0,2))
	......s PRSourceType=vSourceType
	......s PRSourceID=ISLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=ISEquipTypeDR
	......s PRHold1=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	......s PRItem=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	......s PRQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7))
	......s PRRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,ISLRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,ISLRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......;Add By QW20210422 BUG:QW0099 增加发票信息 begin
	......s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLRowID)
	......s TInvoiceNos=$p(return,"^",1)
	......s TInvoiceDate=$p(return,"^",2)
	......s TInvoiceFee=$p(return,"^",3)
	......s TInvoiceQty=$p(return,"^",6)
	......;Add By QW20210422 BUG:QW0099 增加发票信息 end
	......d OutputRowGetPayRecord
	.//15:首次出库明细(不推荐)
	.i vSourceType="15"  d
	..s SMEquipTypeDR=0
	..f  s SMEquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR))  q:SMEquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(SMEquipTypeDR)=1	//modified by csj 2020-04-07
	...s SMAuditDate=0
	...f  s SMAuditDate=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate))  q:SMAuditDate=""  d
	....s SMRowID=0
	....f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate,SMRowID))  q:SMRowID=""  d
	.....s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.....q:SMInvalidFlag="Y"
	.....s SMStatus=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
	.....q:SMStatus'="2"
	.....s SMMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	.....q:SMMoveType'="0"
	.....s SMLRowID=0
	.....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
	......q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",14)="Y"	;不可付款标志
	......q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""	;过滤附属设备
	......s EquipListIDs=##Class(web.DHCEQPayRequest).GetEquipList(SMLRowID)
	......q:EquipListIDs=""
	......q:$D(^DHCEQPayRecordDetail(0,"Status","15",SMLRowID,0,2))
	......s SMLInStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	......s SMLEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	......i SMLInStockListDR'=""  d
	.......s SMLInStockDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",1)
	.......s SMLProviderDR=$p($g(^DHCEQInStock(SMLInStockDR)),"^",17)
	......e  d
	.......s SMLProviderDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",25)
	......q:(vProviderDR'="")&&(SMLProviderDR'=vProviderDR)
	......d ResetVariablesGetPayRecord
	......s PRSourceType=vSourceType
	......s PRSourceID=SMLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=SMEquipTypeDR
	......s PRItem=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
	......s PRQuantity=$L(EquipListIDs,",")	//$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7))
	......s PRRemark=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11)
	......s PRHold1=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,SMLRowID)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,SMLRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	.//16:退货
	.i vSourceType="16"  d
	..s REquipTypeDR=0
	..f  s REquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR))  q:REquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(REquipTypeDR)=1
	...s ROutTypeDR=0
	...f  s ROutTypeDR=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR))  q:ROutTypeDR=""  d
	....s ROutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",ROutTypeDR)),"^",1)
	....q:ROutTypeCode'="TH"
	....s RBillAuditDate=0
	....f  s RBillAuditDate=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR,RBillAuditDate))  q:RBillAuditDate=""  d
	.....s RRowID=0
	.....f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR,RBillAuditDate,RRowID))  q:RRowID=""  d
	......s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
	......q:RStatus'="2"
	......s RInvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
	......q:RInvalidFlag="Y"
	......s RProviderDR=$p($g(^DHCEQReturn(RRowID)),"^",3)
	......q:(vProviderDR'="")&&(RProviderDR'=vProviderDR)
	......s RLRowID=0
	......f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
	.......d ResetVariablesGetPayRecord
	.......q:$D(^DHCEQPayRecordDetail(0,"Status","16",RLRowID,0,2))
	.......s RLEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
	.......s RLInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
	.......s PRSourceType=vSourceType
	.......s PRSourceID=RLRowID
	.......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	.......s PRHold3=$P(RetentionInfo,"^",1)
	.......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	.......s PREquipTypeDR=REquipTypeDR
	.......s PRHold1=$p($g(^DHCEQReturn(RRowID)),"^",1)
	.......i RLEquipDR'=""  d
	........s PRItem=$p($g(^DHCEQEquip(RLEquipDR)),"^",1)
	.......e  d
	........s PRItem=$p($g(^DHCEQInStockList(RLInStockListDR)),"^",5)
	.......s PRQuantity=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
	.......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6))
	.......s PRRemark=$p($g(^DHCEQReturnList(RLRowID)),"^",9)
	.......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	.......s TPayAmount=+..GetAllPayAmount(vSourceType,RLRowID)					//已付总金额(指所有相关业务付款总额)
	.......s TNotPayAmount=..GetNotPayAmount(vSourceType,RLRowID,"",TAllAmount)
	.......q:+TNotPayAmount=0
	.......s PRPayFee=TNotPayAmount
	.......s PRInvalidFlag="N"
	.......d OutputRowGetPayRecord
	.//31:配件入库
	.i vSourceType="31"  d
	..s ISEquipTypeDR=0
	..f  s ISEquipTypeDR=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR))  q:ISEquipTypeDR=""  d
	...q:##class(web.DHCEQACommon).AccessoryTypeIsIn(ISEquipTypeDR)=1
	...s ISBillAuditDate=0
	...f  s ISBillAuditDate=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate))  q:ISBillAuditDate=""  d
	....s ISRowID=0
	....f  s ISRowID=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate,ISRowID))  q:ISRowID=""  d
	.....s ISInStockNo=$p($g(^DHCEQAInStock(ISRowID)),"^",6)
	.....q:ISInStockNo=""
	.....s ISStatus=$p($g(^DHCEQAInStock(ISRowID)),"^",16)
	.....q:ISStatus'="2"
	.....s ISProviderDR=$p($g(^DHCEQAInStock(ISRowID)),"^",8)
	.....q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	.....s ISLRowID=0
	.....f  s ISLRowID=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	......d ResetVariablesGetPayRecord
	......q:$D(^DHCEQPayRecordDetail(0,"Status","31",ISLRowID,0,2))
	......s PRSourceType=vSourceType
	......s PRSourceID=ISLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=ISEquipTypeDR
	......s PRHold1=$p($g(^DHCEQAInStockList(ISRowID)),"^",6)
	......s PRItem=$p($g(^DHCEQAInStockList(ISLRowID)),"^",4)
	......s PRQuantity=$p($g(^DHCEQAInStockList(ISLRowID)),"^",9)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAInStockList(ISLRowID)),"^",8))
	......s PRRemark=$p($g(^DHCEQAInStockList(ISLRowID)),"^",20)
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,ISLRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,ISLRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	.//32:首次配件出库(不推荐)
	.i vSourceType="32"  d
	..s MSEquipTypeDR=0
	..f  s MSEquipTypeDR=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR))  q:MSEquipTypeDR=""  d
	...q:##class(web.DHCEQACommon).AccessoryTypeIsIn(MSEquipTypeDR)=1
	...s MSBillAuditDate=0
	...f  s MSBillAuditDate=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR,MSBillAuditDate))  q:MSBillAuditDate=""  d
	....s MSRowID=0
	....f  s MSRowID=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR,MSBillAuditDate,MSRowID))  q:MSRowID=""  d
	.....s MSLRowID=0
	.....f  s MSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",MSRowID,MSLRowID))  q:MSLRowID=""  d
	......d ResetVariablesGetPayRecord
	......q:$D(^DHCEQPayRecordDetail(0,"Status","32",MSLRowID,0,2))
	......s MSLInStockListDR=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",15)
	......q:MSLInStockListDR=""
	......s MSLInStockDR=$p($g(^DHCEQAInStockList(MSLInStockListDR)),"^",1)
	......q:MSLInStockDR=""
	......s ISProviderDR=$p($g(^DHCEQAInStock(MSLInStockDR)),"^",8)
	......q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	......s PRSourceType=vSourceType
	......s PRSourceID=MSLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=MSEquipTypeDR
	......s PRHold1=$p($g(^DHCEQAMoveStock(MSRowID)),"^",1)
	......s PRItem=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",4)
	......s PRQuantity=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",11)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAMoveStockList(MSLRowID)),"^",10))
	......s PRRemark=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",13)
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,MSLRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,MSLRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	.//33:配件退货
	.i vSourceType="33"  d
	..s REquipTypeDR=0
	..f  s REquipTypeDR=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR))  q:REquipTypeDR=""  d
	...q:##class(web.DHCEQACommon).AccessoryTypeIsIn(REquipTypeDR)=1
	...s RBillAuditDate=0
	...f  s RBillAuditDate=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR,1,RBillAuditDate))  q:RBillAuditDate=""  d
	....s RRowID=0
	....f  s RRowID=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR,1,RBillAuditDate,RRowID))  q:RRowID=""  d
	.....s RStatus=$p($g(^DHCEQAReduce(RRowID)),"^",23)
	.....q:RStatus'="2"
	.....s RProviderDR=$p($g(^DHCEQAReduce(RRowID)),"^",6)
	.....q:(vProviderDR'="")&&(RProviderDR'=vProviderDR)
	.....s RLRowID=0
	.....f  s RLRowID=$o(^DHCEQAReduceList(0,"Reduce",RRowID,RLRowID))  q:RLRowID=""  d
	......d ResetVariablesGetPayRecord
	......q:$D(^DHCEQPayRecordDetail(0,"Status","33",RLRowID,0,2))
	......s RLItemDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",2)
	......s PRSourceType=vSourceType
	......s PRSourceID=RLRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=REquipTypeDR
	......s PRHold1=$p($g(^DHCEQAReduce(RRowID)),"^",1)
	......i RLItemDR'="" s PRItem=$p(^DHCEQCCode("DHCEQCAccessory",RLItemDR),"^",2)
	......s PRQuantity=$p($g(^DHCEQAReduceList(RLRowID)),"^",10)
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAReduceList(RLRowID)),"^",9))
	......s PRRemark=$p($g(^DHCEQAReduceList(RLRowID)),"^",12)
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,RLRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,RLRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	.//41:调账
	.i vSourceType="41"  d
	..s CAEquipTypeDR=0
	..f  s CAEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR))  q:CAEquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(CAEquipTypeDR)=1
	...s BillAuditDate=0
	...f  s BillAuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,BillAuditDate))  q:BillAuditDate=""  d
	....s CARowID=0
	....f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,BillAuditDate,CARowID))  q:CARowID=""  d
	.....s CAStatus=$p($g(^DHCEQChangeAccount(CARowID)),"^",11)
	.....q:CAStatus'="2"
	.....s CAProviderDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",35)			//调账增减值付款供应商
	.....q:(vProviderDR'="")&&(CAProviderDR'=vProviderDR)
	.....s CAChangeFee=$p($g(^DHCEQChangeAccount(CARowID)),"^",2)
	.....q:CAChangeFee=0			//资金来源变动不在付款范围内
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","41",CARowID,0,2))
	.....d ResetVariablesGetPayRecord
	.....s PRSourceType=vSourceType
	.....s PRSourceID=CARowID
	.....s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	.....s PRHold3=$P(RetentionInfo,"^",1)
	.....s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	.....s PREquipTypeDR=CAEquipTypeDR
	.....s PRHold1=CARowID
	.....s PRItem=$p($g(^DHCEQChangeAccount(CARowID)),"^",8)
	.....s PRQuantity=1
	.....s PRPrice=##Class(web.DHCEQCommon).FormatNumber(CAChangeFee)
	.....s PRRemark=$p($g(^DHCEQChangeAccount(CARowID)),"^",10)
	.....s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	.....s TPayAmount=+..GetAllPayAmount(vSourceType,CARowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNotPayAmount=..GetNotPayAmount(vSourceType,CARowID,"",TAllAmount)
	.....q:+TNotPayAmount=0
	.....s PRPayFee=TNotPayAmount
	.....s PRInvalidFlag="N"
	.....d OutputRowGetPayRecord
	.//51:保养  52:检查  53:维修
	.i (vSourceType="51")||(vSourceType="52")  d
	..s MTTypeDR=0		//1保养,2检查
 	..f  s MTTypeDR=$o(^DHCEQMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	...q:(vSourceType="51")&&(MTTypeDR'=1)
 	...q:(vSourceType="52")&&(MTTypeDR'=2)
 	...s MSourceID=""
	...f  s MSourceID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID))  q:MSourceID=""  d
	....s EQRowID=0
	....f  s EQRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID))  q:EQRowID=""  d
	.....s MTRowID=0
	.....f  s MTRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	......s MTInvalidFlag=$p($g(^DHCEQMaint(MTRowID)),"^",39)
	......q:MTInvalidFlag="Y"
	......s MTStatus=$p($g(^DHCEQMaint(MTRowID)),"^",13)
	......q:MTStatus'="2"
	......s MTAuditDate=$p($g(^DHCEQMaint(MTRowID)),"^",19)
	......s MTMaintType=$p($g(^DHCEQMaint(MTRowID)),"^",4)		//4巡检,5计量							
	......d ResetVariablesGetPayRecord
	......s PRSourceType=vSourceType
	......s PRSourceID=MTRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s MTMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(MTAuditDate)
	......s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MTMonthStr)
	......i SnapID'=""  d
	.......s PREquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)		///类组
	......e  d
	.......s PREquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	......s PRHold1=MTRowID				///单号
	......s PRItem=$p($g(^DHCEQEquip(EQRowID)),"^",1)				///项目
	......s PRQuantity=1
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(MTRowID)),"^",9))
	......q:+PRPrice=0
	......s PRRemark=$p($g(^DHCEQMaint(MTRowID)),"^",14)				///备注
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,MTRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,MTRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	.//53:维修
	.i vSourceType="53"  d
	..s MTTypeDR=0
 	..f  s MTTypeDR=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	...q:MTTypeDR'=3
 	...s MSourceID=""
	...f  s MSourceID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID))  q:MSourceID=""  d
	....s SourceEquipTypeDR=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",3)
	....q:##Class(web.DHCEQCommon).EquipTypeIsIn(SourceEquipTypeDR)=1
	....s EQRowID=0
	....f  s EQRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID))  q:EQRowID=""  d
	.....s MTRowID=0
	.....f  s MTRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	......s MTInvalidFlag=$p($g(^DHCEQMMaint(MTRowID)),"^",39)
	......q:MTInvalidFlag="Y"
	......s MTStatus=$p($g(^DHCEQMMaint(MTRowID)),"^",13)
	......q:MTStatus'="2"
	......s MTAuditDate=$p($g(^DHCEQMMaint(MTRowID)),"^",19)
	......s MTMaintType=$p($g(^DHCEQMMaint(MTRowID)),"^",4)							
	......d ResetVariablesGetPayRecord
	......s PRSourceType=vSourceType
	......s PRSourceID=MTRowID
	......s RetentionInfo=##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo(PRSourceType,PRSourceID)	;start by csj 2020-04-08 质保金信息
	......s PRHold3=$P(RetentionInfo,"^",1)
	......s PRHold4=$P(RetentionInfo,"^",2)	;end by csj 2020-04-08
	......s PREquipTypeDR=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",3)		///类组
	......s PRHold1=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",1)				///单号
	......s PRItem=$p($g(^DHCEQEquip(EQRowID)),"^",1)				///项目
	......s PRQuantity=1
	......s PRPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMMaint(MTRowID)),"^",9))
	......q:+PRPrice=0
	......s PRRemark=$p($g(^DHCEQMMaint(MTRowID)),"^",14)				///备注
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(PRQuantity*PRPrice)
	......s TPayAmount=+..GetAllPayAmount(vSourceType,MTRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNotPayAmount=..GetNotPayAmount(vSourceType,MTRowID,"",TAllAmount)
	......q:+TNotPayAmount=0
	......s PRPayFee=TNotPayAmount
	......s PRInvalidFlag="N"
	......d OutputRowGetPayRecord
	
	Quit $$$OK
OutputRowGetPayRecord
	i vPayRequestDR="" s PRPayType=$Case(PRPayType,"0":"全款","1":"预付款","2":"期款","3":"尾款",:"")
	s Data=$lb(PRRowID,PRPayRequestDR,PRSourceType,PRSourceID,PREquipTypeDR,PRPayPlanDR,PRItem,PRQuantity,PRPrice,PRPayType,PRPayPercent,PRPayFee,PRCertificateDR,PRRemark,PRInvalidFlag,PRHold1,PRHold2,PRHold3,PRHold4,PRHold5,TAllAmount,TPayAmount,TNotPayAmount,Opt,TContractNo,TInvoiceNos,TInvoiceDate,TInvoiceFee,TInvoiceQty)  ;Modified By QW20210422 BUG:QW0099 增加发票信息
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayRecord
	Set (PRRowID,PRPayRequestDR,PRSourceType,PRSourceID,PREquipTypeDR,PRPayPlanDR,PRItem,PRQuantity,PRPrice,PRPayType,PRPayPercent,PRPayFee,PRCertificateDR,PRRemark,PRInvalidFlag,PRHold1,PRHold2,PRHold3,PRHold4,PRHold5,TAllAmount,TPayAmount,TNotPayAmount,Opt,TContractNo,PRAccessoryTypeDR,TInvoiceNos,TInvoiceDate,TInvoiceFee,TInvoiceQty)=""  ;Modified By QW20210422 BUG:QW0099 增加发票信息
	Quit
}

ClassMethod GetPayRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRecordExecute ]
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

ClassMethod GetPayRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2019-10-10
/// 获取所有相关业务已付款总金额
ClassMethod GetAllPayAmount(vSourceType As %String = "", vSourceID As %String = "", vPlanDR As %String = "", ContainInBussFlag As %String = "", vPRRowID As %String = "")
{
	n (vSourceType,vSourceID,vPlanDR,ContainInBussFlag,vPRRowID)
	s (NewOCLSourceType,NewISLSourceType,NewOCLRowID,NewCTLRowID)=""
	s AllAmount=0
	
	i vSourceType="14"  d
	.s NewISLSourceType=$p($g(^DHCEQInStockList(vSourceID)),"^",18)
	.i NewISLSourceType="2"  d
	..s vSourceType="13"
	..s NewOCLRowID=$p($g(^DHCEQInStockList(vSourceID)),"^",19)
	.e  d
	..s PRDAmount=..GetPayAmount(vSourceType,vSourceID,"",ContainInBussFlag,vPRRowID)
	..s NewNum=$p($g(^DHCEQInStockList(vSourceID)),"^",8)
	..s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(vSourceID)),"^",7))
	..s AllAmount=##Class(web.DHCEQCommon).FormatNumber(NewNum*NewPrice)
	
	i vSourceType="13"  d
	.i NewOCLRowID'=""  d
	..s NewOCLSourceType=$p($g(^DHCEQOpenCheckList(NewOCLRowID)),"^",63)
	..i (NewOCLSourceType=1)||(NewOCLSourceType=4)||(NewOCLSourceType=5)  d
	...s vSourceType="12"
	...s NewCTLRowID=$p($g(^DHCEQOpenCheckList(NewOCLRowID)),"^",64)
	..e  d
	...s PRDAmount=..GetPayAmount(vSourceType,NewOCLRowID,"",ContainInBussFlag,vPRRowID)
	...s vSourceID=NewOCLRowID
	.e  d
	..s NewOCLSourceType=$p($g(^DHCEQOpenCheckList(vSourceID)),"^",63)
	..i (NewOCLSourceType=1)||(NewOCLSourceType=4)||(NewOCLSourceType=5)  d
	...s vSourceType="12"
	...s NewCTLRowID=$p($g(^DHCEQOpenCheckList(vSourceID)),"^",64)
	..e  d
	...s PRDAmount=..GetPayAmount(vSourceType,vSourceID,"",ContainInBussFlag,vPRRowID)
	
	i (vSourceType="12")||(vSourceType="22")  d
	.i NewCTLRowID'=""  d
	..s vSourceID=$p($g(^DHCEQContractList(NewCTLRowID)),"^",1)
	.e  d
	..s vSourceID=$p($g(^DHCEQContractList(vSourceID)),"^",1)
	
	i (vSourceType="11")||(vSourceType="12")||(vSourceType="21")||(vSourceType="22")  d
	.i (vSourceType="11")||(vSourceType="12")  d
	..s PRDAmount=..GetPayAmount("11",vSourceID,"",ContainInBussFlag,vPRRowID)
	.e  d
	..s PRDAmount=..GetPayAmount("21",vSourceID,"",ContainInBussFlag,vPRRowID)
	.;0:采购合同,1:保修合同,2:协议合同,3:投放合同	MZY0033	1370009		2020-06-15
	.i $p($g(^DHCEQContract(vSourceID)),"^",39)=1 s AllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(vSourceID)),"^",4))
	.
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",vSourceID,CTLRowID))  q:CTLRowID=""  d
	..i (vSourceType="11")||(vSourceType="12")  d
	...s PRDAmount=PRDAmount+..GetPayAmount("12",CTLRowID,"",ContainInBussFlag,vPRRowID)
	..e  d
	...s PRDAmount=PRDAmount+..GetPayAmount("22",CTLRowID,"",ContainInBussFlag,vPRRowID)
	..s NewNum=$p($g(^DHCEQContractList(CTLRowID)),"^",7)
	..s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",6))
	..i $p($g(^DHCEQContract(vSourceID)),"^",39)'=1 s AllAmount=AllAmount+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",8))
	..q:(vSourceType="21")||(vSourceType="22")
	..s OCLSourceType=0
	..f  s OCLSourceType=$o(^DHCEQOpenCheckList(0,"Source",OCLSourceType))  q:OCLSourceType=""  d
	...q:(OCLSourceType'=1)&&(OCLSourceType'=4)&&(OCLSourceType'=5)
	...s OCLRowID=0
	...f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",OCLSourceType,CTLRowID,OCLRowID))  q:OCLRowID=""  d
	....s PRDAmount=PRDAmount+..GetPayAmount("13",OCLRowID,"",ContainInBussFlag,vPRRowID)
	....s ISLRowID=0
	....f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID))  q:ISLRowID=""  d
	.....s ISLHold4=$p($g(^DHCEQInStockList(ISLRowID)),"^",22)
	.....q:ISLHold4'=""
	.....s PRDAmount=PRDAmount+..GetPayAmount("14",ISLRowID,"",ContainInBussFlag,vPRRowID)
	
	i vSourceType="13"  d
	.s ISLFind=0
	.s ISLRowID=0
	.f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,vSourceID,ISLRowID))  q:ISLRowID=""  d
	..s ISLHold4=$p($g(^DHCEQInStockList(ISLRowID)),"^",22)
	..q:ISLHold4'=""
	..s PRDAmount=PRDAmount+..GetPayAmount("14",ISLRowID,"",ContainInBussFlag,vPRRowID)
	..s ISLFind=1
	..s NewNum=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	..s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7))
	..s AllAmount=##Class(web.DHCEQCommon).FormatNumber(NewNum*NewPrice)
	.i ISLFind=0  d
	..s NewNum=$p($g(^DHCEQOpenCheckList(vSourceID)),"^",16)
	..s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(vSourceID)),"^",17))
	..s AllAmount=##Class(web.DHCEQCommon).FormatNumber(NewNum*NewPrice)
	
	i (+vSourceType<30)&&(vSourceType'="15")&&(vSourceType'=16)  q PRDAmount_"^"_AllAmount
	
	i vSourceType="15"
	{
		s EquipListStrs=##Class(web.DHCEQPayRequest).GetEquipList(vSourceID)	//$p($g(^DHCEQStoreMoveList(vSourceID)),"^",8)
		s NewNum=$L(EquipListStrs,",")
		s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(vSourceID)),"^",7))
	}
	elseif vSourceType="16"
	{
		s NewNum=$p($g(^DHCEQReturnList(vSourceID)),"^",5)
		s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(vSourceID)),"^",6))
	}
	elseif vSourceType="31"
	{
		s NewNum=$p($g(^DHCEQAInStockList(vSourceID)),"^",9)
		s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAInStockList(vSourceID)),"^",8))
	}
	elseif vSourceType="32"
	{
		s NewNum=$p($g(^DHCEQAMoveStockList(vSourceID)),"^",11)
		s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAMoveStockList(vSourceID)),"^",10))
	}
	elseif vSourceType="33"
	{
		s NewNum=$p($g(^DHCEQAReduceList(vSourceID)),"^",10)
		s NewPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAReduceList(vSourceID)),"^",9))
	}
	elseif vSourceType="41"
	{
		s NewNum=1
		s NewPrice=$p($g(^DHCEQChangeAccount(vSourceID)),"^",2)
	}
	elseif (vSourceType="51")||(vSourceType="52")
	{
		s NewNum=1
		s NewPrice=$p($g(^DHCEQMaint(vSourceID)),"^",9)
	}
	elseif vSourceType="53"
	{
		s NewNum=1
		s NewPrice=$p($g(^DHCEQMMaint(vSourceID)),"^",9)
	}
	s AllAmount=##Class(web.DHCEQCommon).FormatNumber(NewNum*NewPrice)
	
	q ..GetPayAmount(vSourceType,vSourceID,"",ContainInBussFlag,vPRRowID)_"^"_AllAmount
}

/// Add By DJ 2019-10-10
/// 获取当前业务已付款总金额
ClassMethod GetPayAmount(vSourceType As %String = "", vSourceID As %String = "", vPlanDR As %String = "", ContainInBussFlag As %String = "", vPRRowID As %String = "")
{
	n (vSourceType,vSourceID,vPlanDR,ContainInBussFlag,vPRRowID)
	i (vSourceType="")||(vSourceID="") q 0
	s PRDAmount=0
	s PRDRowID=0
	f  s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",vSourceType,vSourceID,PRDRowID))  q:PRDRowID=""  d
	.s PRDPlanDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",11)
	.q:(vPlanDR'="")&&(PRDPlanDR'=vPlanDR)
	.s PRDAmount=PRDAmount+$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",4)
	
	
	//在途付款总金额
	s PRRowID=0
	f  s PRRowID=$o(^DHCEQPayRequest(0,"Status",1,PRRowID))  q:(PRRowID="")||(ContainInBussFlag="N")  d
	.q:(vPRRowID'="")&&(PRRowID=vPRRowID)
	.s PRInvalidFlag=$p($g(^DHCEQPayRequest(PRRowID)),"^",26)
	.q:PRInvalidFlag="Y"
	.s PRSourceType=$p($g(^DHCEQPayRequest(PRRowID)),"^",28)
	.q:(vSourceType'="")&&(PRSourceType'=vSourceType)
	.s RecordID=0
	.f  s RecordID=$o(^DHCEQPayRecord(0,"PayRequest",PRRowID,RecordID))  q:RecordID=""  d
	..s RecordInvalidFlag=$p($g(^DHCEQPayRecord(RecordID)),"^",14)
	..q:RecordInvalidFlag="Y"
	..s RecordSourceID=$p($g(^DHCEQPayRecord(RecordID)),"^",3)
	..s RecordPlanDR=$p($g(^DHCEQPayRecord(RecordID)),"^",5)
	..q:(vSourceID'="")&&(RecordSourceID'=vSourceID)
	..q:(vPlanDR'="")&&(RecordPlanDR'=vPlanDR)
	..s PRDAmount=PRDAmount+$p($g(^DHCEQPayRecord(RecordID)),"^",11)
	
	
	q PRDAmount
}

/// Add By DJ 2019-10-10
/// 获取当前业务最大未付总金额
ClassMethod GetNotPayAmount(vSourceType As %String = "", vSourceID As %String = "", vPlanDR As %String = "", vBussAmount As %String = "", vPRRowID As %String = "")
{
	n (vSourceType,vSourceID,vPlanDR,vBussAmount,vPRRowID)
	s PayInfo=..GetAllPayAmount(vSourceType,vSourceID,"","",vPRRowID)
	s AllAmount=$p(PayInfo,"^",2)
	s AllAmountPay=$p(PayInfo,"^",1)
	s BussPayAmount=..GetPayAmount(vSourceType,vSourceID,vPlanDR,"",vPRRowID)
	i (AllAmount-AllAmountPay)>(vBussAmount-BussPayAmount)  q ##Class(web.DHCEQCommon).FormatNumber(vBussAmount-BussPayAmount)
	q ##Class(web.DHCEQCommon).FormatNumber(AllAmount-AllAmountPay)
}

/// Add By DJ 2019-10-10
/// 检测提交单据明细对应合同付款额度
ClassMethod CheckConAmountBySubmit(vPayRequestDR As %String = "", vContractDR As %String = "")
{
	n (vPayRequestDR,vContractDR)
	i vContractDR="" q 0
	
	s PayInfo=..GetAllPayAmount("11",vContractDR)
	s ContMaxPay=$p(PayInfo,"^",2)-$p(PayInfo,"^",1)
	s ConSubmitFee=0
	s RecordID=0
	f  s RecordID=$o(^DHCEQPayRecord(0,"PayRequest",vPayRequestDR,RecordID))  q:RecordID=""  d
	.s RecordInvalidFlag=$p($g(^DHCEQPayRecord(RecordID)),"^",14)
	.q:RecordInvalidFlag="Y"
	.s RecordContractDR=$p($g(^DHCEQPayRecord(RecordID)),"^",16)
	.q:vContractDR'=RecordContractDR
	.s RecordPayFee=$p($g(^DHCEQPayRecord(RecordID)),"^",11)
	.s ConSubmitFee=ConSubmitFee+RecordPayFee
	
	i ContMaxPay>=ConSubmitFee q 0
	
	q "-1^"_ContMaxPay_"^"_ConSubmitFee
}

ClassMethod GetContractDR(vSourceType As %String = "", vSourceID As %String = "")
{
	n (vSourceType,vSourceID)
	s ContractDR=""
	
	i vSourceType="14"  d
	.s ISLSourceType=$p($g(^DHCEQInStockList(vSourceID)),"^",18)
	.i ISLSourceType=2  d
	..s vSourceType="13"
	..s vSourceID=$p($g(^DHCEQInStockList(vSourceID)),"^",19)
	
	i vSourceType="13"  d
	.s OCLSourceType=$p($g(^DHCEQOpenCheckList(vSourceID)),"^",63)
	.i (OCLSourceType=1)||(OCLSourceType=4)||(OCLSourceType=5)  d
	..s vSourceType="12"
	..s vSourceID=$p($g(^DHCEQOpenCheckList(vSourceID)),"^",64)
	
	i (vSourceType="12")||(vSourceType="22")  d
	.s ContractDR=$p($g(^DHCEQContractList(vSourceID)),"^",1)
	
	i (vSourceType="11")||(vSourceType="21") s ContractDR=vSourceID
	
	q ContractDR
}

/// Add By DJ 2019-10-10
ClassMethod GetPayCostType()
{
	s PayCostTypeInfo=""
	s PCTRowID=0
	f  s PCTRowID=$o(^DHCEQCCode("DHCEQCPayCostType",PCTRowID))  q:PCTRowID=""  d
	.s PCTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCPayCostType",PCTRowID)),"^",5)
	.q:PCTInvalidFlag="Y"
	.s PCTDesc=$p($g(^DHCEQCCode("DHCEQCPayCostType",PCTRowID)),"^",2)
	.i PayCostTypeInfo=""  d
	..s PayCostTypeInfo="9"_PCTRowID_"^"_PCTDesc
	.e  d
	..s PayCostTypeInfo=PayCostTypeInfo_"@9"_PCTRowID_"^"_PCTDesc
	q PayCostTypeInfo
}

ClassMethod UpdateData(PRRowID, vStatus)
{
	TSTART
	s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	i vStatus=0
	{
		&SQL(Update SQLUSER.DHC_EQPayRequest set PR_Status=:vStatus, PR_SubmitUserDR=NULL, PR_SubmitDate=NULL where PR_RowID = :PRRowID)
	}
	elseif vStatus=1
	{
		//提交之前校验明细付款情况
		s RecordID=0
		f  s RecordID=$o(^DHCEQPayRecord(0,"PayRequest",PRRowID,RecordID))  q:(RecordID="")||(SQLCODE'=0)  d
		.s RecordInvalidFlag=$p($g(^DHCEQPayRecord(RecordID)),"^",14)
		.q:RecordInvalidFlag="Y"
		.s RecordContractDR=$p($g(^DHCEQPayRecord(RecordID)),"^",16)
		.s CheckConAmountBySubmit=..CheckConAmountBySubmit(PRRowID,RecordContractDR)
		.i $p(CheckConAmountBySubmit,"^",1)="-1"  d
		..s ContractNo=$p($g(^DHCEQContract(RecordContractDR)),"^",2)
		..s SQLCODE="合同"_ContractNo_"最大付款额度为:"_$p(CheckConAmountBySubmit,"^",2)_"当前单据提交额度为:"_$p(CheckConAmountBySubmit,"^",3)
		
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200",SQLCODE)
		}
		
		&SQL(Update SQLUSER.DHC_EQPayRequest set PR_Status=:vStatus, PR_SubmitUserDR=:User, PR_SubmitDate=:Date where PR_RowID = :PRRowID)
	}
	elseif vStatus=2
	{
		&SQL(Update SQLUSER.DHC_EQPayRequest set PR_Status=:vStatus, PR_AuditUserDR=:User, PR_AuditDate=:Date where PR_RowID = :PRRowID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//付款详细记录登记
		s RecordID=0
		f  s RecordID=$o(^DHCEQPayRecord(0,"PayRequest",PRRowID,RecordID))  q:(RecordID="")||(SQLCODE'=0)  d
		.s RecordInvalidFlag=$p($g(^DHCEQPayRecord(RecordID)),"^",14)
		.q:RecordInvalidFlag="Y"
		.k PLIST
		.s RecordSourceType=$p($g(^DHCEQPayRecord(RecordID)),"^",2)
		.s RecordSourceID=$p($g(^DHCEQPayRecord(RecordID)),"^",3)
		.s RecordEquipType=$p($g(^DHCEQPayRecord(RecordID)),"^",4)
		.s RecordPlanDR=$p($g(^DHCEQPayRecord(RecordID)),"^",5)
		.s RecordPayFee=$p($g(^DHCEQPayRecord(RecordID)),"^",11)
		.s RecordProvider=$p($g(^DHCEQPayRequest(PRRowID)),"^",4)
		.s RecordItem=$p($g(^DHCEQPayRecord(RecordID)),"^",6)
		.s RecordQuantity=$p($g(^DHCEQPayRecord(RecordID)),"^",7)
		.s RecordPrice=$p($g(^DHCEQPayRecord(RecordID)),"^",8)
		.s RecordBussNo=$p($g(^DHCEQPayRecord(RecordID)),"^",15)
		.s RecordContractDR=$p($g(^DHCEQPayRecord(RecordID)),"^",16)
		.s RecordAmount=##Class(web.DHCEQCommon).FormatNumber(RecordQuantity*RecordPrice)
		.s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",RecordSourceType,RecordSourceID,0))
		.i PRDRowID=""  d
		..s PLIST(2)=RecordSourceType	//SourceType
		..s PLIST(3)=RecordSourceID	//SourceID
		..s PLIST(4)=1	//付款次数
		..s PLIST(5)=RecordPayFee	//已付款总金额
		..s PLIST(6)=RecordProvider
		..s PLIST(7)=RecordBussNo
		..s PLIST(8)=RecordItem
		..s PLIST(9)=RecordEquipType
		..s PLIST(11)=RecordAmount
		..s PLIST(12)=RecordPlanDR
		..s PLIST(16)=RecordPrice
		..s PLIST(17)=RecordQuantity
		..&SQL(insert into SQLUSER.DHC_EQPayRecordDetail Values :PLIST())
		..s PRDRowID=$g(%ROWID)
		.e  d
		..s PLIST(4)=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",3)+1
		..s PLIST(5)=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",4)+RecordPayFee
		..&SQL(Update SQLUSER.DHC_EQPayRecordDetail Values :PLIST() where PRD_RowID = :PRDRowID)
		.q:SQLCODE'=0
		.s AllPayAmount=..GetAllPayAmount(RecordSourceType,RecordSourceID,"","N")
		.;检测是否付款完成
		.i +$p(AllPayAmount,"^",1)=+$p(AllPayAmount,"^",2)  d
		..s SQLCODE=..UpdatePRDetailStatus(PRDRowID,RecordSourceType,RecordSourceID,RecordContractDR)
		
	}
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,PRRowID)
}

ClassMethod UpdatePRDetailStatus(vPRDRowID As %String = "", vRecordSourceType As %String = "", vRecordSourceID As %String = "", vRecordContractDR As %String = "")
{
	n (vPRDRowID,vRecordSourceType,vRecordSourceID,vRecordContractDR)
	s SQLCODE=0
	i (vRecordSourceType<30)&&(vRecordSourceType'=15)
	{
		//无合同情况:(1)入库明细  (2)验收明细  (3)入库明细来自验收明细,但验收未来自合同
		i vRecordContractDR=""
		{
			s OCLSourceID=""
			i vRecordSourceType="14"  d
			.s ISLSourceType=$p($g(^DHCEQInStockList(vRecordSourceID)),"^",18)
			.i ISLSourceType="2"  d
			..s OCLSourceID=$p($g(^DHCEQInStockList(vRecordSourceID)),"^",19)
			e  d
			.s OCLSourceID=vRecordSourceID
			
			i OCLSourceID'=""
			{
				s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",13,OCLSourceID,0))
				i PRDRowID'=""
				{
					&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
					i SQLCODE q SQLCODE
				}
				s ISLRowID=0
				f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLSourceID,ISLRowID))  q:(ISLRowID="")||(SQLCODE'=0)  d
				.s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",14,ISLRowID,0))
				.i PRDRowID'=""  d
				..&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_SourceType='14' and PRD_SourceID=:vRecordSourceID)
			}
		}
		else
		{
			s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","11",vRecordContractDR,0))
			i PRDRowID="" s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","21",vRecordContractDR,0))
			i PRDRowID'=""
			{
				&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
				i SQLCODE q SQLCODE
			}
			s CTLRowID=0
			f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",vRecordContractDR,CTLRowID))  q:(CTLRowID="")||(SQLCODE'=0)  d
			.s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","12",CTLRowID,0))
			.i PRDRowID="" s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","22",CTLRowID,0))
			.i PRDRowID'=""  d
			..&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
			.q:SQLCODE'=0
			.s OCLSourceType=0
			.f  s OCLSourceType=$o(^DHCEQOpenCheckList(0,"Source",OCLSourceType))  q:(OCLSourceType="")||(SQLCODE'=0)  d
			..q:(OCLSourceType'=1)&&(OCLSourceType'=4)&&(OCLSourceType'=5)
			..s OCLRowID=0
			..f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",OCLSourceType,CTLRowID,OCLRowID))  q:(OCLRowID="")||(SQLCODE'=0)  d
			...s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","13",OCLRowID,0))
			...i PRDRowID'=""  d
			....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
			...q:SQLCODE'=0
			...s ISLRowID=0
			...f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID))  q:(ISLRowID="")||(SQLCODE'=0)  d
			....s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID","14",ISLRowID,0))
			....i PRDRowID'=""  d
			.....&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:PRDRowID)
		}
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQPayRecordDetail Set PRD_Status='2' Where PRD_RowID=:vPRDRowID)
	}
	q SQLCODE
}

ClassMethod SaveData(data, dataList, DelIs)
{
	s $ZT="ERRORPayRequest"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	TSTART
	if DelIs=1
	{
		s RowID=data
		;无效所有明细
		&SQL(Update SQLUSER.DHC_EQPayRecord Set PR_InvalidFlag='Y' where PR_PayRequestDR=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		&SQL(Update SQLUSER.DHC_EQPayRequest set PR_InvalidFlag='Y' where PR_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPayRequest",JsonData,.PLIST)
		s RowID = JsonData.PRRowID
	 	s PLIST(15) = User	;RequestUserDR
	 	s PLIST(16) = Date	;RequestDate
		s PLIST(13) = "0"	;Status
		s PLIST(27) = "N"
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQPayRequest Values :PLIST() where PR_RowID = :RowID)
		}
		else
		{
			s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPayRequest",Date,JsonData.PRLocDR)
			
			&SQL(insert into SQLUSER.DHC_EQPayRequest Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s SQLCODE=##Class(web.DHCEQ.EM.BUSPayRequest).SaveDataList(RowID,dataList)
	}
	
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORPayRequest
	TROLLBACK 
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

ClassMethod SaveDataList(RowID, dataList)
{
	k PLIST
	s SQLCODE=0
	s ISLRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		k PLIST,ISLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPayRecord",JsonData,.PLIST)
		s PLIST(2)=RowID
		s PLIST(17)=..GetContractDR(JsonData.PRSourceType,JsonData.PRSourceID)
		s PRRowID = JsonData.PRRowID
	    if PRRowID'=""
	    {
		    //已有记录取消选择删除
		    if JsonData.Opt="N"
		    {
			    &SQL(Update SQLUSER.DHC_EQPayRecord Set PR_InvalidFlag='Y' where PR_RowID = :PRRowID)
		    }
		    else
		    {
			    &SQL(Update SQLUSER.DHC_EQPayRecord Values :PLIST() where PR_RowID = :PRRowID)
		    }
		}
		else
		{
			//选择记录才进行存储
			if JsonData.Opt="Y"
			{
				&SQL(insert into SQLUSER.DHC_EQPayRecord Values :PLIST())
				s PRowID=$g(%ROWID)
				;增加发票信息  Add By QW20210916 BUG:QW0148 保存报错修改 begin
				i JsonData.PRSourceType="14"
			    {
					s SQLCODE=##Class(web.DHCEQ.EM.BUSInStock).UpdateInvoiceInfo(JsonData.PRSourceID, JsonData.InvoiceNos, "", JsonData.PRPrice,"",JsonData.InvoiceQty)
			    }
				;Add By QW20210916 BUG:QW0148 保存报错修改 end
			}
		}
	}
	q SQLCODE
}

ClassMethod GetOnePayRequest(RowID As %Library.String = "", ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOnePayRequest"
	s ObjPayRequest=##Class(User.DHCEQPayRequest).%OpenId(RowID)
	s PayRequestInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjPayRequest)
	d PayRequestInfo.%Set("PRProviderDR_VDesc",ObjPayRequest.PRProviderDR.VName)
	d PayRequestInfo.%Set("PRLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjPayRequest.PRLocDR))
	d PayRequestInfo.%Set("PRChineseFee",##Class(web.DHCEQCommon).RMBDXXZH("","",ObjPayRequest.PRTotalFee))
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("19",RowID,ApproveRoleDR)
	d PayRequestInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d PayRequestInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d PayRequestInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d PayRequestInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d PayRequestInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d PayRequestInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d PayRequestInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d PayRequestInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d PayRequestInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d PayRequestInfo.%Set("NextRole",$p(AppInfo,"^",10))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,PayRequestInfo)
ERRORGetOnePayRequest
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// Add By CSJ 2020-04-08
/// 获取已填写质保金比例及金额
/// w ##Class(web.DHCEQ.EM.BUSPayRequest).GetRetentionInfo("14","2")
ClassMethod GetRetentionInfo(vSourceType As %String = "", vSourceID As %String = "")
{
	n (vSourceType,vSourceID)
	s (RetentionPercent,Retention)=""
	s PayRecordID=0
	f  s PayRecordID=$o(^DHCEQPayRecord(0,"Source",vSourceType,vSourceID,PayRecordID))  q:(PayRecordID="")||(RetentionPercent'="")||(Retention'="")  d
	.s RetentionPercent=$p($g(^DHCEQPayRecord(PayRecordID)),"^",17)
	.s Retention=$p($g(^DHCEQPayRecord(PayRecordID)),"^",18)
	q RetentionPercent_"^"_Retention
}

/*/// Modified By QW20210220 BUG:QW0093  属于旧版未付款查询逻辑与新版差太多了
Query GetUnPayList(RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "", RetentionFlag As %String = "", WarnFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TDate:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TPaedFee:%String,TNeedPayFee:%String,TAmountFee:%String,TRemark:%String,TReduceQtyNum:%String,TFlag:%String,TInvoiceNo:%String,TInvoiceDate:%String,TLoc:%String,TAMSLHold3:%String,TListInfo:%String,TEquipType:%String,TProviderDR:%String,TGuaranteeDate:%String,TGuaranteeFee:%String,TRate:%String,TOpenCheckDate:%String,TProvider:%String,TJob:%String,TOpenCheckAuditDate:%String,TOpenCheckOrigin:%String,TOpenCheckRemark:%String,TUseLoc:%String")
{
}

ClassMethod GetUnPayListExecute(ByRef qHandle As %Binary, RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "", RetentionFlag As %String = "", WarnFlag As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set (TotalQty,Total)=0
	;s ^DHCEQMozy("GetUnPayList")=RowID_","_SourceType_","_PayFromType_","_ProviderDR
	Set index=1
	Set TJob=$Job
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("UnPayRequestList")

	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	//20150929 ZY0145付款申请单错误修改,查找不保存信息;
	//最终审核的时候保存付款记录的信息
	s Status=""
	Set TRow=0
	if RowID'=""
	{
		s Status=$Piece($Get(^DHCEQPayRequest(RowID)),"^",12)
		s PayFromType=$Piece($Get(^DHCEQPayRequest(RowID)),"^",27)
		s StoreLocDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",3)
		s ProviderDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",4)
	}
	;i ProviderDR="" Quit $$$OK
	if +Status<2
	{
		if PayFromType=1
		{
			if SourceType=12
			{
				; "转移明细(首次)"
				k ^DHCEQTEMP("GetUnPayList")
				s SMRowID=0
				f  s SMRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID)) q:SMRowID=""  d
				.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
				.;q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
				.q:(%session.Get("LOGON.GROUPID")="83")&&((TEquipTypeDR="11")||(TEquipTypeDR="14"))
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"	;SMInvalidFlag
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2	;SMStatus
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'=0	;SMMoveType
				.s SMLRowID=0
				.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
				..d ResetVariablesGetUnPayList
				..;q:$get(^DHCEQStoreMoveList(SMLRowID,"PayRequestInvalidFlag"))
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",14)="Y"		;SMLHold2
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""		;SMLHold3	过滤附属设备	;Mozy	587884	2018-11-28
				..s EquipDRs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
				..q:EquipDRs=""
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(EquipDRs,",",1))),"^",70)
				...s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				...s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(EquipDRs)),"^",70)
				...i isldr="" d	
				....s TProviderDR=$p($g(^DHCEQEquip(EquipDRs)),"^",25)	;provderDR
				...e  d
				....s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				....s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
				..i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商	add by csj 2020-03-23
				..;返回转移单明细的首次出库的设备DR
				..s equiplist=##Class(web.DHCEQPayRequest).GetEquipList(SMLRowID)
				..q:equiplist=""
				..
				..;
				..s TSourceType="12"	;12:"转移明细(首次)"
				..s TSourceID=SMLRowID
				..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
				..
				..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)     ;add by kdf 2017-11-14 需求号：468398
				..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR) ;add by kdf 2017-11-14 需求号：468398
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(equiplist,",",1))),"^",70)
				...s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip($p(equiplist,",",1))),"^",12),"date")	//add by csj 20200111 验收日期
				...s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				...s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				...s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(equiplist)),"^",70)
				...s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(equiplist)),"^",12),"date")	//add by csj 20200111 验收日期
				...i isldr="" d	
				....s TEquipName=$p($g(^DHCEQEquip(equiplist)),"^",1)
				....s TUnitDR=$p($g(^DHCEQEquip(equiplist)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQEquip(equiplist)),"^",27)
				...e  d
				....s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				....s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..i isldr'="" d
				...s (TCurOpenCheckListDR,TCurOpenCheckDR,TOpenCheckOriginDR)=""
				...s TCurOpenCheckListDR=$p($g(^DHCEQInStockList(isldr)),"^",19)
				...i TCurOpenCheckListDR'="" d
				....s TCurOpenCheckDR=$p($g(^DHCEQOpenCheckList(TCurOpenCheckListDR)),"^",1)
				....s TUseLoc=$p($g(^DHCEQOpenCheckList(TCurOpenCheckListDR)),"^",33)
				....s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
				...i TCurOpenCheckDR'="" d
				....s TOpenCheckAuditDate=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",26)
				....s TOpenCheckOriginDR=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",8)
				....i TOpenCheckOriginDR'="" s TOpenCheckOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOpenCheckOriginDR)),"^",2)
				....s TOpenCheckRemark=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",21)
				..s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
				..i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
				..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
				..i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				..s TQuantityNum=$length(equiplist,",")
				..
				..s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(12,SMLRowID,"","","","")
				..s TGuaranteeDate=$p(PayInfo,"^",6)
				..;w TGuaranteeDate ,! 
				..q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				..q:(RetentionFlag'="")&&(TQuantityNum*TOriginalFee-$p(PayInfo,"^",2)'=0)	//add by csj 2020-3-24 质保金
				..q:(WarnFlag'="")&&(TGuaranteeDate'="")&&(TGuaranteeDate-(+$h)<30)	//add by csj 2020-03-19 质保预警标志
				..s TTotalFee=TQuantityNum*TOriginalFee
				..s TPaedFee=$p(PayInfo,"^",2)
				..s TNeedPayFee=TTotalFee-TPaedFee
				..s TAddFlag=0
				..i isldr'="" d
				...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",isldr,"","","")
				...s TInvoiceNo=$p(TInvoiceInfo,"^",4)
				..;q:(isldr'="")&&($p(TInvoiceInfo,"^",1)=0)	//add by csj 20200107 不显示未审核发票单据
				..q:TInvoiceNo=""	//add  by csj 2020-05-07 哈医大需求 过滤没有发票号的(不用付款)
				..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
				..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				..
				..i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				...s PayRequestInfo=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				...s TAmountFee=$p(PayRequestInfo,"^",1)
				...s TGuaranteeFee=$p(PayRequestInfo,"^",2)
				...s TGuaranteeDate=$p(PayRequestInfo,"^",3)
				...
				...s TRate=$p(PayRequestInfo,"^",4)
				...
				...s TFlag="Y"
				...s TAddFlag=1
				..s TGuaranteeDate=##Class(web.DHCEQCommon).Trim(TGuaranteeDate)
				..i TGuaranteeDate="" d
				...s TGuaranteeInfo=##Class(web.DHCEQPayRequest).CheckGuaranteeDate(TSourceType,TSourceID)
				...i $p(TGuaranteeInfo,"^",1)=1 s TGuaranteeFee=$p(TGuaranteeInfo,"^",3)
				...s TGuaranteeDate=$p(TGuaranteeInfo,"^",2)
				...i TGuaranteeDate'="" d
				....s TGuaranteeDate=$ZD($p(TGuaranteeInfo,"^",2),3)
				..q:(RowID'="")&&(TAddFlag=0)
				..q:((+Status=1)&&(TFlag'="Y"))
				..s TListInfo=equiplist
				..s TOpenCheckDate=$zdh(TOpenCheckDate,"3")
				..s ^DHCEQTEMP("GetUnPayList",TOpenCheckDate,TSourceID)=TRowID_"^"_TRow_"^"_TSourceType_"^"_TSourceID_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TFlag_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TAMSLHold3_"^"_TListInfo_"^"_TEquipType_"^"_TProvider_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark
				..;s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
				..;Do OutputRowGetUnPayList
				//add by csj 20200113 根据验收日期排序
				s OpenCheckDate=""
				f  s OpenCheckDate=$o(^DHCEQTEMP("GetUnPayList",OpenCheckDate))  q:OpenCheckDate=""  d
				.s SourceID=0
				.f  s SourceID=$o(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID))  q:SourceID=""  d
				..d ResetVariablesGetUnPayList
				..s TRowID=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",1)
				..s TRow=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",2)
				..s TSourceType=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",3)
				..s TSourceID=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",4)
				..s TSourceNo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",5)
				..s TDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",6)
				..s TEquipName=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",7)
				..s TOriginalFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",8)
				..s TQuantityNum=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",9)
				..s TTotalFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",10)
				..s TPaedFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",11)
				..s TNeedPayFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",12)
				..s TAmountFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",13)
				..s TRemark=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",14)
				..s TReduceQtyNum=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",15)
				..s TFlag=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",16)
				..s TInvoiceNo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",17)
				..s TInvoiceDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",18)
				..s TLoc=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",19)
				..s TAMSLHold3=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",20)
				..s TListInfo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",21)
				..s TEquipType=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",22)
				..s TProvider=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",23)
				..s TGuaranteeDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",24)
				..s TGuaranteeFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",25)
				..s TRate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",26)
				..s TOpenCheckDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",27)
				..s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
				..s TOpenCheckAuditDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",28)
				..s TOpenCheckAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckAuditDate,"date")
				..s TOpenCheckOrigin=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",29)
				..s TOpenCheckRemark=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",30)
				..d OutputRowGetUnPayList
			}
			elseif SourceType=11
			{
				// ^DHCEQAMoveStockList	配件出库明细
				s AMSLRowID=0
				f  s AMSLRowID=$o(^DHCEQAMoveStockList(AMSLRowID)) q:AMSLRowID=""  d
				.d ResetVariablesGetUnPayList
				.q:$get(^DHCEQAMoveStockList(AMSLRowID,"PayRequestInvalidFlag"))
				.s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",1)
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
				.q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
				.s TAMSMoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)
				.q:TAMSMoveType'=0
				.s TAMSStatus=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",28)
				.q:TAMSStatus'=2
				.s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",15)	;入库明细AISL_InStockListDR
				.Quit:AMSLAISListDR=""
				.s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
				.q:AISRowID=""         //add by mwz 20180313 需求号：551254
				.s TProviderDR=$Piece($Get(^DHCEQAInStock(AISRowID)),"^",8)
				.q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
				.i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商	add by csj 2020-03-23
				.s TSourceType="11"	;11:配件出库明细
				.s TSourceID=AMSLRowID
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)    ;add by kdf 2017-11-15 需求号：468398
				.i TAccessoryTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR) ;add by kdf 2017-11-15 需求号：468398
				.s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
				.s TEquipName = $p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",4)
				.s TModel=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",5)
				.s TUnitDR=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",6)
				.i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				.s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
				.i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				.s TOriginalFee=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",10)
				.s TQuantityNum=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",11)
				.
				.s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(11,AMSLRowID,"","","","")
				.s TGuaranteeDate=$p(PayInfo,"^",6)
				.q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				.q:(RetentionFlag'="")&&(TQuantityNum*TOriginalFee-$p(PayInfo,"^",2)'=0)	//add by csj 2020-3-24 质保金
				.q:(WarnFlag'="")&&(TGuaranteeDate'="")&&(TGuaranteeDate-(+$h)<30)	//add by csj 2020-03-19 质保预警标志
				.s TTotalFee=TQuantityNum*TOriginalFee
				.s TPaedFee=$p(PayInfo,"^",2)
				.s TNeedPayFee=TTotalFee-TPaedFee
				.s TAddFlag=0
				.
				.s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)	;Mozy	587950	2018-11-28
				.s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
				.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				.s TAMSLHold3=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",20)	;呈批件号	Mozy	588024	2018-11-28
				.
				.i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				..s PayRequestInfo=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				..s TAmountFee=$p(PayRequestInfo,"^",1)
				..s TGuaranteeFee=$p(PayRequestInfo,"^",2)
				..s TGuaranteeDate=$p(PayRequestInfo,"^",3)
				..s TRate=$p(PayRequestInfo,"^",4)
				..s TFlag="Y"
				..s TAddFlag=1
				..s TGuaranteeDate=##Class(web.DHCEQCommon).Trim(TGuaranteeDate)
				.i TGuaranteeDate="" d
				..s TGuaranteeInfo=##Class(web.DHCEQPayRequest).CheckGuaranteeDate(TSourceType,TSourceID)
				..i $p(TGuaranteeInfo,"^",1)=1 s TGuaranteeFee=$p(TGuaranteeInfo,"^",3)
				..s TGuaranteeDate=$p(TGuaranteeInfo,"^",2)
				..i TGuaranteeDate'="" d
				...s TGuaranteeDate=$ZD($p(TGuaranteeInfo,"^",2),4)
				..s TFlag="Y"
				.q:((+Status=1)&&(TFlag'="Y"))
				.Do OutputRowGetUnPayList
			}
			else
			{
				
			}
		}
		elseif PayFromType=2
		{
			
		}
		elseif PayFromType=3
		{
			
		}
	}
	else
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQPayRecord(0,"PayRequest",RowID,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetUnPayList
		.s flag=0
		.s DataList =$G(^DHCEQPayRecord(rowid))
		.s TRowID = rowid
		.s TAmountFee=+$P(DataList,"^",3)
		.s TRemark=$P(DataList,"^",9)
		.s TTotalFee=$P(DataList,"^",11)
		.s TPaedFee=$p(DataList,"^",12)
		.s TNeedPayFee=$p(DataList,"^",13)
		.s TSourceType=$P(DataList,"^",15)
		.s TSourceID=$P(DataList,"^",16)
		.s TPayPlanDR=$P(DataList,"^",17)	;Mozy0203	20180224
		.
		.;来源类型是入库明细
		.i TSourceType=1 Do
		..Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
		..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
        ..;q:$p(TInvoiceInfo,"^",1)=0
	    ..s TInvoiceNo=$p(TInvoiceInfo,"^",4)  //modify by mwz 20180313 需求号：550672
	    ..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
		..s TSourceNo=$P($G(^DHCEQInStock(ISRowID)),"^",14)
		..s TDate=$P($G(^DHCEQInStock(ISRowID)),"^",1)
		..s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
		..s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
		..s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
		.q:flag'=0
		.
		.;来源类型是保修合同	Mozy0203	20180224	
		.i TSourceType=8 Do
		..i TPayPlanDR'="" d
		...i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
		....;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
		....s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
		....s GlobalData=$Get(^DHCEQPayRecord(TSourceID,"List"))	;20180424 Mozy0205
		....Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
		....Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
		....s ContractListDR=""
		....f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
		.....;//Mozy	567216	201-3-26	增加类组取值
		.....s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
		.....s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
		.....i ContractListSType=1 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
		.....else  if ContractListSType=2 d
		......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		.....else  if ContractListSType=3 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
		.....else  if ContractListSType=4 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
		.....else  if ContractListSType=5 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
		.....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
		....;; End
		....Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
		....s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
		....Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
		....Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
		....Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
		....If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
		....s TQuantityNum=1
		....;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
		....;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		....s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
		....i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
		....s TInvoiceNo=$Piece(GlobalData,"^",3)	;20180424 Mozy0205
		....s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
		....s TTotalFee=TOriginalFee
		....s TPaedFee=$p(PayInfo,"^",2)
		....s TNeedPayFee=TTotalFee-TPaedFee
		..e  d
		...s CTLRowID=0
		...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
		....s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
		....s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
		....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
		....s TEquipTypeDR=""
		....i CTLST=1 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
		....else  if CTLST=2 d
		.....Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		....else  if CTLST=3 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
		....else  if CTLST=4 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
		....else  if CTLST=5 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
		....set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		...
		...s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
		...s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
		...s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
		...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		...;s TDate=$p($g(^DHCEQContract(TSourceID)),"^",7)	;合同签订日期
		...;s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		...s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
		...s TQuantityNum=1
		...s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,TSourceID,"","","","")
		...s TTotalFee=TQuantityNum*TOriginalFee
		...s TPaedFee=$p(PayInfo,"^",2)
		...s TNeedPayFee=TTotalFee-TPaedFee
		...s TLoc=$p($g(^DHCEQContract(TSourceID)),"^",8)   ;合同签订部门
		...s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		...s GlobalData=$Get(^DHCEQPayRecord(rowid,"List"))
		...s TFileNo=$Piece(GlobalData,"^",4)
		...s TLocDR=$Piece(GlobalData,"^",5)
		...i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		.q:flag'=0
		.
		.;来源类型是配件转移明细
		.i TSourceType=11 Do
		..s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
		..s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
		..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
		..s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
		..s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
		..q:AISRowID=""         //add by mwz 20180313 需求号：551254
		..s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
		..s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
		..s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
		..s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)		;Mozy	587950	2018-11-28
		..s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		..s TAMSLHold3=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",20)		;Mozy	588024	2018-11-28
		.q:flag'=0
		.
		.;来源类型是转移明细(首次)
		.i TSourceType=12 Do
		..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
		..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
		..s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
		..s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
		..i $Get(^DHCEQPayRecord(rowid,"List"))'="" s TQuantityNum=$length($Get(^DHCEQPayRecord(rowid,"List")),",")
		..i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
		...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
        ...q:$p(TInvoiceInfo,"^",1)=0
	    ...s TInvoiceNo=$p(TInvoiceInfo,"^",4)    //modify by mwz 20180313 需求号：550672
		..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		.q:flag'=0
		.
		.;q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.s TAmountFee=$P(DataList,"^",3)
		.s TRemark=$P(DataList,"^",9)
		.s TGuaranteeFee=$P(DataList,"^",14)
		.s TGuaranteeDate=$P(DataList,"^",32)
		.s TRate=$P(DataList,"^",33)	//add by csj 20200108 质保金比例
		.s Total=Total+TAmountFee
		.s TFlag="Y"
		.d OutputRowGetUnPayList
	}
#;	d ResetVariablesGetUnPayList
#;	s TEquipName="合计："
#;	s TQuantityNum=TotalQty
#;	s TTotalFee=Total
#;	d OutputRowGetUnPayList

	Quit $$$OK
OutputRowGetUnPayList
	s TRow=TRow+1
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s TPaedFee=##Class(web.DHCEQCommon).FormatNumber(TPaedFee,"")
	s TNeedPayFee=##Class(web.DHCEQCommon).FormatNumber(TNeedPayFee,"")
	s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee,"")
	i TProviderDR="" s TProviderDR=ProviderDR  //add by mwz 需求号551659
#;	s TotalQty=TotalQty+TQuantityNum //总数量
#;	s Total=Total+TNeedPayFee	//需付总金额

	Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TGuaranteeDate,TGuaranteeFee,TRate,TOpenCheckDate,TProvider,TJob,TOpenCheckAuditDate,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc)    ////modify by mwz 20180313 需求号：550672
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("UnPayRequestList",+$H,TJob,index)=TRowID_"^"_TSourceType_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TEquipType_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TProvider_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark_"^"_TUseLoc

	Set index=index+1
	Quit
ResetVariablesGetUnPayList
	Set (DataList,TRowID,TEquipTypeDR,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TProvider,TGuaranteeDate,TGuaranteeFee,TRate,TOpenCheckDate,TOpenCheckAuditDate,TOpenCheckOriginDR,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc)=""
	Quit
}

ClassMethod GetUnPayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPayListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetUnPayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPayListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
/// add by csj 2020-05-06 返回总数量、总需付金额
/// d ##class(web.DHCEQ.EM.BUSPayRequest).GetSumUnPayInfo()
ClassMethod GetSumUnPayInfo(Job)
{
	s info=""
	s (Count,TotalFee)=0
	s nrowid=0
	i Job'="" 
	{
		f  s nrowid=$o(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)) q:nrowid=""  d
		.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",10),"")
		.s Count=Count+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",7),"")
	}
  	s info="总数量:"_Count_"&nbsp;&nbsp;&nbsp;总需付金额:"_TotalFee_"元"   
  	q info
}

/// add by csj 2020-05-06 返回总数量、总需付金额
/// d ##class(web.DHCEQ.EM.BUSPayRequest).GetSumUnPayInfoSimple()
ClassMethod GetSumUnPayInfoSimple(Job)
{
	s info=""
	s (Count,TotalFee,TotalNeedPay,TotalPaed)=0
	s nrowid=0
	i Job'="" 
	{
		f  s nrowid=$o(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)) q:nrowid=""  d
		.s TotalNeedPay=TotalNeedPay+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",10),"")
		.s Count=Count+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",7),"")
		.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",8),"")
		.s TotalPaed=TotalPaed+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",9),"")
	}
  	s info=Count_"^"_TotalFee_"^"_TotalNeedPay_"^"_TotalPaed
  	q info
}

/// modified by ZY20221206 bug:3130658、3130815
/// Modified By QW20210220 BUG:QW0093
/// 未付款查询
/// ModiFy by mwz 20221201 mwz0065  TGuaranteeDate 修改为 TGuaranteePercent
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPayRequest","GetOpenCheckListLoc","14","","1")
Query GetUnPayList(vSourceType As %String = "", vProviderDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TDate:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TPaedFee:%String,TNeedPayFee:%String,TAmountFee:%String,TRemark:%String,TReduceQtyNum:%String,TFlag:%String,TInvoiceNo:%String,TInvoiceDate:%String,TLoc:%String,TAMSLHold3:%String,TListInfo:%String,TEquipType:%String,TProviderDR:%String,TGuaranteePercent:%String,TGuaranteeFee:%String,TRate:%String,TOpenCheckDate:%String,TProvider:%String,TJob:%String,TOpenCheckAuditDate:%String,TOpenCheckOrigin:%String,TOpenCheckRemark:%String,TUseLoc:%String")
{
}

ClassMethod GetUnPayListExecute(ByRef qHandle As %Binary, vSourceType As %String = "", vProviderDR As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	// MZY0123	2665290		2022-05-12
	;i ((vSourceType="")||(vProviderDR=""))  Quit $$$OK
	i (vSourceType="")  Quit $$$OK
	Set TJob=$Job
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("UnPayRequestList")

	//未生成付款申请记录,取各业务记录
	;1:新购设备	(11:合同总单  12:合同明细  13:验收单 14:入库明细  15:首次出库明细(不推荐) 16:退货明细)
	;2:维保合同	(21:维保合同总单 22:维保合同明细)
	;3:配件		(31:配件入库  32:首次配件出库(不推荐) 33:配件退货)
	;4:调账		(41:调账)
	;5:维护费用	(51:保养  52:检查  53:维修)
	;9:其它费用	(9+ID号：手工付款费用类型DHC_EQCPayCostType(动态9+ID号))
	//11:合同总单 12:合同明细 21:维保合同总单 22:维保合同明细
	i (vSourceType="11")||(vSourceType="12")||(vSourceType="21")||(vSourceType="22")  d
	.//0:采购合同,1:保修合同,2:协议合同,3:投放合同
	.s ContractType=""
	.f  s ContractType=$O(^DHCEQContract(0,"ContractType",ContractType))  q:ContractType=""  d
	..q:((vSourceType="11")||(vSourceType="12"))&&(ContractType'=0)
	..q:((vSourceType="21")||(vSourceType="22"))&&(ContractType'=1)
	..s CTRowID=0
	..f  s CTRowID=$o(^DHCEQContract(0,"ContractType",ContractType,CTRowID))  q:CTRowID=""  d
	...s CTStatus=$p($g(^DHCEQContract(CTRowID)),"^",24)
	...q:CTStatus'="2"
	...s TSignLocDR = $p($g(^DHCEQContract(CTRowID)),"^",8)		//czf 2021-11-18 2215015
	...q:((TSignLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR)))
	...s CTProviderDR=$p($g(^DHCEQContract(CTRowID)),"^",18)
	...q:(vProviderDR'="")&&(CTProviderDR'=vProviderDR)
	...q:((vSourceType="11")||(vSourceType="12"))&&($D(^DHCEQPayRecordDetail(0,"Status","11",CTRowID,0,2)))
	...q:((vSourceType="21")||(vSourceType="22"))&&($D(^DHCEQPayRecordDetail(0,"Status","21",CTRowID,0,2)))
	...s CTLRowID=0
	...s (FirstEquipTypeDR,AccessoryTypeDR,AllEquipType)=""	// MZY0113	2435642		2022-01-25
	...s (CTQuantity,CTAmount)=0
    ...s CTAmount=$p($g(^DHCEQContract(CTRowID)),"^",4)
	...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID))  q:CTLRowID=""  d
	....d ResetVariablesGetUnPayList
	....s CTLSourceType = $p($g(^DHCEQContractList(CTLRowID)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
 	....s CTLSourceID = $p($g(^DHCEQContractList(CTLRowID)),"^",17)
 	....i CTLSourceType=1 d
 	.....s PREquipTypeDR=$p($g(^DHCEQBuyPlan($p($g(^DHCEQBuyPlanList(CTLSourceID)),"^",1))),"^",12)
 	....else  if CTLSourceType=2 d
 	.....s IFBBagItemDR = +$p($g(^DHCEQIFBBag(CTLSourceID)),"^",3)
	.....s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
 	....else  if CTLSourceType=3 d
 	.....s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CTLSourceID)),"^",3)
 	....else  if CTLSourceType=4 d
 	.....s PREquipTypeDR=$p($g(^DHCEQEquip(CTLSourceID)),"^",63)
 	....else  if CTLSourceType=5 d
 	.....s PREquipTypeDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(CTLSourceID)),"^",1))),"^",20)
 	....else  if CTLSourceType=6 d		//czf 1770138 2021-01-20 begin
 	.....s PREquipTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",CTLSourceID)),"^",14)
 	.....s AccessoryTypeDR=PREquipTypeDR
 	.....s PRAccessoryTypeDR=PREquipTypeDR
 	....else  if CTLSourceType=7 d
 	.....s PREquipTypeDR=$p($g(^DHCEQOpenCheckList(CTLSourceID)),"^",3)
 	....q:(CTLSourceType=6)&&(##Class(web.DHCEQACommon).AccessoryTypeIsIn(PREquipTypeDR)=1)
 	....q:(CTLSourceType'=6)&&(##Class(web.DHCEQCommon).EquipTypeIsIn(PREquipTypeDR)=1)
 	....;	MZY0113	2435642		2022-01-25
 	....i ((","_AllEquipType_",")'[(","_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)_",")) d
 	.....i AllEquipType'="" s AllEquipType=AllEquipType_","
 	.....s AllEquipType=AllEquipType_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
 	....i FirstEquipTypeDR="" s FirstEquipTypeDR=PREquipTypeDR
 	....i CTLSourceType=6 s FirstEquipTypeDR=""	//czf 1770138 2021-01-20 end
	....s TQuantityNum=$p($g(^DHCEQContractList(CTLRowID)),"^",7)
	....s CTQuantity=CTQuantity+TQuantityNum
	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",6))
	....s TAllAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",8))	//明细应付总金额
	....s CTAmount=CTAmount+TAllAmount
    ....s TTotalFee=TAllAmount  //add by ZY20230111 bug:3130815
	....i (vSourceType="12")||(vSourceType="22")  d		//明细业务付款时输出
	.....q:$D(^DHCEQPayRecordDetail(0,"Status",vSourceType,CTLRowID,0,2))
	.....s TSourceType=vSourceType
	.....s TSourceID=CTLRowID
	.....s TSourceNo=$p($g(^DHCEQContract(CTRowID)),"^",2)
	.....s TDate = $p($g(^DHCEQContract(CTRowID)),"^",6)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s TEquipName = $p($g(^DHCEQContractList(CTLRowID)),"^",2)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,CTLRowID)		//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,CTLRowID,"",TAllAmount)		//明细最大未付总金额
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",CTProviderDR)
	.....;add by mwz20221201 mwz0065 begin
	.....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,CTLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	...i (vSourceType="11")||(vSourceType="21")  d			//总单业务付款时输出
	....d ResetVariablesGetUnPayList
	....s TSourceType=vSourceType
	....s TSourceID=CTRowID
	....s TSourceNo=$p($g(^DHCEQContract(CTRowID)),"^",2)
	....s TDate = $p($g(^DHCEQContract(CTRowID)),"^",6)
	....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	....s PREquipTypeDR=FirstEquipTypeDR
	....i PREquipTypeDR="" s PREquipTypeDR=AccessoryTypeDR	//czf 1770138 2021-01-20 begin
	....q:(FirstEquipTypeDR'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(PREquipTypeDR)=1)	
	....q:(AccessoryTypeDR'="")&&(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR)=1)	//czf 1770138 2021-01-20 end
	....s TEquipName=$p($g(^DHCEQContract(CTRowID)),"^",1)
	....s TEquipType=AllEquipType	;##class(web.DHCEQCommon).GetTrakNameByID("equiptype",FirstEquipTypeDR)	MZY0113	2435642		2022-01-25
	....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",CTProviderDR)
	....s TQuantityNum=CTQuantity
	....s TOriginalFee=CTAmount
	....s TTotalFee=CTAmount
	....;检测是否存在付款计划,若存在付款计划则按照付款计划付款.
	....s (PPRowID,PPFlag)=0
	....f  s PPRowID=$o(^DHCEQPayPlan(0,"Source",1,CTRowID,PPRowID))  q:PPRowID=""  d
	.....s PPFlag=1
	.....q:$D(^DHCEQPayRecordDetail(0,"Status",vSourceType,CTRowID,PPRowID,2))
	.....s PPPrice=$p($g(^DHCEQPayPlan(PPRowID)),"^",10)
	.....s PPAllAmount=PPPrice
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,CTRowID)			//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,CTRowID,PPRowID,PPAllAmount)		//计划最大未付总金额
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....;add by mwz20221201 mwz0065 begin
	.....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,TSourceID)		// MZY0154	3251181		2023-03-03
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	....i PPFlag=0  d		//无付款计划时按照合同总额付款
	.....s TAllAmount=CTAmount		//合同总金额
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,CTRowID)			//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,CTRowID,"",TAllAmount)			//合同总单未付款金额
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....;add by mwz20221201 mwz0065 begin
	.....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,TSourceID)		// MZY0154	3251181		2023-03-03
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//13:验收单
	i vSourceType="13"  d
	.s OCRCheckType=""
	.f  s OCRCheckType=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType))  q:OCRCheckType=""  d
	..s OCREquipTypeDR=0
	..f  s OCREquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR))  q:OCREquipTypeDR=""  d
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(OCREquipTypeDR)=1
	...s OCRRowID=0
	...f  s OCRRowID=$o(^DHCEQOpenCheckRequest(0,"Status",OCRCheckType,OCREquipTypeDR,2,OCRRowID))  q:OCRRowID=""  d
	....s OCRInvalidFlag=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",45)
	....q:OCRInvalidFlag="Y"
	....s OCRProviderDR=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",5)
	....q:(vProviderDR'="")&&(OCRProviderDR'=vProviderDR)
	....s OCRHospID=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",38)	//czf 1770138 2021-01-20 begin
	....q:(OCRHospID'="")&&(##class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(OCRHospID,QXType))
	....s OCLRowID=0
	....f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,OCLRowID))  q:OCLRowID=""  d
	.....d ResetVariablesGetUnPayList
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","13",OCLRowID,0,2))
	.....s TSourceType=vSourceType
	.....s TSourceID=OCLRowID
	.....s PREquipTypeDR=OCREquipTypeDR
	.....s TSourceNo=$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	.....s TDate = $p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",11)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 	
	.....s TEquipName=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2)
	.....s TQuantityNum=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)  //modifid by myl 20210914  1897382
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",OCRProviderDR)    //modifid by myl 20210914  1897382
	.....;MZY0119	2569265		2022-04-07
	.....s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",33))
	.....s TOpenCheckDate=TDate
	.....s TOpenCheckAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26),"date")
	.....;检测是否存在付款计划,若存在付款计划则按照付款计划付款.
	.....s (PPRowID,PPFlag)=0
	.....f  s PPRowID=$o(^DHCEQPayPlan(0,"Source",2,OCRRowID,PPRowID))  q:PPRowID=""  d
	......s PPFlag=1
	......q:$D(^DHCEQPayRecordDetail(0,"Status","13",OCLRowID,PPRowID,2))
	......s PPPrice=$p($g(^DHCEQPayPlan(PPRowID)),"^",10)
	......s PPAllAmount=PPPrice
	......s TPaedFee=+..GetAllPayAmount(vSourceType,OCLRowID)			//已付总金额(指所有相关业务付款总额)
	......s TNeedPayFee=..GetNotPayAmount(vSourceType,OCLRowID,PPRowID,PPAllAmount)		//计划最大未付总金额
	......q:+TNeedPayFee=0
	......s TAmountFee=TNeedPayFee
	......d OutputRowGetUnPayList
	.....i PPFlag=0  d		//无付款计划时按照验收明细付款
	......s TAllAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	......s TPaedFee=+..GetAllPayAmount(vSourceType,OCLRowID)
	......s TNeedPayFee=..GetNotPayAmount(vSourceType,OCLRowID,"",TAllAmount)
	......q:+TNeedPayFee=0
	......s TAmountFee=TNeedPayFee
	......;add by mwz20221201 mwz0065 begin
    ......s TGuaranteeInfo=..GetRetentionInfo(vSourceType,OCLRowID)
	......s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	......s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	......;add by mwz20221201 mwz0065 end
	......d OutputRowGetUnPayList
	//14:入库明细
	i vSourceType="14"  d
	.s ISEquipTypeDR=0
	.f  s ISEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR))  q:ISEquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(ISEquipTypeDR)=1
	..s ISBillAuditDate=0
	..f  s ISBillAuditDate=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate))  q:ISBillAuditDate=""  d
	...s ISRowID=0
	...f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate,ISRowID))  q:ISRowID=""  d
	....s ISInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	....q:ISInStockNo=""
	....s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	....q:ISStatus'="2"
	....s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	....q:ISInvalidFlag="Y"
	....s ISProviderDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	....q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	....s TLocDR = $p($g(^DHCEQInStock(ISRowID)),"^",2)	//czf 2021-11-18 2215015
	....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	....s ISLRowID=0
	....f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	.....d ResetVariablesGetUnPayList
	.....q:$p($g(^DHCEQInStockList(ISLRowID)),"^",22)'=""		;过滤附属设备
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","14",ISLRowID,0,2))
	.....s TSourceType=vSourceType
	.....s TSourceID=ISLRowID
	.....s TSourceNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	.....s PREquipTypeDR=ISEquipTypeDR
	.....s TDate = $p($g(^DHCEQInStock(ISRowID)),"^",1)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	.....s TQuantityNum=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,ISLRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,ISLRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",ISProviderDR)
	.....;MZY0119	2569265		2022-04-07
	.....s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)		;库房
	.....i $p($g(^DHCEQInStockList(ISLRowID)),"^",18)=2 d
	......s OCLRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
	......s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	......s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",11),"date")	;验收日期
	......s TOpenCheckAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",26),"date")
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,ISLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//15:首次出库明细(不推荐)
	i vSourceType="15"  d
	.s SMEquipTypeDR=0
	.f  s SMEquipTypeDR=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR))  q:SMEquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(SMEquipTypeDR)=1	//modified by csj 2020-04-07
	..s SMAuditDate=0
	..f  s SMAuditDate=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate))  q:SMAuditDate=""  d
	...s SMRowID=0
	...f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",SMEquipTypeDR,SMAuditDate,SMRowID))  q:SMRowID=""  d
	....s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	....q:SMInvalidFlag="Y"
	....s SMStatus=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
	....q:SMStatus'="2"
	....s SMMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	....q:SMMoveType'="0"
	....s TToLocDR = $p($g(^DHCEQStoreMove(SMRowID)),"^",3)	//czf 2021-11-18 2215015
	....q:((TToLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR)))
	....s SMLRowID=0
	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
	.....q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",14)="Y"	;不可付款标志
	.....q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""	;过滤附属设备
	.....s EquipListIDs=##Class(web.DHCEQPayRequest).GetEquipList(SMLRowID)
	.....q:EquipListIDs=""
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","15",SMLRowID,0,2))
	.....s SMLInStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	.....s SMLEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	.....i SMLInStockListDR'=""  d
	......s SMLInStockDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",1)
	......s SMLProviderDR=$p($g(^DHCEQInStock(SMLInStockDR)),"^",17)
	.....e  d
	......s SMLProviderDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",25)
	.....q:(vProviderDR'="")&&(SMLProviderDR'=vProviderDR)
	.....d ResetVariablesGetUnPayList
	.....s TSourceType=vSourceType
	.....s TSourceID=SMLRowID
	.....s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	.....s PREquipTypeDR=SMEquipTypeDR
	.....s TDate = $p($g(^DHCEQStoreMove(SMRowID)),"^",5)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
	.....s TQuantityNum=$L(EquipListIDs,",")	//$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,SMLRowID)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,SMLRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",SMLProviderDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,SMLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//16:退货
	i vSourceType="16"  d
	.s REquipTypeDR=0
	.f  s REquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR))  q:REquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(REquipTypeDR)=1
	..s ROutTypeDR=0
	..f  s ROutTypeDR=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR))  q:ROutTypeDR=""  d
	...s ROutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",ROutTypeDR)),"^",1)
	...q:ROutTypeCode'="TH"
	...s RBillAuditDate=0
	...f  s RBillAuditDate=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR,RBillAuditDate))  q:RBillAuditDate=""  d
	....s RRowID=0
	....f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",REquipTypeDR,ROutTypeDR,RBillAuditDate,RRowID))  q:RRowID=""  d
	.....s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
	.....q:RStatus'="2"
	.....s RInvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
	.....q:RInvalidFlag="Y"
	.....s RProviderDR=$p($g(^DHCEQReturn(RRowID)),"^",3)
	.....q:(vProviderDR'="")&&(RProviderDR'=vProviderDR)
	.....s TLocDR = $p($g(^DHCEQReturn(RRowID)),"^",2)	//czf 2021-11-18 2215015
	.....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.....s RLRowID=0
	.....f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
	......d ResetVariablesGetUnPayList
	......q:$D(^DHCEQPayRecordDetail(0,"Status","16",RLRowID,0,2))
	......s RLEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
	......s RLInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
	......s TSourceType=vSourceType
	......s TSourceID=RLRowID
	......s TSourceNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
	......s TDate = $p($g(^DHCEQReturn(RRowID)),"^",4)
	......s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	......s PREquipTypeDR=REquipTypeDR
	......i RLEquipDR'=""  d
	.......s TEquipName=$p($g(^DHCEQEquip(RLEquipDR)),"^",1)
	......e  d
	.......s TEquipName=$p($g(^DHCEQInStockList(RLInStockListDR)),"^",5)
	......s TQuantityNum=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6))
	......s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	......s TPaedFee=+..GetAllPayAmount(vSourceType,RLRowID)					//已付总金额(指所有相关业务付款总额)
	......s TNeedPayFee=..GetNotPayAmount(vSourceType,RLRowID,"",TTotalFee)
	......q:+TNeedPayFee=0
	......s TAmountFee=TNeedPayFee
	......s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	......s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",RProviderDR)
	......;add by mwz20221201 mwz0065 begin
    ......s TGuaranteeInfo=..GetRetentionInfo(vSourceType,RLRowID)
	......s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	......s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	......;add by mwz20221201 mwz0065 end
	......d OutputRowGetUnPayList
	//31:配件入库
	i vSourceType="31"  d
	.s ISEquipTypeDR=0
	.f  s ISEquipTypeDR=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR))  q:ISEquipTypeDR=""  d
	..q:##class(web.DHCEQACommon).AccessoryTypeIsIn(ISEquipTypeDR)=1
	..s ISBillAuditDate=0
	..f  s ISBillAuditDate=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate))  q:ISBillAuditDate=""  d
	...s ISRowID=0
	...f  s ISRowID=$o(^DHCEQAInStock(0,"TypeDate",ISEquipTypeDR,ISBillAuditDate,ISRowID))  q:ISRowID=""  d
	....s ISInStockNo=$p($g(^DHCEQAInStock(ISRowID)),"^",6)
	....q:ISInStockNo=""
	....s ISStatus=$p($g(^DHCEQAInStock(ISRowID)),"^",16)
	....q:ISStatus'="2"
	....s ISProviderDR=$p($g(^DHCEQAInStock(ISRowID)),"^",8)
	....q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	....s TLocDR = $p($g(^DHCEQAInStock(ISRowID)),"^",3)	//czf 2021-11-18 2215015
	....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	....s ISLRowID=0
	....f  s ISLRowID=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
	.....d ResetVariablesGetUnPayList
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","31",ISLRowID,0,2))
	.....s TSourceType=vSourceType
	.....s TSourceID=ISLRowID
	.....s TSourceNo=$p($g(^DHCEQAInStock(ISRowID)),"^",6)
	.....s TDate = $p($g(^DHCEQAInStock(ISRowID)),"^",1)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s PREquipTypeDR=ISEquipTypeDR
	.....s TEquipName=$p($g(^DHCEQAInStockList(ISLRowID)),"^",4)
	.....s TQuantityNum=$p($g(^DHCEQAInStockList(ISLRowID)),"^",9)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAInStockList(ISLRowID)),"^",8))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,ISLRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,ISLRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",ISProviderDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,ISLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//32:首次配件出库(不推荐)
	i vSourceType="32"  d
	.s MSEquipTypeDR=0
	.f  s MSEquipTypeDR=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR))  q:MSEquipTypeDR=""  d
	..q:##class(web.DHCEQACommon).AccessoryTypeIsIn(MSEquipTypeDR)=1
	..s MSBillAuditDate=0
	..f  s MSBillAuditDate=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR,MSBillAuditDate))  q:MSBillAuditDate=""  d
	...s MSRowID=0
	...f  s MSRowID=$o(^DHCEQAMoveStock(0,"StatusTypeDate",2,0,MSEquipTypeDR,MSBillAuditDate,MSRowID))  q:MSRowID=""  d
	....s TToLocDR = $p($g(^DHCEQAMoveStock(MSRowID)),"^",5)	//czf 2021-11-18 2215015
	....q:((TToLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR)))
	....s MSLRowID=0
	....f  s MSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",MSRowID,MSLRowID))  q:MSLRowID=""  d
	.....d ResetVariablesGetUnPayList
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","32",MSLRowID,0,2))
	.....s MSLInStockListDR=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",15)
	.....q:MSLInStockListDR=""
	.....s MSLInStockDR=$p($g(^DHCEQAInStockList(MSLInStockListDR)),"^",1)
	.....q:MSLInStockDR=""
	.....s ISProviderDR=$p($g(^DHCEQAInStock(MSLInStockDR)),"^",8)
	.....q:(vProviderDR'="")&&(ISProviderDR'=vProviderDR)
	.....s TSourceType=vSourceType
	.....s TSourceID=MSLRowID
	.....s TSourceNo=$p($g(^DHCEQAMoveStock(MSRowID)),"^",1)
	.....s TDate = $p($g(^DHCEQAMoveStock(MSRowID)),"^",7)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s PREquipTypeDR=MSEquipTypeDR
	.....s TEquipName=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",4)
	.....s TQuantityNum=$p($g(^DHCEQAMoveStockList(MSLRowID)),"^",11)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAMoveStockList(MSLRowID)),"^",10))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,MSLRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,MSLRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",ISProviderDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,MSLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//33:配件退货
	i vSourceType="33"  d
	.s REquipTypeDR=0
	.f  s REquipTypeDR=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR))  q:REquipTypeDR=""  d
	..q:##class(web.DHCEQACommon).AccessoryTypeIsIn(REquipTypeDR)=1
	..s RBillAuditDate=0
	..f  s RBillAuditDate=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR,1,RBillAuditDate))  q:RBillAuditDate=""  d
	...s RRowID=0
	...f  s RRowID=$o(^DHCEQAReduce(0,"TypeDate",REquipTypeDR,1,RBillAuditDate,RRowID))  q:RRowID=""  d
	....s RStatus=$p($g(^DHCEQAReduce(RRowID)),"^",23)
	....q:RStatus'="2"
	....s RProviderDR=$p($g(^DHCEQAReduce(RRowID)),"^",6)
	....q:(vProviderDR'="")&&(RProviderDR'=vProviderDR)
	....s TLocDR = $p($g(^DHCEQAReduce(RRowID)),"^",4)	//czf 2021-11-18 2215015
	....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	....s RLRowID=0
	....f  s RLRowID=$o(^DHCEQAReduceList(0,"Reduce",RRowID,RLRowID))  q:RLRowID=""  d
	.....d ResetVariablesGetUnPayList
	.....q:$D(^DHCEQPayRecordDetail(0,"Status","33",RLRowID,0,2))
	.....s RLItemDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",2)
	.....s TSourceType=vSourceType
	.....s TSourceID=RLRowID
	.....s TSourceNo=$p($g(^DHCEQAReduce(RRowID)),"^",1)
	.....s TDate = $p($g(^DHCEQAReduce(RRowID)),"^",8)
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s PREquipTypeDR=REquipTypeDR
	.....i RLItemDR'="" s TEquipName=$p(^DHCEQCCode("DHCEQCAccessory",RLItemDR),"^",2)
	.....s TQuantityNum=$p($g(^DHCEQAReduceList(RLRowID)),"^",10)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAReduceList(RLRowID)),"^",9))
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TTotalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,RLRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,RLRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s PRPayFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",RProviderDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,RLRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//41:调账
	i vSourceType="41"  d
	.s CAEquipTypeDR=0
	.f  s CAEquipTypeDR=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR))  q:CAEquipTypeDR=""  d
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(CAEquipTypeDR)=1
	..s BillAuditDate=0
	..f  s BillAuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,BillAuditDate))  q:BillAuditDate=""  d
	...s CARowID=0
	...f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",CAEquipTypeDR,BillAuditDate,CARowID))  q:CARowID=""  d
	....s CAStatus=$p($g(^DHCEQChangeAccount(CARowID)),"^",11)
	....q:CAStatus'="2"
	....s CAProviderDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",35)			//调账增减值付款供应商
	....q:(vProviderDR'="")&&(CAProviderDR'=vProviderDR)
	....s CAChangeFee=$p($g(^DHCEQChangeAccount(CARowID)),"^",2)
	....q:CAChangeFee=0			//资金来源变动不在付款范围内
	....q:$D(^DHCEQPayRecordDetail(0,"Status","41",CARowID,0,2))
	....s TLocDR = $p($g(^DHCEQChangeAccount(CARowID)),"^",28)	//czf 2021-11-18 2215015
	....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	....d ResetVariablesGetUnPayList
	....s TSourceType=vSourceType
	....s TSourceID=CARowID
	....s TSourceNo=CARowID
	....s TDate = $p($g(^DHCEQChangeAccount(CARowID)),"^",9)
	....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	....s PREquipTypeDR=CAEquipTypeDR
	....s TEquipName=$p($g(^DHCEQChangeAccount(CARowID)),"^",8)
	....s TQuantityNum=1
	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(CAChangeFee)
	....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	....s TPaedFee=+..GetAllPayAmount(vSourceType,CARowID)					//已付总金额(指所有相关业务付款总额)
	....s TNeedPayFee=..GetNotPayAmount(vSourceType,CARowID,"",TTotalFee)
	....q:+TNeedPayFee=0
	....s TAmountFee=TNeedPayFee
	....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",CAProviderDR)
	....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,CARowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	....;add by mwz20221201 mwz0065 end
	....d OutputRowGetUnPayList
	//51:保养  52:检查  53:维修
	i (vSourceType="51")||(vSourceType="52")  d
	.s MTTypeDR=0		//1保养,2检查
 	.f  s MTTypeDR=$o(^DHCEQMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	..q:(vSourceType="51")&&(MTTypeDR'=1)
 	..q:(vSourceType="52")&&(MTTypeDR'=2)
 	..s MSourceID=""
	..f  s MSourceID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID))  q:MSourceID=""  d
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID))  q:EQRowID=""  d
	....s MTRowID=0
	....f  s MTRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	.....s MTInvalidFlag=$p($g(^DHCEQMaint(MTRowID)),"^",39)
	.....q:MTInvalidFlag="Y"
	.....s MTStatus=$p($g(^DHCEQMaint(MTRowID)),"^",13)
	.....q:MTStatus'="2"
	.....s TLocDR = $p($g(^DHCEQMaint(MTRowID)),"^",6)	//czf 2021-11-18 2215015
	.....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.....s MTAuditDate=$p($g(^DHCEQMaint(MTRowID)),"^",19)
	.....s MTMaintType=$p($g(^DHCEQMaint(MTRowID)),"^",4)		//4巡检,5计量							
	.....d ResetVariablesGetUnPayList
	.....s TSourceType=vSourceType
	.....s TSourceID=MTRowID
	.....s TSourceNo=MTRowID
	.....s TDate = MTAuditDate
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s MTMonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(MTAuditDate)
	.....s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MTMonthStr)
	.....i SnapID'=""  d
	......s PREquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)		///类组
	.....e  d
	......s PREquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	.....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)				///项目
	.....s TQuantityNum=1
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(MTRowID)),"^",9))
	.....q:+TOriginalFee=0			///备注
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,MTRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,MTRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s TAmountFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,MTRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	//53:维修
	i vSourceType="53"  d
	.s MTTypeDR=0
 	.f  s MTTypeDR=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	..q:MTTypeDR'=3
 	..s MSourceID=""
	..f  s MSourceID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID))  q:MSourceID=""  d
	...s SourceEquipTypeDR=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",3)
	...q:##Class(web.DHCEQCommon).EquipTypeIsIn(SourceEquipTypeDR)=1
	...s EQRowID=0
	...f  s EQRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID))  q:EQRowID=""  d
	....s MTRowID=0
	....f  s MTRowID=$o(^DHCEQMMaint(0,"SourceID",MTTypeDR,MSourceID,EQRowID,MTRowID))  q:MTRowID=""  d
	.....s MTInvalidFlag=$p($g(^DHCEQMMaint(MTRowID)),"^",39)
	.....q:MTInvalidFlag="Y"
	.....s MTStatus=$p($g(^DHCEQMMaint(MTRowID)),"^",13)
	.....q:MTStatus'="2"
	.....s TLocDR = $p($g(^DHCEQMMaint(MTRowID)),"^",6)	//czf 2021-11-18 2215015
	.....q:((TLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.....s MTAuditDate=$p($g(^DHCEQMMaint(MTRowID)),"^",19)
	.....s MTMaintType=$p($g(^DHCEQMMaint(MTRowID)),"^",4)							
	.....d ResetVariablesGetUnPayList
	.....s TSourceType=vSourceType
	.....s TSourceID=MTRowID
	.....s TSourceNo=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",1)
	.....s TDate = MTAuditDate
	.....s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date") 
	.....s PREquipTypeDR=$p($g(^DHCEQMMaintRequest(MSourceID)),"^",3)		///类组
	.....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)				///项目
	.....s TQuantityNum=1
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMMaint(MTRowID)),"^",9))
	.....q:+PRPrice=0
	.....s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum*TOriginalFee)
	.....s TPaedFee=+..GetAllPayAmount(vSourceType,MTRowID)					//已付总金额(指所有相关业务付款总额)
	.....s TNeedPayFee=..GetNotPayAmount(vSourceType,MTRowID,"",TTotalFee)
	.....q:+TNeedPayFee=0
	.....s PRPayFee=TNeedPayFee
	.....s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",PREquipTypeDR)
	.....;add by mwz20221201 mwz0065 begin
    .....s TGuaranteeInfo=..GetRetentionInfo(vSourceType,MTRowID)
	.....s TGuaranteeFee=+$p(TGuaranteeInfo,"^",2)
	.....s TGuaranteePercent=+$p(TGuaranteeInfo,"^",1)
	.....;add by mwz20221201 mwz0065 end
	.....d OutputRowGetUnPayList
	
	Quit $$$OK
OutputRowGetUnPayList
    Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TGuaranteePercent,TGuaranteeFee,TRate,TOpenCheckDate,TProvider,TJob,TOpenCheckAuditDate,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc)    ////modify by mwz 20180313 需求号：550672
    Set ^CacheTemp(repid,index)=Data
    Set ^DHCEQTemp("UnPayRequestList",+$H,TJob,index)=TRowID_"^"_TSourceType_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TEquipType_"^"_TGuaranteePercent_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TProvider_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark_"^"_TUseLoc

	Set index=index+1
	quit
ResetVariablesGetUnPayList
	Set (DataList,TRowID,TEquipTypeDR,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TProvider,TGuaranteePercent,TGuaranteeFee,TRate,TOpenCheckDate,TOpenCheckAuditDate,TOpenCheckOriginDR,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc,PRAccessoryTypeDR)=""		//czf 1770138 2021-01-20
	Quit
}

ClassMethod GetUnPayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPayListExecute ]
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

ClassMethod GetUnPayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPayListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
