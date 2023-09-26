/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 修改方法：GetOneStoreMoveStat,GetStoreMoveStat
/// 描述:增加了变动信息的打印导出功能
/// -------------------------------
Class web.DHCEQStoreMoveList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, Type)
{
	//Type=1 删除
	//Type=0 插入、更新
	s RowID=$P(val,"^",1)
 	s PLIST(2) = $p(val,"^",2)	;StoreMoveDR
 	s PLIST(3) = $p(val,"^",3)	;EquipDR
 	s PLIST(4) = $p(val,"^",4)	;BatchFlag
 	i $p(val,"^",4)'=""  s PLIST(4) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")	;BatchFlag
 	s PLIST(5) = $p(val,"^",5)	;InStockListDR
 	s PLIST(6) = $p(val,"^",6)	;EquipName
 	s PLIST(7) = $p(val,"^",7)	;ManuFactoryDR
 	s PLIST(8) = $p(val,"^",8)	;OriginalFee
 	s PLIST(9) = $p(val,"^",9)	;QuantityNum
 	s PLIST(10) = $p(val,"^",10)	;ModelDR
 	s PLIST(11) = $p(val,"^",11)	;UnitDR
 	s PLIST(12) = $p(val,"^",12)	;Remark
	TSTART
	if +Type=0
	{
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQStoreMoveList values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQStoreMoveList values :PLIST() where SML_RowID=:RowID)
		}
		s Total=..StoreMoveHaveEquip(PLIST(2),PLIST(4),PLIST(5),PLIST(3))
		i Total>0
		{
			
		}
		else
		{
			TROLLBACK
			q Total
		}
	}
	if +Type=1
	{
		&SQL(delete from sqluser.DHC_EQStoreMoveList where SML_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ID=$G(%ROWID)
	TCOMMIT
	q ID
}

ClassMethod GetOneStoreMoveList(rowid)
{
	new result,resultex,Quantity
	s (result,resultex,Quantity)=""
	s result= ^DHCEQStoreMoveList(rowid)
	s resultex=resultex_"^"	;StoreMoveDR
	//i $p(result,"^",1)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQStoreMove($p(result,"^",1))),"^",XX)
	s resultex=resultex_"^"	;EquipDR
	//i $p(result,"^",2)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",2))),"^",XX)
	s $p(result,"^",3)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"bool")	;BatchFlag
	s resultex=resultex_"^"	;InStockListDR
	//i $p(result,"^",4)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",4))),"^",XX)
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",6))  //$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",6))),"^",1) //CZF0093
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",9))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",10))
	
	s InStockList=$p(result,"^",4)
	i InStockList'=""
	{
		s StoreMoveDR=$p(result,"^",1)
		s Stock=$P(^DHCEQStoreMove(StoreMoveDR),"^",2)
		s EquipType=$P(^DHCEQStoreMove(StoreMoveDR),"^",16)
		s StatCat=$P(^DHCEQStoreMove(StoreMoveDR),"^",17)
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,InStockList,EquipType,StatCat,rowid) //2010-06-03 党军
	}
	else
	{
		s Quantity=1
	}
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",7)'="" s $p(result,"^",7)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",7),"",2)	;OriginalFee
	
	q result_resultex_"^"_Quantity
}

ClassMethod StoreMoveHaveEquip(StoreMoveDR, BatchFlag, InStockListDR, EquipDR)
{
	s (Total2)=0
	if BatchFlag="Y"
	{
		&SQL(select COUNT(SML_RowID) into :Total2 from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:StoreMoveDR and SML_InStockListDR=:InStockListDR and SML_BatchFlag=:BatchFlag)
	}
	else
	{
		&SQL(select COUNT(SML_RowID) into :Total2 from sqluser.DHC_EQStoreMoveList where SML_StoreMoveDR=:StoreMoveDR and SML_EquipDR=:EquipDR and SML_BatchFlag=:BatchFlag)
	}
	i Total2>1 q "本单据已经录入该设备"
	q StoreMoveDR
}

ClassMethod GetBachFlag(RowID)
{
	i RowID="" q 0
	q $P(^DHCEQStoreMoveList(RowID),"^",3)
}

Query GetStoreMoveList(StoreMoveDR) As %Query(ROWSPEC = "TTotalFee:%String,TStockStatus:%String,TStock:%String,TRowID:%String,TStoreMoveDR:%String,TEquipDR:%String,TBatchFlag:%String,TInStockListDR:%String,TEquipName:%String,TManuFactoryDR:%String,TOriginalFee:%String,TQuantityNum:%String,TModelDR:%String,TUnitDR:%String,TRemark:%String,TStoreMove:%String,TEquip:%String,TInStockList:%String,TManuFactory:%String,TModel:%String,TUnit:%String,TMoveNum:%String")
{
}

