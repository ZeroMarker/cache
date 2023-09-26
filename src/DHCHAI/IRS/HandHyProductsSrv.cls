/// 名称: DHCHAI.IRS.HandHyProductsSrv
/// 描述: 手卫生用品服务
/// 编写者：zhoubo
/// 编写日期: 2017-12-27
Class DHCHAI.IRS.HandHyProductsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-12-27
/// Description:  查询手卫生用品列表
/// Table：       DHCHAI.IR.HandHyProducts
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.HandHyProductsSrv","QryHHProducts","1")
Query QryHHProducts(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,HHPCode:%String,HHPDesc:%String,HHPPinyin:%String,HHPSpec:%String,UnitDr:%String,UnitCode:%String,UnitDesc:%String,AvgAmount:%String,IsActive:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryHHProductsExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.HandHyProductsD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.HandHyProducts).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set HHPCode     = obj.HHPCode
		Set HHPDesc     = obj.HHPDesc
		Set HHPPinyin   = obj.HHPPinyin
		Set HHPSpec     = obj.HHPSpec
		Set (UnitDr,UnitCode,UnitDesc)=""
		If $IsObject(obj.HHPUnit) {
			Set UnitDr   = obj.HHPUnit.%Id()
			Set UnitCode = obj.HHPUnit.BTCode
			Set UnitDesc = obj.HHPUnit.BTDesc
		} 
		Set AvgAmount = obj.HHPAvgAmount
		Set IsActive  = obj.HHPActive
		Continue:((aIsActive'="")&&(aIsActive'=IsActive))
		Set Resume    = obj.HHPResume
		
		Set Data=$lb(xID,HHPCode,HHPDesc,HHPPinyin,HHPSpec,UnitDr,UnitCode,UnitDesc,AvgAmount,IsActive,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHHProductsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHHProductsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHHProductsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHHProductsExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-30
/// Description:  查询手卫生用品列表  下拉列表用
/// Table：       DHCHAI.IR.HandHyProducts
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.HandHyProductsSrv","QryCboHHProducts","1")
Query QryCboHHProducts(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,HHPCode:%String,HHPDesc:%String,HHPPinyin:%String,HHPSpec:%String,UnitDr:%String,UnitCode:%String,UnitDesc:%String,AvgAmount:%String,IsActive:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryCboHHProductsExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.HandHyProductsD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.HandHyProducts).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set HHPCode     = obj.HHPCode
		Set HHPDesc     = obj.HHPDesc
		Set HHPPinyin   = obj.HHPPinyin
		Set HHPSpec     = obj.HHPSpec
		Set (UnitDr,UnitCode,UnitDesc)=""
		If $IsObject(obj.HHPUnit) {
			Set UnitDr   = obj.HHPUnit.%Id()
			Set UnitCode = obj.HHPUnit.BTCode
			Set UnitDesc = obj.HHPUnit.BTDesc
		} 
		Set HHPDesc=HHPDesc_" "_HHPSpec_UnitDesc
		Set AvgAmount = obj.HHPAvgAmount
		Set IsActive  = obj.HHPActive
		Continue:((aIsActive'="")&&(aIsActive'=IsActive))
		Set Resume    = obj.HHPResume
		
		Set Data=$lb(xID,HHPCode,HHPDesc,HHPPinyin,HHPSpec,UnitDr,UnitCode,UnitDesc,AvgAmount,IsActive,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCboHHProductsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCboHHProductsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCboHHProductsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCboHHProductsExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
