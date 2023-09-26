/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 修改方法：GetReturnDetail,GetOneReturnDetail
/// 描述:增加了变动信息的打印导出功能
/// -------------------------------
Class web.DHCEQReturnList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Type As %Library.String = "")
{
	//Type=1 删除
	//Type=0 插入、更新
	s RowID=$P(val,"^",1)
 	s PLIST(2) = $p(val,"^",2)	;ReturnDR
 	s PLIST(3) = $p(val,"^",3)	;BatchFlag
 	i $p(val,"^",3)'=""  s PLIST(3) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"bool")	;BatchFlag
 	s PLIST(4) = $p(val,"^",4)	;InStockListDR
 	s PLIST(5) = $p(val,"^",5)	;EquipDR
 	s PLIST(6) = $p(val,"^",6)	;ReturnQtyNum
 	s PLIST(7) = $p(val,"^",7)	;ReturnFee
 	s PLIST(8) = $p(val,"^",8)	;InvoiceNo
 	s PLIST(9) = $p(val,"^",9)	;ReturnReasonDR
 	s PLIST(10) = $p(val,"^",10)	;Remark
	TSTART
	if +Type=0
	{
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQReturnList values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQReturnList values :PLIST() where RL_RowID=:RowID)
		}
		s Total=..ReturnHaveEquip(PLIST(2),PLIST(3),PLIST(4),PLIST(5))
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
		&SQL(delete from sqluser.DHC_EQReturnList where RL_RowID=:RowID)
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
	q $P(^DHCEQReturnList(RowID),"^",2)
}

ClassMethod ReturnHaveEquip(ReturnDR, BatchFlag, InStockListDR, EquipDR)
{
	s (Total2)=0
	if BatchFlag="Y"
	{
		&SQL(select COUNT(RL_RowID) into :Total2 from sqluser.DHC_EQReturnList where RL_ReturnDR=:ReturnDR and RL_InStockListDR=:InStockListDR and RL_BatchFlag=:BatchFlag)
	}
	else
	{
		&SQL(select COUNT(RL_RowID) into :Total2 from sqluser.DHC_EQReturnList where RL_ReturnDR=:ReturnDR and RL_EquipDR=:EquipDR and RL_BatchFlag=:BatchFlag)
	}
	i Total2>1 q "本单据已经录入该设备"
	q ReturnDR
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
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF0093
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
		i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) // $p(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF0093
		s UnitDR=$p(^DHCEQEquip(RowID),"^",5)
		s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
		s Quantity=1
		s Fee=$p(^DHCEQEquip(RowID),"^",27)
		s InStockListDR=$p(^DHCEQEquip(RowID),"^",70)
		i InStockListDR'="" s Fee=$p(^DHCEQInStockList(InStockListDR),"^",7)
		s InStockListDR=""
	}
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i Fee'="" s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"",2)	;Fee
	
	q ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_UnitDR_"^"_Unit_"^"_Quantity_"^"_Fee_"^"_InStockListDR
}