ClassMethod GetStoreMoveListExecute(ByRef qHandle As %Binary, StoreMoveDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i StoreMoveDR'="" s StoreLoc=$p($g(^DHCEQStoreMove(StoreMoveDR)),"^",2)
 	i StoreMoveDR'="" s SMEquipType=$p($g(^DHCEQStoreMove(StoreMoveDR)),"^",16)
 	i StoreMoveDR'="" s SMStatCat=$p($g(^DHCEQStoreMove(StoreMoveDR)),"^",17)
	s index=1
	s rowid=0
	d BuildDataGetStoreMoveList
	Quit $$$OK
BuildDataGetStoreMoveList
	if StoreMoveDR'=""
	{
	f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetStoreMoveList
	.s TRowID = rowid
	.s TStoreMoveDR = StoreMoveDR
	.s TEquipDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",2)
	.i TEquipDR '=""  d
	..s TStockStatus=$p($g(^DHCEQEquip(TEquipDR)),"^",60)
	..s TStockStatus=$Case(TStockStatus,"0":"新增","1":"入库","2":"转移出库","3":"出库",:"")
	..s TStock=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
	..s TStock=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	.s TBatchFlag = $p($g(^DHCEQStoreMoveList(rowid)),"^",3)
	.s TInStockListDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",4)
	.i (TInStockListDR '="")&&(TBatchFlag="Y")  d
	..s TMoveNum=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(StoreLoc,TInStockListDR,SMEquipType,SMStatCat)
	.s TEquip = $p($g(^DHCEQStoreMoveList(rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",6)
	.i TManuFactoryDR '=""  d
	..s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	.s TOriginalFee = $p($g(^DHCEQStoreMoveList(rowid)),"^",7)
	.s TQuantityNum = $p($g(^DHCEQStoreMoveList(rowid)),"^",8)
	.s TTotalFee=TOriginalFee*TQuantityNum
	.s TModelDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",9)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TUnitDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",10)
	.i TUnitDR '=""  d
	..s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TRemark = $p($g(^DHCEQStoreMoveList(rowid)),"^",11)
	.
	.//add by jdl 2009-9-25  JDL0036
	.//格式化金额为小数点两位
	.i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	.i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	.
	.d OutputRowGetStoreMoveList
	}
	quit
OutputRowGetStoreMoveList
	s Data=$lb(TTotalFee,TStockStatus,TStock,TRowID,TStoreMoveDR,TEquipDR,TBatchFlag,TInStockListDR,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,TRemark,TStoreMove,TEquip,TInStockList,TManuFactory,TModel,TUnit,TMoveNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveList
	s (TTotalFee,TStockStatus,TStock,TRowID,TStoreMoveDR,TEquipDR,TBatchFlag,TInStockListDR,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,TRemark,TStoreMove,TEquip,TInStockList,TManuFactory,TModel,TUnit,TMoveNum)=""
	quit
}

ClassMethod GetStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
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

ClassMethod GetStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetInStockList(StatCatDR, EquipTypeDR, Equip, StockDR) As %Query(ROWSPEC = "Name:%String,HIDDEN:%String,Model:%String,ManuFactory:%String,Quantity:%String,InStockNo:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, StatCatDR, EquipTypeDR, Equip, StockDR) As %Status
{
 	new repid, index,rowid,ISRowID,StockStatu,Flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set Equip=$ZCONVERT(Equip,"U")
	s index=1
	s InStockListID=0
	d BuildDataGetInStockList
	Quit $$$OK
BuildDataGetInStockList
	q:(StockDR="")||(EquipTypeDR="")
	f  s InStockListID=$O(^DHCEQEquip(0,"StoreInStock",StockDR,EquipTypeDR,"1","N",InStockListID)) q:InStockListID=""  d
	.d ResetVariablesGetInStockList
	.s RowID=InStockListID
	.s Flag="N"
	.s ISRowID=$p($g(^DHCEQInStockList(InStockListID)),"^",1)
	.s StockStatu=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.i StockStatu'="3" s Flag="Y"
	.q:Flag="Y"
	.s BatchFlag=$P($G(^DHCEQInStockList(RowID)),"^",3)
	.q:BatchFlag'="Y"
	.s InStockID=$P($G(^DHCEQInStockList(RowID)),"^",1)
	.s InStockNo=$P($G(^DHCEQInStock(InStockID)),"^",14)
	.s StatCatID=$P($G(^DHCEQInStock(InStockID)),"^",21)
	.q:(StatCatDR'="")&&(StatCatDR'=StatCatID)
	.s Name=$ZCONVERT($P($G(^DHCEQInStockList(RowID)),"^",5),"U")
	.s ItemDR=$P($G(^DHCEQInStockList(RowID)),"^",16)
	.i ItemDR'="" d
	..s Item=$ZCONVERT($P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1),"U")
	..s Code=$ZCONVERT($P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2),"U")
	.q:(Equip'="")&&((Name'[Equip)&&(Item'[Equip)&&(Code'[Equip))
	.//||(Item'[Equip))
	.s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(StockDR,RowID,EquipTypeDR,StatCatDR)
	.q:Quantity=0
	.s ModelDR=$P($G(^DHCEQInStockList(RowID)),"^",9)
	.i ModelDR'="" s Model=$P($G(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	.s ManuFactoryDR=$P($G(^DHCEQInStockList(RowID)),"^",6)
	.i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$P($G(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1) //CZF0093
	.d OutputRowGetInStockList
	quit
OutputRowGetInStockList
	s Data=$lb(Name,RowID,Model,ManuFactory,Quantity,InStockNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (Name,RowID,Model,ManuFactory,Quantity,InStockNo,ItemDR,Item,Code)=""
	quit
}

ClassMethod GetInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListExecute ]
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

ClassMethod GetInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStoreMoveEquipType(StoreMoveDR, Type)
{
	i StoreMoveDR="" q ""
	s EquipTypeDR=$P($G(^DHCEQStoreMove(StoreMoveDR)),"^",15+Type)
	q EquipTypeDR
}

ClassMethod GetOtherData(RowID, Type, EquipType, StatCat, Stock)
{
	s (Model,ModelDR,ManuFactory,ManuFactoryDR,Unit,UnitDR,InStockListDR)=""
	s (Quantity,Fee)=0
	if Type="1" //入库明细
	{
		s ModelDR=$p(^DHCEQInStockList(RowID),"^",9)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQInStockList(RowID),"^",6)
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF00093
		s ISRowID=$p(^DHCEQInStockList(RowID),"^",1)
		//s Stock=$p(^DHCEQInStock(ISRowID),"^",2)
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,RowID,EquipType,StatCat) //$p(^DHCEQInStockList(RowID),"^",8)
		s Fee=$p(^DHCEQInStockList(RowID),"^",7)
		s UnitDR=$p(^DHCEQInStockList(RowID),"^",10)
		s Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s InStockListDR=RowID
	}
	else ///设备
	{
		s ModelDR=$p(^DHCEQEquip(RowID),"^",3)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQEquip(RowID),"^",26)
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF0093
		s UnitDR=$p(^DHCEQEquip(RowID),"^",5)
		s Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s Quantity=1
		s Fee=$p(^DHCEQEquip(RowID),"^",27)
		//s InStockListDR=$p(^DHCEQEquip(RowID),"^",70)
	}
	q ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_UnitDR_"^"_Unit_"^"_Quantity_"^"_Fee_"^"_InStockListDR
}

Query GetStoreMoveDetail(FromLocDR, Status, StartDate, EndDate, MinPrice, MaxPrice, ToLocDR, ModelDR, Name, EquipCatDR, EquipTypeDR, StatCatDR, MoveType) As %Query(ROWSPEC = "TSMRowID:%String,TFromLocDR:%String,TFromLoc:%String,TToLocDR:%String,TToLoc:%String,TSMNo:%String,TMoveDate:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TTotalFee:%String,TEquipCat:%String")
{
}

ClassMethod GetStoreMoveDetailExecute(ByRef qHandle As %Binary, FromLocDR, Status, StartDate, EndDate, MinPrice, MaxPrice, ToLocDR, ModelDR, Name, EquipCatDR, EquipTypeDR, StatCatDR, MoveType) As %Status
{
 	new repid, index,rowid,Total,TotalFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##class(web.DHCEQCommon).KillTempGlobal("StoreMoveDetail")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s Total=0
	s TotalFee=0
	s PNum=1
	s index=2
	s SMRowID=0
	s rowid=0
	d BuildDataGetStoreMoveDetail
	Quit $$$OK
BuildDataGetStoreMoveDetail
	i FromLocDR'=""
	{
		f  s SMRowID=$o(^DHCEQStoreMove(0,"FromLoc",FromLocDR,SMRowID))  quit:SMRowID=""  d
		.s TToLocDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",3)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",13)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TMakeDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		.q:(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneStoreMoveDetail
	}
	else
	{
		f  s SMRowID=$o(^DHCEQStoreMove(SMRowID))  quit:SMRowID=""  d
		.s TToLocDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",3)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",13)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TMakeDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		.q:(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneStoreMoveDetail
	}
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetStoreMoveDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TFromLoc="合计:"
		
		//add by jdl 2009-9-25  JDL0036
		//格式化金额为小数点两位
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
		
		s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("StoreMoveDetail",+$H,$J,PNum)=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat
	}
	quit
GetOneStoreMoveDetail
	d ResetVariablesGetStoreMoveDetail
	s TSMRowID=SMRowID
	s TFromLocDR=$p($G(^DHCEQStoreMove(TSMRowID)),"^",2)
	i TFromLocDR'="" s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	s TToLocDR=$p($G(^DHCEQStoreMove(TSMRowID)),"^",3)
	i TToLocDR'="" s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	s TSMNo=$p($G(^DHCEQStoreMove(TSMRowID)),"^",1)
	s TMoveDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(TSMRowID)),"^",5),"date")
	s TStatCatDR=$p($g(^DHCEQStoreMove(TSMRowID)),"^",17)
	q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR '=""  d
	.s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQStoreMove(TSMRowID)),"^",16)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQStoreMove(TSMRowID)),"^",13)
	;s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"出库审核","3":"入库审核",:"没有定义")
	Set TStatus=##class(web.DHCEQInStock).GetInStockStatus(TStatus)		//20151014  Mozy0166
	q:..EquipIsStoreMove(rowid,Name)
	s TEquipName=$p($G(^DHCEQStoreMoveList(rowid)),"^",5)
	s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
	i TModelDR'="" d
	.s TModel=$P($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TOriginalFee=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
	s TQuantityNum=$p($G(^DHCEQStoreMoveList(rowid)),"^",8)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TUnitDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",10)
	i TUnitDR'="" d
	.s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	
	d OutputRowGetStoreMoveDetail
	quit
OutputRowGetStoreMoveDetail
	s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("StoreMoveDetail",+$H,$J,PNum)=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat
	s PNum=PNum+1
	quit
ResetVariablesGetStoreMoveDetail
	s (TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat)=""
	quit
}

