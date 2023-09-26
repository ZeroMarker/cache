Class web.DHCEQM.DHCEQMCCaseReasonDealMap Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Add by wsp 2016-4-12
/// 保存数据
/// d ##Class(web.DHCEQM.DHCEQMCCaseReasonDealMap).SaveData("^1^1^1^^^^^")
ClassMethod SaveData(val)
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

/// d ##Class(web.DHCEQM.DHCEQMCCaseReasonDealMap).DeleteData()
ClassMethod DeleteData(rowid)
{
	i rowid="" q ""
	&SQL(Delete From SQLUser.DHC_EQMCCaseReasonDealMap where CRDM_RowID=:rowid)
	q SQLCODE
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMCCaseReasonDealMap","GetCaseReasonDealMap","","","")
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

}
