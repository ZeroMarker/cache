/// 名称: DHCMA.CPW.BTS.PathComplExtSrv
/// 描述: 路径并发症子 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathComplExtSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-23
/// Description:  查询合并症扩展项
/// Table：       DHCMA.CPW.BT.PathComplExt
/// Input：       ParRef:DHCMA.CPW.BT.PathCompl.RowId
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathComplExtSrv","QryPathComplExt","3")
Query QryPathComplExt(aParRef As %String) As %Query(ROWSPEC = "BTSID:%String,ExtID:%String,ExtDesc:%String")
{
}

ClassMethod QryPathComplExtExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK
 	
	Set xExtDesc=""
 	For {
	 	Set xExtDesc=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc",xExtDesc))
	 	Quit:xExtDesc=""
	 	
		Set xSub=""
	 	For {
	 		Set xSub=$o(^DHCMA.CPW.BT.PathComplI("EXT","IdxofExtDesc",xExtDesc,aParRef,xSub))
	 		Quit:xSub=""
	 		
	 		Set ID = aParRef_"||"_xSub
	 		Set obj = ##class(DHCMA.CPW.BT.PathComplExt).GetObjById(ID)
	 		Continue:'$IsObject(obj)
	 		Set Desc   = obj.BTExtDesc	
	 		
			Set Data=$lb(xSub,ID,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
 	}
	Quit $$$OK
}

ClassMethod QryPathComplExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatTypeSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathComplExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatTypeSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
