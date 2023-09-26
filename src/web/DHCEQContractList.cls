Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQContractList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 69;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CTL_RowID";

Parameter SQLDESCRIPTION = "CTL_RowID";

Parameter SQLROWID = "CTL_RowID";

ClassMethod GetOneContractList(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex,BuyPlanDR,BuyPlan
	s (result,resultex,BuyPlanDR,BuyPlan)=""
	s result= ^DHCEQContractList(rowid)
	s resultex=resultex_"^"	;ContractDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQContract($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFacDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",4))),"^",1)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"bool")	;TestFlag
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;ContractArriveDate
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;ArriveDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",13))
	s $p(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;UpdateDate
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",16))
	s resultex=resultex_"^"	;BuyPlanListDR
	i $p(result,"^",17)'=""  d
	.s BuyPlanDR=$p($g(^DHCEQBuyPlanList($p(result,"^",17))),"^",1)
	.s resultex=resultex_$p($g(^DHCEQBuyPlanList($p(result,"^",17))),"^",2)
	s resultex=resultex_"^"_BuyPlanDR	;BuyPlanDR
	i BuyPlanDR'="" s BuyPlan=$p($g(^DHCEQBuyPlan(BuyPlanDR)),"^",1)
	s resultex=resultex_"^"_BuyPlan	;BuyPlan
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType, User)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	s PLIST(1) = $p(val,"^",1)	;RowID
	s RowID=PLIST(1)
 	s PLIST(2) = $p(val,"^",2)	;ContractDR
 	s PLIST(3) = $p(val,"^",3)	;Name
 	s PLIST(4) = $p(val,"^",4)	;ModelDR
 	s PLIST(5) = $p(val,"^",5)	;ManuFacDR
 	s PLIST(6) = $p(val,"^",6)	;TestFlag
 	i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")	;TestFlag
 	s PLIST(7) = $p(val,"^",7)	;PriceFee
 	s PLIST(8) = $p(val,"^",8)	;QuantityNum
 	s PLIST(9) = $p(val,"^",9)	;TotalFee
 	s PLIST(10) = $p(val,"^",10)	;Remark
 	s PLIST(11) = $p(val,"^",11)	;ContractArriveDate
 	i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;ContractArriveDate
 	s PLIST(12) = $p(val,"^",12)	;ArriveDate
 	i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;ArriveDate
 	s PLIST(13) = 0 //$p(val,"^",13)	;ArriveQuantityNum
 	s PLIST(14) = User //$p(val,"^",14)	;UpdateUserDR
 	s PLIST(15) = +$H //$p(val,"^",15)	;UpdateDate
 	//i $p(val,"^",15)'=""  s PLIST(15) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",15),"date")	;UpdateDate
 	s PLIST(16) = $P($h,",",2) //$p(val,"^",16)	;UpdateTime
 	s PLIST(17) = $p(val,"^",17)	;CurrencyDR
 	s PLIST(18) = $p(val,"^",18)	;BuyPlanListDR
 	s PLIST(19) = $p(val,"^",19)	;ItemDR
 	kill PLIST(1)
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQContractList values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQLCODE=..UpdateBuyPlanList(PLIST(8),PLIST(18))
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	s OldBPLRowID=..GetOldBPLRowID(RowID)
	 	s OldNum=$P(^DHCEQContractList(RowID),"^",7)
	 	i OldBPLRowID'=PLIST(18)
	 	{
	 		s SQLCODE=..UpdateBuyPlanList(-OldNum,OldBPLRowID)
	 		if SQLCODE
	 		{
			 	TROLLBACK
			 	q SQLCODE
	 		}
	 		s SQLCODE=..UpdateBuyPlanList(PLIST(8),PLIST(18))
	 		if SQLCODE
	 		{
			 	TROLLBACK
			 	q SQLCODE
	 		}
	 	}
	 	else
	 	{
		 	s Num=PLIST(8)-OldNum
		 	s SQLCODE=..UpdateBuyPlanList(Num,PLIST(18))
	 		if SQLCODE
	 		{
			 	TROLLBACK
			 	q SQLCODE
	 		}
	 	}
	 	&sql(update sqluser.DHC_EQContractList values :PLIST() where CTL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	
	 	s OldNum=$P(^DHCEQContractList(RowID),"^",7)
	 	s BPLID=$P(^DHCEQContractList(RowID),"^",17)
	 	s SQLCODE=..UpdateBuyPlanList(-OldNum,BPLID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	&sql(delete from sqluser.DHC_EQContractList where CTL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod UpdateBuyPlanList(Num, BPLRowID)
{
	//更新对应的List中的PlanRequestListDR的ContractNum
	i BPLRowID="" q 0
	i Num="" s Num=0
	s ContractNum=$p(^DHCEQBuyPlanList(BPLRowID),"^",23)
	s ExecNum=$p(^DHCEQBuyPlanList(BPLRowID),"^",11)
	i ContractNum="" s ContractNum=0
	s Num=ContractNum+Num
	i Num>ExecNum q -1001
	&sql(update sqluser.DHC_EQBuyPlanList set BPL_ContractNum=:Num where BPL_RowID =:BPLRowID)
	if (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}
	q SQLCODE
}

ClassMethod GetContractDR(itms As %Library.String = "", itmsex As %Library.String = "", BuyPlanListDR)
{
	q $P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",11)
}

ClassMethod GetOldBPLRowID(RowID)
{
	new BPLRowID
	s BPLRowID=""
	s BPLRowID=$p(^DHCEQContractList(RowID),"^",17)
	//&sql(select CTL_BuyPlanListDR into :BPLRowID from sqluser.DHC_EQContractList where CTL_RowID=:RowID)
	q BPLRowID
}

ClassMethod UpdateContract(itms As %Library.String = "", itmsex As %Library.String = "", ContractDR, Type)
{
	s TotalFee=0
	s QuantityNum=0
	&sql(select sum(CTL_TotalFee),sum(CTL_QuantityNum) into :TotalFee,:QuantityNum from sqluser.DHC_EQContractList where CTL_ContractDR=:ContractDR)
	
	if Type=1
	{&sql(update sqluser.DHC_EQContract set CT_TotalFee=:TotalFee,CT_QuantityNum=:QuantityNum where CT_RowID=:ContractDR)
	q SQLCODE
	}
	if Type=2 q TotalFee_"^"_QuantityNum
}

//,TBuyPlan:%Sting,TBuyPlanDR:%String

Query GetContractList(ContractDR) As %Query(ROWSPEC = "TRowID:%String,TContractDR:%String,TName:%String,TModelDR:%String,TManuFacDR:%String,TTestFlag:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TRemark:%String,TContractArriveDate:%String,TArriveDate:%String,TArriveQuantityNum:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TBuyPlanListDR:%String,TContract:%String,TModel:%String,TManuFac:%String,TUpdateUser:%String,TCurrency:%String,TBuyPlanDR:%String,TBuyPlan:%String,TItemDR:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, ContractDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList
	f  s rowid=$o(^DHCEQContractList(rowid))  quit:rowid=""  d
	.d ResetVariablesGetContractList
	.s TRowID = rowid
	.s TContractDR = $p($g(^DHCEQContractList(rowid)),"^",1)
	.q:(ContractDR="")||(ContractDR'=TContractDR)
	.i TContractDR '=""  d
	..s TContract = $p($g(^DHCEQContract(TContractDR)),"^",1)
	.s TName = $p($g(^DHCEQContractList(rowid)),"^",2)
	.s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFacDR = $p($g(^DHCEQContractList(rowid)),"^",4)
	.i TManuFacDR '=""  d
	..s TManuFac = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	.s TTestFlag = $p($g(^DHCEQContractList(rowid)),"^",5)
	.s TPriceFee = $p($g(^DHCEQContractList(rowid)),"^",6)
	.s TQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",7)
	.s TTotalFee = $p($g(^DHCEQContractList(rowid)),"^",8)
	.s TRemark = $p($g(^DHCEQContractList(rowid)),"^",9)
	.s TContractArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",10),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",11),"date")
	.s TArriveQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",12)
	.s TUpdateUserDR = $p($g(^DHCEQContractList(rowid)),"^",13)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",14),"date")
	.s TUpdateTime = $p($g(^DHCEQContractList(rowid)),"^",15)
	.s TCurrencyDR = $p($g(^DHCEQContractList(rowid)),"^",16)
	.i TCurrencyDR '=""  d
	..s TCurrency = ##class(web.DHCEQCommon).GetTrakNameByID("user",TCurrencyDR)
	.s TBuyPlanListDR = $p($g(^DHCEQContractList(rowid)),"^",17)
	.i TBuyPlanListDR '=""  d
	..s TBuyPlanDR = $p($g(^DHCEQBuyPlanList(TBuyPlanListDR)),"^",1)
	..i TBuyPlanDR'="" s TBuyPlan=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
	.s TItemDR=$p($g(^DHCEQContractList(rowid)),"^",18)
	.d OutputRowGetContractList
	quit
OutputRowGetContractList
	s Data=$lb(TRowID,TContractDR,TName,TModelDR,TManuFacDR,TTestFlag,TPriceFee,TQuantityNum,TTotalFee,TRemark,TContractArriveDate,TArriveDate,TArriveQuantityNum,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TBuyPlanListDR,TContract,TModel,TManuFac,TUpdateUser,TCurrency,TBuyPlanDR,TBuyPlan,TItemDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TRowID,TContractDR,TName,TModelDR,TManuFacDR,TTestFlag,TPriceFee,TQuantityNum,TTotalFee,TRemark,TContractArriveDate,TArriveDate,TArriveQuantityNum,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TBuyPlanListDR,TContract,TModel,TManuFac,TUpdateUser,TCurrency,TBuyPlan,TBuyPlanDR,TItemDR)=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetBPListDetail(itms As %Library.String = "", itmsex As %Library.String = "", BuyPlanListDR)
{
	i BuyPlanListDR="" q ""
	s (CurrencyDR,ModelDR,Model,ManuFacDR,ManuFac,QuantityNum,PriceFee,TotalFee,TestFlag,ItemDR)=""
	s BuyPlanID=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",1)
	s ModelDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",3)
	i ModelDR'="" s Model=$P($G(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ManuFacDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",4)
	i ManuFacDR'="" s ManuFac=$P($G(^DHCEQCCode("DHCEQCManufacturer",ManuFacDR)),"^",1)
	s ExecNum=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",11)
	s ContractNum=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",23)
	i ExecNum="" s ExecNum=0
	i ContractNum="" s ContractNum=0
	s QuantityNum=(ExecNum-ContractNum)
	s PriceFee=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",6)
	s TestFlag=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",5)
	s TotalFee=PriceFee*QuantityNum
	s CurrencyDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",15)
	s ItemDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",18)
	//i EquipTypeDR'="" s EquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	q ModelDR_"^"_Model_"^"_ManuFacDR_"^"_ManuFac_"^"_QuantityNum_"^"_PriceFee_"^"_TotalFee_"^"_TestFlag_"^"_CurrencyDR_"^"_ItemDR_"^"_ExecNum_"^"_ContractNum //_"^"_EquipType
}

ClassMethod IsCanAdd(RowID)
{
	s Flag=1
	s BPLID=0
	// Mozy	2010-12-17
	//s BPLID=$o(^DHCEQBuyPlanList(0,"BuyPlan",RowID,BPLID)) q:(BPLID="")||Flag=0  d
	For  Set BPLID=$Order(^DHCEQBuyPlanList(0,"BuyPlan",RowID,BPLID)) Quit:(BPLID="")||(Flag=0)  Do
	.s ExecNum=$P(^DHCEQBuyPlanList(BPLID),"^",11)
	.i ExecNum="" s ExecNum=0
	.s ContractNum=$P(^DHCEQBuyPlanList(BPLID),"^",23)
	.i ContractNum="" s ContractNum=0
	.i (ExecNum-ContractNum)>0 s Flag=0
	q Flag
}

Query GetBuyPlan(BuyPlan) As %Query(ROWSPEC = "TPlanName:%String,HIDDEN:%String,TQuantityNum:%String,TRemark:%String,TPlanNo:%String")
{
}

ClassMethod GetBuyPlanExecute(ByRef qHandle As %Binary, BuyPlan) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBuyPlan
	Quit $$$OK
BuildDataGetBuyPlan
	s rowid=0
	f  s rowid=$o(^DHCEQBuyPlan(0,"BuyStatus",3,rowid))  quit:rowid=""  d
	.q:..IsCanAdd(rowid)
	.d ResetVariablesGetBuyPlan
	.d GetOneBuy
	s rowid=0
	f  s rowid=$o(^DHCEQBuyPlan(0,"BuyStatus",4,rowid))  quit:rowid=""  d
	.q:..IsCanAdd(rowid)
	.d ResetVariablesGetBuyPlan
	.d GetOneBuy
	quit
GetOneBuy
	s TRowID = rowid
	s TPlanName = $p($g(^DHCEQBuyPlan(rowid)),"^",1)
	q:(BuyPlan'="")&&(TPlanName'[BuyPlan)
	s TQuantityNum = $p($g(^DHCEQBuyPlan(rowid)),"^",2)
	s TTotalFee = $p($g(^DHCEQBuyPlan(rowid)),"^",3)
	s TRemark = $p($g(^DHCEQBuyPlan(rowid)),"^",4)
	s TPlanNo = $p($g(^DHCEQBuyPlan(rowid)),"^",25)
	s TPlanType = $p($g(^DHCEQBuyPlan(rowid)),"^",26)
	q:TPlanType="1"
	d OutputRowGetBuyPlan
	quit
OutputRowGetBuyPlan
	s Data=$lb(TPlanName,TRowID,TQuantityNum,TRemark,TPlanNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBuyPlan
	s (TPlanName,TRowID,TQuantityNum,TRemark,TPlanNo)=""
	quit
}

ClassMethod GetBuyPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanExecute ]
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

ClassMethod GetBuyPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBPList(BuyPlanDR) As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TModel:%String,TManuFac:%String,TQuantityNum:%String,TExecNum:%String,TContractNum:%String")
{
}

ClassMethod GetBPListExecute(ByRef qHandle As %Binary, BuyPlanDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBPList
	Quit $$$OK
BuildDataGetBPList
	q:BuyPlanDR=""
	s rowid=0
	f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",BuyPlanDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetBPList
	.d GetOneBuyPlanList
	quit
GetOneBuyPlanList
	s TRowID = rowid
	s TName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)
	s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
	i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
	i TManuFacDR'="" s TManumFac=$P(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR),"^",1)
	s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
	s TExecNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",11)
	s TContractNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",23)
	q:TContractNum'<TExecNum
	d OutputRowGetBPList
	quit
OutputRowGetBPList
	s Data=$lb(TName,TRowID,TModel,TManuFac,TQuantityNum,TExecNum,TContractNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPList
	s (TName,TRowID,TModel,TManuFac,TQuantityNum,TExecNum,TContractNum)=""
	quit
}

ClassMethod GetBPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPListExecute ]
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

ClassMethod GetBPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
