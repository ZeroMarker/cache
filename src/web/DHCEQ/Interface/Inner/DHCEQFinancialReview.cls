Class web.DHCEQ.Interface.Inner.DHCEQFinancialReview Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2015-08-12
/// 描述:财务检审接口
/// 参数:vBussinessType 【RK:入库  ZY:转移  TH:退货  JS:减少  BF:报废  TZ:台帐  ZJ:折旧  CA:调账】
/// 	 vAutoFlag		Y/N
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).CreateFinancialReviewList("","3")
ClassMethod CreateFinancialReviewList(val, vAutoFlag As %String = "", vBussID As %String = "")
{
	n (val,vAutoFlag,vBussID,%session)
	s vBussinessType=$p(val,"^",1)
	s vMonth=$p(val,"^",2)
	s vEquipTypeIDS=$p(val,"^",3)
	s SDate=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")
	s EDate=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")
	s User=$p(val,"^",6)
	s vFRRowID=$p(val,"^",7)
	s LogonLocdr=$p(val,"^",8)
	s Remark=$p(val,"^",9)
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	/************************************生成财务检审主表**************************************/
	TSTART
	s SQLCODE=0
	K FRPLIST
	s FRPLIST(2)=vBussinessType															//FR_BussinessType
	s FRBussinessNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQFinancialReview",+$H,LogonLocdr)
	s FRPLIST(3)=FRBussinessNo															//FR_BussinessNo
	s FRPLIST(4)=vEquipTypeIDS																		//FR_EquipTypeIDs
	s FRPLIST(5)=FRBussinessNo_".pdf"													//FR_PDFName
	s FRPLIST(6)=SDate																	//FR_BussinessSDate
	s FRPLIST(7)=EDate																	//FR_BussinessEDate
	s FRPLIST(8)=vAutoFlag																//FR_CreateType（1：自动任务  2：接口调用  3：手动生成）
	s FRPLIST(9)=User																	//FR_CreateUserDR
	s FRPLIST(10)=+$H																	//FR_CreateDate
	s FRPLIST(11)=$p($H,",",2)															//FR_CreateTime
	s FRPLIST(22)="0"																	//FR_Status
	s FRPLIST(23)="N"																	//FR_InvalidFlag
	s FRPLIST(24)=Remark																//FR_Remark
	s FRPLIST(25)="0"																	//FR_AccountFlag（0:未传输  1:未做帐  2:已做帐）
	s FRPLIST(29)=vMonth																//FR_Month
	s FRPLIST(30)=##Class(web.DHCEQCommon).GetHospital()								//FR_Hosptial 院区
	i vFRRowID=""
	{
		&SQL(insert into sqluser.DHC_EQFinancialReview values :FRPLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQFinancialReview values :FRPLIST() where FR_RowID=:vFRRowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s FRRowID=$G(%ROWID)
	/********************************清空当前主单对应的所有明细记录***************************/
	i $D(^DHCEQFinancialReviewList(0,"FinancialReview",FRRowID))
	{
		&SQL(Delete From SQLUSER.DHC_EQFinancialReviewList Where FRL_FinancialReviewDR=:FRRowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	/**************************************获取各个业务明细数据*******************************/
	//(1)入库
	i vBussinessType="RK"  d
	.s FRLEquipTypeDR=0
	.f  s FRLEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",FRLEquipTypeDR)) q:((FRLEquipTypeDR="")||(SQLCODE'=0))  d
	..q:(","_vEquipTypeIDS_",")'[(","_FRLEquipTypeDR_",")
	..s BillDate=SDate-1
	..f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",FRLEquipTypeDR,BillDate)) q:((BillDate="")||(BillDate>EDate)||(SQLCODE'=0))  d
	...s ISRowID=0
	...f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",FRLEquipTypeDR,BillDate,ISRowID)) q:((ISRowID="")||(SQLCODE'=0))  d
	....q:(vBussID'="")&&(vBussID'=ISRowID)
	....s ISNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	....q:ISNo=""
	....s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	....q:ISStatus'=2
	....s InvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	....q:InvalidFlag="Y"
	....s FRLLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
	....s FRLOriginDR=$p($g(^DHCEQInStock(ISRowID)),"^",15)
	....s FRLVendorDR=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	....s FRLBussUserDR=$p($g(^DHCEQInStock(ISRowID)),"^",12)
	....s FRLBussDate=BillDate
	....s FRLBussNo=ISNo
	....s ISLRowID=0
	....f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:(ISLRowID="")  d
	.....s FRLSourceID=ISLRowID
	.....s FRLStatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
	.....i FRLStatCatDR="" s FRLStatCatDR=$p($g(^DHCEQInStock(ISRowID)),"^",21)
	.....s FRLEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	.....s FRLQuantityNum=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	.....s FRLPrice=$p($g(^DHCEQInStockList(ISLRowID)),"^",7)
	.....s FRLPrice=##Class(web.DHCEQCommon).FormatNumber(FRLPrice,"")
	.....s FRLAmount=##Class(web.DHCEQCommon).FormatNumber(FRLQuantityNum*FRLPrice,"")
	.....s (FRLFundsInfo,FRLOtherInfo,FRLBrandDR,FRLCountryDR,FRLToLoc,FRLChangeDepreTotal,FRLToDept,FRLBudgetNo)=""
	.....s FRLRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
	.....s FRLUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
	.....s FRLModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
	.....s FRLEquipCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",14)
	.....s FRLManuFactoryDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",6)
	.....s valList="^"_FRRowID_"^"_FRLSourceID_"^"_FRLEquipTypeDR_"^"_FRLStatCatDR_"^"_FRLLocDR_"^"_FRLOriginDR_"^"_FRLEquipName_"^"_FRLQuantityNum_"^"_FRLPrice_"^"_FRLAmount_"^"_FRLFundsInfo_"^"_FRLOtherInfo_"^"_FRLRemark_"^"_FRLEquipCatDR_"^"_FRLUnitDR_"^"_FRLVendorDR_"^"_FRLModelDR_"^"_FRLManuFactoryDR_"^"_FRLBrandDR_"^"_FRLCountryDR_"^"_FRLToLoc_"^"_FRLChangeDepreTotal_"^"_FRLToDept_"^0^^^^"_FRLBussUserDR_"^"_FRLBussDate_"^"_FRLBudgetNo_"^^"_FRLBussNo
	.....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
	.....s SQLCODE=+SQLInfo
	.....q:SQLCODE'=0
	.....s FRLRowID=$p(SQLInfo,"^",2)
	.....;获取最后一个设备ID
	.....s FindMaxID=""
	.....s EQStoreLocDR=0
	.....f  s EQStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR))  q:EQStoreLocDR=""  d
	......s EQRowID=0
	......f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR,EQRowID))  q:EQRowID=""  d
	.......i FindMaxID="" s FindMaxID=EQRowID
	.......i EQRowID>FindMaxID s FindMaxID=EQRowID
	.....;保存DHC_EQFinancialReviewEquip表
	.....s EQStoreLocDR=0
	.....f  s EQStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR))  q:(EQStoreLocDR="")||(SQLCODE'=0)  d
	......s EQRowID=0
	......f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocDR,EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
	.......s TBrandDR=$p($g(^DHCEQEquip(EQRowID)),"^",94)
	.......s TCountryDR=$p($g(^DHCEQEquip(EQRowID)),"^",16)
	.......s TLocationDR=$p($g(^DHCEQEquip(EQRowID)),"^",72)
	.......s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.......s TPurposeTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",65)
	.......s TTransAsSetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	.......s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
	.......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
	.......s SQLCODE=+SQLInfo
	.......q:SQLCODE'=0
	.......s FRERowID=$p(SQLInfo,"^",2)
	.......;保存DHC_EQFinancialReviewFunds表
	.......s FundsRowID=0
	.......f  s FundsRowID=$o(^DHCEQFunds(0,"Source",3,ISLRowID,FundsRowID))  q:(FundsRowID="")||(SQLCODE'=0)  d
	........s FundsInvalidFlag=$p($g(^DHCEQFunds(FundsRowID)),"^",10)
	........q:FundsInvalidFlag="Y"
	........s FundsOperFlag=$p($g(^DHCEQFunds(FundsRowID)),"^",6)
	........q:FundsOperFlag=2
	........s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	........s FundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",3),"")
	........s FundsDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",13),"")
	........i EQRowID=FindMaxID  d
	.........s TOriginalFee=FundsFee - (##Class(web.DHCEQCommon).FormatNumber(FundsFee/FRLQuantityNum,"")*(FRLQuantityNum-1))
	.........s TDepreTotalFee=FundsDepreTotal - (##Class(web.DHCEQCommon).FormatNumber(FundsDepreTotal/FRLQuantityNum,"")*(FRLQuantityNum-1))
	.........s TNetFee=TOriginalFee-TDepreTotalFee
	........e  d
	.........s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(FundsFee/FRLQuantityNum,"")
	.........s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(FundsDepreTotal/FRLQuantityNum,"")
	.........s TNetFee=TOriginalFee-TDepreTotalFee
	........s valList="^"_FRERowID_"^"_FundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotalFee
	........s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
	........s SQLCODE=+SQLInfo
	/**************************************************************************************************/
	//(2)转移
	i vBussinessType="ZY"  d
	.s ETRowID=0
	.f  s ETRowID=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID)) q:(ETRowID="")||(SQLCODE'=0)  d
	..q:(","_vEquipTypeIDS_",")'[(","_ETRowID_",")
	..s BillDate=SDate-1
	..f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID,BillDate)) q:((BillDate="")||(BillDate>EDate)||(SQLCODE'=0))  d
	...s SMRowID=0
	...f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID,BillDate,SMRowID)) q:(SMRowID="")  d
	....q:(vBussID'="")&&(vBussID'=SMRowID)
	....s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	....q:SMInvalidFlag="Y"
	....s SMStatus=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
	....q:SMStatus'=2
	....s FRLBussNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	....s FRLLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)		//FromLoc
	....s FRLOtherInfo=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)	//MoveType
	....s FRLToLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)		//ToLoc
	....s FRLBussUserDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",9)
	....s FRLBussDate=BillDate
	....s SMLRowID=0
	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:(SMLRowID="")||(SQLCODE'=0)  d
	.....s FRLSourceID=SMLRowID
	.....s FRLEquipTypeDR=ETRowID
	.....s SMLEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	.....s SMLInStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	.....i SMLEquipDR'=""  d
	......s FRLStatCatDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",75)
	......s FRLOriginDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",20)
	......s EQRowIDs=SMLEquipDR
	......s FRLVendorDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",25)
	......s FRLEquipCatDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",4)
	......s FRLBrandDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",94)
	......s FRLCountryDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",16)
	.....e  d
	......s SMLInStockDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",1)
	......s FRLStatCatDR=$p(##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(SMLInStockListDR),"^",2)
	......i FRLStatCatDR="" s FRLStatCatDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",17)
	......i FRLStatCatDR="" s FRLStatCatDR=$p($g(^DHCEQInStock(SMLInStockDR)),"^",21)
	......s FRLOriginDR=$p($g(^DHCEQInStock(SMLInStockDR)),"^",15)
	......s EQRowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	......s FRLVendorDR=$p($g(^DHCEQInStock(SMLInStockDR)),"^",17)
	......s FRLEquipCatDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",14)
	......s FRLBrandDR=""
	......s FRLCountryDR=""
	.....s FRLEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
	.....s FRLQuantityNum=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.....s FRLPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7))
	.....s FRLAmount=##Class(web.DHCEQCommon).FormatNumber(FRLQuantityNum*FRLPrice)
	.....s (FRLFundsInfo,FRLChangeDepreTotal,FRLToDept,FRLBudgetNo)=""
	.....s FRLRemark=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11)
	.....s FRLUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
	.....s FRLManuFactoryDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",6)
	.....s FRLModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
	.....s FRLLocationDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",12)	
	.....s valList="^"_FRRowID_"^"_FRLSourceID_"^"_FRLEquipTypeDR_"^"_FRLStatCatDR_"^"_FRLLocDR_"^"_FRLOriginDR_"^"_FRLEquipName_"^"_FRLQuantityNum_"^"_FRLPrice_"^"_FRLAmount_"^"_FRLFundsInfo_"^"_FRLOtherInfo_"^"_FRLRemark_"^"_FRLEquipCatDR_"^"_FRLUnitDR_"^"_FRLVendorDR_"^"_FRLModelDR_"^"_FRLManuFactoryDR_"^"_FRLBrandDR_"^"_FRLCountryDR_"^"_FRLToLoc_"^"_FRLChangeDepreTotal_"^"_FRLToDept_"^0^^^^"_FRLBussUserDR_"^"_FRLBussDate_"^"_FRLBudgetNo_"^^"_FRLBussNo
	.....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
	.....s SQLCODE=+SQLInfo
	.....q:SQLCODE'=0
	.....s FRLRowID=$p(SQLInfo,"^",2)	
	.....;保存DHC_EQFinancialReviewEquip表
	.....s EQCount=$l(EQRowIDs,",")
	.....f i=1:1:EQCount d
	......q:SQLCODE'=0
	......s EQRowID=$p(EQRowIDs,",",i)
	......s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	......s TPurposeTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",65)
	......s TTransAsSetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	......s valList="^"_FRLRowID_"^"_EQRowID_"^"_FRLLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
	......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
	......s SQLCODE=+SQLInfo
	......q:SQLCODE'=0
	......s FRERowID=$p(SQLInfo,"^",2)
	......;保存DHC_EQFinancialReviewFunds表
	......s FundsTypeDR=0
	......f  s FundsTypeDR=$o(^DHCEQStoreMoveList(SMLRowID,"FundsInfo",EQRowID,FundsTypeDR))  q:(FundsTypeDR="")||(SQLCODE'=0)  d
	.......s TOriginalFee=$p($g(^DHCEQStoreMoveList(SMLRowID,"FundsInfo",EQRowID,FundsTypeDR)),"^",1)
	.......s TDepreTotalFee=$p($g(^DHCEQStoreMoveList(SMLRowID,"FundsInfo",EQRowID,FundsTypeDR)),"^",2)
	.......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee)
	.......s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TDepreTotalFee)
	.......s TNetFee=TOriginalFee-TDepreTotalFee
	.......s valList="^"_FRERowID_"^"_FundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotalFee
	.......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
	.......s SQLCODE=+SQLInfo
	
	/**************************************************************************************************/
	//(3)退货//(4)减少
	i (vBussinessType="TH")||(vBussinessType="JS")  d
	.s ETRowID=0
	.f  s ETRowID=$o(^DHCEQReturn(0,"TypeDate",ETRowID))  q:(ETRowID="")||(SQLCODE'=0)  d
	..q:(","_vEquipTypeIDS_",")'[(","_ETRowID_",")
	..s OTRowID=0
	..f  s OTRowID=$o(^DHCEQReturn(0,"TypeDate",ETRowID,OTRowID))  q:(OTRowID="")||(SQLCODE'=0)  d
	...s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OTRowID)),"^",1)
	...q:(vBussinessType="TH")&&(OutTypeCode'="TH")
	...q:(vBussinessType="JS")&&(OutTypeCode="TH")
	...s AuditDate=SDate-1
	...f  s AuditDate=$o(^DHCEQReturn(0,"TypeDate",ETRowID,OTRowID,AuditDate))  q:(AuditDate="")||(AuditDate>EDate)||(SQLCODE'=0)  d
	....s RRowID=0
	....f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",ETRowID,OTRowID,AuditDate,RRowID))  q:(RRowID="")||(SQLCODE'=0)  d
	.....q:(vBussID'="")&&(vBussID'=RRowID)
	.....s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
	.....q:RStatus'=2
	.....s RInvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
	.....q:RInvalidFlag="Y"
	.....s FRLBussNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
	.....s FRLLocDR=$p($g(^DHCEQReturn(RRowID)),"^",24)		//退货科室
	.....i FRLLocDR="" s FRLLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)		//退货库房
	.....s FRLToDept=$p($g(^DHCEQReturn(RRowID)),"^",18)
	.....s FRLBussUserDR=$p($g(^DHCEQReturn(RRowID)),"^",10)
	.....s FRLBussDate=$p($g(^DHCEQReturn(RRowID)),"^",11)
	.....s RLRowID=0
	.....f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:(RLRowID="")||(SQLCODE'=0)  d
	......s TBatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	......s TInStockListDR=$P(^DHCEQReturnList(RLRowID),"^",3)
	......s RLEQRowID=$P(^DHCEQReturnList(RLRowID),"^",4)
	......i TInStockListDR'=""  d   //批量设备
	.......s InStockRowID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.......s FRLStatCatDR=$p(##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(TInStockListDR),"^",2)
	.......i FRLStatCatDR="" s FRLStatCatDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",17)
	.......i FRLStatCatDR="" s FRLStatCatDR=$p($g(^DHCEQInStock(InStockRowID)),"^",21)
	.......s FRLOriginDR=$p($g(^DHCEQInStock(InStockRowID)),"^",15)
	.......s FRLVendorDR=$p($g(^DHCEQInStock(InStockRowID)),"^",17)
	.......s FRLEquipName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5)
	.......s FRLUnitDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",10)
	.......s FRLModelDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",9)
	.......s FRLEquipCatDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",14)
	.......s FRLManuFactoryDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",6)
	.......s FRLBrandDR=""
	.......s FRLCountryDR=""
	.......s EQRowIDs=$G(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	......e  d
	.......s FRLStatCatDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",75)
	.......s FRLOriginDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",20)
	.......s FRLEquipName=$p($g(^DHCEQEquip(RLEQRowID)),"^",1)
	.......s FRLUnitDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",5)	
	.......s FRLModelDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",3)			//Modify By DJ 2021-02-19 begin
	.......s FRLVendorDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",25)
	.......s FRLManuFactoryDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",26)
	.......s FRLEquipCatDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",4)
	.......s FRLBrandDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",94)
	.......s FRLCountryDR=$p($g(^DHCEQEquip(RLEQRowID)),"^",16)			//Modify By DJ 2021-02-19 end
	.......s EQRowIDs=RLEQRowID
	......s FRLSourceID=RLRowID
	......s FRLEquipTypeDR=ETRowID	
	......s FRLQuantityNum=$P(^DHCEQReturnList(RLRowID),"^",5)
	......s FRLPrice=##Class(web.DHCEQCommon).FormatNumber($P(^DHCEQReturnList(RLRowID),"^",6))
	......s FRLAmount=##Class(web.DHCEQCommon).FormatNumber(FRLQuantityNum*FRLPrice)
	......s (FRLFundsInfo,FRLToLoc,FRLChangeDepreTotal,FRLBudgetNo)=""
	......s FRLOtherInfo=OTRowID
	......s FRLRemark=$P(^DHCEQReturnList(RLRowID),"^",9)
	......s valList="^"_FRRowID_"^"_FRLSourceID_"^"_FRLEquipTypeDR_"^"_FRLStatCatDR_"^"_FRLLocDR_"^"_FRLOriginDR_"^"_FRLEquipName_"^"_FRLQuantityNum_"^"_FRLPrice_"^"_FRLAmount_"^"_FRLFundsInfo_"^"_FRLOtherInfo_"^"_FRLRemark_"^"_FRLEquipCatDR_"^"_FRLUnitDR_"^"_FRLVendorDR_"^"_FRLModelDR_"^"_FRLManuFactoryDR_"^"_FRLBrandDR_"^"_FRLCountryDR_"^"_FRLToLoc_"^"_FRLChangeDepreTotal_"^"_FRLToDept_"^0^^^^"_FRLBussUserDR_"^"_FRLBussDate_"^"_FRLBudgetNo_"^^"_FRLBussNo
	......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
	......s SQLCODE=+SQLInfo
	......q:SQLCODE'=0
	......s FRLRowID=$p(SQLInfo,"^",2)
	......;保存DHC_EQFinancialReviewEquip表
	......s EQCount=$l(EQRowIDs,",")
	......f i=1:1:EQCount d
	.......q:SQLCODE'=0
	.......s EQRowID=$p(EQRowIDs,",",i)
	.......s TLocationDR=$p($g(^DHCEQEquip(EQRowID)),"^",72)
	.......s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	.......s TPurposeTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",65)
	.......s TTransAsSetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	.......s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
	.......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
	.......s SQLCODE=+SQLInfo
	.......q:SQLCODE'=0
	.......s FRERowID=$p(SQLInfo,"^",2)
	.......;保存DHC_EQFinancialReviewFunds表
	.......s FundsID=0
	.......f  s FundsID=$o(^DHCEQFunds(0,"Source","1",EQRowID,FundsID)) q:(FundsID="")||(SQLCODE'=0)  d
	........q:$p(^DHCEQFunds(FundsID),"^",10)="Y"
	........q:$p(^DHCEQFunds(FundsID),"^",6)="2"
	........s FundsTypeDR=$p($g(^DHCEQFunds(FundsID)),"^",2)
	........s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
	........s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
	........s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee-TDepreTotalFee,"",2)
	........s valList="^"_FRERowID_"^"_FundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotalFee
	........s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
	........s SQLCODE=+SQLInfo
	/**************************************************************************************************/
	//(5)报废
	i vBussinessType="BF"  d
	.s DEquipType=0
	.f  s DEquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType))  q:(DEquipType="")||(SQLCODE'=0)  d
	..q:(","_vEquipTypeIDS_",")'[(","_DEquipType_",")
	..s StockDate=SDate-1
	..f  s StockDate=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate)) q:((StockDate="")||(StockDate>EDate)||(SQLCODE'=0))  d
 	...s DRowID=0
 	...f  s DRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate,DRowID)) q:(DRowID="")||(SQLCODE'=0)  d
 	....q:(vBussID'="")&&(vBussID'=DRowID)
 	....s DStatus=$p($g(^DHCEQDisuseRequest(DRowID)),"^",10)
 	....q:DStatus'=2
 	....s DInvalidFlag=$p($g(^DHCEQDisuseRequest(DRowID)),"^",53)
 	....q:DInvalidFlag="Y"
 	....S FRLBussNo=$p($g(^DHCEQDisuseRequest(DRowID)),"^",33)
 	....s FRLEquipTypeDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",43)
 	....s FRLLocDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",34)
 	....s FRLRemark=$p($g(^DHCEQDisuseRequest(DRowID)),"^",9)
 	....s DKindFlag=$p($g(^DHCEQDisuseRequest(DRowID)),"^",44)		//0:单台 1:批量 2:多批
 	....s FRLBussUserDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",20)
 	....s FRLBussDate=StockDate
	....s FRLOtherInfo=DKindFlag
	....s DRLRowID=0
	....f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRowID,DRLRowID))  q:(DRLRowID="")||(SQLCODE'=0)  d
	.....s DRLEQRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.....s DRLHold2=+$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",12)		//多批报废DHC_EQDisuseList表RowID
	.....s FRLSourceID=DRowID_"||"_DRLHold2_"||"_DRLRowID
	.....s FRLStatCatDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",75)
	.....s FRLOriginDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",20)
	.....s FRLEquipName=$p($g(^DHCEQEquip(DRLEQRowID)),"^",1)
	.....s FRLQuantityNum=1
	.....s FRLPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(DRLEQRowID)),"^",27))
	.....s FRLAmount=##Class(web.DHCEQCommon).FormatNumber(FRLQuantityNum*FRLPrice)
	.....s FRLUnitDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",5)
	.....s FRLModelDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",3)
	.....s FRLVendorDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",25)
	.....s FRLManuFactoryDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",26)
	.....s FRLEquipCatDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",4)
	.....s FRLBrandDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",94)
	.....s FRLCountryDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",16)
	.....s TLocationDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",72)
	.....s TEQNo=$p($g(^DHCEQEquip(DRLEQRowID)),"^",71)
	.....s TPurposeTypeDR=$p($g(^DHCEQEquip(DRLEQRowID)),"^",65)
	.....s TTransAsSetDate=$p($g(^DHCEQEquip(DRLEQRowID)),"^",45)
	.....s (FRLFundsInfo,FRLToLoc,FRLChangeDepreTotal,FRLToDept,FRLBudgetNo)=""	
	.....s valList="^"_FRRowID_"^"_FRLSourceID_"^"_FRLEquipTypeDR_"^"_FRLStatCatDR_"^"_FRLLocDR_"^"_FRLOriginDR_"^"_FRLEquipName_"^"_FRLQuantityNum_"^"_FRLPrice_"^"_FRLAmount_"^"_FRLFundsInfo_"^"_FRLOtherInfo_"^"_FRLRemark_"^"_FRLEquipCatDR_"^"_FRLUnitDR_"^"_FRLVendorDR_"^"_FRLModelDR_"^"_FRLManuFactoryDR_"^"_FRLBrandDR_"^"_FRLCountryDR_"^"_FRLToLoc_"^"_FRLChangeDepreTotal_"^"_FRLToDept_"^0^^^^"_FRLBussUserDR_"^"_FRLBussDate_"^"_FRLBudgetNo_"^^"_FRLBussNo
	.....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
	.....s SQLCODE=+SQLInfo
	.....q:SQLCODE'=0
	.....s FRLRowID=$p(SQLInfo,"^",2)
	.....;保存DHC_EQFinancialReviewEquip表
	.....s valList="^"_FRLRowID_"^"_DRLEQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
	.....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
	.....s SQLCODE=+SQLInfo
	.....q:SQLCODE'=0
	.....s FRERowID=$p(SQLInfo,"^",2)	
	.....;保存DHC_EQFinancialReviewFunds表
	.....s FundsID=0
	.....f  s FundsID=$o(^DHCEQFunds(0,"Source","1",DRLEQRowID,FundsID)) q:(FundsID="")||(SQLCODE'=0)  d
	......q:$p(^DHCEQFunds(FundsID),"^",10)="Y"
	......q:$p(^DHCEQFunds(FundsID),"^",6)="2"
	......s FundsTypeDR=$p($g(^DHCEQFunds(FundsID)),"^",2)
	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3),"",2)
	......s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13),"",2)
	......s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee-TDepreTotalFee,"",2)
	......s valList="^"_FRERowID_"^"_FundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotalFee
	......s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
	......s SQLCODE=+SQLInfo	
	/**************************************************************************************************/
	//(6)台帐
	/**************************************************************************************************/
	//(8)调账
	i vBussinessType="CA"  d
	.s ETRowID=0
	.f  s ETRowID=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID))  q:(ETRowID="")||(SQLCODE'=0)  d
	..q:(","_vEquipTypeIDS_",")'[(","_ETRowID_",")
	..s AuditDate=SDate-1
	..f  s AuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID,AuditDate))  q:(AuditDate="")||(AuditDate>EDate)||(SQLCODE'=0)  d
	...s CARowID=0
	...f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",ETRowID,AuditDate,CARowID))  q:(CARowID="")||(SQLCODE'=0)  d
	....q:(vBussID'="")&&(vBussID'=CARowID)
	....s CAStatus=$p($g(^DHCEQChangeAccount(CARowID)),"^",11)
	....q:CAStatus'=2
	....s FRLSourceID=CARowID
	....s FRLEquipTypeDR=ETRowID
	....s FRLStatCatDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",31)
	....s FRLLocDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",28)
	....s FRLBussUserDR=$p($g(^DHCEQChangeAccount(CARowID)),"^",21)
	....s FRLBussDate=$p($g(^DHCEQChangeAccount(CARowID)),"^",22)
	....s FRLPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",2))
	....s FRLAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",2))
	....s FRLChangeDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQChangeAccount(CARowID)),"^",33))
	....s (FRLFundsInfo,FRLOtherInfo,FRLToLoc,FRLToDept,FRLBudgetNo)=""
	....s FRLRemark=$p($g(^DHCEQChangeAccount(CARowID)),"^",8)	
	....s EQRowID=$p($g(^DHCEQChangeAccount(CARowID)),"^",1)
	....s FRLEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)	
	....s FRLUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
	....s FRLOriginDR=$p($g(^DHCEQEquip(EQRowID)),"^",20)
	....s FRLModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	....s FRLVendorDR=$p($g(^DHCEQEquip(EQRowID)),"^",25)
	....s FRLManuFactoryDR=$p($g(^DHCEQEquip(EQRowID)),"^",26)
	....s FRLEquipCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)
	....s FRLBrandDR=$p($g(^DHCEQEquip(EQRowID)),"^",94)
	....s FRLCountryDR=$p($g(^DHCEQEquip(EQRowID)),"^",16)
	....s FRLQuantityNum=1	
	....s valList="^"_FRRowID_"^"_FRLSourceID_"^"_FRLEquipTypeDR_"^"_FRLStatCatDR_"^"_FRLLocDR_"^"_FRLOriginDR_"^"_FRLEquipName_"^"_FRLQuantityNum_"^"_FRLPrice_"^"_FRLAmount_"^"_FRLFundsInfo_"^"_FRLOtherInfo_"^"_FRLRemark_"^"_FRLEquipCatDR_"^"_FRLUnitDR_"^"_FRLVendorDR_"^"_FRLModelDR_"^"_FRLManuFactoryDR_"^"_FRLBrandDR_"^"_FRLCountryDR_"^"_FRLToLoc_"^"_FRLChangeDepreTotal_"^"_FRLToDept_"^0^^^^"_FRLBussUserDR_"^"_FRLBussDate_"^"_FRLBudgetNo
	....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
	....s SQLCODE=+SQLInfo
	....q:SQLCODE'=0
	....s FRLRowID=$p(SQLInfo,"^",2)
	....;保存DHC_EQFinancialReviewEquip表
	....s TLocationDR=$p($g(^DHCEQEquip(EQRowID)),"^",72)
	....s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	....s TPurposeTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",65)
	....s TTransAsSetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	....s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
	....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
	....s SQLCODE=+SQLInfo
	....q:SQLCODE'=0
	....s FRERowID=$p(SQLInfo,"^",2)	
	....;保存DHC_EQFinancialReviewFunds表
	....s FundsRowID=0
	....f  s FundsRowID=$o(^DHCEQFunds(0,"Source",7,CARowID,FundsRowID))  q:(FundsRowID="")||(SQLCODE'=0)  d
	.....s FundsInvalidFlag=$p($g(^DHCEQFunds(FundsRowID)),"^",10)
	.....q:FundsInvalidFlag="Y"
	.....s FundsOperFlag=$p($g(^DHCEQFunds(FundsRowID)),"^",6)
	.....q:FundsOperFlag=2
	.....s FundsTypeDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",18),"")	//变动前原值
	.....s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",19),"")	//变动前累计折旧
	.....s TNetFee=TOriginalFee-TDepreTotalFee																//变动前净值
	.....s TChangeFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",3),"")		//原值变动金额
	.....s TChangeDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsRowID)),"^",13),"")	//累计折旧变动金额
	.....s valList="^"_FRERowID_"^"_FundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotalFee_"^"_TChangeFee_"^"_TChangeDepreTotal
	.....s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
	.....s SQLCODE=+SQLInfo
	
	/**************************************************************************************************/
	//(7)折旧
	i (vBussinessType="ZJ")&&(vMonth'="")
	{
		s MonthStr=$E(vMonth,1,4)_"-"_$E(vMonth,5,6)
		s PreMonthStr=##Class(web.DHCEQReport).GetPreMonth(MonthStr)
		s SnapShotID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr,"Equip")
		s PreShotID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreMonthStr,"Equip")
		i ((SnapShotID'="")&&(PreShotID'=""))
		{
			//获取当前月份快照的所有有效设备清单
			s EQRowID=0
			f  s EQRowID=$o(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID))  q:(EQRowID="")||(SQLCODE'=0)  d
			.s StockStatus=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",60)
			.q:((StockStatus="3")||(StockStatus="0"))			//月末折旧增加此过滤
			.s PreStockStatus=$p($g(^DHCEQSnapShot(PreShotID,"Equip",EQRowID)),"^",60)
			.;q:((PreStockStatus="3")||(PreStockStatus="0"))	//月初折旧增加此过滤
			.s Status=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",38)
			.q:Status="3"		//月末折旧增加此过滤
			.s PreStatus=$p($g(^DHCEQSnapShot(PreShotID,"Equip",EQRowID)),"^",38)
			.;q:PreStatus="3"	//月初折旧增加此过滤
			.s InvalidFlag=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",59)
			.q:InvalidFlag="Y"		//月末折旧增加此过滤
			.s PreInvalidFlag=$p($g(^DHCEQSnapShot(PreShotID,"Equip",EQRowID)),"^",59)
			.;q:PreInvalidFlag="Y"		//月初折旧增加此过滤
			.s TEquipTypeDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",63)
			.q:(","_vEquipTypeIDS_",")'[(","_TEquipTypeDR_",")
			.s TStatCatDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",75)
			.s TStoreLocDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",67)
			.s TOriginDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",20)
			.s TEquipName=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",1)
			.s TEquipCatDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",4)
			.s TModelDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",3)
			.s TVendorDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",25)
			.s TManuFactoryDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",26)
			.s TBrandDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",94)
			.s TCountryDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",16)
			.s TLocationDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",72)
			.s TEQNo=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",71)
			.s TPurposeTypeDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",65)
			.s TTransAsSetDate=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",45)
			.s TUnitDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",5)		//单位
			.s (TFundsInfo,TOtherInfo,TToLoc,TChangeDepreTotal,TToDept,TBudgetNo)=""
			.s TQuantityNum=1
			.s CADCount=0
			.s MDRowID=0
			.f  s MDRowID=$o(^DHCEQMonthDepre(0,"EquipMonth",EQRowID,MonthStr,MDRowID))  q:(MDRowID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQMonthDepre(MDRowID)),"^",39)'=""			;过滤冲负记录
			..s TBussUserDR=$p($g(^DHCEQMonthDepre(MDRowID)),"^",28)
			..s TBussDate=$p($g(^DHCEQMonthDepre(MDRowID)),"^",29)
			..s CADDR=0
			..f  s CADDR=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADDR))  q:(CADDR="")||(SQLCODE'=0)  d
			...s CADCount=CADCount+1
			...s CADFundsTypeDR=$p($g(^DHCEQCostAllotDetail(CADDR)),"^",7)
			...s CADLocDR=$p($g(^DHCEQCostAllotDetail(CADDR)),"^",3)
			...s TDepreFee=+$fn($p($g(^DHCEQCostAllotDetail(CADDR)),"^",5),"",2)
			...s TOriginalFee=+$fn($p($g(^DHCEQCostAllotDetail(CADDR)),"^",6),"",2)
			...s TDepreTotal=+$fn($p($g(^DHCEQCostAllotDetail(CADDR)),"^",8),"",2)
			...i TDepreTotal>TOriginalFee s TDepreTotal=TOriginalFee
			...s TNetFee=TOriginalFee-TDepreTotal
			...s valList="^"_FRRowID_"^"_CADDR_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_CADLocDR_"^"_TOriginDR_"^"_TEquipName_"^"_TQuantityNum_"^"_TDepreFee_"^"_TDepreFee_"^"_TFundsInfo_"^"_TOtherInfo_"^^"_TEquipCatDR_"^"_TUnitDR_"^"_TVendorDR_"^"_TModelDR_"^"_TManuFactoryDR_"^"_TBrandDR_"^"_TCountryDR_"^"_TToLoc_"^"_TChangeDepreTotal_"^"_TToDept_"^0^^^^"_TBussUserDR_"^"_TBussDate_"^"_TBudgetNo_"^0"
			...s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
			...s SQLCODE=+SQLInfo
			...q:SQLCODE'=0
			...s FRLRowID=$p(SQLInfo,"^",2)
			...;保存DHC_EQFinancialReviewEquip表
			...s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
			...s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
			...s SQLCODE=+SQLInfo
			...q:SQLCODE'=0
			...s FRERowID=$p(SQLInfo,"^",2)
			...;保存DHC_EQFinancialReviewFunds表(主设备科室的保存当月折旧,原值,净值,累计折旧;非主设备科室的仅保存当月折旧)
			...i CADLocDR=TStoreLocDR  d
			....s valList="^"_FRERowID_"^"_CADFundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotal_"^"_TDepreFee
			...e  d
			....s valList="^"_FRERowID_"^"_CADFundsTypeDR_"^^^^"_TDepreFee
			...s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
			...s SQLCODE=+SQLInfo
			..q:SQLCODE'=0
			.q:SQLCODE'=0
			.;无折旧保存原值,净值,累计折旧
			.i CADCount=0  d
			..;保存DHC_EQFinancialReviewList表
			..s valList="^"_FRRowID_"^^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TStoreLocDR_"^"_TOriginDR_"^"_TEquipName_"^"_TQuantityNum_"^"_0_"^"_0_"^"_TFundsInfo_"^"_TOtherInfo_"^^"_TEquipCatDR_"^"_TUnitDR_"^"_TVendorDR_"^"_TModelDR_"^"_TManuFactoryDR_"^"_TBrandDR_"^"_TCountryDR_"^"_TToLoc_"^"_TChangeDepreTotal_"^"_TToDept_"^0^^^^^^"_TBudgetNo_"^0"
			..s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
			..s SQLCODE=+SQLInfo
			..q:SQLCODE'=0
			..s FRLRowID=$p(SQLInfo,"^",2)
			..;保存DHC_EQFinancialReviewEquip表
			..s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
			..s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
			..s SQLCODE=+SQLInfo
			..q:SQLCODE'=0
			..s FRERowID=$p(SQLInfo,"^",2)
			..s FSnapID=""
			..f  s FSnapID=$o(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID))  q:FSnapID=""  d
			...q:$p($g(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID)),"^",10)'="N"
			...q:$p($g(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID)),"^",6)=2
			...s TFundsTypeDR=$p($g(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID)),"^",2)
			...s TOriginalFee=+$fn($p($g(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID)),"^",3),"",2)
			...q:TOriginalFee=0
			...s TDepreTotal=+$fn($p($g(^DHCEQSnapShot(SnapShotID,"Funds",EQRowID,FSnapID)),"^",13),"",2)
			...i TDepreTotal>TOriginalFee s TDepreTotal=TOriginalFee		//医大存在累计折旧大于原值数据
			...s TNetFee=TOriginalFee-TDepreTotal
			...i TNetFee<0 s TNetFee=0
			...;保存DHC_EQFinancialReviewFunds表
			...s valList="^"_FRERowID_"^"_TFundsTypeDR_"^"_TOriginalFee_"^"_TNetFee_"^"_TDepreTotal_"^"
			...s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
			...s SQLCODE=+SQLInfo
			
			
			;处理折旧值冲负
			s MDRowID=0
			f  s MDRowID=$o(^DHCEQMonthDepre(0,"Month",MonthStr,MDRowID))  q:(MDRowID="")||(SQLCODE'=0)  d
			.q:$p($g(^DHCEQMonthDepre(MDRowID)),"^",39)=""
			.s EQRowID=$p($g(^DHCEQMonthDepre(MDRowID)),"^",2)
			.s TEquipTypeDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",63)
			.q:(","_vEquipTypeIDS_",")'[(","_TEquipTypeDR_",")
			.s TStatCatDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",75)
			.s TStoreLocDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",67)
			.s TOriginDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",20)
			.s TEquipName=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",1)
			.s TEquipCatDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",4)
			.s TModelDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",3)
			.s TVendorDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",25)
			.s TManuFactoryDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",26)
			.s TBrandDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",94)
			.s TCountryDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",16)
			.s TLocationDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",72)
			.s TEQNo=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",71)
			.s TPurposeTypeDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",65)
			.s TTransAsSetDate=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",45)
			.s TQuantityNum=1
			.s (TFundsInfo,TOtherInfo,TToLoc,TChangeDepreTotal,TToDept,TBudgetNo)=""
			.s TUnitDR=$p($g(^DHCEQSnapShot(SnapShotID,"Equip",EQRowID)),"^",5)		//单位
			.s CADDR=0
			.f  s CADDR=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADDR))  q:(CADDR="")||(SQLCODE'=0)  d
			..s CADFundsTypeDR=$p($g(^DHCEQCostAllotDetail(CADDR)),"^",7)
			..s CADLocDR=$p($g(^DHCEQCostAllotDetail(CADDR)),"^",3)
			..s TDepreFee=+$fn($p($g(^DHCEQCostAllotDetail(CADDR)),"^",5),"",2)
			..s valList="^"_FRRowID_"^"_CADDR_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_CADLocDR_"^"_TOriginDR_"^"_TEquipName_"^"_TQuantityNum_"^"_TDepreFee_"^"_TDepreFee_"^"_TFundsInfo_"^"_TOtherInfo_"^^"_TEquipCatDR_"^"_TUnitDR_"^"_TVendorDR_"^"_TModelDR_"^"_TManuFactoryDR_"^"_TBrandDR_"^"_TCountryDR_"^"_TToLoc_"^"_TChangeDepreTotal_"^"_TToDept_"^0^^^^"_TBussUserDR_"^"_TBussDate_"^"_TBudgetNo_"^2"
			..s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveList(valList)
			..s SQLCODE=+SQLInfo
			..q:SQLCODE'=0
			..s FRLRowID=$p(SQLInfo,"^",2)
			..;保存DHC_EQFinancialReviewEquip表
			..s valList="^"_FRLRowID_"^"_EQRowID_"^"_TLocationDR_"^"_TEQNo_"^"_TPurposeTypeDR_"^"_TTransAsSetDate
			..s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveEquipList(valList)
			..s SQLCODE=+SQLInfo
			..q:SQLCODE'=0
			..s FRERowID=$p(SQLInfo,"^",2)
			..;保存DHC_EQFinancialReviewFunds表(折旧充负记录仅登记净值(增加充负数据),累计折旧(减少充负数据),折旧(充负折旧))
			..s TNetFee=0-TDepreFee
			..s TDepreTotal=TDepreFee
			..s valList="^"_FRERowID_"^"_CADFundsTypeDR_"^^"_TNetFee_"^"_TDepreTotal_"^"_TDepreFee
			..s SQLInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).SaveFundsList(valList)
			..s SQLCODE=+SQLInfo
		}
	}
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q FRRowID
}