ClassMethod GetStoreMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveDetailExecute ]
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

ClassMethod GetStoreMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 0在此转移单  1不在此转移单
ClassMethod EquipIsStoreMove(SMLID, Name)
{
	i Name="" q 0
	s Name=$ZCONVERT(Name ,"U")
	s SMName=$ZCONVERT($p(^DHCEQStoreMoveList(SMLID),"^",5),"U")
	i SMName[Name q 0
	s EquipID=$p(^DHCEQStoreMoveList(SMLID),"^",2)
	i EquipID=""
	{
		s CSID=$o(^DHCEQChangeStock(0,"Source","1",SMLID,0))
		i CSID="" q 1
		s EquipID=$p(^DHCEQChangeStock(CSID),"^",1)
	}
	s Code=$ZCONVERT($p(^DHCEQEquip(EquipID),"^",6),"U")
	i Code[Name q 0
	q 1
}

/// -------------------------------
/// 创建：zy 2009-11-18   ZY0017
/// 描述:取到打印导出的查询信息
/// -------------------------------
ClassMethod GetOneStoreMoveStat(PNum, job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("StoreMoveStat",User,job,""),-1)
	q $g(^DHCEQTemp("StoreMoveStat",User,job,PNum))
}

/// modified by ZY0286 增加制单人输出
/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 描述:保存查询的信息到临时Global中,为保存导出提供数据
/// -------------------------------
/// 转移明细统计
/// Modify by zx 2020-08-20 BUG ZX0102 增加供货商查询及供货商和发票号显示
Query GetStoreMoveStat(vData As %String = "") As %Query(ROWSPEC = "TSMRowID:%String,TFromLocDR:%String,TFromLoc:%String,TToLocDR:%String,TToLoc:%String,TSMNo:%String,TMoveDate:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TTotalFee:%String,TEquipCat:%String,TInStockNo:%String,TOrigin:%String,TEquipNo:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TLocationDR:%String,TLocation:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TCommonName:%String,TRow:%String,TRemark:%String,TInvoiceNos:%String,TProvider:%String,TContractNo:%String,TMaker:%String,TAuditDate:%String")
{
}

ClassMethod GetStoreMoveStatExecute(ByRef qHandle As %Binary, vData As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    //modified by ZY 20220928
    //k ^DHCEQTemp("StoreMoveStat",User)
 	///d ..KillTempGlobal("StoreMoveStat")
 	/********************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set FromLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FromLocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")	
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set EquipCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")	
	Set ToLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToLocDR")
	Set MoveType=##Class(web.DHCEQCommon).GetDataByName(vData,"MoveType")
	Set StoreMoveNo=##Class(web.DHCEQCommon).GetDataByName(vData,"StoreMoveNo")
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")
	Set InStockNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockNo")
	Set Flag=##Class(web.DHCEQCommon).GetDataByName(vData,"Flag")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set ContractNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")		//czf 20200818
	Set IsPrintDR=##Class(web.DHCEQCommon).GetDataByName(vData,"IsPrintDR")   ;Add By QW20210422 bug:QW0100
	Set LeaveFactoryNo=##Class(web.DHCEQCommon).GetDataByName(vData,"LeaveFactoryNo") //Modify by zx 2020-05-19 Bug 1880109
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
	Set QXType=##Class(web.DHCEQCommon).GetDataByName(vData,"QXType")
	Set ApproveRoleDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ApproveRoleDR")
	
	i ##Class(web.DHCEQCommon).ExistsElement(vData,"InvalidFlag")
	{
		Set InvalidFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"InvalidFlag")
	}
	else
	{
		Set InvalidFlag="N"
	}
	s EquipTypeValues=""
	i Flag="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	//i StartDate'="" s StartDate=$ZDH(StartDate,4)
	//i EndDate'="" s EndDate=$ZDH(EndDate,4)
	// 日期格式统一调整 mwz 2017-3-2
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	// MZY0157	3412819		2023-03-29
	Set SAuditDate=##Class(web.DHCEQCommon).GetDataByName(vData,"SAuditDate")
	Set EAuditDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EAuditDate")
	s SAuditDate=##class(web.DHCEQCommon).TransValueFromPage(SAuditDate,"date")
	s EAuditDate=##class(web.DHCEQCommon).TransValueFromPage(EAuditDate,"date")
 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s Total=0
	s TotalFee=0
	s PNum=1
	s index=2
	s SMRowID=0
	s rowid=0
	s TJob=$J
    //modified by ZY 20220928
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("StoreMoveStat",TJob,User)
	d BuildDataGetStoreMoveStat
	Quit $$$OK
BuildDataGetStoreMoveStat
	i vData="" q
	i StartDate>EndDate q
	i FromLocDR'=""
	{
		// MZY0130	2775872		2022-07-27
		s SMRowID=""
		f  s SMRowID=$o(^DHCEQStoreMove(0,"FromLoc",FromLocDR,SMRowID),-1)  quit:SMRowID=""  d
		.s TToLocDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",3)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",13)
		.q:(Status'="")&&(TStatusDR'=Status)
		.;q:TStatusDR'=3
		.
		.s TMakeDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TInAckDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
		.;q:(TInAckDate>EndDate)||(TInAckDate<StartDate)
		.
		.s TMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		.q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
		.q:(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneStoreMoveStat
	}
	else
	{
		// MZY0130	2775872		2022-07-27
		s SMRowID=""
		f  s SMRowID=$o(^DHCEQStoreMove(SMRowID),-1) quit:(SMRowID="")||(SMRowID=0)  d
		.s TToLocDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",3)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQStoreMove(SMRowID)),"^",13)
		.q:(Status'="")&&(TStatusDR'=Status)
		.;q:TStatusDR'=3
		.
		.s TMakeDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TInAckDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
		.;q:(TInAckDate>EndDate)||(TInAckDate<StartDate)
		.
		.s TMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
		.q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
		.q:(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
		..q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneStoreMoveStat
	}
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")  //将'401001'改为'301006'. Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetStoreMoveStat
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TRow="合计:"		
		//add by jdl 2009-9-25  JDL0036
		.//格式化金额为小数点两位
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
		//s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat,TInStockNo,TOrigin,TEquipNo,TJob,TApproveStep,TApproveRole,TLocationDR,TLocation,THold1,THold2,THold3,THold4,THold5,TCommonName,TRow,TRemark,TInvoiceNos,TProvider,TContractNo,TMaker)
		//Set ^CacheTemp(repid,TotalLoc)=Data
        //modified by ZY 20220928
        //Set ^DHCEQTemp("StoreMoveStat",User,TJob,PNum)=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat_"^"_TInStockNo_"^"_TOrigin_"^"_TEquipNo_"^"_TLocation_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TCommonName_"^"_TInvoiceNos_"^"_TProvider_"^"_TContractNo_"^"_TMaker
        s tmpValue=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat_"^"_TInStockNo_"^"_TOrigin_"^"_TEquipNo_"^"_TLocation_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TCommonName_"^"_TInvoiceNos_"^"_TProvider_"^"_TContractNo_"^"_TMaker_"^"_TAuditDate	// MZY0157	3412819		2023-03-29
        d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("StoreMoveStat",+$H,TJob,User,PNum,tmpValue)
	}
	quit
GetOneStoreMoveStat
	d ResetVariablesGetStoreMoveStat
	s TSMRowID=SMRowID
	s SMFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	i SMFlag="" s SMFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=SMFlag)
	s TStoreMoveNo = $p($g(^DHCEQStoreMove(TSMRowID)),"^",1)
	q:(StoreMoveNo'="")&&($e(TStoreMoveNo,1,$l(StoreMoveNo))'=StoreMoveNo)
	s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("StoreMove",TSMRowID,EquipNo)
	q:(EquipNo'="")&&(Find=0)
	s TFromLocDR=$p($G(^DHCEQStoreMove(TSMRowID)),"^",2)
	s TToLocDR=$p($G(^DHCEQStoreMove(TSMRowID)),"^",3)
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TToLocDR) ;Add QW20210629 BUG:QW0131
	q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	;MZY0021	1304164		2020-05-06
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","","","","",TFromLocDR)'=0)&&(##Class(web.DHCEQCommon).CheckManageLimit("","","","","","",TToLocDR)'=0)
	;Add By QW20210422 bug:QW0100
	s TPrintNum=##class(web.DHCEQ.Plat.BUSOperateLog).GetOperateTimes("22",TSMRowID) ;Modified By QW20210913 BUG:QW0147 修改打印次数
	q:(IsPrintDR="1")&&(TPrintNum=0) 
	q:(IsPrintDR="0")&&(TPrintNum'=0) 
	;Add By QW20210422 bug:QW0100
	s TempFlag=0																		//modified GR0018 2014-12-01 改Flag为TempFlag 解决局部变量重名
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromLocDR))) s TempFlag=TempFlag+1 //2010-10-26 DJ
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR))) s TempFlag=TempFlag+1 //2010-10-26 DJ
	q:TempFlag=2																		//GR0018 end
	i TFromLocDR'="" s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	i TToLocDR'="" s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	s TSMNo=$p($G(^DHCEQStoreMove(TSMRowID)),"^",1)
	s TMoveDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(TSMRowID)),"^",5),"date")
	;s TStatCatDR=$p($g(^DHCEQStoreMove(TSMRowID)),"^",17)
	;q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	;i TStatCatDR '=""  d
	;.s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQStoreMove(TSMRowID)),"^",16)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQStoreMove(TSMRowID)),"^",13)
	
	q:..EquipIsStoreMove(rowid,Name)
	s result=##class(web.DHCEQCommon).FundsTypeIsIn(4,rowid)	// Mozy0231	资金来源类型
	q:+result'=0
	
	s TMakerDR=$p($g(^DHCEQStoreMove(TSMRowID)),"^",4)
	s TMaker=##class(web.DHCEQCommon).GetTrakNameByID("user", TMakerDR)
	
	s TCommonName=$p($G(^DHCEQStoreMoveList(rowid)),"^",5)	//2013-06-24 DJ0118 begin
	s EquipDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",2)
	s InStockListDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",4)
	i InStockListDR'=""  d
	.s TEquipName=$p($g(^DHCEQInStockList(InStockListDR)),"^",16)
	e  d
	.s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	i TEquipName'="" s TEquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquipName)),"^",1) //2013-06-24 DJ0118 end
	s TModelDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",9)
	i TModelDR'="" d
	.s TModel=$P($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TOriginalFee=$p($G(^DHCEQStoreMoveList(rowid)),"^",7)
	s TQuantityNum=$p($G(^DHCEQStoreMoveList(rowid)),"^",8)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TUnitDR=$p($G(^DHCEQStoreMoveList(rowid)),"^",10)
	i TUnitDR'="" d
	.s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	;过滤配置设备统计	// Mozy0217  2018-11-01
	//Modify by zx 2021-05-19 1880109 合计放在退出条件后
	;i $p($g(^DHCEQStoreMoveList(rowid)),"^",15)="" d
	;.s Total=Total+TQuantityNum
	;.s TotalFee=TotalFee+TTotalFee
	Set TInStockNo=""
	Set TOrigin=""
	Set TEquipNo=""
	Set TVendor=""
	Set TStatCatDR=""
	Set TContractNo=""
	;Set TempFlag=0			//modified GR0018 2014-12-01 改Flag为TempFlag 解决局部变量重名
	Set TLeaveFactoryNo=""	//2013-01-10 DJ
	
	Set BatchFlag=$Piece(^DHCEQStoreMoveList(rowid),"^",3)
	If BatchFlag="Y" Do
	.Set RowIDs=$Get(^DHCEQStoreMoveList(rowid,"EX","RowIDs"))
	.Set equipRowIDs=RowIDs
	Else  Do
	.Set EquipDR=$Piece(^DHCEQStoreMoveList(rowid),"^",2)
	.Set equipRowIDs=EquipDR
	
	Set count=$length(equipRowIDs,",")
	For i=1:1:count Do
	.;Quit:TempFlag'=0			//modified GR0018 2014-12-01 改Flag为TempFlag 解决局部变量重名
	.Set TEquipDR=$Piece(equipRowIDs,",",i)
	.If TEquipDR'=""  Do
	..If TEquipNo'="" Set TEquipNo=TEquipNo_","
	..Set TEquipNo=TEquipNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	..If TLeaveFactoryNo'="" Set TLeaveFactoryNo=TLeaveFactoryNo_","
	..Set TLeaveFactoryNo=TLeaveFactoryNo_$Piece($Get(^DHCEQEquip(TEquipDR)),"^",10)
	..
	..Set TInStockListDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",70)
	..Set TStatCatDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",75)
	..Set TOrigin=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",20)
	..If $Piece($Get(^DHCEQEquip(TEquipDR)),"^",25)'="" Set TVendor=##Class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",25))
	..Set TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$Piece($Get(^DHCEQEquip(TEquipDR)),"^",4))	// MZY0125	2617494		2022-06-08
	..;Set TInStockListDR=$Piece($Get(^DHCEQStoreMoveList(rowid)),"^",4)   ;2014-01-03  Mozy0115
	..If TInStockListDR'="" Do
	...Set TInStockDR=$Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	...Set TInStockNo=$Piece($Get(^DHCEQInStock(TInStockDR)),"^",14)
	...//Modify by zx 2020-08-20
	...;Set TInvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,TInStockDR)
	...;Set TInvoiceNos=$p(TInvoiceInfo,"^",1)
	...Set TInvoiceNos=##class(web.DHCEQCommon).GetInvoiceNo(1,TInStockListDR)		//czf 2022-07-01
	...Set TProviderDR=$Piece($Get(^DHCEQInStock(TInStockDR)),"^",17)
	...If TProviderDR'="" Set TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov", TProviderDR)
	..s ConNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",76)		//add by czf 20200818 begin 1476413
	..s contractlistdr=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",32)
	..i (contractlistdr'="")&&(ConNo="") d
	...s contractdr=$Piece($Get(^DHCEQContractList(contractlistdr)),"^",1)
	...s ConNo=$Piece($Get(^DHCEQContract(contractdr)),"^",2)
	..i TContractNo="" s TContractNo=ConNo
	..e  i ((","_TContractNo_",")'[(","_ConNo_",")) s TContractNo=TContractNo_","_ConNo
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	q:(ContractNo'="")&&((","_TContractNo_",")'[(","_ContractNo_","))
	//Modify by zx 2020-05-19 Bug 1880109
	q:(LeaveFactoryNo'="")&&(TLeaveFactoryNo'[LeaveFactoryNo)
	Set TEquipNo=##Class(web.DHCEQCommon).NoToGroupNo(TEquipNo)	// 20150914  Mozy0165
	i TOrigin'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOrigin)),"^",2)
	q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR '="" s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	//Modify by zx 2021-05-19 1880109 合计放在退出条件后
	;i $p($g(^DHCEQStoreMoveList(rowid)),"^",15)="" d
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	i TStatus'=0
	{
		s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("14",TSMRowID)
		i ApproveInfo'=""
		{
			s TApproveRole=$p(ApproveInfo,"^",9)
			s TApproveStep=$p(ApproveInfo,"^",5)
		}
	}
	;s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"出库审核","3":"入库审核","9":"管理审核",:"没有定义")
	Set TStatus=##class(web.DHCEQInStock).GetInStockStatus(TStatus)		//20151014  Mozy0166
	//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
	s TLocationDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",12)
	i TLocationDR'="" s TLocation = $p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	s THold1 = $p($g(^DHCEQStoreMoveList(rowid)),"^",13)
	s THold2 = $p($g(^DHCEQStoreMoveList(rowid)),"^",14)
	s THold3 = $p($g(^DHCEQStoreMoveList(rowid)),"^",15)
	s THold4 = $p($g(^DHCEQStoreMoveList(rowid)),"^",16)
	s THold5 = $p($g(^DHCEQStoreMoveList(rowid)),"^",17)
	//s TRemark=$p($g(^DHCEQStoreMoveList(rowid)),"^",11)		//Add By DJ 2015-09-21 DJ0165
    s TRemark=$p($g(^DHCEQStoreMove(SMRowID)),"^",14)       //Add By DJ 2015-09-21 DJ0165
    // MZY0157	3412819		2023-03-29
    s auditflag=0
	s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,SMRowID,0))
	i AIRowID'="" d
	.s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	.i TApproveRole'="" d
	..s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)
	..i TApproveRole=ApproveRoleDR d
	...s ALRowID=$o(^DHCEQApproveList("0","ApproveRole",ApproveType,SMRowID,TApproveRole,""),-1)
	...i ALRowID'="" d
	....i (SAuditDate'="")&&($p($g(^DHCEQApproveList(ALRowID)),"^",7)<SAuditDate) s auditflag=1
	....i (EAuditDate'="")&&($p($g(^DHCEQApproveList(ALRowID)),"^",7)>EAuditDate) s auditflag=1
	....s TAuditDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",7),"date")
	....s TAuditDate=TAuditDate_"  "_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQApproveList(ALRowID)),"^",8),"time")
	q:auditflag'=0
	q:((SAuditDate'="")||(EAuditDate'=""))&&(TAuditDate="")
	d OutputRowGetStoreMoveStat
	quit
OutputRowGetStoreMoveStat
	s TRow=PNum
	s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat,TInStockNo,TOrigin,TEquipNo,TJob,TApproveStep,TApproveRole,TLocationDR,TLocation,THold1,THold2,THold3,THold4,THold5,TCommonName,TRow,TRemark,TInvoiceNos,TProvider,TContractNo,TMaker,TAuditDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
    //modified by ZY 20220928
    //Set ^DHCEQTemp("StoreMoveStat",User,TJob,PNum)=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat_"^"_TInStockNo_"^"_TOrigin_"^"_TEquipNo_"^"_TLocation_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TCommonName_"^"_TInvoiceNos_"^"_TProvider_"^"_TContractNo_"^"_TMaker
    s tmpValue=TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat_"^"_TInStockNo_"^"_TOrigin_"^"_TEquipNo_"^"_TLocation_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TCommonName_"^"_TInvoiceNos_"^"_TProvider_"^"_TContractNo_"^"_TMaker
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("StoreMoveStat",+$H,TJob,User,PNum,tmpValue)
	s PNum=PNum+1
	quit
ResetVariablesGetStoreMoveStat
	s (TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMoveDate,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TTotalFee,TEquipCat,TInStockNo,TOrigin,TEquipNo,TApproveStep,TApproveRole,TLocationDR,TLocation,THold1,THold2,THold3,THold4,THold5,TCommonName,TRow,TRemark,TInvoiceInfo,TInvoiceNos,TProviderDR,TProvider,TContractNo,TMaker,TAuditDate)=""	// MZY0157	3412819		2023-03-29
	quit
}

ClassMethod GetStoreMoveStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveStatExecute ]
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

ClassMethod GetStoreMoveStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2011-07-20 DJ
/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetNum(node As %Library.String = "", job)
{
	q ..GetOneStoreMoveStat(0,job)
}

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneStoreMoveStat(gnum,job)
}

/*********************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveList","GetFirstMove","","2020-1-9")
Query GetFirstMove(StartDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TModel:%String,TEquipType:%String,TStatCat:%String,TEquipeCat:%String,TOriginalFee:%String,TStoreMoveNo:%String,TInStockNo:%String,TStoreMoveDate:%String,TFromStoreLoc:%String,TToStoreLoc:%String,TSourceID:%String,TJob:%String,TEquipeCode:%String,TCommonName:%String,TRow:%String,TABCType:%String,TFileNo:%String,TProvider:%String,TManuFactory:%String")
{
}

ClassMethod GetFirstMoveExecute(ByRef qHandle As %Binary, StartDate, EndDate) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")  ;hisui改造 modified by kdf 2018-06-15 日期格式修改
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  ;hisui改造 modified by kdf 日期格式修改
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
 	s StartDate=StartDate-1  //add by lmm 357444
 	s TJob=$J
 	s index=1
 	s PNum=1
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("FirstMove",User)
	d BuildDataGetFirstMove
	Quit $$$OK
BuildDataGetFirstMove
	f  s StartDate=$o(^DHCEQLifeInfo(0,"AppendType","22","0",StartDate)) q:(StartDate="")||(StartDate>EndDate)  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQLifeInfo(0,"AppendType","22","0",StartDate,rowid))  q:rowid=""  d
	..d ResetVariablesGetFirstMove
	..s TRowID=rowid
	..s TEquipDR=$p($g(^DHCEQLifeInfo(rowid)),"^",1)
	..//modified by ZY0239 首次出库的逻辑需要过滤无效掉的业务单据
	..q:$p($g(^DHCEQLifeInfo(rowid)),"^",30)="Y"
	..q:..CheckFirstMove(rowid,TEquipDR)'=1	;判断该设备是否首次出库
	..s InvalidFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",59)   //add by czf 需求号：349883
	..q:InvalidFlag'="N"
	..s TCommonName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)	//2013-06-24 DJ0118 begin
	..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	..i TEquipName'="" s TEquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquipName)),"^",1) //2013-06-24 DJ0118 end
	..s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s ModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i ModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s EquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR))
	..i EquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	..s StatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	..i StatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	..s EquipeCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",4)
	..i EquipeCatDR'=""  d
	...s TEquipeCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipeCatDR)),"^",1)
	...s TEquipeCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipeCatDR)),"^",2)
	..s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	..s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	..s TOriginalFee=$p($g(^DHCEQLifeInfo(rowid)),"^",6)
	..s FromStoreLocDR=$p($g(^DHCEQLifeInfo(rowid)),"^",5)
	..i FromStoreLocDR'="" s TFromStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", FromStoreLocDR)
	..s ToStoreLocDR=$p($g(^DHCEQLifeInfo(rowid)),"^",10)
	..i ToStoreLocDR'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", ToStoreLocDR)
	..s TSourceID=$p($g(^DHCEQLifeInfo(rowid)),"^",20)
	..;过滤已作废的转移 add by wy 2020-1-9 1170863
	..q:(TSourceID'="")&&( $p($g(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(TSourceID)),"^",1))),"^",27)="Y")&&($p($g(^DHCEQStoreMoveList(TSourceID)),"^",1)'="")
	..;s TReduceNum=0
	..;i (TSourceID'="") d
	...;s TReduceValue=##Class(web.DHCEQStoreMoveNew).GetReturnInfoOfSMList(TSourceID,TEquipDR)		//czf 2022-07-01
	...;s TReduceNum=$p(TReduceValue,"^",1)
	..;q:+TReduceNum>0
	..i TSourceID'=""  d
	...s InStockListDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4)
	...s SMRowID=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",1)
	...i SMRowID'=""  d
	....s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	....s TStoreMoveDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",10),"date")
	...i InStockListDR="" s InStockListDR=$p($g(^DHCEQEquip(TEquipDR)),"^",70)	;单台设备转移取台账入库明细
	...i InStockListDR'=""  d
	....s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	....i InStockDR'=""  d
	.....s TInStockNo=$p($g(^DHCEQInStock(InStockDR)),"^",14)
	..s TRow=PNum
	..;ABC分类													//modified by czf 2020-11-05 1560648 begin
	..;If TOriginalFee>80000 Set TABCType="A"
	..;If (TOriginalFee>10000)&(TABCType="") Set TABCType="B"
	..;If (TOriginalFee>1000)&(TABCType="") Set TABCType="C"
	..;If TABCType="" Set TABCType="D"
	..Set TABCType="A"
	..s SplitFlag=##class(web.DHCEQCommon).GetSysInfo("201013")
	..i SplitFlag="" s SplitFlag="100000,10000"
	..If TOriginalFee<+$p(SplitFlag,",",1) Set TABCType="B"
	..If TOriginalFee<+$p(SplitFlag,",",2) Set TABCType="C"
	..If TOriginalFee<+$p(SplitFlag,",",3) Set TABCType="D"		//modified by czf 2020-11-05 1560648 end
	..Set TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
	..i TProviderDR '="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..i TManuFactoryDR '="" s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	..d OutputRowGetFirstMove
	quit
OutputRowGetFirstMove
	Set Data=$lb(TRowID,TEquipDR,TEquipName,TEquipNo,TModel,TEquipType,TStatCat,TEquipeCat,TOriginalFee,TStoreMoveNo,TInStockNo,TStoreMoveDate,TFromStoreLoc,TToStoreLoc,TSourceID,TJob,TEquipeCode,TCommonName,TRow,TABCType,TFileNo,TProvider,TManuFactory)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("FirstMove",User,TJob,PNum)=TRowID_"^"_TEquipDR_"^"_TEquipName_"^"_TEquipNo_"^"_TModel_"^"_TEquipType_"^"_TStatCat_"^"_TEquipeCat_"^"_TOriginalFee_"^"_TStoreMoveNo_"^"_TInStockNo_"^"_TStoreMoveDate_"^"_TFromStoreLoc_"^"_TToStoreLoc_"^"_TSourceID_"^"_TEquipeCode_"^"_TCommonName_"^"_TABCType_"^"_TFileNo_"^"_TProvider_"^"_TManuFactory
	Set PNum=PNum+1
	quit
ResetVariablesGetFirstMove
	s (TRowID,TEquipDR,TEquipName,TEquipNo,TModel,TEquipType,TStatCat,TEquipeCat,TOriginalFee,TStoreMoveNo,TInStockNo,TStoreMoveDate,TFromStoreLoc,TToStoreLoc,TSourceID,TEquipeCode,TCommonName,TRow,TABCType,TFileNo,TProvider,TManuFactory)=""
	quit
}

ClassMethod GetFirstMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFirstMoveExecute ]
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

ClassMethod GetFirstMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFirstMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by mwz  2018-11-06 
/// 描述：科室领用资产汇总报表
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveList","GetFirstMoveRQ","","","","","","06/01/2018","06/11/2018",3,8,19)
Query GetFirstMoveRQ(QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TModel:%String,TEquipType:%String,TStatCat:%String,TEquipeCat:%String,TOriginalFee:%String,TStoreMoveNo:%String,TInStockNo:%String,TStoreMoveDate:%String,TFromStoreLoc:%String,TToStoreLoc:%String,TSourceID:%String,TJob:%String,TEquipeCode:%String,TCommonName:%String,TRow:%String,TABCType:%String,TFileNo:%String,TProvider:%String,TManuFactory:%String,TQuantity:%String") [ SqlProc ]
{
}

ClassMethod GetFirstMoveRQExecute(ByRef qHandle As %Binary, QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", StartDate As %String = "", EndDate As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	i (StartDate="")||(EndDate="")  quit $$$OK
 	i StartDate=""  s StartDate=0 
 	e  s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	i EndDate=""  s EndDate=+$H
 	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	k ^DHCEQTempSMTKList
	d BuildDataGetFirstMoveRQ
	k ^DHCEQTempSMTKList
	Quit $$$OK
BuildDataGetFirstMoveRQ
    s StartDate=StartDate-1    //add by mwz 20200529 MWZ0040
	f  s StartDate=$o(^DHCEQLifeInfo(0,"AppendType","22","0",StartDate)) q:(StartDate="")||(StartDate>EndDate)  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQLifeInfo(0,"AppendType","22","0",StartDate,rowid))  q:rowid=""  d
	..d ResetVariablesGetFirstMoveRQ
	..s TRowID=rowid
	..//modified by ZY0239 首次出库的逻辑需要过滤无效掉的业务单据
	..q:$p($g(^DHCEQLifeInfo(rowid)),"^",30)="Y"
	..s TEquipDR=$p($g(^DHCEQLifeInfo(rowid)),"^",1)
	..q:..CheckFirstMove(rowid,TEquipDR)'=1	;判断该设备是否首次出库
	..s InvalidFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",59)   
	..q:InvalidFlag'="N"
	..s TCommonName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)	
	..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	..i TEquipName'="" s TEquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquipName)),"^",1)
	..s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s ModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i ModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	..q:((EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR))
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
	..i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..s StatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	..i StatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	..s EquipeCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",4)
	..i EquipeCatDR'=""  d
	...s TEquipeCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipeCatDR)),"^",1)
	...s TEquipeCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipeCatDR)),"^",2)
	..s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	..s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	..s TOriginalFee=$p($g(^DHCEQLifeInfo(rowid)),"^",6)
	..s FromStoreLocDR=$p($g(^DHCEQLifeInfo(rowid)),"^",5)
	..q:((FromLocDR'="")&&(FromStoreLocDR'=FromLocDR))
	..i FromStoreLocDR'="" s TFromStoreLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",FromStoreLocDR)),"^",2),"-")   //add by wy 2020-10-12 CTLOC转换成DHCEQCDepartment bug WY0081 
	..s ToStoreLocDR=$p($g(^DHCEQLifeInfo(rowid)),"^",10)
	..q:((ToLocDR'="")&&(ToStoreLocDR'=ToLocDR))
	..i ToStoreLocDR'="" s TToStoreLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",ToStoreLocDR)),"^",2),"-")
	..s TSourceID=$p($g(^DHCEQLifeInfo(rowid)),"^",20)
	..s TReduceNum=0
	..i (TSourceID'="") d
	...s TReduceValue=##Class(web.DHCEQStoreMoveNew).GetReturnInfoOfSMList(TSourceID,TEquipDR)		//czf 2023-05-09 beign
	...s TReduceNum=$p(TReduceValue,"^",1)
	...s TOutNum=$p(TReduceValue,"^",3)
	...s TReduceNum=TReduceNum-TOutNum		//实际退库数量 czf 2023-05-09 end
 	...;d ##Class(web.DHCEQStoreMoveNew).GetStoreMoveListLinkTKID(TSourceID,TEquipDR)	//czf 2022-07-01 beign
 	...;s TKListID=$g(^DHCEQTempSMTKList("TKList",TSourceID,TEquipDR))
 	...;i TKListID'="" s TReduceNum=1		//czf 2022-07-01 beign
	..q:+TReduceNum>0
	..s SMRowID=""
	..i TSourceID'=""  d
	...s InStockListDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4)
	...s SMRowID=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",1)
	...i SMRowID'=""  d
	....s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	....s TStoreMoveDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",10),"date")
	...i InStockListDR="" s InStockListDR=$p($g(^DHCEQEquip(TEquipDR)),"^",70)	;单台设备转移取台账入库明细
	...i InStockListDR'=""  d
	....s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	....i InStockDR'=""  d
	.....s TInStockNo=$p($g(^DHCEQInStock(InStockDR)),"^",14)
	..q:(SMRowID'="")&&($p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2)		//czf 2021-11-4
	..q:(SMRowID'="")&&($p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y")
	..s TQuantity=1
	..i TProviderDR '="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..i TManuFactoryDR '="" s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	..d OutputRowGetFirstMoveRQ
	quit
OutputRowGetFirstMoveRQ
	Set Data=$lb(TRowID,TEquipDR,TEquipName,TEquipNo,TModel,TEquipType,TStatCat,TEquipeCat,TOriginalFee,TStoreMoveNo,TInStockNo,TStoreMoveDate,TFromStoreLoc,TToStoreLoc,TSourceID,TJob,TEquipeCode,TCommonName,TRow,TABCType,TFileNo,TProvider,TManuFactory,TQuantity)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesGetFirstMoveRQ
	s (TRowID,TEquipDR,TEquipName,TEquipNo,TModel,TEquipType,TStatCat,TEquipeCat,TOriginalFee,TStoreMoveNo,TInStockNo,TStoreMoveDate,TFromStoreLoc,TToStoreLoc,TSourceID,TEquipeCode,TCommonName,TRow,TABCType,TFileNo,TProvider,TManuFactory,TQuantity)=""
	quit
}

ClassMethod GetFirstMoveRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFirstMoveRQExecute ]
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

ClassMethod GetFirstMoveRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFirstMoveRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFirstMoveNum(node As %Library.String = "", job)
{
	q ..GetOneFirstMove(0,job)
}

ClassMethod GetFirstMoveList(node As %Library.String = "", job, gnum)
{
	q ..GetOneFirstMove(gnum,job)
}

ClassMethod GetOneFirstMove(PNum, job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("FirstMove",User,job,""),-1)
	q $g(^DHCEQTemp("FirstMove",User,job,PNum))
}

/*********************************************************************/
/// //modified by ZY0239 首次出库的逻辑需要过滤无效掉的业务单据
/// Add By DJ 2015-09-30
/// 描述:判断是否首次出库
/// 入参:vLifeInfoDR  生命周期表RowID        vEquipDR   设备RowID
/// 返回值:0表示不是首次出库 1表示是首次出库
/// w ##CLass(web.DHCEQStoreMoveList).CheckFirstMove(9,9)
ClassMethod CheckFirstMove(vLifeInfoDR, vEquipDR)
{
	n ChangeDate,ChangeDateRowID,StartDate,FindFlag
	s FindFlag=""
	
	i ((vLifeInfoDR="")||(vEquipDR=""))  q 0
	s StartDate=$p($g(^DHCEQLifeInfo(vLifeInfoDR)),"^",15)
	s ChangeDate=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,"22",StartDate),-1)
	i ChangeDate=""
	{
		
	}else
	{
		s ChangeDateRowID=vLifeInfoDR
		f  s ChangeDateRowID=$o(^DHCEQLifeInfo(0,"EquipSourceDate",vEquipDR,"22",StartDate,ChangeDateRowID),-1) q:ChangeDateRowID=""||(FindFlag'="")  d
		.q:$p($g(^DHCEQLifeInfo(ChangeDateRowID)),"^",30)="Y"
		.s FindFlag=ChangeDateRowID
		i FindFlag'="" q 0
	}
	
	q 1
}

/// czf 2022-07-05
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// w ##Class(web.DHCEQStoreMoveList).GetSumInfo(27232)
ClassMethod GetSumInfo(Ejob As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	
	s nrowid=0	
	f  s nrowid=$o(^DHCEQTemp("StoreMoveStat",curuser,Ejob,nrowid)) q:nrowid=""  d
	.q:$p($g(^DHCEQTemp("StoreMoveStat",curuser,Ejob,nrowid)),"^",1)=""	;TRowID
	.s OriginalFee=$p($g(^DHCEQTemp("StoreMoveStat",curuser,Ejob,nrowid)),"^",16)
	.s Quantity=$p($g(^DHCEQTemp("StoreMoveStat",curuser,Ejob,nrowid)),"^",17)
	.s Count=Count+Quantity
	.s TotalFee=TotalFee+(Quantity*OriginalFee)
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
  	
  	q info
}

Storage Default
{
<Data name="DHCEQStoreMoveListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQStoreMoveListD</DataLocation>
<DefaultData>DHCEQStoreMoveListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQStoreMoveListD</IdLocation>
<IndexLocation>^web.DHCEQStoreMoveListI</IndexLocation>
<StreamLocation>^web.DHCEQStoreMoveListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