ClassMethod ReturnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReturnListExecute(ByRef qHandle As %Binary, ReturnDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i ReturnDR'="" s StoreLoc=$p($g(^DHCEQReturn(ReturnDR)),"^",2) //退货科室
	i ReturnDR'="" s EquipType=$p($g(^DHCEQReturn(ReturnDR)),"^",15) //类组
	i ReturnDR'="" s StatCat=$p($g(^DHCEQReturn(ReturnDR)),"^",16) //统计分类
	d BuildDataGetReturnList
	Quit $$$OK
BuildDataGetReturnList
	if ReturnDR'="" 
	{
	f  s rowid=$o(^DHCEQReturnList(0,"Return",ReturnDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetReturnList
	.s LRowID = rowid	//rowid
	.s LReturnDR=$p($g(^DHCEQReturnList(rowid)),"^",1) //退货单
	.s StatCat=$p($g(^DHCEQReturn(ReturnDR)),"^",16) //统计分类
	.s LBatchFlag=$p($g(^DHCEQReturnList(rowid)),"^",2) //批标志
	.s TInStockList=$p($g(^DHCEQReturnList(rowid)),"^",3) //入库单号
	.i LBatchFlag'="Y" d
	..s LEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",4) 
	..i LEquipDR'="" d
	...s LEquip=$p($g(^DHCEQEquip(LEquipDR)),"^",1) //设备名称
	...s TStock=$p($g(^DHCEQEquip(LEquipDR)),"^",67) //库房
	...s TStock=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	...s LModelDR = $p($g(^DHCEQEquip(LEquipDR)),"^",3) //机型
	...i LModelDR'="" s LMModel=$p($g(^DHCEQCCode("DHCEQCModel",LModelDR)),"^",2)
	...s LManuFactoryDR = $p($g(^DHCEQEquip(LEquipDR)),"^",26) //生产厂商
	...i LManuFactoryDR'="" s LManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",LManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",LManuFactoryDR)),"^",1) //CZF0093
	.i LBatchFlag="Y" d
	..s LEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",3) 
	..i LEquipDR'="" d
	...i TInStockList'="" s TReturnNum=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(StoreLoc,TInStockList,EquipType,StatCat)
	...s LEquip=$p($g(^DHCEQInStockList(LEquipDR)),"^",5) //设备名称
	...s LModelDR =$p($g(^DHCEQInStockList(LEquipDR)),"^",9) //机型
	...i LModelDR'="" s LMModel=$p($g(^DHCEQCCode("DHCEQCModel",LModelDR)),"^",2)
	...s LManuFactoryDR =$p($g(^DHCEQInStockList(LEquipDR)),"^",6) //生产厂商
	...i LManuFactoryDR'="" s LManuFactory= ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",LManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",LManuFactoryDR)),"^",1) //CZF0093
	.s LReturnQtyNum=$p($g(^DHCEQReturnList(rowid)),"^",5) //退货数量
	.s LReturnFee=$p($g(^DHCEQReturnList(rowid)),"^",6) //退货金额
	.s TTotalFee=LReturnQtyNum*LReturnFee
	.s LInvoiceNo=$p($g(^DHCEQReturnList(rowid)),"^",7) //发票号
	.s LReturnReasonDR=$p($g(^DHCEQReturnList(rowid)),"^",8) //退货原因
	.i LReturnReasonDR'="" s LReturnReason=$p($g(^DHCEQCCode("DHCEQCReturnReason",LReturnReasonDR)),"^",2) //结果
	.s LRemark=$p($g(^DHCEQReturnList(rowid)),"^",9) //备注
	.
	.//add by jdl 2009-9-25  JDL0036
	.//格式化金额为小数点两位
	.i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	.i LReturnFee'="" s LReturnFee=##Class(web.DHCEQCommon).FormatNumber(LReturnFee,"",2)
	.
	.d OutputRowGetReturnList
	}
	quit
OutputRowGetReturnList
   s Data=$lb(TTotalFee,TReturnNum,TStock,LRowID,LReturnDR,LBatchFlag,LEquip,LMModel,LManuFactory,LReturnQtyNum,LReturnFee,LInvoiceNo,LReturnReason,LRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturnList
	s (TTotalFee,TReturnNum,TStock,LRowID,LReturnDR,LBatchFlag,LEquip,LMModel,LManuFactory,LReturnQtyNum,LReturnFee,LInvoiceNo,LReturnReason,LRemark)=""
	quit
}

ClassMethod ReturnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnListExecute ]
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

Query ReturnList(ReturnDR As %String = "") As %Query(ROWSPEC = "TTotalFee:%String,TReturnNum:%String,TStock:%String,TRowID:%String,TReturn:%String,TBatchFlag:%String,TEquip:%String,TMModel:%String,TManuFactory:%String,TReturnQtyNum:%String,TReturnFee:%String,TInvoiceNo:%String,TReturnReason:%String,TRemark:%String")
{
}

ClassMethod GetID(rowid As %Library.String = "")
{
	s (ModelDR,Model)=""
	s (ManuFactory,ManuFactory)=""
	s Equip=""
	new result,resultex,Quantity
	s (result,resultex)=""
	s result= ^DHCEQReturnList(rowid)
	s resultex=resultex_"^"	;ReturnDR
	//i $p(result,"^",1)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQReturn($p(result,"^",1))),"^",XX)
	//s $p(result,"^",2)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"bool")	;BatchFlag
	s resultex=resultex_"^"	;InStockListDR
	//i $p(result,"^",3)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",3))),"^",XX)
	s resultex=resultex_"^"	;EquipDR
	//i $p(result,"^",4)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",4))),"^",XX)
	s resultex=resultex_"^"	;ReturnReasonDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCReturnReason",$p(result,"^",8))),"^",2)
	
	s ContractNo=""
	s EquipNo=""
	i $p(result,"^",2)="Y"
	{
		s ISLID=$p(result,"^",3)
		s Equip=$p($g(^DHCEQInStockList(ISLID)),"^",5)
		s ModelDR=$p($g(^DHCEQInStockList(ISLID)),"^",9)
		s ManuFactoryDR=$p($g(^DHCEQInStockList(ISLID)),"^",6)
		s Unit=$p($g(^DHCEQInStockList(ISLID)),"^",10)
	}
	else
	{
		s Equip=$p($g(^DHCEQEquip($p(result,"^",4))),"^",1)
		s ModelDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",3)
		s ManuFactoryDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",26)
		s Unit=$p($g(^DHCEQEquip($p(result,"^",4))),"^",5)				
		s ISLID=$p($g(^DHCEQEquip($p(result,"^",4))),"^",70)
		
		s ContractNo=##class(web.DHCEQEquip).GetContractNo($p(result,"^",4))
	}
	i ModelDR'="" s Model=$P(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
	i ManuFactoryDR'="" s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //$P(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR),"^",1) //CZF0093
	
	s InStockList=$p(result,"^",3)
	i InStockList'=""
	{
		s ReturnDR=$p(result,"^",1)
		s Stock=$P(^DHCEQReturn(ReturnDR),"^",2)
		s EquipType=$P(^DHCEQReturn(ReturnDR),"^",15)
		s StatCat=$P(^DHCEQReturn(ReturnDR),"^",16)
		s Quantity=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(Stock,InStockList,EquipType,StatCat)
	}
	else
	{
		s Quantity=1
	}
	/*	 20150914  Mozy0165
	s EquipDR=$p(result,"^",4) //2010-10-08 Add By DJ Begin
	i ($p(result,"^",5)=1)&&(EquipDR="") s EquipDR=$g(^DHCEQReturnList(rowid,"EX","RowIDs"))
	i EquipDR'="" s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71) //2010-10-08 Add By DJ end
	*/
	Set RowIDs=$Get(^DHCEQReturnList(rowid,"EX","RowIDs"))
	s Count=$l(RowIDs,",")
	for j=1:1:Count
	{
		s EquipNo=EquipNo_","_$p($g(^DHCEQEquip($p(RowIDs,",",j))),"^",71)
	}
	s EquipNo=$e(EquipNo,2,$l(EquipNo))
	Set EquipNo=##Class(web.DHCEQCommon).NoToGroupNo(EquipNo)
	i Unit'=""  s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	s InvoiceNo=""
	i ISLID'="" s InvoiceNo=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLID),"^",1)
	
	s resultex=##Class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",6)'="" s $p(result,"^",6)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",6),"",2)	;ReturnFee
	i $p(result,"^",10)'="" s $p(result,"^",10)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",10),"",2)	;DealFee
	
	q result_resultex_"^"_Equip_"^"_Model_"^"_ManuFactory_"^"_Quantity_"^"_Unit_"^"_InvoiceNo_"^"_EquipNo_"^"_ContractNo
}

ClassMethod GetReturnEquipType(ReturnDR, Type)
{
	i ReturnDR="" q ""
	s EquipTypeDR=$P($G(^DHCEQReturn(ReturnDR)),"^",14+Type)
	q EquipTypeDR
}

/// 根据科室、设备编号、入库明细号、类组、类型、判断是否可以退（转移）填入的数量
/// Type=1退货，Type=2转移
ClassMethod HaveEquipTotal(LocID, EquipID, InStockListID, EquipType, StatCat, EquipNum, Type, SourceID)
{
	;s ^DHCEQTemp("JDL")=LocID_","_EquipID_","_InStockListID_","_EquipType_","_StatCat_","_EquipNum_","_Type_","_SourceID
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
	.s HadReturn=..EquipIsHad(Stock, EQRowID,Type,SourceID)
	.q:HadReturn=0
	.s Total=Total+1
	q Total
}

/// 批入库在转移、退货中的中数量
ClassMethod InStockListTotal(LocID, InStockListID, EquipType, StatCat, Type, SourceID)
{
	s ReturnListID=0
	s Total=0
	f  s ReturnListID=$O(^DHCEQReturnList(0,"InStockList",InStockListID,ReturnListID)) q:ReturnListID=""  d
	.q:(Type="1")&&(SourceID=ReturnListID)
	.s Flag=$P(^DHCEQReturnList(ReturnListID),"^",2)
	.q:Flag="N"
	.s ReturnID=$P(^DHCEQReturnList(ReturnListID),"^",1)
	.s Statu=$P(^DHCEQReturn(ReturnID),"^",13)
	.q:Statu="3"
	.s EquipTypeDR=$P(^DHCEQReturn(ReturnID),"^",15)
	.q:EquipTypeDR'=EquipType
	.s StatCatDR=$P(^DHCEQReturn(ReturnID),"^",16)
	.q:StatCatDR'=StatCat
	.s ReturnLoc=$P(^DHCEQReturn(ReturnID),"^",2)
	.q:ReturnLoc'=LocID
	.s Num=$P(^DHCEQReturnList(ReturnListID),"^",5)
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
	new ReturnID,ReturnLoc,StoreMoveID
	s ReturnListID=0
	s Flag="N"
	f  s ReturnListID=$O(^DHCEQReturnList(0,"Equip",EquipID,ReturnListID)) q:(ReturnListID="")||(Flag="Y")  d
	.q:(Type="1")&&(SourceID=ReturnListID)
	.q:($P(^DHCEQReturnList(ReturnListID),"^",2)="Y")
	.s ReturnID=$P(^DHCEQReturnList(ReturnListID),"^",1)
	.s Statu=$P(^DHCEQReturn(ReturnID),"^",13)
	.q:Statu="3"
	.s ReturnLoc=$P(^DHCEQReturn(ReturnID),"^",2)
	.q:ReturnLoc'=LocID
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

/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 描述:保存查询的信息到临时Global中,为保存导出提供数据
Query GetReturnDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TInStockDR:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TRow:%String,TManuFactory:%String,TInvoice:%String,TRemark:%String,THold1:%String")
{
}

ClassMethod GetReturnDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    //modified by ZY 20220928
    //d ##Class(web.DHCEQCommon).KillTempGlobal("ReturnDetail")
 	/**************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set Type=##Class(web.DHCEQCommon).GetDataByName(vData,"Type")
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")	
	Set InvoiceNos=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNos")
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set EquipCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	Set StatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
	Set OutTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"OutTypeDR")
	Set ReturnNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ReturnNo")
	Set EquipNo=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipNo")
	Set ToDeptDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToDeptDR")
	Set Flag=##Class(web.DHCEQCommon).GetDataByName(vData,"Flag")
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR") // Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
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
 	/**************************************************/
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
 	i vData="" q $$$OK
	i StartDate>EndDate q $$$OK
	s index=2
	
	s Total=0
	s TotalFee=0
	s PNum=1
	s TJob=$J
    //modified by ZY 20220928
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("ReturnDetail",TJob,curuser)
	// MZY0130	2775875,2775876		2022-07-27
	s ISRowID=""
	f  s ISRowID=$o(^DHCEQReturn(ISRowID),-1) quit:(ISRowID="")||(ISRowID=0)  d
	.s TLocDR=$p(^DHCEQReturn(ISRowID),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR))) //2010-10-26 DJ
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TLocDR) ;Add QW20210629 BUG:QW0131
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	.s TStatusDR=$p(^DHCEQReturn(ISRowID),"^",13)
	.q:(Status'="")&&(TStatusDR'=Status)
	.s TInDate=$p($g(^DHCEQReturn(ISRowID)),"^",4)
	.q:(TInDate>EndDate)||(TInDate<StartDate)
	.s TEquipTypeDR=$p($g(^DHCEQReturn(ISRowID)),"^",15)
	.q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturnList(0,"Return",ISRowID,rowid))  quit:rowid=""  d
	..s TPrice=$p(^DHCEQReturnList(rowid),"^",6)
	..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
	..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
	..//s TModelDR=$p(^DHCEQReturnList(rowid),"^",9)
	..//q:(ModelDR'="")&&(TModelDR'=ModelDR)
	..d GetOneInStockDetail
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")  //将'401001'改为'301006'. Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetReturnDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TRow="合计:"
		
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
		//s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID,TJob,TApproveStep,TApproveRole,TRow,TManuFactory,TInvoice,TRemark)
		//Set ^CacheTemp(repid,TotalLoc)=Data
        //modified by ZY 20220928
        //Set ^DHCEQTemp("ReturnDetail",+$H,TJob,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TManuFactory_"^"_TInvoice_"^"_TRemark_"^"_THold1
        s tmpValue=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TManuFactory_"^"_TInvoice_"^"_TRemark_"^"_THold1
        d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("ReturnDetail",+$H,TJob,curuser,PNum,tmpValue)
	}
	Quit $$$OK
