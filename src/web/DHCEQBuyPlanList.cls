Import SQLUser

Include webimport

IncludeGenerator webimport

/// modified by ZY0221 202-04-14 修改厂家表字段指向问题
Class web.DHCEQBuyPlanList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 160;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BPL_RowID";

Parameter SQLDESCRIPTION = "BPL_RowID";

Parameter SQLROWID = "BPL_RowID";

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType, User)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	s PLIST(1) = $p(val,"^",1)	;RowID
 	s RowID=PLIST(1)
 	s PLIST(2) = $p(val,"^",2)	;BuyPlanDR
 	s PLIST(3) = $p(val,"^",3)	;Name
 	s PLIST(4) = $p(val,"^",4)	;ModelDR
 	s PLIST(5) = $p(val,"^",5)	;ManuFacDR
 	s PLIST(6) = $p(val,"^",6)	;TestFlag
 	i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")	;TestFlag
 	s PLIST(7) = $p(val,"^",7)	;PriceFee
 	s PLIST(8) = $p(val,"^",8)	;QuantityNum
 	s PLIST(9) = $p(val,"^",9)	;TotalFee
 	s PLIST(10) = $p(val,"^",10)	;Remark
 	s PLIST(11) = $p(val,"^",11)	;BuyRequestListDR
 	s PLIST(12) = $p(val,"^",12)	;ContractDR
 	s PLIST(13) = User	;UpdateUserDR
 	s PLIST(14) = +$H	;UpdateDate
 	s PLIST(15) = $P($h,",",2)	;UpdateTime
 	s PLIST(16) = $p(val,"^",16)	;CurrencyDR
 	s PLIST(17) = $p(val,"^",17)	;EquipCatDR
 	s PLIST(18) = $p(val,"^",18)	;Hold1
 	s PLIST(19) = $p(val,"^",19)	;ItemDR
 	s PLIST(20) = $p(val,"^",20)	;ArriveDate
 	i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;ArriveDate
 	s PLIST(21) = $p(val,"^",21)	;PurposeTypeDR-->Hold3
 	s PLIST(22) = $p(val,"^",22)	;RefuseFlag
 	i $p(val,"^",22)'=""  s PLIST(22) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool")	;RefuseFlag
 	s PLIST(23) = $p(val,"^",23)	;RefuseReason
 	
 	s PLIST(25) = $p(val,"^",25)	;Hold1
 	s PLIST(26) = $p(val,"^",26)	;Hold2
 	
 	k PLIST(1)
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQBuyPlanList values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQLCODE=..UpdateBuyRequestList(PLIST(2),PLIST(11))
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyPlan("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	s OldBRLRowID=..GetOldBRLRowID(RowID)
	 	i OldBRLRowID'=PLIST(11)
	 	{
	 		s SQLCODE=..UpdateBuyRequestList("",OldBRLRowID)
	 		if SQLCODE
	 		{
			 	TROLLBACK
			 	q SQLCODE
	 		}
	 	}
	 	&sql(update sqluser.DHC_EQBuyPlanList values :PLIST() where BPL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	
	 	s SQLCODE=..UpdateBuyRequestList(PLIST(2),PLIST(11))
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyPlan("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	&sql(delete from sqluser.DHC_EQBuyPlanList where BPL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQLCODE=..UpdateBuyRequestList("",PLIST(11))
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyPlan("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod UpdateBuyRequestList(BuyPlanDR, BRLRowID)
{
	//更新对应的List中的PlanRequestListDR的PlanFlag标志
	&sql(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:BuyPlanDR where BRL_RowID =:BRLRowID)
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}
	q SQLCODE
}

ClassMethod GetBuyPlanDR(itms As %Library.String = "", itmsex As %Library.String = "", BuyRequestListDR)
{
	q $P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",13)
}

ClassMethod GetOldBRLRowID(RowID)
{
	s BRLRowID=""
	&sql(select BPL_BuyRequestListDR into :BRLRowID from sqluser.DHC_EQBuyPlanList where BPL_RowID=:RowID)
	q BRLRowID
}

/// ##Class(web.DHCEQBuyPlanList).GetOneBuyPlanList("","",rowid)
ClassMethod GetOneBuyPlanList(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex,BuyRequestDR,BuyRequest
	s (result,resultex,BuyRequestDR,BuyRequest)=""
	s result= ^DHCEQBuyPlanList(rowid)
	s resultex=resultex_"^"	;BuyPlanDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQBuyPlan($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFacDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",4))),"^",1)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"bool")	;TestFlag
	s resultex=resultex_"^"	;BuyRequestListDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQBuyRequestList($p(result,"^",10))),"^",1)
	.s BuyRequestDR=$p($g(^DHCEQBuyRequestList($p(result,"^",10))),"^",1) //BuyRequestDR
	i BuyRequestDR'="" s BuyRequest=$p($g(^DHCEQBuyRequest(BuyRequestDR)),"^",1) //BuyRequest
	s resultex=resultex_"^"	;ContractDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQContract($p(result,"^",11))),"^",1)
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;UpdateDate
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",15))
	s resultex=resultex_"^"	;EquipeCatDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",16))),"^",2)
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;ArriveDate
	s resultex=resultex_"^"	;PurposeTypeDR
	//i $p(result,"^",20)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",20))),"^",2)
	s $p(result,"^",21)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"bool")	;RefuseFlag
	
	//s resultex=resultex_"^"	;Hold1Desc
	s Hold1Desc=$p(result,"^",24)
	i Hold1Desc'=""  d
	.s Hold1Desc=$p($g(^DHCEQCCode("DHCEQCVendor",Hold1Desc)),"^",2)
	.
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_BuyRequestDR_"^"_BuyRequest_"^"_Hold1Desc
}

