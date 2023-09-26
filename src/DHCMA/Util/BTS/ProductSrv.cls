/// 名称: DHCMA.Util.BTS.ProductSrv
/// 描述: 产品 服务类
/// 编写者：刘贞贺   
/// 编写日期: 2018-09-17
Class DHCMA.Util.BTS.ProductSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-17
/// Description:  查询产品线
/// Table：       DHCMA.Util.BT.Product
/// Input： 
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.ProductSrv","QryProduct")      
Query QryProduct(aActive As %String = "") As %Query(ROWSPEC = "ProID:%String,ProCode:%String,ProDesc:%String,ProVersion:%String,ProIconCls:%String,ProIndNo:%String,IsActive:%String,IsActDesc:%String,ProResume :%String")
{
}

ClassMethod QryProductExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For{
	 	Set xID      = $o(^DHCMA.Util.BT.ProductD(xID))
	 	Quit:xID=""
	 	
	 	Set obj      = ##class(DHCMA.Util.BT.Product).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.ProCode
	 	Set Desc     = obj.ProDesc
	 	Set Version  = obj.ProVersion
	 	Set Icon     = obj.ProIconClass
	 	Set IndNo    = obj.ProIndNo
	 	Set IsActive = obj.ProIsActive
	 	Set Resume   = obj.ProResume
	 	
	 	Continue:(aActive'="")&&(aActive'=IsActive)
	 	Set IsActDesc=$s(IsActive=1:"是",1:"否")
	    
		Set Data=$lb(xID,Code,Desc,Version,Icon,IndNo,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProductExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProductExecute ]
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

/// Creator：     yukai
/// CreatDate：   2019-06-04
/// Description:  查询产品线
/// Table：       DHCMA.Util.BT.Product
/// Input： 
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.ProductSrv","QryConProduct","")      
Query QryConProduct(aProduct As %String) As %Query(ROWSPEC = "ProID:%String,ProCode:%String,ProDesc:%String,ProVersion:%String,ProIconCls:%String,ProIndNo:%String,IsActive:%String,IsActDesc:%String,ProResume :%String")
{
}

ClassMethod QryConProductExecute(ByRef qHandle As %Binary, aProduct As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For{
	 	Set xID      = $o(^DHCMA.Util.BT.ProductD(xID))
	 	Quit:xID=""
	 	
	 	Set obj      = ##class(DHCMA.Util.BT.Product).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.ProCode
	 	Continue:(aProduct'="")&&(Code'=aProduct)
	 	Set Desc     = obj.ProDesc
	 	Set Version  = obj.ProVersion
	 	Set Icon     = obj.ProIconClass
	 	Set IndNo    = obj.ProIndNo
	 	Set IsActive = obj.ProIsActive
	 	Set Resume   = obj.ProResume
	 	
	 	Set IsActDesc=$s(IsActive=1:"是",1:"否")
	    
		Set Data=$lb(xID,Code,Desc,Version,Icon,IndNo,IsActive,IsActDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryConProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProductExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryConProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProductExecute ]
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
