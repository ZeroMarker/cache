/// add by zy 2013-05-29 ZY0107
Class web.DHCEQUseConsumableStat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2013-05-28
/// 根据使用记录来汇总统计对应的消耗数据,汇总的数据写到临时golable下:^DHCEQUseConsumableStat("Temp")
/// d ##Class(web.DHCEQUseConsumableStat).GatherUseConsumableStat("2012-06")
ClassMethod GatherUseConsumableStat(UseRecordID, tmpSourceType, tmpSourceID, tmpServiceItemID, tmpUseLocID, tmpPrice, tmpWorkLoadUnitID)
{
	new UCIRowID,UseConsumableItemID,UnitID,Quantity,Price,Amount
	new ServiceItemID,ServDetItemID,ServDetItemQty,TempDate
	new tmpQuantity,tmpAmount
	
	s UCIRowID=0
	f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",UseRecordID,UCIRowID))  quit:UCIRowID=""  d
	.q:$p(^DHCEQUseConsumableItem(UCIRowID),"^",7)=2
	.s UseConsumableItemID=$p(^DHCEQUseConsumableItem(UCIRowID),"^",2)
	.s UnitID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",3)
	.s Quantity=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",4)
	.s Price=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",5)
	.s Amount=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",6)
	.s ServiceItemID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",12)
	.s ServDetItemID=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",13)
	.s ServDetItemQty=+$p(^DHCEQUseConsumableItem(UCIRowID),"^",14)
	.s TempDate=$g(^DHCEQUseConsumableItem("Temp",tmpSourceType,tmpSourceID,tmpServiceItemID,tmpUseLocID,tmpPrice,tmpWorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,Price))
	.s tmpQuantity=+$p(TempDate,"^",1)+Quantity
	.s tmpAmount=+$p(TempDate,"^",2)+Amount
	.s ^DHCEQUseConsumableStat("Temp",tmpSourceType,tmpSourceID,tmpServiceItemID,tmpUseLocID,tmpPrice,tmpWorkLoadUnitID,UseConsumableItemID,ServDetItemID,UnitID,Price)=tmpQuantity_"^"_tmpAmount
	
	q ""
}

ClassMethod SaveDate(val)
{
	new PLIST,RowID,SQLCODE
	s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)	//UseRecordStatDR
	s PLIST(3)=$p(val,"^",3)	//ConsumableItemDR
	i $p(val,"^",4)>0 s PLIST(4)=$p(val,"^",4)	//UOMDR
	s PLIST(5)=$p(val,"^",5)	//Quantity
	s PLIST(6)=$p(val,"^",6)	//Price
	s PLIST(7)=$p(val,"^",7)	//Amount
	i $p(val,"^",8)>0 s PLIST(8)=$p(val,"^",8)	//ServiceItemDR
	i $p(val,"^",9)>0 s PLIST(9)=$p(val,"^",9)	//ServDetItemDR
	s PLIST(10)=$p(val,"^",10)	//Remark
	s PLIST(11)=$p(val,"^",11)	//Hold1
	s PLIST(12)=$p(val,"^",12)	//Hold2
	s PLIST(13)=$p(val,"^",13)	//Hold3
	s PLIST(14)=$p(val,"^",14)	//Hold4
	s PLIST(15)=$p(val,"^",15)	//Hold5
	s PLIST(16)=$p(val,"^",16)	//PayPrice  //add by zx 2014-09-16
	s PLIST(17)=$p(val,"^",17)	//PayAmount
	if RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseConsumableStat Values :PLIST())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQUseConsumableStat Values :PLIST() where UCS_RowID = :RowID)
	}
 	i RowID="" Set RowID=$g(%ROWID)
 	q RowID
}

}
