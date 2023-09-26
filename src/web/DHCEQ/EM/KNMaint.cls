Class web.DHCEQ.EM.KNMaint Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Add by lmm 2018-11-06
/// 保存数据
/// d ##Class(web.DHCEQ.EM.KNMaint).SaveData("^1^1^1^^^^^")
ClassMethod SaveCaseReasonDealMapData(val)
{
	k PList,rowid
	s rowid=$P(val,"^",1)  ;RowID
	s PList(2)=$P(val,"^",2)  ;主要类型
	s PList(3)=$P(val,"^",3)  ;来源ID
	s PList(4)=$P(val,"^",4)  ;对照ID
	s PList(5)=$P(val,"^",5)  ;FEM_Hold1
	s PList(6)=$P(val,"^",6)  ;FEM_Hold2
	s PList(7)=$P(val,"^",7)  ;FEM_Hold3
	s PList(8)=$P(val,"^",8)  ;FEM_Hold4
	s PList(9)=$P(val,"^",9)  ;FEM_Hold5
	
	i rowid=""
	{
		&SQL(Insert Into SQLUser.DHC_EQMCCaseReasonDealMap values :PList())
		s rowid=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUser.DHC_EQMCCaseReasonDealMap values :PList() where CRDM_RowID=:rowid)
	}
	i SQLCODE  q SQLCODE
	q rowid
}

