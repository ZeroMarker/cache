Class web.DHCEQUseConsumableItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by jyp 2016-11-18
/// 保存数据
/// do ##Class(web.DHCEQUseConsumableItem).SaveData("1^2^2^2)
ClassMethod SaveData(val)
{
	k PList,rowid
	s rowid=$P(val,"^",1)
	s PList(2)=$P(val,"^",2)
	s PList(3)=$P(val,"^",3)
	s PList(4)=$p($g(^DHCEQCCode("DHCEQCConsumableItem",PList(3))),"^",4)    //$P(val,"^",4)
	s PList(5)=$P(val,"^",4)
	s PList(6)=$p($g(^DHCEQCCode("DHCEQCConsumableItem",PList(3))),"^",3)    //$P(val,"^",6)
	s PList(7)=PList(5)*PList(6)    //$P(val,"^",7)
	//i PList(7)'="" s PList(7)=##Class(web.DHCEQCommon).TransValueFromPage(PList(7),"date","3")
	s PList(8)="" //$P(val,"^",8)
	s PList(9)="" //$P(val,"^",9)
	s PList(10)="" //$P(val,"^",10)
	s PList(11)="" //$P(val,"^",11)
	s PList(12)="" //$P(val,"^",12)
	s PList(13)="" //$P(val,"^",13)
	s PList(14)="" //$P(val,"^",14)
	s PList(15)="" //$P(val,"^",15)
	s PList(16)="" //$P(val,"^",16)
	s PList(17)="" //$P(val,"^",17)
	s PList(18)="" //$P(val,"^",18)
	s PList(19)="" //$P(val,"^",19)
	s PList(20)="" //$P(val,"^",20)
	s PList(21)="" //$P(val,"^",21)
	s PList(22)="" //$P(val,"^",22)
	
			
	//i PList(10)="" s PList(10)="N"
	i rowid=""
	{
		&SQL(Insert Into SQLUser.DHC_EQUseConsumableItem values :PList())
		s rowid=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUser.DHC_EQUseConsumableItem values :PList() where UCI_RowID=:rowid)
	}
	i SQLCODE q SQLCODE
	q rowid
}

