Class web.DHCEQOutStockList Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//设备退货单祥单

Parameter SQLCODE = "OSL_RowID";

Parameter SQLDESCRIPTION = "OSL_RowID";

Parameter SQLROWID = "OSL_RowID";

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Type As %Library.String = "")
{
	//Type=1 删除
	//Type=0 插入、更新
	s RowID=$P(val,"^",1)
 	s PLIST(2) = $p(val,"^",2)	;OutStockDR
 	s PLIST(3) = $p(val,"^",3)	;BatchFlag
 	i $p(val,"^",3)'=""  s PLIST(3) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"bool")	;BatchFlag
 	s PLIST(4) = $p(val,"^",4)	;InStockListDR
 	s PLIST(5) = $p(val,"^",5)	;EquipDR
 	s PLIST(6) = $p(val,"^",6)	;OutStockQtyNum
 	s PLIST(7) = $p(val,"^",7)	;OutStockFee
 	s PLIST(8) = $p(val,"^",8)	;InvoiceNo
 	s PLIST(9) = $p(val,"^",9)	;OutStockReasonDR
 	s PLIST(10) = $p(val,"^",10)	;Remark
	TSTART
	if +Type=0
	{
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQOutStockList values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQOutStockList values :PLIST() where OSL_RowID=:RowID)
		}
		s Total=..OutStockHaveEquip(PLIST(2),PLIST(3),PLIST(4),PLIST(5))
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
		&SQL(delete from sqluser.DHC_EQOutStockList where OSL_RowID=:RowID)
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

ClassMethod GetBachFlag(RowID)
{
	i RowID="" q 0
	q $P(^DHCEQOutStockList(RowID),"^",2)
}

ClassMethod OutStockHaveEquip(OutStockDR, BatchFlag, InStockListDR, EquipDR)
{
	s (Total2)=0
	if BatchFlag="Y"
	{
		&SQL(select COUNT(OSL_RowID) into :Total2 from sqluser.DHC_EQOutStockList where OSL_OutStockDR=:OutStockDR and OSL_InStockListDR=:InStockListDR and OSL_BatchFlag=:BatchFlag)
	}
	else
	{
		&SQL(select COUNT(OSL_RowID) into :Total2 from sqluser.DHC_EQOutStockList where OSL_OutStockDR=:OutStockDR and OSL_EquipDR=:EquipDR and OSL_BatchFlag=:BatchFlag)
	}
	i Total2>1 q "本单据已经录入该设备"
	q OutStockDR
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
		i ManuFactoryDR'="" s ManuFactory=$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1)
		s ISRowID=$p(^DHCEQInStockList(RowID),"^",1)
		//s Stock=$p(^DHCEQInStock(ISRowID),"^",2)
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,RowID,EquipType,StatCat) //$p(^DHCEQInStockList(RowID),"^",8)
		s Fee=$p(^DHCEQInStockList(RowID),"^",7)
		s UnitDR=$p(^DHCEQInStockList(RowID),"^",10)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s InStockListDR=RowID
	}
	else ///设备
	{
		s ModelDR=$p(^DHCEQEquip(RowID),"^",3)
		i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
		s ManuFactoryDR=$p(^DHCEQEquip(RowID),"^",26)
		i ManuFactoryDR'="" s ManuFactory=$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1)
		s UnitDR=$p(^DHCEQEquip(RowID),"^",5)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s Quantity=1
		s Fee=$p(^DHCEQEquip(RowID),"^",27)
		s InStockListDR=$p(^DHCEQEquip(RowID),"^",70)
		i InStockListDR'="" s Fee=$p(^DHCEQInStockList(InStockListDR),"^",7)
		s InStockListDR=""
	}
	q ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_UnitDR_"^"_Unit_"^"_Quantity_"^"_Fee_"^"_InStockListDR
}