/// d ##Class(web.DHCEQ.EM.KNMaint).DeleteData()
ClassMethod DeleteCaseReasonDealMapData(rowid)
{
	i rowid="" q ""
	&SQL(Delete SQLUser.DHC_EQMCCaseReasonDealMap where CRDM_RowID=:rowid)
	q SQLCODE
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.KNMaint","GetCaseReasonDealMap","","","")
Query GetCaseReasonDealMap(MapType, SourceID, MapSourceID) As %Query(ROWSPEC = "TRow,TRowID,TMapTypeID,TMapType,TSourceID,TSource,TMapSourceID,TMapSource")
{
}

ClassMethod GetCaseReasonDealMapExecute(ByRef qHandle As %Binary, MapType, SourceID, MapSourceID) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s TRow=0
 	s rowid=0
 	f  s rowid=$O(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid)) q:rowid=""  d
 	.d ResetVariableGetCaseReasonDealMap
 	.s TRowID=rowid
 	.s TMapTypeID=$P(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid),"^",1)  	;主要类型：,故障现象与故障原因对照 2，故障原因与解决方法对照
 	.q:(MapType'="")&(MapType'=TMapTypeID)
 	.i TMapTypeID'="" s TMapType=$CASE(TMapTypeID,1:"故障现象与故障原因对照",2:"故障原因与解决方法对照")
 	.s TSourceID=$P(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid),"^",2) ;MapType为1时，指故障现象，MapType为2时指故障原因
 	.q:(TSourceID'=SourceID)&(SourceID'="")
	.i (TSourceID'="")&($p($g(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid)),"^",1)=1) d
	..s TSource = $p($g(^DHCEQCCode("DHCEQMCFaultCase",TSourceID)),"^",2)
	.i (TSourceID'="")&($p($g(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid)),"^",1)=2) d
	..s TSource=$p($g(^DHCEQCCode("DHCEQMCFaultReason",TSourceID)),"^",2) 
 	.s TMapSourceID=$P(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid),"^",3)  ;MapType为1时，指故障原因，MapType为2时指解决方法
	.i (TMapSourceID'="")&($p($g(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid)),"^",1)=1) d
	..s TMapSource = $p($g(^DHCEQCCode("DHCEQMCFaultReason",TMapSourceID)),"^",2)
	.i (TMapSourceID'="")&($p($g(^DHCEQCCode("DHCEQMCCaseReasonDealMap",rowid)),"^",1)=2) d
	..s TMapSource=$p($g(^DHCEQCCode("DHCEQMCDealMethod",TMapSourceID)),"^",2) 
 	.q:(MapSourceID'="")&(MapSourceID'=TMapSourceID)
 	.s TRow=TRow+1
	.d OutputRowGetCaseReasonDealMap
 	
	Quit $$$OK
	
ResetVariableGetCaseReasonDealMap
	s (TRow,TRowID,TMapTypeID,TMapType,TSourceID,TSource,TMapSourceID,TMapSource)=""
	quit
	
OutputRowGetCaseReasonDealMap
	s Data=$lb(TRow,TRowID,TMapTypeID,TMapType,TSourceID,TSource,TMapSourceID,TMapSource)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCaseReasonDealMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCaseReasonDealMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCaseReasonDealMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCaseReasonDealMapExecute ]
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

/// add by lmm 2018-11-06
/// 保存数据
/// d ##Class(web.DHCEQ.EM.KNMaint).SaveData("^3^1^2^22^103^1^^^^^^")
/// modified by wy 2023-2-10 3266881修改返回值的结构 
/// modified by wy 2022-4-19 更新对照保存方法
ClassMethod SaveFaultEquipMapData(val)
{
	k PList,rowid
	s rowid=$P(val,"^",1)  ;RowID
	s PList(2)=$P(val,"^",2)  ;主要类型
	s MapType=PList(2)
	s PList(3)=$P(val,"^",3)  ;故障ID
	s FaultID=PList(3)
	s PList(4)=$P(val,"^",4)  ;来源类型
	s ESourceType=PList(4)
	s PList(5)=$P(val,"^",5)  ;来源ID
	s ESourceID=PList(5)
	s PList(6)=$P(val,"^",6)  ;机型
	s PList(7)=$P(val,"^",7)  ;品牌
	s PList(8)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",8),"bool")  ;使用标志
	s PList(9)=$P(val,"^",9)  ;FEM_Hold1
	s PList(10)=$P(val,"^",10)  ;FEM_Hold2
	s PList(11)=$P(val,"^",11)  ;FEM_Hold3
	s PList(12)=$P(val,"^",12)  ;FEM_Hold4
	s PList(13)=$P(val,"^",13)  ;FEM_Hold5
	//s PList(8)="N"  ;使用标志
	//modified by zyq 2022-10-11 begin
	s tmpid=""
	
	&SQL(select FEM_RowID into :tmpid from sqluser.DHC_EQMCFaultEquipMap where FEM_MapType=:MapType and FEM_FaultID=:FaultID and FEM_ESourceID=:ESourceID and  FEM_ESourceType=:ESourceType)
	i (tmpid="")&&(rowid="") 
	{		
			&SQL(Insert Into SQLUser.DHC_EQMCFaultEquipMap values :PList())
			s rowid=$g(%ROWID)		
	}
	else
	{
		if (rowid'="")&&((tmpid="")||(tmpid=rowid)) //没有重复数据;只修改可用标记 modified by zyq 2022-11-01
		{
			
			&SQL(Update SQLUser.DHC_EQMCFaultEquipMap values :PList() where FEM_RowID=:rowid)
		}
		else
		{
			 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9210) ;有重复数据，不添加
		}
	} 
	//modified by zyq 2022-10-11 end
	i SQLCODE  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
}

/// d ##Class(web.DHCEQ.EM.KNMaint).DeleteData()
ClassMethod DeleteFaultEquipMapData(rowid)
{
	i rowid="" q ""
	&SQL(Delete SQLUser.DHC_EQMCFaultEquipMap where FEM_RowID=:rowid)
	q SQLCODE
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.KNMaint","GetFaultEquipMap","3","","","")
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
 	.s TMapTypeID=$P(^DHCEQCCode("DHCEQMCFaultEquipMap",rowid),"^",1)  	;主要类型：1:故障现象 2:故障原因 3:故障解决方法,4:故障类型
 	.q:(MapType'="")&(MapType'=TMapTypeID)
 	.i TMapTypeID'="" s TMapType=$CASE(TMapTypeID,1:"故障现象",2:"故障原因",3:"故障解决方法",4:"故障类型") //modified by WY 2022-9-15 增加故障类型的对照
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