ClassMethod UpdateBuyPlan(itms As %Library.String = "", itmsex As %Library.String = "", BuyPlanDR, Type)
{
	s TotalFee=0
	s QuantityNum=0
	&sql(select sum(BPL_TotalFee),sum(BPL_QuantityNum) into :TotalFee,:QuantityNum from sqluser.DHC_EQBuyPlanList where BPL_BuyPlanDR=:BuyPlanDR and BPL_RefuseFlag='N')
	if Type=1
	{&sql(update sqluser.DHC_EQBuyPlan set BP_TotalFee=:TotalFee,BP_QuantityNum=:QuantityNum where BP_RowID=:BuyPlanDR)
	q SQLCODE
	}
	if Type=2 q TotalFee_"^"_QuantityNum
}

ClassMethod GetBRListDetail(itms As %Library.String = "", itmsex As %Library.String = "", BuyRequestListDR)
{
	i BuyRequestListDR="" q ""
	s (PurposeType,PurposeTypeDR,ArriveDate,Hold1,ItemDR,EquipCat,EquipCatDR,CurrencyDR,ModelDR,Model,ManuFacDR,ManuFac,QuantityNum,PriceFee,TotalFee,TestFlag)=""
	s ModelDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",3)
	i ModelDR'="" s Model=$P($G(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ManuFacDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",4)
	i ManuFacDR'="" s ManuFac=$P($G(^DHCEQCCode("DHCEQCManufacturer",ManuFacDR)),"^",1)
	s QuantityNum=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",7)
	s PriceFee=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",6)
	s TestFlag=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",5)
	s TotalFee=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",8)
	s CurrencyDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",14)
	s EquipCatDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",15)
	i EquipCatDR'="" s EquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	s Hold1=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",16)
	s ItemDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",17)
	s ArriveDate=##Class(web.DHCEQCommon).TransValueToPage($P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",19),"date")
	s PurposeTypeDR=$P($G(^DHCEQBuyRequestList(BuyRequestListDR)),"^",21)
	i PurposeTypeDR'="" s PurposeType=$P($G(^DHCEQCCode("DHCEQCPurposeType",PurposeTypeDR)),"^",2)
	q ModelDR_"^"_Model_"^"_ManuFacDR_"^"_ManuFac_"^"_QuantityNum_"^"_PriceFee_"^"_TotalFee_"^"_TestFlag_"^"_CurrencyDR_"^"_EquipCatDR_"^"_EquipCat_"^"_Hold1_"^"_ItemDR_"^"_ArriveDate_"^"_PurposeTypeDR_"^"_PurposeType
}

