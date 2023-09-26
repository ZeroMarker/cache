/// 名称: DHCHAI.BTS.InvasOperSrv
/// 描述: 侵害性操作相关服务
/// 编写者：zhouruimeng
/// 编写日期: 2017-04-12
Class DHCHAI.BTS.InvasOperSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2017-04-12
/// Description:  查询侵害性操作列表
/// Table：       DHCHAI.BT.InvasOper
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.InvasOperSrv","QueryInvasOper")
Query QueryInvasOper(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QueryInvasOperExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.InvasOperD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.InvasOper).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		Set IndNo=obj.BTIndNo
		Set IsActive=obj.BTIsActive
		Continue:(aActive'="")&&(aActive'=IsActive)
	
		Set BTIsActive=$s(IsActive=1:"是",1:"否")
		set Data=$lb(xID,Code,Desc,IndNo,BTIsActive,IsActive)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryInvasOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInvasOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInvasOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInvasOperExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.InvasOperSrv","QueryInvasOperRow",ID)
Query QueryInvasOperRow(aID As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String,IsActive:%String") [ SqlProc ]
{
}

ClassMethod QueryInvasOperRowExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set obj=##class(DHCHAI.BT.InvasOper).GetObjById(aID)
 	Quit:'$IsObject(obj) $$$OK
 	Set Code=obj.BTCode
	Set Desc=obj.BTDesc
	Set IndNo=obj.BTIndNo
	Set IsActive=obj.BTIsActive
	Set BTIsActive=$s(IsActive=1:"是",1:"否")
	set Data=$lb(aID,Code,Desc,IndNo,BTIsActive,IsActive)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryInvasOperRowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInvasOperRowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInvasOperRowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInvasOperRowExecute ]
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

}
