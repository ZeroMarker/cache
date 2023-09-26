/// 名称: DHCHAI.BTS.PreFactorSrv
/// 描述: 易感因素相关服务
/// 编写者：zhouruimeng
/// 编写日期: 2017-04-12
Class DHCHAI.BTS.PreFactorSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2017-04-12
/// Description:  查询易感因素列表
/// Table：       DHCHAI.BT.PreFactor
/// Input：       
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.PreFactorSrv","QueryPreFactor")
Query QueryPreFactor(aIsNewborn As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String,IsActive:%String,IsNewborn:%String,BTIsNewborn:%String") [ SqlProc ]
{
}

ClassMethod QueryPreFactorExecute(ByRef qHandle As %Binary, aIsNewborn As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//走排序索引 ^DHCHAI.BT.PreFactorI("IdxofIndNo"
	Set xIdxNo=""
 	For {
	 	Set xIdxNo=$o(^DHCHAI.BT.PreFactorI("IdxofIndNo",xIdxNo))
	 	Quit:xIdxNo=""
	 	
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCHAI.BT.PreFactorI("IdxofIndNo",xIdxNo,xID))
		 	Quit:xID=""
		 	
		 	Set obj=##class(DHCHAI.BT.PreFactor).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	Set Code=obj.BTCode
			Set Desc=obj.BTDesc
			Set IndNo=obj.BTIndNo
			Set IsActive=obj.BTIsActive
			Continue:(aActive'="")&&(aActive'=IsActive)
			Set BTIsActive=$s(IsActive=1:"是",1:"否")
			Set IsNewborn=obj.BTIsNewborn
		    Continue:(aIsNewborn'="")&&(aIsNewborn'=IsNewborn)
			Set BTIsNewborn=$s(IsNewborn=2:"是",1:"否")
			set Data=$lb(xID,Code,Desc,IndNo,BTIsActive,IsActive,IsNewborn,BTIsNewborn)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
 	}
	Quit $$$OK
}

ClassMethod QueryPreFactorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPreFactorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPreFactorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPreFactorExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.PreFactorSrv","QueryPreFactorRow",ID)
Query QueryPreFactorRow(aID As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTIndNo:%String,BTIsActive:%String,IsActive:%String,IsNewborn:%String,BTIsNewborn:%String") [ SqlProc ]
{
}

ClassMethod QueryPreFactorRowExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set obj=##class(DHCHAI.BT.PreFactor).GetObjById(aID)
 	Quit:'$IsObject(obj) $$$OK
 	Set ID=obj.%Id()
 	Set Code=obj.BTCode
	Set Desc=obj.BTDesc
	Set IndNo=obj.BTIndNo
	Set IsActive=obj.BTIsActive
	Set BTIsActive=$s(IsActive=1:"是",1:"否")
	Set IsNewborn=obj.BTIsNewborn
	Set BTIsNewborn=$s(IsNewborn=2:"是",1:"否")
	set Data=$lb(ID,Code,Desc,IndNo,BTIsActive,IsActive,IsNewborn,BTIsNewborn)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryPreFactorRowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPreFactorRowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPreFactorRowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPreFactorRowExecute ]
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