ClassMethod DeleteData(rowid)
{
	i rowid="" q ""
	&SQL(Delete from SQLUser.DHC_EQUseConsumableItem where UCI_RowID=:rowid)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQUseConsumableItem","UseConsumableItem","","")
Query UseConsumableItem(UseRecordDR As %String = "", ConsumableItemDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TUseRecordDR:%String,TUseRecord:%String,TConsumableItemDR:%String,TConsumableItem:%String,TUomDR:%String,TUom:%String,TQuantity:%String,TPrice:%String,TAmount:%String")
{
}

ClassMethod UseConsumableItemExecute(ByRef qHandle As %Binary, UseRecordDR As %String = "", ConsumableItemDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	s rowid=0 	
 	i UseRecordDR'=""  d
 	.f  s rowid=$o(^DHCEQUseConsumableItem(0,"UseRecord",UseRecordDR,rowid))   q:rowid=""  d
 	..d ResetVariablesUseConsumableItem
 	..d SetVariablesUseConsumableItem
	..d OutputRowUseConsumableItem
	///modified by ZY0284 20211122 索引节点错误
 	e  i ConsumableItemDR'=""  d
 	.f  s rowid=$o(^DHCEQUseConsumableItem(0,"ConsumableItem",ConsumableItemDR,rowid))   q:rowid=""  d
 	..d ResetVariablesUseConsumableItem
 	..d SetVariablesUseConsumableItem
	..d OutputRowUseConsumableItem
	e  d
	.f  s rowid=$o(^DHCEQUseConsumableItem(rowid))   q:rowid=""  d
	..d ResetVariablesUseConsumableItem
 	..d SetVariablesUseConsumableItem
	..d OutputRowUseConsumableItem 
	Quit $$$OK
OutputRowUseConsumableItem
	s Data=$lb(TRowID,TUseRecordDR,TUseRecord,TConsumableItemDR,TConsumableItem,TUomDR,TUom,TQuantity,TPrice,TAmount)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUseConsumableItem
	s (TRowID,TUseRecordDR,TUseRecord,TConsumableItemDR,TConsumableItem,TUomDR,TUom,TQuantity,TPrice,TAmount)=""
	quit
SetVariablesUseConsumableItem
    s TRowID=rowid
	s TUseRecordDR=$P(^DHCEQUseConsumableItem(rowid),"^",1)
	q:(UseRecordDR'="")&(UseRecordDR'=TUseRecordDR)
 	i TUseRecordDR'=""  d
 	.s SourceType=$P(^DHCEQUseRecord(TUseRecordDR),"^",1)
 	.s SourceID=$P(^DHCEQUseRecord(TUseRecordDR),"^",2)
 	.i SourceType=1  s TUseRecord=$p($g(^DHCEQEquip(SourceID)),"^",1)
 	.e  s TUseRecord=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",1)
 	s TConsumableItemDR=$P(^DHCEQUseConsumableItem(rowid),"^",2)
 	q:(ConsumableItemDR'="")&(ConsumableItemDR'=TConsumableItemDR)
 	i TConsumableItemDR'="" s TConsumableItem=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",1)
 	s TUomDR=$P(^DHCEQUseConsumableItem(rowid),"^",3)
 	i TUomDR'="" s TUom=$p($g(^DHCEQCCode("DHCEQCUOM",TUomDR)),"^",4)
 	s TQuantity=$P(^DHCEQUseConsumableItem(rowid),"^",4)
 	s TPrice=$P(^DHCEQUseConsumableItem(rowid),"^",5)
 	s TAmount=$P(^DHCEQUseConsumableItem(rowid),"^",6)
 	quit
}

ClassMethod UseConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UseConsumableItemExecute ]
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

ClassMethod UseConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UseConsumableItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
Query UseConsumableItem(EquipID As %String = "", ConsumableItemID As %String = "", Rate As %String = "", SumByMonthFlag As %String = "Y") As %Query(ROWSPEC = "TRowID:%String,TMonthStr:%String,TQuantity:%String,TAmount:%String,TAmountRate:%String")
{
}

ClassMethod UseConsumableItemExecute(ByRef qHandle As %Binary, EquipID As %String = "", ConsumableItemID As %String = "", Rate As %String = "", SumByMonthFlag As %String = "Y") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (SumByMonthFlag="")||(EquipID="") Quit $$$OK
	i EquipID'="" s UseLocID=$p($g(^DHCEQEquip(EquipID)),"^",19)
	if SumByMonthFlag="Y"
	{
		//^DHCEQUseConsumableItem(0,"MonthStr","Y",1,EquipDR,Month,UCIRowID
		s MonthStr=0
		f  s MonthStr=$o(^DHCEQUseConsumableItem(0,"MonthStr","Y",1,EquipID,MonthStr))  quit:MonthStr=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQUseConsumableItem(0,"MonthStr","Y",1,EquipID,MonthStr,rowid))  quit:rowid=""  d
		..q:$p(^DHCEQUseConsumableItem(rowid),"^",7)=2
		..q:$p(^DHCEQUseConsumableItem(rowid),"^",9)'=UseLocID
		..d ResetVariablesUseConsumableItem
		..s DateList =$g(^DHCEQUseConsumableItem(rowid))
		..s TRowID =rowid
		..s TMonthStr =MonthStr
		..q:$p(DateList,"^",2)'=ConsumableItemID
		..s TQuantity=$p(DateList,"^",4)
		..s TAmount=$p(DateList,"^",6)
		..i +Rate>0 s TAmountRate=TAmount*Rate
		..d OutputRowUseConsumableItem
	}
	Quit $$$OK
OutputRowUseConsumableItem
	s Data=$lb(TRowID,TMonthStr,TQuantity,TAmount,TAmountRate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUseConsumableItem
	s (TRowID,TMonthStr,TQuantity,TAmount,TAmountRate,DateList)=""
	quit
}

ClassMethod UseConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UseConsumableItemExecute ]
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

ClassMethod UseConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UseConsumableItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}
*/
}