GetOneInStockDetail
	d ResetVariablesGetReturnDetail
	s TISRowID=ISRowID
	s RFlag=$p($g(^DHCEQReturn(TISRowID)),"^",28)
	i RFlag="" s RFlag="N"
	q:(InvalidFlag'="")&&(InvalidFlag'=RFlag)
	;s TProviderDR=$p(^DHCEQReturn(TISRowID),"^",3)
	;q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
	;s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    s TRemark=$p(^DHCEQReturnList(rowid),"^",9)  //取备注  需求号：284951  Add by mwz 2016-11-14
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQReturn(TISRowID)),"^",4),"date")
	s TISNo=$p(^DHCEQReturn(TISRowID),"^",1)
	q:(ReturnNo'="")&&(TISNo'=ReturnNo) //Add By DJ 2010-08-31 Begin
	;增加设备编号过滤条件
	s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("Return",TISRowID,EquipNo)
	q:(EquipNo'="")&&(Find=0) //Add By DJ 2010-08-31 end
	s TLocDR=$p(^DHCEQReturn(TISRowID),"^",2)
	i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	s TStatCatDR=$p($g(^DHCEQReturn(TISRowID)),"^",16)
	;q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)			//Modify By CZF 2016-11-17
	i TStatCatDR '=""  d
	.s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	
	s TOutType=$p($g(^DHCEQReturn(TISRowID)),"^",17)
	q:(OutTypeDR'="")&&(OutTypeDR'=TOutType)
	q:(OutTypeDR="")&&(1=TOutType)
	s TToDept=$p($g(^DHCEQReturn(TISRowID)),"^",18)
	q:(ToDeptDR'="")&&(ToDeptDR'=TToDept)
	
	s TEquipTypeDR=$p($g(^DHCEQReturn(TISRowID)),"^",15)
	q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	s result=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQReturn(TISRowID)),"^",13)
	q:..EquipIsReturn(rowid,Name)
	s TProviderDR=""
	i ($p(^DHCEQReturnList(rowid),"^",3)'="") //add by csj 20190912 批量标记退货明细id可能为空 需求号：1027147 //modified by czf 1232316
	{
		s TEquipName=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",5)
		s TModelDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",9)
		s TManuFactoryDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",6)
		Set TUnitDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",10)
		Set TStatCatDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",17)
		Set TEquipCat=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",14)
		; MZY0103	2318754		2021-12-06	修正发票号取值
		;s InvoiceNos=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,$p(^DHCEQReturnList(rowid),"^",3))
		;s TInvoice=$P(InvoiceNos,"^",1)
		s InStockDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",1)  ;add by kdf 2017-11-13 需求号474087  
	    i InStockDR'=""  s TProviderDR=$p($g(^DHCEQInStock(InStockDR)),"^",17)                          ;add by kdf 2017-11-13 需求号474087  
		Set TUseYearsNum=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(rowid),"^",3))),"^",15)	// MZY0125	2617690		2022-06-08
	}
	i ($p(^DHCEQReturnList(rowid),"^",4)'="")		//modified by czf 1232316
	{
		s TEquipName=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",1)
		s TModelDR=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",3)
		s TManuFactoryDR=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",26)
		Set TUnitDR=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",5)
		Set TStatCatDR=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",75)
		Set TEquipCat=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",4)
		s TProviderDR=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",25)   ;add by kdf 2017-11-13 需求号474087  
		Set TUseYearsNum=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",31)	// MZY0125	2617690		2022-06-08
		/*	 MZY0103	2318754		2021-12-06	修正发票号取值
		s ISLID=$p($g(^DHCEQEquip($p(^DHCEQReturnList(rowid),"^",4))),"^",70)
		if ISLID'=""
		{
			s InvoiceNos=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLID)
			s TInvoice=$P(InvoiceNos,"^",1)
		}
		*/
	}
	// MZY0103	2318754		2021-12-06	修正发票号取值
	s InvoiceNos=##Class(web.DHCEQInvoice).GetInvoiceInfos(2,rowid)
	s TInvoice=$p(InvoiceNos,"^",1)
	q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)       ;add by kdf 2017-11-13 需求号474087  
	i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR) ;add by kdf 2017-11-13 需求号474087  
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$P(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR),"^",1) //CZF0093
	i TUnitDR '="" s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	i TStatCatDR '="" s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	i TEquipCat '="" s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCat),"^",2)
	s TOriginalFee=$p(^DHCEQReturnList(rowid),"^",6)
	s TQuantityNum=$p(^DHCEQReturnList(rowid),"^",5)
	s TTotalFee=TOriginalFee*TQuantityNum
	// Mozy0217  2018-11-01
	i ($p(^DHCEQReturnList(rowid),"^",12)="") d
	.s Total=Total+TQuantityNum
	.s TotalFee=TotalFee+TTotalFee
	
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	i TStatus'=0  d
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("15",TISRowID) //2010-08-31 DJ begin
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5) //2010-08-31 DJ end
	s TStatus=##class(web.DHCEQReturn).GetStatu(TStatus)
	s THold1=$p(^DHCEQReturnList(rowid),"^",11)		//减少去向
	d OutputRowGetReturnDetail
	quit