/// Add By DJ 2015-10-09
/// 描述:保存明细记录
ClassMethod SaveList(valList)
{
	K FRLPLIST
	s FRLPLIST(2)=$p(valList,"^",2)		//FinancialReviewDR
	s FRLPLIST(3)=$p(valList,"^",3)		//SourceID
	s FRLPLIST(4)=$p(valList,"^",4)		//EquipTypeDR
	s FRLPLIST(5)=$p(valList,"^",5)		//StatCatDR
	s FRLPLIST(6)=$p(valList,"^",6)		//LocDR			//转移业务时为供给部门
	s FRLPLIST(7)=$p(valList,"^",7)		//OriginDR
	s FRLPLIST(8)=$p(valList,"^",8)		//EquipName
	s FRLPLIST(9)=$p(valList,"^",9)		//QuantityNum
	s FRLPLIST(10)=$p(valList,"^",10)	//Price
	s FRLPLIST(11)=$p(valList,"^",11)	//Amount
	//s FRLPLIST(12)=$p(valList,"^",12)	//FundsInfo
	s FRLPLIST(13)=$p(valList,"^",13)	//OtherInfo		//转移或减少业务时记录转移类型或减少类型
	s FRLPLIST(14)=$p(valList,"^",14)	//Remark
	s FRLPLIST(15)=$p(valList,"^",15)	//FRL_EquipCatDR
	s FRLPLIST(16)=$p(valList,"^",16)	//FRL_UnitDR
	s FRLPLIST(17)=$p(valList,"^",17)	//FRL_VendorDR
	s FRLPLIST(18)=$p(valList,"^",18)	//FRL_ModelDR
	s FRLPLIST(19)=$p(valList,"^",19)	//FRL_ManuFactoryDR
	s FRLPLIST(20)=$p(valList,"^",20)	//FRL_BrandDR
	s FRLPLIST(21)=$p(valList,"^",21)	//FRL_CountryDR
	s FRLPLIST(22)=$p(valList,"^",22)	//FRL_ToLoc
	s FRLPLIST(23)=$p(valList,"^",23)	//FRL_ChangeDepreTotal
	s FRLPLIST(24)=$p(valList,"^",24)	//FRL_ToDept
	s FRLPLIST(25)="0"					//FRL_AccountFlag（0:未传输  1:未做帐  2:已做帐）
	s FRLPLIST(26)=$p(valList,"^",26)	//FRL_AccountDate
	s FRLPLIST(27)=$p(valList,"^",27)	//FRL_AccountTime
	s FRLPLIST(28)=$p(valList,"^",28)	//FRL_Voucher
	s FRLPLIST(29)=$p(valList,"^",29)	//FRL_BussUserDR
	s FRLPLIST(30)=$p(valList,"^",30)	//FRL_BussDate
	s FRLPLIST(31)=$p(valList,"^",31)	//FRL_BudgetNo
	s FRLPLIST(32)=$p(valList,"^",32)	//FRL_DepreBussType
	s FRLPLIST(33)=$p(valList,"^",33)	//FRL_BussNo
	s FRLPLIST(34)=$p(valList,"^",34)	//Hold1
	s FRLPLIST(35)=$p(valList,"^",35)	//Hold2
	s FRLPLIST(36)=$p(valList,"^",36)	//Hold3
	s FRLPLIST(37)=$p(valList,"^",37)	//Hold4
	s FRLPLIST(38)=$p(valList,"^",38)	//Hold5
	
	&SQL(insert into sqluser.DHC_EQFinancialReviewList values :FRLPLIST())
	s FRLRowID=$G(%ROWID)
	q SQLCODE_"^"_FRLRowID
}