ClassMethod OutStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutStockListExecute(ByRef qHandle As %Binary, OutStockDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i OutStockDR'="" s StoreLoc=$p($g(^DHCEQOutStock(OutStockDR)),"^",2) //退货科室
	i OutStockDR'="" s EquipType=$p($g(^DHCEQOutStock(OutStockDR)),"^",15) //类组
	i OutStockDR'="" s StatCat=$p($g(^DHCEQOutStock(OutStockDR)),"^",16) //统计分类
	d BuildDataGetOutStockList
	Quit $$$OK
BuildDataGetOutStockList
	if OutStockDR'="" 
	{
	f  s rowid=$o(^DHCEQOutStockList(0,"OutStock",OutStockDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetOutStockList
	.s LRowID = rowid	//rowid
	.s LOutStockDR=$p($g(^DHCEQOutStockList(rowid)),"^",1) //退货单
	.s StatCat=$p($g(^DHCEQOutStock(OutStockDR)),"^",16) //统计分类
	.s LBatchFlag=$p($g(^DHCEQOutStockList(rowid)),"^",2) //批标志
	.s TInStockList=$p($g(^DHCEQOutStockList(rowid)),"^",3) //入库单号
	.i LBatchFlag="N" d
	..s LEquipDR=$p($g(^DHCEQOutStockList(rowid)),"^",4) 
	..i LEquipDR'="" d
	...s LEquip=$p($g(^DHCEQEquip(LEquipDR)),"^",1) //设备名称
	...s TStock=$p($g(^DHCEQEquip(LEquipDR)),"^",67) //库房
	...s TStock=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	...s LModelDR = $p($g(^DHCEQEquip(LEquipDR)),"^",3) //机型
	...i LModelDR'="" s LMModel=$p($g(^DHCEQCCode("DHCEQCModel",LModelDR)),"^",2)
	...s LManuFactoryDR = $p($g(^DHCEQEquip(LEquipDR)),"^",26) //生产厂商
	...i LManuFactoryDR'="" s LManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",LManuFactoryDR)),"^",1)
	.i LBatchFlag="Y" d
	..s LEquipDR=$p($g(^DHCEQOutStockList(rowid)),"^",3) 
	..i LEquipDR'="" d
	...i TInStockList'="" s TOutStockNum=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(StoreLoc,TInStockList,EquipType,StatCat)
	...s LEquip=$p($g(^DHCEQInStockList(LEquipDR)),"^",5) //设备名称
	...s LModelDR =$p($g(^DHCEQInStockList(LEquipDR)),"^",9) //机型
	...i LModelDR'="" s LMModel=$p($g(^DHCEQCCode("DHCEQCModel",LModelDR)),"^",2)
	...s LManuFactoryDR =$p($g(^DHCEQInStockList(LEquipDR)),"^",6) //生产厂商
	...i LManuFactoryDR'="" s LManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",LManuFactoryDR)),"^",1)
	.s LOutStockQtyNum=$p($g(^DHCEQOutStockList(rowid)),"^",5) //退货数量
	.s LOutStockFee=$p($g(^DHCEQOutStockList(rowid)),"^",6) //退货金额
	.s TTotalFee=LOutStockQtyNum*LOutStockFee
	.s LInvoiceNo=$p($g(^DHCEQOutStockList(rowid)),"^",7) //发票号
	.s LOutStockReasonDR=$p($g(^DHCEQOutStockList(rowid)),"^",8) //退货原因
	.i LOutStockReasonDR'="" s LOutStockReason=$p($g(^DHCEQCCode("DHCEQCOutReason",LOutStockReasonDR)),"^",2) //结果
	.s LRemark=$p($g(^DHCEQOutStockList(rowid)),"^",9) //备注
	.d OutputRowGetOutStockList
	}
	quit
OutputRowGetOutStockList
   s Data=$lb(TTotalFee,TOutStockNum,TStock,LRowID,LOutStockDR,LBatchFlag,LEquip,LMModel,LManuFactory,LOutStockQtyNum,LOutStockFee,LInvoiceNo,LOutStockReason,LRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOutStockList
	s (TTotalFee,TOutStockNum,TStock,LRowID,LOutStockDR,LBatchFlag,LEquip,LMModel,LManuFactory,LOutStockQtyNum,LOutStockFee,LInvoiceNo,LOutStockReason,LRemark)=""
	quit
}

ClassMethod OutStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutStockListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OutStockList(OutStockDR As %String = "") As %Query(ROWSPEC = "TTotalFee:%String,TOutStockNum:%String,TStock:%String,TRowID:%String,TOutStock:%String,TBatchFlag:%String,TEquip:%String,TMModel:%String,TManuFactory:%String,TOutStockQtyNum:%String,TOutStockFee:%String,TInvoiceNo:%String,TOutStockReason:%String,TRemark:%String")
{
}

ClassMethod GetID(rowid As %Library.String = "")
{
	s (ModelDR,Model)=""
	s (ManuFactory,ManuFactory)=""
	s Equip=""
	new result,resultex,Quantity
	s (result,resultex)=""
	s result= ^DHCEQOutStockList(rowid)
	s resultex=resultex_"^"	;OutStockDR
	//i $p(result,"^",1)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQOutStock($p(result,"^",1))),"^",XX)
	//s $p(result,"^",2)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"bool")	;BatchFlag
	s resultex=resultex_"^"	;InStockListDR
	//i $p(result,"^",3)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",3))),"^",XX)
	s resultex=resultex_"^"	;EquipDR
	//i $p(result,"^",4)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",4))),"^",XX)
	s resultex=resultex_"^"	;OutStockReasonDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOutStockReason",$p(result,"^",8))),"^",2)
	i $p(result,"^",2)="Y"
	{
		
		s Equip=$p($g(^DHCEQInStockList($p(result,"^",3))),"^",5)
		s ModelDR=$p($g(^DHCEQInStockList($p(result,"^",3))),"^",9)
		s ManuFactoryDR=$p($g(^DHCEQInStockList($p(result,"^",3))),"^",6)
		
	}
	else
	{
		s Equip=$p($g(^DHCEQEquip($p(result,"^",4))),"^",1)
		s ModelDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",3)
		s ManuFactoryDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",26)
	}
	i ModelDR'="" s Model=$P(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
	i ManuFactoryDR'="" s ManuFactory=$P(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1)
	
	s InStockList=$p(result,"^",3)
	i InStockList'=""
	{
		s OutStockDR=$p(result,"^",1)
		s Stock=$P(^DHCEQOutStock(OutStockDR),"^",2)
		s EquipType=$P(^DHCEQOutStock(OutStockDR),"^",15)
		s StatCat=$P(^DHCEQOutStock(OutStockDR),"^",16)
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,InStockList,EquipType,StatCat)
	}
	else
	{
		s Quantity=1
	}
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q result_resultex_"^"_Equip_"^"_Model_"^"_ManuFactory_"^"_Quantity
}

ClassMethod GetOutStockEquipType(OutStockDR, Type)
{
	i OutStockDR="" q ""
	s EquipTypeDR=$P($G(^DHCEQOutStock(OutStockDR)),"^",14+Type)
	q EquipTypeDR
}

/// 根据科室、设备编号、入库明细号、类组、类型、判断是否可以退（转移）填入的数量
/// Type=1退货，Type=2转移
ClassMethod HaveEquipTotal(LocID, EquipID, InStockListID, EquipType, StatCat, EquipNum, Type, SourceID)
{
	
	i EquipID'=""
	{
		s Had=..EquipIsHad(LocID,EquipID,Type,SourceID)
		q:Had<0 Had
		s InStockListDR=$P(^DHCEQEquip(EquipID),"^",70)
		i InStockListDR="" q 0
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(LocID,InStockListDR,EquipType,StatCat)
		s TotalNum=..InStockListTotal(LocID, InStockListDR,StatCat,EquipType,Type,SourceID)
		i TotalNum'<Quantity q -3003
		q 0
	}
	i InStockListID'=""
	{
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(LocID,InStockListID,EquipType,StatCat)
		s TotalNum=..InStockListTotal(LocID, InStockListID,EquipType,StatCat,Type,SourceID)
		s HaveEquipNum=..EquipInInStockListTotal(InStockListID,LocID,EquipType,StatCat,Type,SourceID)
		i HaveEquipNum+TotalNum'<Quantity q -3003
		i Quantity-(EquipNum+HaveEquipNum+TotalNum)<0 q (HaveEquipNum+TotalNum)-Quantity
		q 0
	}
}

/// 单个设备并且是一批入库的在转移、退货中的总数量
ClassMethod EquipInInStockListTotal(InStockList, Stock, EquipType, StatCat, Type, SourceID)
{
	s Total=0
	s EQRowID=0
	f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",Stock,EquipType,"1","N",InStockList,EQRowID)) q:EQRowID=""  d
	.s StatCatDR=$P(^DHCEQEquip(EQRowID),"^",75)
	.q:StatCatDR'=StatCat
	.s HadOutStock=..EquipIsHad(Stock, EQRowID,Type,SourceID)
	.q:HadOutStock=0
	.s Total=Total+1
	q Total
}

/// 批入库在转移、退货中的中数量
ClassMethod InStockListTotal(LocID, InStockListID, EquipType, StatCat, Type, SourceID)
{
	s OutStockListID=0
	s Total=0
	f  s OutStockListID=$O(^DHCEQOutStockList(0,"InStockList",InStockListID,OutStockListID)) q:OutStockListID=""  d
	.q:(Type="1")&&(SourceID=OutStockListID)
	.s Flag=$P(^DHCEQOutStockList(OutStockListID),"^",2)
	.q:Flag="N"
	.s OutStockID=$P(^DHCEQOutStockList(OutStockListID),"^",1)
	.s Statu=$P(^DHCEQOutStock(OutStockID),"^",13)
	.q:Statu="3"
	.s EquipTypeDR=$P(^DHCEQOutStock(OutStockID),"^",15)
	.q:EquipTypeDR'=EquipType
	.s StatCatDR=$P(^DHCEQOutStock(OutStockID),"^",16)
	.q:StatCatDR'=StatCat
	.s OutStockLoc=$P(^DHCEQOutStock(OutStockID),"^",2)
	.q:OutStockLoc'=LocID
	.s Num=$P(^DHCEQOutStockOutStockList(OutStockListID),"^",5)
	.s Total=Total+Num
	s StoreMoveListID=0
	f  s StoreMoveListID=$O(^DHCEQStoreMoveList(0,"InStockList",InStockListID,StoreMoveListID)) q:StoreMoveListID=""  d
	.q:(Type="2")&&(SourceID=StoreMoveListID)
	.s Flag=$P(^DHCEQStoreMoveList(StoreMoveListID),"^",3)
	.q:Flag="N"
	.s StoreMoveID=$P(^DHCEQStoreMoveList(StoreMoveListID),"^",1)
	.s Statu=$P(^DHCEQStoreMove(StoreMoveID),"^",13)
	.q:Statu>1
	.s EquipTypeDR=$P(^DHCEQStoreMove(StoreMoveID),"^",16)
	.q:EquipTypeDR'=EquipType
	.s StatCatDR=$P(^DHCEQStoreMove(StoreMoveID),"^",17)
	.q:StatCatDR'=StatCat
	.s StoreMoveLoc=$P(^DHCEQStoreMove(StoreMoveID),"^",2)
	.q:StoreMoveLoc'=LocID
	.s Num=$P(^DHCEQStoreMoveList(StoreMoveListID),"^",8)
	.s Total=Total+Num
	q Total
}

/// 单个设备是否在转移、退货中
ClassMethod EquipIsHad(LocID, EquipID, Type, SourceID)
{
	new OutStockID,OutStockLoc,StoreMoveID
	s OutStockListID=0
	s Flag="N"
	f  s OutStockListID=$O(^DHCEQOutStockList(0,"Equip",EquipID,OutStockListID)) q:(OutStockListID="")||(Flag="Y")  d
	.q:(Type="1")&&(SourceID=OutStockListID)
	.q:($P(^DHCEQOutStockList(OutStockListID),"^",2)="Y")
	.s OutStockID=$P(^DHCEQOutStockList(OutStockListID),"^",1)
	.s Statu=$P(^DHCEQOutStock(OutStockID),"^",13)
	.q:Statu="3"
	.s OutStockLoc=$P(^DHCEQOutStock(OutStockID),"^",2)
	.q:OutStockLoc'=LocID
	.s Flag="Y"
	i Flag="Y" q -3001
	s StoreMoveListID=0
	f  s StoreMoveListID=$O(^DHCEQStoreMoveList(0,"Equip",EquipID,StoreMoveListID)) q:StoreMoveListID=""||(Flag="Y")  d
	.q:(Type="2")&&(SourceID=StoreMoveListID)
	.q:($P(^DHCEQStoreMoveList(StoreMoveListID),"^",3)="Y")
	.s StoreMoveID=$P(^DHCEQStoreMoveList(StoreMoveListID),"^",1)
	.s Statu=$P(^DHCEQStoreMove(StoreMoveID),"^",13)
	.q:+Statu>1
	.s StoreMoveLoc=$P(^DHCEQStoreMove(StoreMoveID),"^",2)
	.q:StoreMoveLoc'=LocID
	.s Flag="Y"
	i Flag="Y" q -3002
	q 0
}

Query GetOutStockDetail(Type, LocDR, Status, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, ModelDR, Name, EquipCatDR, EquipTypeDR, StatCatDR) As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TInStockDR:%String")
{
}

ClassMethod GetOutStockDetailExecute(ByRef qHandle As %Binary, Type, LocDR, Status, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, ModelDR, Name, EquipCatDR, EquipTypeDR, StatCatDR) As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("OutStockDetail")
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s index=2
	s ISRowID=0
	s rowid=0
	s Total=0
	s TotalFee=0
	s PNum=1
	d BuildDataGetOutStockDetail
	Quit $$$OK
BuildDataGetOutStockDetail
	
		f  s ISRowID=$o(^DHCEQOutStock(ISRowID))  quit:ISRowID=""  d
		.s TLocDR=$p(^DHCEQOutStock(ISRowID),"^",2)
		.q:(LocDR'="")&&(LocDR'=TLocDR)
		.s TStatusDR=$p(^DHCEQOutStock(ISRowID),"^",13)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TInDate=$p($g(^DHCEQOutStock(ISRowID)),"^",4)
		.q:(TInDate>EndDate)||(TInDate<StartDate)
		.s TEquipTypeDR=$p($g(^DHCEQOutStock(ISRowID)),"^",15)
		.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQOutStockList(0,"OutStock",ISRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p(^DHCEQOutStockList(rowid),"^",6)
		..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
		..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
		..//s TModelDR=$p(^DHCEQOutStockList(rowid),"^",9)
		..//q:(ModelDR'="")&&(TModelDR'=ModelDR)
		..d GetOneInStockDetail
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetOutStockDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TInvoice="合计:"
		s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("OutStockDetail",+$H,$J,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID
		
	}
	quit
GetOneInStockDetail
	d ResetVariablesGetOutStockDetail
	s TISRowID=ISRowID
	s TProviderDR=$p(^DHCEQOutStock(TISRowID),"^",3)
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQOutStock(TISRowID)),"^",4),"date")
	s TISNo=$p(^DHCEQOutStock(TISRowID),"^",1)
	s TLocDR=$p(^DHCEQOutStock(TISRowID),"^",2)
	i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	s TStatCatDR=$p($g(^DHCEQOutStock(TISRowID)),"^",16)
	q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR '=""  d
	.s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQOutStock(TISRowID)),"^",15)
	q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	s result=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQOutStock(TISRowID)),"^",13)
	s TStatus=##class(web.DHCEQOutStock).GetStatu(TStatus)
	q:..EquipIsOutStock(rowid,Name)
	i $p(^DHCEQOutStockList(rowid),"^",2)="Y"
	{
		
		s TEquipName=$p($g(^DHCEQInStockList($p(^DHCEQOutStockList(rowid),"^",3))),"^",5)
		s ModelDR=$p($g(^DHCEQInStockList($p(^DHCEQOutStockList(rowid),"^",3))),"^",9)
		//s ManuFactoryDR=$p($g(^DHCEQInStockList($p(result,"^",3))),"^",6)
		
	}
	else
	{
		s TEquipName=$p($g(^DHCEQEquip($p(^DHCEQOutStockList(rowid),"^",4))),"^",1)
		s ModelDR=$p($g(^DHCEQEquip($p(^DHCEQOutStockList(rowid),"^",4))),"^",3)
		//s ManuFactoryDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",26)
	}
	i TModelDR'="" d
	.s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TOriginalFee=$p(^DHCEQOutStockList(rowid),"^",6)
	s TQuantityNum=$p(^DHCEQOutStockList(rowid),"^",5)
	s TTotalFee=TOriginalFee*TQuantityNum
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	d OutputRowGetOutStockDetail
	quit
OutputRowGetOutStockDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("OutStockDetail",+$H,$J,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID
	Set PNum=PNum+1
	Set index=index+1
	quit
ResetVariablesGetOutStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,InvoiceInfo,TISRowID)=""
	quit
}

ClassMethod GetOutStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutStockDetailExecute ]
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

ClassMethod GetOutStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 0在此退货单  1不在此退货单
ClassMethod EquipIsOutStock(ISLID, Name)
{
	i Name="" q 0
	s Name=$ZCONVERT(Name ,"U")
	i $p(^DHCEQOutStockList(ISLID),"^",2)="Y"
	{
		s Equip=$p($g(^DHCEQInStockList($p(^DHCEQOutStockList(ISLID),"^",3))),"^",5)
		//s ModelDR=$p($g(^DHCEQInStockList($p(^DHCEQOutStockList(ISLID),"^",3))),"^",9)
		//s ManuFactoryDR=$p($g(^DHCEQInStockList($p(^DHCEQOutStockList(ISLID),"^",3))),"^",6)
		
	}
	else
	{
		s Equip=$p($g(^DHCEQEquip($p(^DHCEQOutStockList(ISLID),"^",4))),"^",1)
		//s ModelDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",3)
		//s ManuFactoryDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",26)
	}
	s Equip=$ZCONVERT(Equip ,"U")
	i Equip[Name q 0
	q 1
}

ClassMethod GetOneOutStockDetail(PNum)
{
	i PNum=0 q $o(^DHCEQTemp("OutStockDetail",+$H,$J,""),-1)
	q $g(^DHCEQTemp("OutStockDetail",+$H,$J,PNum))
}

}