OutputRowGetReturnDetail
    s TRow=PNum
    s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISRowID,TJob,TApproveStep,TApproveRole,TRow,TManuFactory,TInvoice,TRemark,THold1)
    Set ^CacheTemp(repid,index)=Data
    //modified by ZY 20220928
    //Set ^DHCEQTemp("ReturnDetail",+$H,TJob,PNum)=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TManuFactory_"^"_TInvoice_"^"_TRemark_"^"_THold1
    s tmpValue=TISRowID_"^"_TProviderDR_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLocDR_"^"_TLoc_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TInvoice_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TISRowID_"^"_TManuFactory_"^"_TInvoice_"^"_TRemark_"^"_THold1
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("ReturnDetail",+$H,TJob,curuser,PNum,tmpValue)
	Set PNum=PNum+1
	Set index=index+1
	quit
ResetVariablesGetReturnDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,InvoiceInfo,TISRowID,TApproveStep,TApproveRole,TManuFactory,TInvoice,TRemark,THold1)=""
	quit
}

ClassMethod GetReturnDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnDetailExecute ]
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

ClassMethod GetReturnDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 0在此退货单  1不在此退货单
ClassMethod EquipIsReturn(ISLID, Name)
{
	i Name="" q 0
	s Name=$ZCONVERT(Name ,"U")
	i $p(^DHCEQReturnList(ISLID),"^",2)="Y"
	{
		s Equip=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(ISLID),"^",3))),"^",5)
		//s ModelDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(ISLID),"^",3))),"^",9)
		//s ManuFactoryDR=$p($g(^DHCEQInStockList($p(^DHCEQReturnList(ISLID),"^",3))),"^",6)
		
	}
	else
	{
		s Equip=$p($g(^DHCEQEquip($p(^DHCEQReturnList(ISLID),"^",4))),"^",1)
		//s ModelDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",3)
		//s ManuFactoryDR=$p($g(^DHCEQEquip($p(result,"^",4))),"^",26)
	}
	s Equip=$ZCONVERT(Equip ,"U")
	i Equip[Name q 0
	q 1
}