/// Add By DJ 2019-09-23
/// 描述:保存设备明细
ClassMethod SaveEquipList(valList)
{
	K FREPLIST
	s FREPLIST(2)=$p(valList,"^",2)		//FRE_FinancialReviewListDR
	s FREPLIST(3)=$p(valList,"^",3)		//FRE_EquipDR
	s FREPLIST(4)=$p(valList,"^",4)		//FRE_LocationDR
	s FREPLIST(5)=$p(valList,"^",5)		//FRE_EQNo
	s FREPLIST(6)=$p(valList,"^",6)		//FRE_PurposeType
	s FREPLIST(7)=$p(valList,"^",7)		//FRE_TransAsSetDate
	s FREPLIST(8)=$p(valList,"^",8)		//Hold1
	s FREPLIST(9)=$p(valList,"^",9)		//Hold2
	s FREPLIST(10)=$p(valList,"^",10)	//Hold3
	s FREPLIST(11)=$p(valList,"^",11)	//Hold4
	s FREPLIST(12)=$p(valList,"^",12)	//Hold5	
	&SQL(insert into sqluser.DHC_EQFinancialReviewEquip values :FREPLIST())
	s FRERowID=$G(%ROWID)
	q SQLCODE_"^"_FRERowID
}

/// Add By DJ 2019-09-23
/// 描述:保存资金来源明细
ClassMethod SaveFundsList(valList)
{
	K FRFPLIST
	s FRFPLIST(2)=$p(valList,"^",2)		//FinancialReviewEquipDR
	s FRFPLIST(3)=$p(valList,"^",3)		//FundsTypeDR
	s FRFPLIST(4)=$p(valList,"^",4)		//OriginalFee
	s FRFPLIST(5)=$p(valList,"^",5)		//NetFee
	s FRFPLIST(6)=$p(valList,"^",6)		//DepreTotalFee
	s FRFPLIST(7)=$p(valList,"^",7)		//DepreFee
	s FRFPLIST(8)=$p(valList,"^",8)		//ChangeFee
	s FRFPLIST(9)=$p(valList,"^",9)		//ChangeDepreTotal
	s FRFPLIST(10)=$p(valList,"^",10)	//Hold1
	s FRFPLIST(11)=$p(valList,"^",11)	//Hold2
	s FRFPLIST(12)=$p(valList,"^",12)	//Hold3
	s FRFPLIST(13)=$p(valList,"^",13)	//Hold4
	s FRFPLIST(14)=$p(valList,"^",14)	//Hold5	
	&SQL(insert into sqluser.DHC_EQFinancialReviewFunds values :FRFPLIST())
	s FRFRowID=$G(%ROWID)
	q SQLCODE_"^"_FRFRowID
}