Query GetBuyPlanList(BuyPlanDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TBuyPlanDR:%String,TName:%String,TModel:%String,TModelDR:%String,TManuFac:%String,TManuFacDR:%String,TTestFlag:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TBuyRequestListDR:%String,TCurrencyDR:%String,TRemark:%String,TBuyRequestDR:%String,TBuyRequest:%String,TExecNum:%String,TEquipCatDR:%String,TEquipCat:%String,TArriveNum:%String,TItemDR:%String,TArriveDate:%String,TPurposeTypeDR:%String,TPurposeType:%String,TRefuseFlag:%String,TRefuseReason:%String,TRequestLocDR:%String,TContractNum:%String,THold1:%String,THold2:%String")
{
SELECT BPL_RowID TRowID,
	   :BuyPlanDR TBuyPlanDR,
	   BPL_Name TName,
	   BPL_ModelDR->M_Desc TModel,
	   BPL_ModelDR TModelDR,
	   BPL_ManuFacDR->V_Name TManuFac,
	   BPL_ManuFacDR TManuFacDR,
	   BPL_TestFlag TTestFlag,
	   BPL_PriceFee TPriceFee,
	   BPL_QuantityNum TQuantityNum,
	   BPL_TotalFee TTotalFee,
	   BPL_BuyRequestListDR TBuyRequestListDR,
	   BPL_CurrencyDR TCurrencyDR,
	   BPL_Remark TRemark,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR TBuyRequestDR,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_PrjName TBuyRequest,
	   BPL_ExecNum TExcuNum,
	   BPL_EquipCatDR TEquipCatDR,
	   BPL_EquipCatDR->EC_Desc TEquipCat,
	   BPL_ArriveNum TArriveNum,
	   BPL_ItemDR TItemDR,
	   BPL_ArriveDate TArriveDate,
	   BPL_Hold3 TPurposeTypeDR,
	   BPL_Hold3 TPurposeType,
	   BPL_RefuseFlag TRefuseFlag,
	   BPL_RefuseReason TRefuseReason,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_RequestLocDR TRequestLocDR,
	   BPL_ContractNum TContractNum,
	   BPL_Hold1 THold1,
	   BPL_Hold2 THold2
FROM sqluser.DHC_EQBuyPlanList
where BPL_BuyPlanDR=:BuyPlanDR
}

Query GetBuyPlanYearAllList(Year, EquipTypeID) As %SQLQuery(ROWSPEC = "TRowID:%String,TBuyPlanDR:%String,TName:%String,TModel:%String,TModelDR:%String,TManuFac:%String,TManuFacDR:%String,TTestFlag:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TBuyRequestListDR:%String,TCurrencyDR:%String,TRemark:%String,TBuyRequestDR:%String,TBuyRequest:%String,TExecNum:%String,TEquipCatDR:%String,TEquipCat:%String,TItemDR:%String,TArriveNum:%String,TArriveDate:%String,TPurposeTypeDR:%String,TPurposeType:%String,TRefuseFlag:%String,TRefuseReason:%String,TRequestLocDR:%String,TContractNum:%String,THold1:%String,THold2:%String,TBRQuantity:%String")
{
SELECT BPL_RowID TRowID,
	   BPL_BuyPlanDR TBuyPlanDR,
	   BPL_Name TName,
	   BPL_ModelDR->M_Desc TModel,
	   BPL_ModelDR TModelDR,
	   BPL_ManuFacDR->V_Name TManuFac,
	   BPL_ManuFacDR TManuFacDR,
	   BPL_TestFlag TTestFlag,
	   BPL_PriceFee TPriceFee,
	   BPL_QuantityNum TQuantityNum,
	   BPL_TotalFee TTotalFee,
	   BPL_BuyRequestListDR TBuyRequestListDR,
	   BPL_CurrencyDR TCurrencyDR,
	   BPL_Remark TRemark,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR TBuyRequestDR,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_PrjName TBuyRequest,
	   BPL_ExecNum TExecNum,
	   BPL_EquipCatDR TEquipCatDR,
	   BPL_EquipCatDR->EC_Desc TEquipCat,
	   BPL_ItemDR TItemDR,
	   BPL_ArriveNum TArriveNum,
	   BPL_ArriveDate TArriveDate,
	   BPL_Hold3 TPurposeTypeDR,
	   BPL_Hold3 TPurposeType,
	   BPL_RefuseFlag TRefuseFlag,
	   BPL_RefuseReason TRefuseReason,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_RequestLocDR TRequestLocDR,
	   BPL_ContractNum TContractNum,
	   BPL_Hold1 THold1,
	   BPL_Hold2 THold2,
	   BPL_BuyRequestListDR->BRL_QuantityNum TBRQuantity
FROM sqluser.DHC_EQBuyPlanList
where BPL_BuyPlanDR->BP_PlanYear=:Year and BPL_BuyPlanDR->BP_EquipTypeDR=:EquipTypeID
}

Query GetBuyPlanYearList(BuyPlanDR, RequestLocDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TBuyPlanDR:%String,TName:%String,TModel:%String,TModelDR:%String,TManuFac:%String,TManuFacDR:%String,TTestFlag:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TBuyRequestListDR:%String,TCurrencyDR:%String,TRemark:%String,TBuyRequestDR:%String,TBuyRequest:%String,TExec:%String,TEquipCatDR:%String,TEquipCat:%String,TItemDR:%String,TArriveNum:%String,TArriveDate:%String,TPurposeTypeDR:%String,TPurposeType:%String,TRefuseFlag:%String,TRefuseReason:%String,TRequestLocDR:%String,TContractNum:%String,THold1:%String,THold2:%String")
{
SELECT BPL_RowID TRowID,
	   :BuyPlanDR TBuyPlanDR,
	   BPL_Name TName,
	   BPL_ModelDR->M_Desc TModel,
	   BPL_ModelDR TModelDR,
	   BPL_ManuFacDR->V_Name TManuFac,
	   BPL_ManuFacDR TManuFacDR,
	   BPL_TestFlag TTestFlag,
	   BPL_PriceFee TPriceFee,
	   BPL_QuantityNum TQuantityNum,
	   BPL_TotalFee TTotalFee,
	   BPL_BuyRequestListDR TBuyRequestListDR,
	   BPL_CurrencyDR TCurrencyDR,
	   BPL_Remark TRemark,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR TBuyRequestDR,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_PrjName TBuyRequest,
	   BPL_ExecNum TExecNum,
	   BPL_EquipCatDR TEquipCatDR,
	   BPL_EquipCatDR->EC_Desc TEquipCat,
	   BPL_ItemDR TItemDR,
	   BPL_ArriveNum TArriveNum,
	   BPL_ArriveDate TArriveDate,
	   BPL_Hold3 TPurposeTypeDR,
	   BPL_Hold3 TPurposeType,
	   BPL_RefuseFlag TRefuseFlag,
	   BPL_RefuseReason TRefuseReason,
	   BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_RequestLocDR TRequestLocDR,
	   BPL_ContractNum TContractNum,
	   BPL_Hold1 THold1,
	   BPL_Hold2 THold2
FROM sqluser.DHC_EQBuyPlanList
where BPL_BuyPlanDR=:BuyPlanDR and BPL_RefuseFlag='N'
	  and BPL_BuyPlanDR->BP_Status='2' and BPL_BuyRequestListDR->BRL_BuyRequestDR->BR_RequestLocDR=:RequestLocDR
}

// 

Query GetBRList(BuyRequestDR) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TModel:%String,TManuFac:%String,TBuyPlan:%String,HIDDEN:%String")
{
}

ClassMethod GetBRListExecute(ByRef qHandle As %Binary, BuyRequestDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBRList
	Quit $$$OK
BuildDataGetBRList
	i BuyRequestDR'=""
	{
	f  s rowid=$o(^DHCEQBuyRequestList(0,"BuyRequest",BuyRequestDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetBRList
	.s TRowID = rowid
	.s Find=$o(^DHCEQBuyPlanList(0,"BuyRequestList",rowid,0)) //2011-01-28 DJ
	.q:Find'=""
	.s TBuyRequestDR = $p($g(^DHCEQBuyRequestList(rowid)),"^",1)
	.//q:(BuyRequestDR="")||((BuyRequestDR'="")&&(TBuyRequestDR'=BuyRequestDR))
	.i TBuyRequestDR '=""  d
	..s TBuyRequest = $p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
	..s TStatus=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",16)
	.q:TStatus'="2"
	.s TName = $p($g(^DHCEQBuyRequestList(rowid)),"^",2)
	.s TModelDR = $p($g(^DHCEQBuyRequestList(rowid)),"^",3)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFacDR = $p($g(^DHCEQBuyRequestList(rowid)),"^",4)
	.i TManuFacDR '=""  d
	..s TManuFac = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	.s TTestFlag = $p($g(^DHCEQBuyRequestList(rowid)),"^",5)
	.s TPriceFee = $p($g(^DHCEQBuyRequestList(rowid)),"^",6)
	.s TQuantityNum = $p($g(^DHCEQBuyRequestList(rowid)),"^",7)
	.s TTotalFee = $p($g(^DHCEQBuyRequestList(rowid)),"^",8)
	.s TRemark = $p($g(^DHCEQBuyRequestList(rowid)),"^",9)
	.s TUpdateUserDR = $p($g(^DHCEQBuyRequestList(rowid)),"^",10)
	.s TBuyPlanDR = $p($g(^DHCEQBuyRequestList(rowid)),"^",13)
	.i TBuyPlanDR '="" s TBuyPlan=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
	.//.s TCurrency = $p($g(^(TCurrencyDR)),"^",XX)
	.d OutputRowGetBRList
	}
	quit
OutputRowGetBRList
	s Data=$lb(TName,TRowID,TModel,TManuFac,TBuyPlan,TBuyPlanDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBRList
	s (TRowID,TBuyRequestDR,TName,TModelDR,TManuFacDR,TTestFlag,TPriceFee,TQuantityNum,TTotalFee,TRemark,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TBuyRequest,TModel,TManuFac,TUpdateUser,TCurrency,TBuyPlanDR,TBuyPlan)=""
	quit
}

ClassMethod GetBRListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBRListExecute ]
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

ClassMethod GetBRListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBRListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod YearUpdateList(UpdValue)
{
	new BuyPlanDR,RowID,RefuseFlag,RefuseReason,UpdNum,i,j,Value
	s i=$l(UpdValue,";;")
	TSTART
	for j=2:1:i
	{
		s Value=$p(UpdValue,";;",j)
		s RowID=$p(Value,"^",1)
		s RefuseFlag=$p(Value,"^",2)
		s RefuseReason=$p(Value,"^",3)
		s UpdNum=$p(Value,"^",4)
		s UpdPrice=$p(Value,"^",5)
		s UpdTotal=UpdNum*UpdPrice
		s BuyPlanDR=$P($G(^DHCEQBuyPlanList(RowID)),"^",1)
		&SQL(update sqluser.DHC_EQBuyPlanList set BPL_RefuseFlag=:RefuseFlag,BPL_RefuseReason=:RefuseReason,BPL_QuantityNum=:UpdNum,BPL_PriceFee=:UpdPrice,BPL_TotalFee=:UpdTotal where BPL_RowID=:RowID)
		q:SQLCODE'=0
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=..UpdateBuyPlan("","",BuyPlanDR,"1")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod YearDealUpdateList(PlanRowID, RowList, j, Type)
{
	s CODE=0
	s BRCODE=0
	s DealPlanID=$P(^DHCEQBuyPlanList($P(RowList,"^",1)),"^",1)
	TSTART
	For i = 1:1:j
	{
		s RowID=$p(RowList,"^",i)
		s BRLID=$P(^DHCEQBuyPlanList(RowID),"^",10)
		&SQL(update sqluser.DHC_EQBuyRequestList set BRL_BuyPlanDR=:PlanRowID where BRL_RowID=:BRLID)
		s BRCODE=BRCODE+SQLCODE
		i BRCODE q 		
		&SQL(update sqluser.DHC_EQBuyPlanList set BPL_BuyPlanDR=:PlanRowID where BPL_RowID=:RowID)
		s CODE=CODE+SQLCODE
		i CODE q
	}
	if (CODE)
    {
	    TROLLBACK
	    q CODE
    }
    i +Type=1 //根据年度分配id更新数量
    {
    	s SQLCODE=..UpdateBuyPlan("","",PlanRowID,"1")
    }
    else //根据明细id得到年度分配id更新数量
    {
	    s SQLCODE=..UpdateBuyPlan("","",DealPlanID,"1")
    }
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod GetDealFlag(BPLID)
{
	new BPID,PlanType
	i BPLID="" q ""
	s BPID=$P(^DHCEQBuyPlanList(BPLID),"^",1)
	s PlanType=$P(^DHCEQBuyPlan(BPID),"^",26)
	i PlanType="1" q "未分配"
	q "已分配"
}

/// Mozy	2011-1-24
/// d ##class(%ResultSet).RunQuery("web.DHCEQBuyPlanList","GetBuyPlanListByItem","")
Query GetBuyPlanListByItem(Name As %String = "") As %Query(ROWSPEC = "TName:%String,Hidden:%String,Hidden:%String,TPrjName:%String,Hidden:%String,TModel:%String,Hidden:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,Hidden:%String,Hidden:%String,TUnit:%String")
{
}

ClassMethod GetBuyPlanListByItemExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	For  Set rowid=$Order(^DHCEQBuyPlanList(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetBuyPlanListByItem
	.Set TRowID = rowid
	.Set TBuyPlanDR=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",1)
	.Set TPrjName=$Piece($Get(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
	.Set TName=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",2)
	.Quit:(Name'="")&&(TName'[Name)
	.Set TModelDR=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",3)
	.If TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TManuFacDR=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",4)
	.If TManuFacDR'="" Set TManuFac=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	.Set TPriceFee=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",6)
	.Set TQuantityNum=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",7)
	.Set TItemDR=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",18)
	.If TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.
	.Do OutputRowGetBuyPlanListByItem
	Quit $$$OK
OutputRowGetBuyPlanListByItem
	Set Data=$lb(TName,TRowID,TBuyPlanDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyPlanListByItem
	Set (TName,TRowID,TBuyPlanDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit)=""
	Quit
}

ClassMethod GetBuyPlanListByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanListByItemExecute ]
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

ClassMethod GetBuyPlanListByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanListByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