/// -------------------------------
/// 创建：zy 2009-11-18   ZY0017
/// 描述:取到打印导出的查询信息
/// -------------------------------
ClassMethod GetOneReturnDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("ReturnDetail",+$H,job,""),-1)
	q $g(^DHCEQTemp("ReturnDetail",+$H,job,PNum))
}

// 2011-07-20 DJ

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetNum(node As %Library.String = "", job)
{
	q ..GetOneReturnDetail(0,job)
}

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneReturnDetail(gnum,job)
}

/// w ##class(web.DHCEQReturnList).GetReturnToDeptByEquip(24787)
ClassMethod GetReturnToDeptByEquip(RLEquipID)
{
	n (RLEquipID)
	s ReturnToDept=""
	s FindFlag=0
	s RLListID=0
	f  s RLListID=$o(^DHCEQReturnList(RLListID)) q:(RLListID="")||(FindFlag=1)  d
	.s RID=$p($g(^DHCEQReturnList(RLListID)),"^",1)
	.q:$p($g(^DHCEQReturn(RID)),"^",28)="Y"
	.q:$p($g(^DHCEQReturn(RID)),"^",13)=3
	.s ReturnToDept=$p($g(^DHCEQReturnList(RLListID)),"^",11)
	.s RLEQIDs=$g(^DHCEQReturnList(RLListID,"EX","RowIDs"))
	.i (","_RLEQIDs_",")[(","_RLEquipID_",") s FindFlag=1
	
	q ReturnToDept
}

/// czf 2022-06-06
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// w ##Class(web.DHCEQReturnList).GetSumInfo(61300)
ClassMethod GetSumInfo(Ejob As %Library.String = "")
{
	//s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	
	s nrowid=0	
	f  s nrowid=$o(^DHCEQTemp("ReturnDetail",+$h,Ejob,nrowid)) q:nrowid=""  d
	.q:$p($g(^DHCEQTemp("ReturnDetail",+$h,Ejob,nrowid)),"^",1)=""  //合计行
	.s OriginalFee=$p($g(^DHCEQTemp("ReturnDetail",+$h,Ejob,nrowid)),"^",16)
	.s Quantity=$p($g(^DHCEQTemp("ReturnDetail",+$h,Ejob,nrowid)),"^",17)
	.s Count=Count+Quantity
	.s TotalFee=TotalFee+(Quantity*OriginalFee)
	
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
  	
  	q info
}

}