/// Add By DJ 2015-10-09
/// 描述:获取重复生成标志
/// 入参:val判断重复生成条件信息串"^"连接
/// 返回值:空可以重复生成,否则不可生成新单
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).GetReCreateFlag()
ClassMethod GetReCreateFlag(val)
{
	n (val)
	s vBussinessType=$p(val,"^",1)
	i vBussinessType=""		q "-1001^请选择业务类型!"
	s vMonth=$p(val,"^",2)
	i ((vBussinessType="ZJ")&&(vMonth=""))	q "-1002^折旧业务请输入月份!"
	s vEquipTypeIDS=$p(val,"^",3)
	i vEquipTypeIDS=""	q "-1003^请选择类组!"
	s SDate=+##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")
	s EDate=+##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")
	i ((SDate=0)&&(EDate=0))	q "-1004^请输入业务开始日期和结束日期!"
	i EDate<SDate	q "-1005^业务开始日期大于结束日期!"
	;s User=$p(val,"^",6)
	s vFRRowID=$p(val,"^",7)
	
	//检测是否已经存在此条件单据,是则不能生成新单,否则可以
	s FindID=""
	s FRStatus=""
	f  s FRStatus=$o(^DHCEQFinancialReview(0,"Status",FRStatus))  q:(FRStatus="")||(FindID'="")  d
	.q:FRStatus>2
	.s FRRowID=0
	.f FRRowID=$o(^DHCEQFinancialReview(0,"Status",FRStatus,vBussinessType,FRRowID))  q:(FRRowID="")||(FindID'="")  d
	..s FRInvalidFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",22)
	..q:FRInvalidFlag="Y"
	..s FRMonth=$p($g(^DHCEQFinancialReview(FRRowID)),"^",28)
	..q:(vMonth'="")&&(FRMonth'=vMonth)
	..s FREquipTypeIDS=$p($g(^DHCEQFinancialReview(FRRowID)),"^",3)
	..s Flag=0
	..f i=1:1:$L(vEquipTypeIDS,",")  d
	...s CurEquipTypeDR=$p(vEquipTypeIDS,",",i)
	...i (","_FREquipTypeIDS_",")[(","_CurEquipTypeDR_",")	s Flag=1
	..q:Flag=0
	..s FRSDate=+$p($g(^DHCEQFinancialReview(FRRowID)),"^",5)
	..s FREDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",6)
	..i (SDate>=FRSDate)&&(SDate<=FREDate)	s Flag=1
	..i (EDate>=FRSDate)&&(EDate<=FREDate)	s Flag=1
	..q:Flag=0
	..s FindID=FRRowID
	
	i FindID'=""
	{
		s FRBussinessNo=$p($g(^DHCEQFinancialReview(FindID)),"^",2)
		i vFRRowID'=FindID	q "-1006^已存在满足条件单据:["_FRBussinessNo_"]!请检查!^"_FindID	
	}
	
	q ""
}

ClassMethod UpdateData(val, isDel)
{
	n (val,isDel)
	s FRRowID=$p(val,"^",1)
	s User=$p(val,"^",2)
	s CancelReason=$p(val,"^",3)
	s Date=+$H
	s Time=$P($H,",",2)
	s FRStatus=$p($g(^DHCEQFinancialReview(FRRowID)),"^",21)
	s FRAccountFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",24)
	K PLIST
	i +isDel=1		//作废或删除单据
	{
		i ((FRStatus'=0)&&(FRStatus'=2))	q "-1001"		//非新增或审核单据不能作废或删除
		i FRAccountFlag>=1	q "-1002"		//0表示未传输, 1表示已传输未做账 2表示已做账(财务已做帐单据不能作废或删除)
		s PLIST(18)=User
		s PLIST(19)=Date
		s PLIST(20)=Time
		s PLIST(21)=CancelReason
		s PLIST(22)="3"
		s PLIST(23)="Y"
	}
	i +isDel=2		//提交
	{
		i FRStatus'=0	q "-1003"		//非新增单据不能提交
		s PLIST(12)=User
		s PLIST(13)=Date
		s PLIST(14)=Time
		s PLIST(22)="1"
	}
	i +isDel=3		//审核
	{
		i FRStatus'=1	q "-1004"		//非提交单据不能审核
		s PLIST(15)=User
		s PLIST(16)=Date
		s PLIST(17)=Time
		s PLIST(22)="2"
		//s JCRowID=##class(web.DHCENS.BLL.CostAcc.AssetDep).getinfo(FRRowID)
		//i +JCRowID q +JCRowID
	}
	i +isDel=4		//取消提交
	{
		i FRStatus'=1	q "-1005"		//非提交单据不能取消
		s PLIST(12)=""
		s PLIST(13)=""
		s PLIST(14)=""
		s PLIST(22)="0"
	}
	&SQL(Update SQLUSER.DHC_EQFinancialReview values :PLIST() where FR_RowID=:FRRowID)
	i SQLCODE q SQLCODE
	q FRRowID
}

/*
///Modify DJ 2019-10-09
///旧版财务监审使用,新版已不再使用
ClassMethod GetFundsInfo(vSourceType, vSourceID)
{
	n (vSourceType,vSourceID)
	s FundsInfo=""
	s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",vSourceType,vSourceID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsTypeDR=$p(^DHCEQFunds(FundsID),"^",2)
	.i FundsTypeDR="" s FundsTypeDR=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s DepreTotalFundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",13)	//DJ0135
	.i FundsInfo'="" s FundsInfo=FundsInfo_"@"
	.s FundsInfo=FundsInfo_FundsTypeDR_"=0="_FundsFee_"="_DepreTotalFundsFee
	
	q FundsInfo
}
*/

/************************************************************************************************/
Query FinancialReview(BussinessNo As %String = "", BussinessTypeDR As %String = "", EquipTypeIDs As %String = "", vFRRowID As %String = "", vRQFlag As %String = "", Month As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TBussinessType:%String,TBussinessNo:%String,TEquipTypes:%String,TPDFName:%String,TBussinessSDate:%String,TBussinessEDate:%String,TAutoCreateFlag:%String,TStatus:%String,TRemark:%String,TAccountFlag:%String,TAccountDate:%String,TAccountTime:%String,TMonth:%String,TBussinessTypeDR:%String,TEquipTypeIDs:%String,THospital:%String") [ SqlProc ]
{
}

ClassMethod FinancialReviewExecute(ByRef qHandle As %Binary, BussinessNo As %String = "", BussinessTypeDR As %String = "", EquipTypeIDs As %String = "", vFRRowID As %String = "", vRQFlag As %String = "", Month As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i ((vRQFlag="1")&&(vFRRowID="")) q $$$OK
	
	s FRRowID=""
	f  s FRRowID=$o(^DHCEQFinancialReview(FRRowID),-1) q:(FRRowID=0)||(FRRowID="")  d
	.d ResetVariablesGetFinancialReview
	.q:((vFRRowID'="")&&(FRRowID'=vFRRowID))
	.s TRow=index
	.s TRowID=FRRowID
	.s TBussinessTypeDR=$p($g(^DHCEQFinancialReview(FRRowID)),"^",1)
	.q:((BussinessTypeDR'="")&&(TBussinessTypeDR'=BussinessTypeDR))
	.s TBussinessType=$CASE(TBussinessTypeDR,"RK":"入库","ZY":"转移","TH":"退货","JS":"减少","BF":"报废","TZ":"台帐","ZJ":"折旧","CA":"调账","":"")
	.s TBussinessNo=$p($g(^DHCEQFinancialReview(FRRowID)),"^",2)
	.q:((BussinessNo'="")&&(TBussinessNo'=BussinessNo))
	.s TMonth=$p($g(^DHCEQFinancialReview(FRRowID)),"^",28)
	.q:((Month'="")&&(TMonth'=Month))
	.s TEquipTypeIDs=$p($g(^DHCEQFinancialReview(FRRowID)),"^",3)
	.s ETCount=$L(TEquipTypeIDs,",")
	.s Find=0
	.f i=1:1:ETCount  d
	..s EquipTypeDR=$p(TEquipTypeIDs,",",i)
	..i ((","_EquipTypeIDs_",")[(","_EquipTypeDR_","))	s Find=1
	..i EquipTypeDR'="" s TEquipTypes=TEquipTypes_"("_i_")"_$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.q:((EquipTypeIDs'="")&&(Find=0))
	.s TStatus=$p($g(^DHCEQFinancialReview(FRRowID)),"^",21)
	.s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废","":"")
	.s TPDFName=$p($g(^DHCEQFinancialReview(FRRowID)),"^",4)
	.s TBussinessSDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",5)
	.i TBussinessSDate'="" s TBussinessSDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessSDate,"date")
	.s TBussinessEDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",6)
	.i TBussinessEDate'="" s TBussinessEDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessEDate,"date")
	.s TAutoCreateFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",7)
	.s TAutoCreateFlag=$CASE(TAutoCreateFlag,"1":"自动任务","2":"接口调用","3":"手动生成","":"")
	.s TRemark=$p($g(^DHCEQFinancialReview(FRRowID)),"^",23)
	.;s TAccountFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",24)
	.;s TAccountFlag=$CASE(TAccountFlag,"0":"未做账","1":"已做账","":"")
	.;s TAccountDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",25)
	.;i TAccountDate'="" s TAccountDate=##Class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.;s TAccountTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",26)
	.;i TAccountTime'="" s TAccountTime=##Class(web.DHCEQCommon).TransValueToPage(TAccountTime,"time")
	.s THospital=$p($g(^DHCEQFinancialReview(FRRowID)),"^",29)
	.i THospital'="" s THospital=$p($g(^CT("HOSP",THospital)),"^",2)
	.d OutputRowGetFinancialReview
	
	Quit $$$OK
OutputRowGetFinancialReview
	s Data=$lb(TRow,TRowID,TBussinessType,TBussinessNo,TEquipTypes,TPDFName,TBussinessSDate,TBussinessEDate,TAutoCreateFlag,TStatus,TRemark,TAccountFlag,TAccountDate,TAccountTime,TMonth,TBussinessTypeDR,TEquipTypeIDs,THospital)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFinancialReview
	s (TRowID,TBussinessType,TBussinessNo,TEquipTypes,TPDFName,TBussinessSDate,TBussinessEDate,TAutoCreateFlag,TStatus,TRemark,TAccountFlag,TAccountDate,TAccountTime,TMonth,TBussinessTypeDR,TEquipTypeIDs,THospital)=""
	quit
}

ClassMethod FinancialReviewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinancialReviewExecute ]
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

ClassMethod FinancialReviewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinancialReviewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/************************************************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Inner.DHCEQFinancialReview","FinancialReviewList","1")
Query FinancialReviewList(vFRRowID As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", vFundsTypeDR As %String = "", vUseLocDR As %String = "", vListOrEquip As %String = "") As %Query(ROWSPEC = "FRLTRowID:%String, FRLTSourceID:%String, FRLTEquipTypeDR:%String, FRLTStatCatDR:%String, FRLTLocDR:%String, FRLTOriginDR:%String, FRLTEquipName:%String, FRLTQuantityNum:%String, FRLTPrice:%String, FRLTAmount:%String, FRLTFundsInfo:%String, FRLTOtherInfo:%String, FRLTRemark:%String, FRLTEquipCatDR:%String, FRLTUnitDR:%String, FRLTVendorDR:%String, FRLTModelDR:%String, FRLTManuFactoryDR:%String, FRLTBrandDR:%String, FRLTCountryDR:%String, FRLTToLocDR:%String, FRLTChangeDepreTotal:%String, FRLTToDeptDR:%String, FRLTAccountFlag:%String, FRLTAccountDate:%String, FRLTAccountTime:%String, FRLTVoucher:%String, FRLTBussUserDR:%String, FRLTBussDate:%String, FRLTBudgetNo:%String, FRLTDepreBussType:%String, FRLTHold1:%String, FRLTHold2:%String, FRLTHold3:%String, FRLTHold4:%String, FRLTHold5:%String, FRFTFundsTypeDR:%String, FRFTOrigianlFee:%String, FRFTNetFee:%String, FRFTDepreTotalFee:%String, FRFTDepreFee:%String, FRFTChangeFee:%String, FRFTChangeDepreTotal:%String, FRETEquipDR:%String, FRETLocationDR:%String, FRETEQNo:%String, FRETPurposeTypeDR:%String, FRETTransAsSetDate:%String, FRETHold1:%String, FRETHold2:%String, FRETHold3:%String, FRETHold4:%String, FRETHold5:%String, FRFTHold1:%String, FRFTHold2:%String, FRFTHold3:%String, FRFTHold4:%String, FRFTHold5:%String, FRLTEquipType:%String, FRLTStatCat:%String, FRLTLoc:%String, FRLTOrigin:%String, FRLTEquipCat:%String, FRLTUnit:%String, FRLTVendor:%String, FRLTModel:%String, FRLTManuFactory:%String, FRLTBrand:%String, FRLTCountry:%String, FRLTToLoc:%String, FRLTToDept:%String, FRLTBussUser:%String, FRFTFundsType:%String, FRETLocation:%String, FRETPurposeType:%String, FRLTBussNo:%String, FRTRQGroup:%String") [ SqlProc ]
{
}

ClassMethod FinancialReviewListExecute(ByRef qHandle As %Binary, vFRRowID As %String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", vFundsTypeDR As %String = "", vUseLocDR As %String = "", vListOrEquip As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i vListOrEquip="" s vListOrEquip="L"
 	i vFRRowID=""	QUIT $$$OK
 	
	s index=1
	s FRLRowID=0
	f  s FRLRowID=$o(^DHCEQFinancialReviewList(0,"FinancialReview",vFRRowID,FRLRowID)) q:FRLRowID=""  d
	.d ResetVariableList
	.s FRBussTypeDR=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",1)
	.s FRLTRowID=FRLRowID
	.s FRLTSourceID=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",2)
	.s FRTRQGroup=FRLTSourceID
	.i (FRBussTypeDR="BF")&&(vListOrEquip="L")  d
	..s FRTRQGroup=$p(FRLTSourceID,"||",1,2)
	.s FRLTEquipTypeDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",3)
	.s FRLTStatCatDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",4)
	.s FRLTLocDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",5)
	.s FRLTOriginDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",6)
	.s FRLTEquipName=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",7)
	.s FRLTQuantityNum=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",8)
	.s FRLTPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",9))
	.s FRLTAmount=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",10))
	.s FRLTFundsInfo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",11)
	.s FRLTOtherInfo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",12)
	.s FRLTRemark=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",13)
	.s FRLTEquipCatDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",14)
	.s FRLTUnitDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",15)
	.s FRLTVendorDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",16)
	.s FRLTModelDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",17)
	.s FRLTManuFactoryDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",18)
	.s FRLTBrandDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",19)
	.s FRLTCountryDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",20)
	.i FRBussTypeDR="ZY"  d
	..s FRLTToLocDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",21)
	..s FRLTToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FRLTToLocDR)
	.i FRBussTypeDR="CA" s FRLTChangeDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",22))
	.i (FRBussTypeDR="TH")||(FRBussTypeDR="JS")  d
	..s FRLTToDeptDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",23)
	..s FRLTToDept=##Class(web.DHCEQCommon).GetTrakNameByID("todept",FRLTToDeptDR)
	.s FRLTAccountFlag=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",24)
	.s FRLTAccountFlag=$CASE(FRLTAccountFlag,"0":"未传输","1":"未做账","2":"已做账","":"")
	.s FRLTAccountDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",25),"date")
	.s FRLTAccountTime=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",26),"time")
	.s FRLTVoucher=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",27)
	.s FRLTBussUserDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",28)
	.s FRLTBussDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",29),"date")
	.s FRLTBudgetNo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",30)
	.i FRBussTypeDR="ZJ"  d
	..s FRLTDepreBussType=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",31)
	..s FRLTDepreBussType=$CASE(FRLTDepreBussType,"0":"正常折旧","1":"退货回冲","2":"处置回冲","":"")
	.s FRLTBussNo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",32)
	.i FRLTBussNo="" s FRLTBussNo="---"
	.s FRLTHold1=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",33)
	.s FRLTHold2=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",34)
	.s FRLTHold3=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",35)
	.s FRLTHold4=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",36)
	.s FRLTHold5=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",37)
	.s FRLTEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",FRLTEquipTypeDR)
	.s FRLTStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",FRLTStatCatDR)
	.s FRLTLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FRLTLocDR)
	.s FRLTOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",FRLTOriginDR)
	.s FRLTEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",FRLTEquipCatDR)
	.s FRLTUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",FRLTUnitDR)
	.s FRLTVendor=##Class(web.DHCEQCommon).GetTrakNameByID("prov",FRLTVendorDR)
	.s FRLTModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",FRLTModelDR)
	.s FRLTManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",FRLTManuFactoryDR)
	.s FRLTBrand=##Class(web.DHCEQCommon).GetTrakNameByID("brand",FRLTBrandDR)
	.s FRLTCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",FRLTCountryDR)
	.s FRLTBussUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",FRLTBussUserDR)
	.i ((vListOrEquip="L")&&((FRBussTypeDR="RK")||(FRBussTypeDR="ZY")||(FRBussTypeDR="TH")||(FRBussTypeDR="JS")))  d		//明细记录
	..s BussFundsID=$Case(FRBussTypeDR,"RK":"3","ZY":"4","TH":"5","JS":"5")
	..s FundsID=0
	..f  s FundsID=$o(^DHCEQFunds("0","Source",BussFundsID,FRLTSourceID,FundsID))  q:FundsID=""  d
	...s FRFTFundsTypeDR=$p($g(^DHCEQFunds(FundsID)),"^",2)
	...s FRFTFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",FRFTFundsTypeDR)
	...s FRFTOrigianlFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",3))
	...s FRFTDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FundsID)),"^",13))
	...s FRFTNetFee=FRFTOrigianlFee-FRFTDepreTotalFee
	...d OutputRowGetFinancialReviewList
	.e  d	//单台设备
	..s FRERowID=0
	..f  s FRERowID=$o(^DHCEQFinancialReviewEquip(0,"FinancialReviewList",FRLRowID,FRERowID))  q:FRERowID=""  d
	...s FRETEquipDR=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",2)
	...i FRBussTypeDR="ZJ" s FRTRQGroup=FRETEquipDR
	...s FRETLocationDR=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",3)
	...s FRETLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location",FRETLocationDR)
	...s FRETEQNo=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",4)
	...s FRETPurposeTypeDR=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",5)
	...s FRETPurposeType=##Class(web.DHCEQCommon).GetTrakNameByID("purposetype",FRETPurposeTypeDR)
	...s FRETTransAsSetDate=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",6)
	...s FRETTransAsSetDate=##Class(web.DHCEQCommon).TransValueToPage(FRETTransAsSetDate,"date")
	...s FRETHold1=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",7)
	...s FRETHold2=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",8)
	...s FRETHold3=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",9)
	...s FRETHold4=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",10)
	...s FRETHold5=$p($g(^DHCEQFinancialReviewEquip(FRERowID)),"^",11)
	...s FRFRowID=0
	...f  s FRFRowID=$o(^DHCEQFinancialReviewFunds(0,"FinancialReviewEquip",FRERowID,FRFRowID))  q:FRFRowID=""  d
	....s FRFTFundsTypeDR=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",2)
	....s FRFTFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",FRFTFundsTypeDR)
	....s FRFTOrigianlFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",3))
	....s FRFTNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",4))
	....s FRFTDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",5))
	....s FRFTDepreFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",6))
	....s FRFTChangeFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",7))
	....s FRFTChangeDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",8))
	....s FRFTHold1=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",9)
	....s FRFTHold2=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",10)
	....s FRFTHold3=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",11)
	....s FRFTHold4=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",12)
	....s FRFTHold5=$p($g(^DHCEQFinancialReviewFunds(FRFRowID)),"^",13)
	....d OutputRowGetFinancialReviewList
	
	Quit $$$OK
OutputRowGetFinancialReviewList
	s Data=$lb(FRLTRowID,FRLTSourceID,FRLTEquipTypeDR,FRLTStatCatDR,FRLTLocDR,FRLTOriginDR,FRLTEquipName,FRLTQuantityNum,FRLTPrice,FRLTAmount,FRLTFundsInfo,FRLTOtherInfo,FRLTRemark,FRLTEquipCatDR,FRLTUnitDR,FRLTVendorDR,FRLTModelDR,FRLTManuFactoryDR,FRLTBrandDR,FRLTCountryDR,FRLTToLocDR,FRLTChangeDepreTotal,FRLTToDeptDR,FRLTAccountFlag,FRLTAccountDate,FRLTAccountTime,FRLTVoucher,FRLTBussUserDR,FRLTBussDate,FRLTBudgetNo,FRLTDepreBussType,FRLTHold1,FRLTHold2,FRLTHold3,FRLTHold4,FRLTHold5,FRFTFundsTypeDR,FRFTOrigianlFee,FRFTNetFee,FRFTDepreTotalFee,FRFTDepreFee,FRFTChangeFee,FRFTChangeDepreTotal,FRETEquipDR,FRETLocationDR,FRETEQNo,FRETPurposeTypeDR,FRETTransAsSetDate,FRETHold1,FRETHold2,FRETHold3,FRETHold4,FRETHold5,FRFTHold1,FRFTHold2,FRFTHold3,FRFTHold4,FRFTHold5,FRLTEquipType,FRLTStatCat,FRLTLoc,FRLTOrigin,FRLTEquipCat,FRLTUnit,FRLTVendor,FRLTModel,FRLTManuFactory,FRLTBrand,FRLTCountry,FRLTToLoc,FRLTToDept,FRLTBussUser,FRFTFundsType,FRETLocation,FRETPurposeType,FRLTBussNo,FRTRQGroup)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariableList
	s (FRLTRowID,FRLTSourceID,FRLTEquipTypeDR,FRLTStatCatDR,FRLTLocDR,FRLTOriginDR,FRLTEquipName,FRLTQuantityNum,FRLTPrice,FRLTAmount,FRLTFundsInfo,FRLTOtherInfo,FRLTRemark,FRLTEquipCatDR,FRLTUnitDR,FRLTVendorDR,FRLTModelDR,FRLTManuFactoryDR,FRLTBrandDR,FRLTCountryDR,FRLTToLocDR,FRLTChangeDepreTotal,FRLTToDeptDR,FRLTAccountFlag,FRLTAccountDate,FRLTAccountTime,FRLTVoucher,FRLTBussUserDR,FRLTBussDate,FRLTBudgetNo,FRLTDepreBussType,FRLTHold1,FRLTHold2,FRLTHold3,FRLTHold4,FRLTHold5,FRFTFundsTypeDR,FRFTOrigianlFee,FRFTNetFee,FRFTDepreTotalFee,FRFTDepreFee,FRFTChangeFee,FRFTChangeDepreTotal,FRETEquipDR,FRETLocationDR,FRETEQNo,FRETPurposeTypeDR,FRETTransAsSetDate,FRETHold1,FRETHold2,FRETHold3,FRETHold4,FRETHold5,FRFTHold1,FRFTHold2,FRFTHold3,FRFTHold4,FRFTHold5,FRLTEquipType,FRLTStatCat,FRLTLoc,FRLTOrigin,FRLTEquipCat,FRLTUnit,FRLTVendor,FRLTModel,FRLTManuFactory,FRLTBrand,FRLTCountry,FRLTToLoc,FRLTToDept,FRLTBussUser,FRFTFundsType,FRETLocation,FRETPurposeType,FRLTBussNo,FRTRQGroup)=""
	quit
}

ClassMethod FinancialReviewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinancialReviewListExecute ]
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

ClassMethod FinancialReviewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinancialReviewListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/************************************************************************************************/
ClassMethod GetOneFinancialReview(vRowID As %String = "")
{
	new result
	
	i vRowID="" q ""
	s result= ^DHCEQFinancialReview(vRowID)
	i $p(result,"^",5)'="" s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
	i $p(result,"^",6)'="" s $p(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")
	i $p(result,"^",7)'="" s $p(result,"^",7)=$CASE($p(result,"^",7),"1":"自动任务","2":"接口调用","3":"手动生成","":"")
	i $p(result,"^",25)'="" s $p(result,"^",25)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"date")
	s result=vRowID_"^"_result
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/************************************************************************************************/
/// Add By DJ 2015-10-08
/// 描述:财务监审回写财务做帐标识及凭证号
/// 入参:vBussinessNo单号,vAccountFlag做帐标志（0:未传输  1:未做帐  2:已做帐）,vVoucher凭证号
/// 返回值:-1001表示入参为空   -1002表示操作单据不存在   0表示成功
ClassMethod UpdateAccountInfo(vBussinessNo, vAccountFlag, vVoucher, vListRowID As %String = "")
{
	n FRRowID,FRDate,FRTime
	i ((vBussinessNo="")||(vAccountFlag=""))	q "-1001"
	i '$D(^DHCEQFinancialReview(0,"BussinessNo",vBussinessNo))	q "-1002"
	s FRRowID=$o(^DHCEQFinancialReview(0,"BussinessNo",vBussinessNo,0))
	s FRDate=+$H
	s FRTime=$p($H,",",2)
	i vListRowID=""  d
	.&SQL(Update SQLUSER.DHC_EQFinancialReview set FR_AccountFlag=:vAccountFlag,FR_AccountDate=:FRDate,FR_AccountTime=:FRTime,FR_Voucher=:vVoucher Where FR_RowID=:FRRowID)
	e  d
	.&SQL(Update SQLUSER.DHC_EQFinancialReviewList set FRL_AccountFlag=:vAccountFlag,FRL_AccountDate=:FRDate,FRL_AccountTime=:FRTime,FRL_Voucher=:vVoucher Where FRL_RowID=:vListRowID)
	q SQLCODE
}

/*************************************************************************************************/

/*
///以下所有内容为中国医大个性开发。其他项目使用需测试后使用
ClassMethod CreatePrintInfo(vFRRowID)
{
	k ^DHCEQTemp("DHCEQFinancialReview",$J)
	s BussinessType=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",1)	
	s ListCount=0
	s FRLRowID=0
	f  s FRLRowID=$o(^DHCEQFinancialReviewList(0,"FinancialReview",vFRRowID,FRLRowID)) q:FRLRowID=""  d
	.s TRowID=FRLRowID
	.s TSourceID=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",2)
	.s TEquipTypeDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",3)
	.s TStatCatDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",4)
	.s TLocDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",5)
	.s TOriginDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",6)
	.s TEquipName=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",7)
	.s TQuantityNum=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",8)
	.s TPrice=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",9)
	.s TAmount=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",10)
	.s TOtherInfo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",12)
	.s TRemark=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",13)
	.s THold1=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",14)
	.s THold2=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",15)
	.s THold3=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",16)
	.s THold4=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",17)
	.s THold5=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",18)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)	
	.s TFundsInfo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",11)
	.i BussinessType="ZJ"  d
	..i '$D(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR))  d
	...s ListCount=ListCount+1
	...s ^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR)=TEquipName_"^"_TQuantityNum_"^"_TPrice_"^"_TAmount_"^"_TRemark_"^"_TEquipType_"^"_TStatCat_"^"_TLoc_"^"_TOrigin_"^"_TFundsInfo
	..e  d
	...s $p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",3)=$p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",3)+TPrice
	...s $p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",4)=$p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",4)+TAmount
	...s $p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",10)=$p(^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TOtherInfo,TLocDR),"^",10)_"@"_TFundsInfo
	.e  d
	..s ListCount=ListCount+1
	..s ^DHCEQTemp("DHCEQFinancialReview",$J,vFRRowID,TSourceID)=TEquipName_"^"_TQuantityNum_"^"_TPrice_"^"_TAmount_"^"_TRemark_"^"_TEquipType_"^"_TStatCat_"^"_TLoc_"^"_TOrigin_"^"_TFundsInfo
	.s FCount=$L(TFundsInfo,"@")
	.f i=1:1:FCount  d
	..s CurFundsInfo=$p(TFundsInfo,"@",i)
	..s TFundsTypeDR=$p(CurFundsInfo,"=",1)
	..s ^DHCEQTemp("DHCEQFinancialReview",$J,"FundsTypeDR",vFRRowID,TFundsTypeDR)=""
	
	s FTStr=""
	s FTRowID=0
	f  s FTRowID=$o(^DHCEQTemp("DHCEQFinancialReview",$J,"FundsTypeDR",vFRRowID,FTRowID))  q:FTRowID=""  d
	.s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
	.s FTStr=FTStr_FTRowID_"="_TFundsType_"@"
	s TBussinessType=$CASE(BussinessType,"RK":"入库","ZY":"转移","TH":"退货","JS":"减少","BF":"报废","TZ":"台帐","ZJ":"折旧","CA":"调账","":"")
	s TBussinessNo=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",2)
	s TEquipTypeIDs=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",3)
	s TEquipTypes=""
	s ETCount=$L(TEquipTypeIDs,",")
	f i=1:1:ETCount  d
	.s EquipTypeDR=$p(TEquipTypeIDs,",",i)
	.i EquipTypeDR'="" s TEquipTypes=TEquipTypes_"("_i_")"_$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	s TPDFName=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",4)
	s TBussinessSDate=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",5)
	i TBussinessSDate'="" s TBussinessSDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessSDate,"date")
	s TBussinessEDate=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",6)
	i TBussinessEDate'="" s TBussinessEDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessEDate,"date")
	s TRemark=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",23)
	s TMonth=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",28)
	q ListCount_"^"_$J_"^"_FTStr_"^"_TBussinessType_"^"_TBussinessNo_"^"_TEquipTypes_"^"_TPDFName_"^"_TBussinessSDate_"^"_TBussinessEDate_"^"_TRemark_"^"_TMonth
}

ClassMethod GetPrintList(vJob, vFRRowID, vSourceID, vLocDR)
{
	s ReturnStr=""
	s NextSourceID=""
	s NextLocDR=""
	s BussinessType=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",1)	
	i BussinessType="ZJ"  d
	.i vSourceID=0  d
	..s NextSourceID=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,0))
	..i NextSourceID'="" s NextLocDR=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID,0))
	.e  d
	..s NextSourceID=vSourceID
	..s NextLocDR=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID,vLocDR))
	..i NextLocDR=""  d
	...s NextSourceID=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID))
	...i NextSourceID'="" s NextLocDR=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID,0))
	.i NextLocDR'="" s ReturnStr=$g(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID,NextLocDR))
	e  d
	.s NextSourceID=$o(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,vSourceID))
	.i NextSourceID'="" s ReturnStr=$g(^DHCEQTemp("DHCEQFinancialReview",vJob,vFRRowID,NextSourceID))
	
	i ReturnStr=""  k ^DHCEQTemp("DHCEQFinancialReview",vJob)
	s ReturnStr=##class(web.DHCEQCommon).Replace(ReturnStr,$C(13,10)," ")
	s ReturnStr=##class(web.DHCEQCommon).Replace(ReturnStr,$C(9)," ")
	q NextSourceID_"^"_NextLocDR_"^"_ReturnStr
}

ClassMethod GetFTPPathS(vValue As %String = "") As %String
{
	i vValue="" q ""
	s vFRRowID=$p(vValue,"^",1)
	s vName=$p(vValue,"^",2)
	s vFundsType=$P(vValue,"^",3)
	i vFRRowID="" q ""
	s PDFName=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",4)
	i vFundsType=""	q "/"_PDFName
	q "/"_$E(PDFName,1,$L(PDFName)-4)_"_"_vFundsType_".pdf"
}

/// 折旧汇总输出
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).GetSumInfo(1)
ClassMethod GetSumInfo(vFRRowID As %String = "", vFundsType As %String = "")
{
	k ^DHCEQTemp("DHCEQFinancialReviewSum",$J)
	k ^DHCEQTemp("DHCEQFRSumPrint",$J)
	s FRLRowID=0
	f  s FRLRowID=$o(^DHCEQFinancialReviewList(0,"FinancialReview",vFRRowID,FRLRowID)) q:FRLRowID=""  d
	.s TRowID=FRLRowID
	.s TEquipTypeDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",3)
	.s TStatCatDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",4)
	.s TLocDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",5)
	.s TOriginDR=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",6)
	.s TAmount=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",10)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)	
	.s TFundsInfo=$p($g(^DHCEQFinancialReviewList(FRLRowID)),"^",11)
	.s FundsCount=$L(TFundsInfo,"@")
	.f i=1:1:FundsCount  d
	..s CurInfo=$p(TFundsInfo,"@",1)
	..s TFundsTypeDR=$p(CurInfo,"=",1)
	..q:(vFundsType'="")&&(TFundsTypeDR'=vFundsType)
	..s TDepreFee=$P(CurInfo,"=",2)
	..s TOriginalFee=$P(CurInfo,"=",3)
	..s TTotalDepre=$P(CurInfo,"=",4)
	..s ^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"1")=TOriginalFee+$g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"1"))
	..s ^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"2")=TDepreFee+$g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"2"))
	..s ^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"3")=TTotalDepre+$g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,TLocDR,TEquipTypeDR,TStatCatDR,TFundsTypeDR,"3"))
	
	s ListCount=1
	s (SumOriginalFee,SumDepre,SumTotalDepre,SumNetFee)=0
	s LocDR=0
	f  s LocDR=$o(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR))  q:LocDR=""  d
	.s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	.s EquipTypeDR=0
	.f  s EquipTypeDR=$o(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	..s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	..s StatCatDR=0
	..f  s StatCatDR=$o(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR,StatCatDR))  q:StatCatDR=""  d
	...s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	...s FundsTypeDR=0
	...f  s FundsTypeDR=$o(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR,StatCatDR,FundsTypeDR))  q:FundsTypeDR=""  d
	....s ListCount=ListCount+1
	....s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundsTypeDR)),"^",2)
	....s OriginalFee=$fn($g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR,StatCatDR,FundsTypeDR,"1")),"",2)
	....s DepreFee=$fn($g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR,StatCatDR,FundsTypeDR,"2")),"",2)
	....s TotalDepre=$fn($g(^DHCEQTemp("DHCEQFinancialReviewSum",$J,LocDR,EquipTypeDR,StatCatDR,FundsTypeDR,"3")),"",2)
	....s NetFee=$fn(OriginalFee-TotalDepre,"",2)
	....s SumOriginalFee=$fn(SumOriginalFee+OriginalFee,"",2)
	....s SumDepre=$fn(SumDepre+DepreFee,"",2)
	....s SumTotalDepre=$fn(SumTotalDepre+TotalDepre,"",2)
	....s SumNetFee=$fn(SumNetFee+NetFee,"",2)
	....s ^DHCEQTemp("DHCEQFRSumPrint",$J,ListCount)=TLoc_"^"_TEquipType_"^"_TStatCat_"^"_TFundsType_"^"_OriginalFee_"^"_DepreFee_"^"_TotalDepre_"^"_NetFee
	
	s ^DHCEQTemp("DHCEQFRSumPrint",$J,1)="合计:^^^^"_SumOriginalFee_"^"_SumDepre_"^"_SumTotalDepre_"^"_SumNetFee
	
	k ^DHCEQTemp("DHCEQFinancialReviewSum",$J)
	//总单信息
	s TBussinessNo=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",2)
	s TEquipTypeIDs=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",3)
	s TEquipTypes=""
	s ETCount=$L(TEquipTypeIDs,",")
	f i=1:1:ETCount  d
	.s EquipTypeDR=$p(TEquipTypeIDs,",",i)
	.i EquipTypeDR'="" s TEquipTypes=TEquipTypes_"("_i_")"_$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	s TPDFName=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",4)
	i vFundsType="" s TPDFName=$E(TPDFName,1,$L(TPDFName)-4)_"_"_vFundsType_".pdf"
	s TBussinessSDate=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",5)
	i TBussinessSDate'="" s TBussinessSDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessSDate,"date")
	s TBussinessEDate=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",6)
	i TBussinessEDate'="" s TBussinessEDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessEDate,"date")
	s TMonth=$p($g(^DHCEQFinancialReview(vFRRowID)),"^",28)
	
	q ListCount_"^"_$J_"^"_TBussinessNo_"^"_$E(TMonth,1,4)_"-"_$E(TMonth,5,6)_"^"_TEquipTypes_"^"_TBussinessSDate_"^"_TBussinessEDate
}

ClassMethod GetSumListInfo(vJob As %String = "", vNum As %String = "")
{
	q $g(^DHCEQTemp("DHCEQFRSumPrint",vJob,vNum))
}

ClassMethod CheckPDFFile(vFRRowID As %String = "", vFundsTypeDR As %String = "")
{
	q $g(^DHCEQFinancialReview("PDFFile",vFRRowID,+vFundsTypeDR))
}

ClassMethod SetPDFRecord(vFRRowID As %String = "", vFundsTypeDR As %String = "")
{
	s ^DHCEQFinancialReview("PDFFile",vFRRowID,+vFundsTypeDR)=1
	q 1
}

Query DHCEQFundsType() As %SQLQuery(ROWSPEC = "Code:%String,Name:%String,Source:%String,Bend:%String") [ SqlProc ]
{
}

ClassMethod DHCEQFundsTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s RowID=0
 	f  s RowID=$o(^DHCEQCCode("DHCEQCFundsType",RowID))  q:RowID=""  d
 	.d ResetDHCEQFundsType
 	.s Code=RowID
 	.s Name=$p($g(^DHCEQCCode("DHCEQCFundsType",RowID)),"^",2)
 	.s Source=""
 	.s Bend="1"
 	.d OutPutDHCEQFundsType
 	
	Quit $$$OK
OutPutDHCEQFundsType
	s Data=$lb(Code,Name,Source,Bend)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetDHCEQFundsType
	s (Code,Name,Source,Bend)=""
	quit
}

ClassMethod DHCEQFundsTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCEQFundsTypeExecute ]
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

ClassMethod DHCEQFundsTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCEQFundsTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

Query DHCEQStatCat() As %SQLQuery(ROWSPEC = "Code:%String,Name:%String,Source:%String,Bend:%String,EQFlag:%String") [ SqlProc ]
{
}

ClassMethod DHCEQStatCatExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s RowID=0
 	f  s RowID=$o(^DHCEQCCode("DHCEQCStatCat",RowID))  q:RowID=""  d
 	.d ResetDHCEQStatCat
 	.s Code=RowID
 	.s Name=$p($g(^DHCEQCCode("DHCEQCStatCat",RowID)),"^",2)
 	.s Source=""
 	.s Bend="1"
 	.s EQFlag="1"
 	.i RowID=39 s EQFlag="0"		//无形资产
 	.d OutPutDHCEQStatCat
 	
	Quit $$$OK
OutPutDHCEQStatCat
	s Data=$lb(Code,Name,Source,Bend,EQFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetDHCEQStatCat
	s (Code,Name,Source,Bend,EQFlag)=""
	quit
}

ClassMethod DHCEQStatCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCEQStatCatExecute ]
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

ClassMethod DHCEQStatCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCEQStatCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

Query FinancialReviewYD(Month As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TBussinessType:%String,TBussinessNo:%String,TEquipTypes:%String,TPDFName:%String,TBussinessSDate:%String,TBussinessEDate:%String,TAutoCreateFlag:%String,TStatus:%String,TRemark:%String,TAccountFlag:%String,TAccountDate:%String,TAccountTime:%String,TMonth:%String,TBussinessTypeDR:%String,TEquipTypeIDs:%String,TCreateUser:%String,TCreateDate:%String,TCreateTime:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TCancelUser:%String,TCancelDate:%String,TCancelTime:%String,TCancelReason:%String,TVoucher:%String") [ SqlProc ]
{
}

ClassMethod FinancialReviewYDExecute(ByRef qHandle As %Binary, Month As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1	
	s FRRowID=0
	f  s FRRowID=$o(^DHCEQFinancialReview(FRRowID)) q:FRRowID=""  d
	.d ResetGetFinancialReviewYD
	.s InvalidFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",22)
	.q:InvalidFlag="Y"
	.s TStatus=$p($g(^DHCEQFinancialReview(FRRowID)),"^",21)
	.q:TStatus'=2
	.s TMonth=$p($g(^DHCEQFinancialReview(FRRowID)),"^",28)
	.q:((Month'="")&&(TMonth'=Month))
	.s TRow=index
	.s TRowID=FRRowID
	.s TBussinessTypeDR=$p($g(^DHCEQFinancialReview(FRRowID)),"^",1)
	.s TBussinessType=$CASE(TBussinessTypeDR,"RK":"入库","ZY":"转移","TH":"退货","JS":"减少","BF":"报废","TZ":"台帐","ZJ":"折旧","":"")
	.s TBussinessNo=$p($g(^DHCEQFinancialReview(FRRowID)),"^",2)
	.s TEquipTypeIDs=$p($g(^DHCEQFinancialReview(FRRowID)),"^",3)
	.s ETCount=$L(TEquipTypeIDs,",")
	.f i=1:1:ETCount  d
	..s EquipTypeDR=$p(TEquipTypeIDs,",",i)
	..i EquipTypeDR'="" s TEquipTypes=TEquipTypes_"("_i_")"_$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废","":"")
	.s TPDFFileName=$p($g(^DHCEQFinancialReview(FRRowID)),"^",4)
	.s TBussinessSDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",5)
	.i TBussinessSDate'="" s TBussinessSDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessSDate,"date")
	.s TBussinessEDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",6)
	.i TBussinessEDate'="" s TBussinessEDate=##Class(web.DHCEQCommon).TransValueToPage(TBussinessEDate,"date")
	.s TAutoCreateFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",7)
	.s TRemark=$p($g(^DHCEQFinancialReview(FRRowID)),"^",23)
	.s TAccountFlag=$p($g(^DHCEQFinancialReview(FRRowID)),"^",24)
	.s TAccountFlag=$CASE(TAccountFlag,"0":"未做账","1":"已做账","":"")
	.s TAccountDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",25)
	.i TAccountDate'="" s TAccountDate=##Class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.s TAccountTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",26)
	.i TAccountTime'="" s TAccountTime=##Class(web.DHCEQCommon).TransValueToPage(TAccountTime,"time")
	.s TCreateUser=$p($g(^DHCEQFinancialReview(FRRowID)),"^",8)
	.i TCreateUser'="" s TCreateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCreateUser)
	.s TCreateDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",9)
	.i TCreateDate'="" s TCreateDate=##Class(web.DHCEQCommon).TransValueToPage(TCreateDate,"date")
	.s TCreateTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",10)
	.i TCreateTime'="" s TCreateTime=##Class(web.DHCEQCommon).TransValueToPage(TCreateTime,"time")
	.s TSubmitUser=$p($g(^DHCEQFinancialReview(FRRowID)),"^",11)
	.i TSubmitUser'="" s TSubmitUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUser)
	.s TSubmitDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",12)
	.i TSubmitDate'="" s TSubmitDate=##Class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	.s TSubmitTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",13)
	.i TSubmitTime'="" s TSubmitTime=##Class(web.DHCEQCommon).TransValueToPage(TSubmitTime,"time")
	.s TAuditUser=$p($g(^DHCEQFinancialReview(FRRowID)),"^",14)
	.i TAuditUser'="" s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUser)
	.s TAuditDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",15)
	.i TAuditDate'="" s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	.s TAuditTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",16)
	.i TAuditTime'="" s TAuditTime=##Class(web.DHCEQCommon).TransValueToPage(TAuditTime,"time")
	.s TCancelUser=$p($g(^DHCEQFinancialReview(FRRowID)),"^",17)
	.i TCancelUser'="" s TCancelUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCancelUser)
	.s TCancelDate=$p($g(^DHCEQFinancialReview(FRRowID)),"^",18)
	.i TCancelDate'="" s TCancelDate=##Class(web.DHCEQCommon).TransValueToPage(TCancelDate,"date")
	.s TCancelTime=$p($g(^DHCEQFinancialReview(FRRowID)),"^",19)
	.i TCancelTime'="" s TCancelTime=##Class(web.DHCEQCommon).TransValueToPage(TCancelTime,"time")
	.s TCancelReason=$p($g(^DHCEQFinancialReview(FRRowID)),"^",20)
	.s TVoucher=$p($g(^DHCEQFinancialReview(FRRowID)),"^",27)
	.s FileFlag=$g(^DHCEQFinancialReview("PDFFile",FRRowID,0))
	.i FileFlag=1  d
	..s TPDFName=TPDFFileName
	..d OutGetFinancialReviewYD
	.s FTRowID=0
	.f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
	..s FileFlag=$g(^DHCEQFinancialReview("PDFFile",FRRowID,FTRowID))
	..i FileFlag=1  d
	...s TPDFName=$E(TPDFFileName,1,$L(TPDFFileName)-4)_"_"_FTRowID_".pdf"
	...d OutGetFinancialReviewYD
	
	Quit $$$OK
OutGetFinancialReviewYD
	s Data=$lb(TRow,TRowID,TBussinessType,TBussinessNo,TEquipTypes,TPDFName,TBussinessSDate,TBussinessEDate,TAutoCreateFlag,TStatus,TRemark,TAccountFlag,TAccountDate,TAccountTime,TMonth,TBussinessTypeDR,TEquipTypeIDs,TCreateUser,TCreateDate,TCreateTime,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUser,TAuditDate,TAuditTime,TCancelUser,TCancelDate,TCancelTime,TCancelReason,TVoucher)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetFinancialReviewYD
	s (TRowID,TBussinessType,TBussinessNo,TEquipTypes,TPDFName,TBussinessSDate,TBussinessEDate,TAutoCreateFlag,TStatus,TRemark,TAccountFlag,TAccountDate,TAccountTime,TMonth,TBussinessTypeDR,TEquipTypeIDs,TCreateUser,TCreateDate,TCreateTime,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUser,TAuditDate,TAuditTime,TCancelUser,TCancelDate,TCancelTime,TCancelReason,TVoucher)=""
	quit
}

ClassMethod FinancialReviewYDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinancialReviewYDExecute ]
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

ClassMethod FinancialReviewYDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinancialReviewYDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}
*/
}
