Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQBuyRequestList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BRL_RowID";

Parameter SQLDESCRIPTION = "BRL_RowID";

Parameter SQLROWID = "BRL_RowID";

ClassMethod UpdateBuyRequestItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	s PLIST(1) = $p(val,"^",1)	;RowID
	s RowID=PLIST(1)
 	s PLIST(2) = $p(val,"^",2)	;BuyRequestDR
 	s PLIST(3) = $p(val,"^",3)	;Name
 	s PLIST(4) = $p(val,"^",4)	;ModelDR
 	s PLIST(5) = $p(val,"^",5)	;ManuFacDR
 	s PLIST(6) = $p(val,"^",6)	;TestFlag
 	i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"bool")	;TestFlag
 	s PLIST(7) = $p(val,"^",7)	;PriceFee
 	s PLIST(8) = $p(val,"^",8)	;QuantityNum
 	s PLIST(9) = $p(val,"^",9)	;TotalFee
 	s PLIST(10) = $p(val,"^",10)	;Remark
 	s PLIST(11) = $p(val,"^",22)	;UpdateUserDR
 	s PLIST(12) = +$H	;UpdateDate
 	//i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;UpdateDate
 	s PLIST(13) = $P($H,",",2)	;UpdateTime
 	s PLIST(14) = $p(val,"^",14)	;BuyPlanDR
 	s PLIST(15) = $p(val,"^",15)	;CurrencyDR
 	s PLIST(16) = $p(val,"^",16)	;EquipCatDR
 	//i $p(val,"^",16)'=""  s PLIST(16) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"bool")	;UrgencyFlag
 	s PLIST(17) = $p(val,"^",17)	;Hold1
 	s PLIST(18) = $p(val,"^",18)	;ItemDR
 	s PLIST(19) = $p(val,"^",19)	;RequestReason
 	s PLIST(20) = $p(val,"^",20)	;ArriveDate
 	i $p(val,"^",20)'=""  s PLIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",20),"date")	;ArriveDate
 	s PLIST(22) = $p(val,"^",23)	;ArgumentationDR
 	k PLIST(1)
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQBuyRequestList values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyRequest("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	&sql(update sqluser.DHC_EQBuyRequestList values :PLIST() where BRL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyRequest("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	&sql(delete from sqluser.DHC_EQBuyRequestList where BRL_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateBuyRequest("","",PLIST(2),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod GetOneBuyRequestList(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBuyRequestList(rowid)
	s resultex=resultex_"^"	;BuyRequestDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQBuyRequest($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFacDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",4))),"^",1)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"bool")	;TestFlag
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;UpdateDate
	s resultex=resultex_"^"	;BuyPlanDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQBuyPlan($p(result,"^",13))),"^",1)
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",14))
	//s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;EquipCatDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",15))),"^",2)
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;ArriveDate
	s resultex=resultex_"^"	;ArgumentationDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQArgumentation($p(result,"^",20))),"^",1)
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",21))),"^",2)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

ClassMethod UpdateBuyRequest(itms As %Library.String = "", itmsex As %Library.String = "", BuyRequestDR, Type)
{
	s TotalFee=0
	s QuantityNum=0
	&sql(select sum(BRL_TotalFee),sum(BRL_QuantityNum) into :TotalFee,:QuantityNum from sqluser.DHC_EQBuyRequestList where BRL_BuyRequestDR=:BuyRequestDR)
	if Type=1
	{&sql(update sqluser.DHC_EQBuyRequest set BR_TotalFee=:TotalFee,BR_QuantityNum=:QuantityNum where BR_RowID=:BuyRequestDR)
	q SQLCODE
	}
	if Type=2 q TotalFee_"^"_QuantityNum
}

Query GetBuyRequestList(BuyRequestDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TBuyRequestDR:%String,TBuyRequest:%String,TName:%String,TModel:%String,TModelDR:%String,TManuFac:%String,TManuFacDR:%String,TTestFlag:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TCurrencyDR:%String,TRemark:%String,TBuyPlanDR:%String,TBuyPlan:%String,TEquipCatDR:%String,TEquipCat:%String,THold1:%String,TItemDR:%String,TRequestReason:%String,TArriveDate:%String,TArgumentationDR:%String,THold2:%String")
{
SELECT BRL_RowID TRowID,
	   :BuyRequestDR TBuyRequestDR,
	   BRL_BuyRequestDR->BR_PrjName TBuyRequest,
	   BRL_Name TName,
	   BRL_ModelDR->M_Desc TModel,
	   BRL_ModelDR TModelDR,
	   BRL_ManuFacDR->V_Name TManuFac,
	   BRL_ManuFacDR TManuFacDR,
	   BRL_TestFlag TTestFlag,
	   BRL_PriceFee TPriceFee,
	   BRL_QuantityNum TQuantityNum,
	   BRL_TotalFee TTotalFee,
	   BRL_CurrencyDR TCurrencyDR,
	   BRL_Remark TRemark,
	   BRL_BuyPlanDR TBuyPlanDR,
	   BRL_BuyPlanDR->BP_PlanName TBuyPlan,
	   BRL_EquipCatDR TEquipCatDR,
	   BRL_EquipCatDR->EC_Desc TEquipCat,
	   BRL_Hold1 THold1,
	   BRL_ItemDR TItemDR,
	   BRL_RequestReason TRequestReason,
	   BRL_ArriveDate TArriveDate,
	   '' TArgumentationDR,
	   BRL_Hold2 THold2
FROM sqluser.DHC_EQBuyRequestList
where BRL_BuyRequestDR=:BuyRequestDR
}

ClassMethod GetBuyPlanState(PlanID)
{
	s PlanState=""
	i PlanID="" q PlanState
	s Status=$P($G(^DHCEQBuyPlan(PlanID)),"^",6)
	s PlanState=##Class(web.DHCEQCommon).GetEditStatusDisplay(Status)
	i Status="1"
	{
		s CurRoleID=$P($G(^DHCEQBuyPlan(PlanID)),"^",11)
		i CurRoleID'="" d
		.s CurRole=$P(^DHCEQCCode("DHCEQCApproveRole",CurRoleID),"^",2)
		.s PlanState=CurRole
	}
	i Status="2"
	{
		s BuyStatus=$P($G(^DHCEQBuyPlan(PlanID)),"^",38)
		i BuyStatus="1"
		{
			s CurRoleID=$P($G(^DHCEQBuyPlan(PlanID)),"^",40)
			i CurRoleID'="" d
			.s CurRole=$P(^DHCEQCCode("DHCEQCApproveRole",CurRoleID),"^",2)
			.s PlanState="采购-"_CurRole
		}
		else
		{
			s PlanState="采购-"_##class(web.DHCEQBuyPlan).GetBuyStatu(BuyStatus)
		}
	}
	q PlanState
}

ClassMethod GetBRInfoByID(BRRowID, Type)
{
	i BRRowID="" q ""
	q $P(^DHCEQBuyRequest(BRRowID),"^",Type)
}

ClassMethod GetArgumentationIcon(ArgumentationID)
{
	i ArgumentationID="" q "websys/new.gif"
	i ArgumentationID'="" q "webemr/regalert2.gif"
}

ClassMethod GetBuyPlanListInfo(RowID)
{
	i RowID="" q ""
	s RowID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",RowID,0))
	i RowID="" q ""
	q ##Class(web.DHCEQBuyPlanList).GetOneBuyPlanList("","",RowID)
}

/// Mozy	2011-1-24
/// d ##class(%ResultSet).RunQuery("web.DHCEQBuyRequestList","GetBuyRequestListByItem","")
Query GetBuyRequestListByItem(PrjName As %String = "") As %Query(ROWSPEC = "TName:%String,Hidden:%String,Hidden:%String,TPrjName:%String,Hidden:%String,TModel:%String,Hidden:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,Hidden:%String,Hidden:%String,TUnit:%String,TRequestLoc:%String,TUseLoc:%String,TCommonName:%String")
{
}

ClassMethod GetBuyRequestListByItemExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	For  Set rowid=$Order(^DHCEQBuyRequestList(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetBuyRequestListByItem
	.Set TRowID = rowid
	.Set TBuyRequestDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",1)
	.Set TPrjName=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
	.Set TCommonName=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",2) //2013-06-24 DJ0118
	.Quit:(Name'="")&&(TCommonName'[Name) //2013-06-24 DJ0118
	.Set TModelDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",3)
	.If TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TManuFacDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",4)
	.If TManuFacDR'="" Set TManuFac=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	.Set TPriceFee=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",6)
	.Set TQuantityNum=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",7)
	.Set TItemDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",17)
	.If TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.i TItemDR'="" s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1) //2013-06-24 DJ0118
	.s TRequestLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",2)
	.s TUseLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",4)
	.i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
	.i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.Do OutputRowGetBuyRequestListByItem
	Quit $$$OK
OutputRowGetBuyRequestListByItem
	Set Data=$lb(TName,TRowID,TBuyRequestDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit,TRequestLoc,TUseLoc,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyRequestListByItem
	Set (TName,TRowID,TBuyRequestDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit,TRequestLoc,TUseLoc,TCommonName)=""
	Quit
}

ClassMethod GetBuyRequestListByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestListByItemExecute ]
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

ClassMethod GetBuyRequestListByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestListByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
