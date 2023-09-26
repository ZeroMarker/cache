Class web.DHCEQM.DHCEQMCFaultEquipMap Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Add by wsp 2016-4-12
/// 保存数据
/// d ##Class(web.DHCEQM.DHCEQMCFaultEquipMap).SaveData("^3^1^2^22^103^1^^^^^^")
ClassMethod SaveData(val)
{
	k PList,rowid
	s rowid=$P(val,"^",1)  ;RowID
	s PList(2)=$P(val,"^",2)  ;主要类型
	s PList(3)=$P(val,"^",3)  ;故障ID
	s PList(4)=$P(val,"^",4)  ;来源类型
	s PList(5)=$P(val,"^",5)  ;来源ID
	s PList(6)=$P(val,"^",6)  ;机型
	s PList(7)=$P(val,"^",7)  ;品牌
	s PList(8)=$P(val,"^",8)  ;使用标志
	s PList(9)=$P(val,"^",9)  ;FEM_Hold1
	s PList(10)=$P(val,"^",10)  ;FEM_Hold2
	s PList(11)=$P(val,"^",11)  ;FEM_Hold3
	s PList(12)=$P(val,"^",12)  ;FEM_Hold4
	s PList(13)=$P(val,"^",13)  ;FEM_Hold5
	//s PList(8)="N"  ;使用标志
	
	i rowid=""
	{
		&SQL(Insert Into SQLUser.DHC_EQMCFaultEquipMap values :PList())
		s rowid=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUser.DHC_EQMCFaultEquipMap values :PList() where FEM_RowID=:rowid)
	}
	i SQLCODE  q SQLCODE
	q rowid
}

/// d ##Class(web.DHCEQM.DHCEQMCFaultEquipMap).DeleteData()
ClassMethod DeleteData(rowid)
{
	i rowid="" q ""
	&SQL(Delete From SQLUser.DHC_EQMCFaultEquipMap where FEM_RowID=:rowid)
	q SQLCODE
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCFaultEquipMap","GetFaultEquipMap","3","","","")
Query GetFaultEquipMap(MapType, FaultID, ESourceType, ESourceID) As %Query(ROWSPEC = "TRow,TRowID,TMapTypeID,TMapType,TFaultID,TFault,TESourceTypeID,TESourceType,TESourceID,TCode,TESource,TEModelDR,TEModel,TEBrandDR,TEBrand,TUsedFlag")
{
}

ClassMethod GetFaultEquipMapExecute(ByRef qHandle As %Binary, MapType, FaultID, ESourceType, ESourceID) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s TRow=0
 	s rowid=0
 	f  s rowid=$O(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)) q:rowid=""  d
 	.d ResetVariableGetFaultEquipMap
 	.s TUsedFlag=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",7)  ;使用标志
 	.//q:TUsedFlag="Y"
 	.s TRowID=rowid
 	.s TMapTypeID=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",1)  	;主要类型：1:故障现象 2:故障原因 3:故障解决方法
 	.q:(MapType'="")&(MapType'=TMapTypeID)
 	.i TMapTypeID'="" s TMapType=$CASE(TMapTypeID,1:"故障现象",2:"故障原因",3:"故障解决方法")
 	.s TFaultID=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",2) ;故障ID
 	.q:(TFaultID'=FaultID)&(FaultID'="")
	.i (TFaultID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",1)=1) d
	..s TFault = $p($g(^DHCEQCCode("DHCEQMCFaultCase",TFaultID)),"^",2)
	.i (TFaultID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",1)=2) d
	..s TFault=$p($g(^DHCEQCCode("DHCEQMCFaultReason",TFaultID)),"^",2) 
	.i (TFaultID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",1)=3) d
	..s TFault=$p($g(^DHCEQCCode("DHCEQMCDealMethod",TFaultID)),"^",2) 
 	.s TESourceTypeID=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",3)  ;来源类型
 	.q:(ESourceType'="")&(ESourceType'=TESourceTypeID)
 	.i TESourceTypeID'="" s TESourceType=$CASE(TESourceTypeID,1:"设备分类",2:"设备项")
 	.s TESourceID=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",4)  ;来源ID
 	.q:(TESourceID'=ESourceID)&(ESourceID'="")
	.i (TESourceID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",3)=1) d
	..s TCode=$P(^DHCEQCCode("DHCEQCEquipeCat",TESourceID),"^",1)
	..s TESource=$P(^DHCEQCCode("DHCEQCEquipeCat",TESourceID),"^",2)
	.i (TESourceID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",3)=2) d
	..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",TESourceID)),"^",2) //代码
	..s TESource=$p($g(^DHCEQCCode("DHCEQCMasterItem",TESourceID)),"^",1) //描述
	.//i (TESourceID'="")&($p($g(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid)),"^",3)=2) d
 	.s TEModelDR=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",5)  ;机型
 	.//q:(EModelDR'="")&(EModelDR'=TEModelDR)
 	.i TEModelDR'="" s TEModel=$p($g(^DHCEQCCode("DHCEQCModel",TEModelDR)),"^",2) //描述
 	.s TEBrandDR=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",6)  ;品牌
 	.//q:(EBrandDR'="")&(EBrandDR'=TEBrandDR)
 	.i TEBrandDR'="" s TEBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TEBrandDR)),"^",3) //描述
 	.s TRow=TRow+1
	.d OutputRowGetFaultEquipMap
 	
	Quit $$$OK
	
ResetVariableGetFaultEquipMap
	s (TRow,TRowID,TMapTypeID,TMapType,TFaultID,TFault,TESourceTypeID,TESourceType,TESourceID,TCode,TESource,TEModelDR,TEModel,TEBrandDR,TEBrand,TUsedFlag)=""
	quit
	
OutputRowGetFaultEquipMap
	s Data=$lb(TRow,TRowID,TMapTypeID,TMapType,TFaultID,TFault,TESourceTypeID,TESourceType,TESourceID,TCode,TESource,TEModelDR,TEModel,TEBrandDR,TEBrand,TUsedFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetFaultEquipMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFaultEquipMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFaultEquipMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFaultEquipMapExecute ]
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

}
