Class web.DHCEQSPrint Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

//设备采购申请	打印

ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod GetBuyRequest(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{

	s result=""
	
	s rowid=0
	s Row=0
	f  s rowid=$o(^DHCEQBuyRequestList(rowid))  quit:rowid=""  d
	.s BRLBuyRequestDR=$p($g(^DHCEQBuyRequestList(rowid)),"^",1)
	.q:(BRLBuyRequestDR'=val)
	.;if (BRLBuyRequestDR=val) 
	.s result=$p($g(^DHCEQBuyRequestList(rowid)),"^",2) //设  备  名  称
	.s Model=$p($g(^DHCEQBuyRequestList(rowid)),"^",3)
	.s result=result_"^"_$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2) //类别/规格
	.s ManuFac=$p($g(^DHCEQBuyRequestList(rowid)),"^",4)
	.s result=result_"^"_$p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFac)),"^",1) ; //生产厂家
	.s result=result_"^"_$p($g(^DHCEQBuyRequestList(rowid)),"^",6) //估 价（万元）
	.s result=result_"^"_$p($g(^DHCEQBuyRequestList(rowid)),"^",9) //备注
	
	.s result=result_";"
	.s Row=Row+1
 q result_"-"_Row
}

/// No 单据编号  Type单据类型
ClassMethod GetEquipBarInfo(No, Type)
{
	new Strs,equipno,equipname,EquipID,ISLID,CSID
	s Strs=""
	i Type="Equip"
	{
		s equipno=$p($g(^DHCEQEquip(No)),"^",71)
		s equipname=$p($g(^DHCEQEquip(No)),"^",1)
		s equipUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(No)),"^",19))
		s Strs=equipno_","_equipname_","_equipUseLoc_","_No
	}
	i Type="OpenCheck"
	{
		s EquipID=$p($g(^DHCEQOpenCheck(No)),"^",1)
		s Strs=..GetEquipBarInfo(EquipID,"Equip")
	}
	i Type="InStock"
	{
		s ISLID=0
		f  s ISLID=$o(^DHCEQInStockList(0,"InStock",No,ISLID)) q:ISLID=""  d
		.s CSID=0
		.f  s CSID=$o(^DHCEQChangeStock(0,"Source","0",ISLID,CSID)) q:CSID=""  d
		..s EquipID=$p($g(^DHCEQChangeStock(CSID)),"^",1)
		..i Strs="" d
		...s Strs=..GetEquipBarInfo(EquipID,"Equip")
		..e  d
		...s Strs=Strs_"^"_..GetEquipBarInfo(EquipID,"Equip")
	}
	i Type="StoreMove"
	{
		s ISLID=0
		f  s ISLID=$o(^DHCEQStoreMoveList(0,"StoreMove",No,ISLID)) q:ISLID=""  d
		.s CSID=0
		.f  s CSID=$o(^DHCEQChangeStock(0,"Source","1",ISLID,CSID)) q:CSID=""  d
		..s EquipID=$p($g(^DHCEQChangeStock(CSID)),"^",1)
		..i Strs="" d
		...s Strs=..GetEquipBarInfo(EquipID,"Equip")
		..e  d
		...s Strs=Strs_"^"_..GetEquipBarInfo(EquipID,"Equip")
	}
	i Type="Inventory"		//Add By DJ  2016-09-21
	{
		s IRowID=$p(No,"^",1)
		s NextEQRowID=+$p(No,"^",2)
		f  s NextEQRowID=$o(^DHCEQInventoryList(0,"BillEquip",IRowID,NextEQRowID))  q:(NextEQRowID="")||(Strs'="")  d
		.s ILRowID=0
		.f  s ILRowID=$o(^DHCEQInventoryList(0,"BillEquip",IRowID,NextEQRowID,ILRowID))  q:(ILRowID="")||(Strs'="")  d
		..s TActerStoreLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",6)
		..q:TActerStoreLocDR'=""
		..s Strs=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
	}
	q Strs
}

}
