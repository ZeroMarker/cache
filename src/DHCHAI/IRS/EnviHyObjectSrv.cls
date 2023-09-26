/// 名称: DHCHAI.IRS.EnviHyObjectSrv
/// 描述: 环境卫生学监测对象服务
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IRS.EnviHyObjectSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  查询监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyObjectSrv","QryEvObject","空气")
Query QryEvObject(aAlis As %String = "") As %Query(ROWSPEC = "ID:%String,ObjectDesc:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,IsActive:%String,IsActDesc:%String,HospID:%String,HospDesc:%String,ObjectDesc2:%String,LocID:%String,LocDesc:%String")
{
}

ClassMethod QryEvObjectExecute(ByRef qHandle As %Binary, aAlis As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyObjectD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.EnviHyObject).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set ObjectDesc  = obj.EHObjDesc
		Set ObjectDesc2  = obj.EHObjDesc2
		Set SpecimenTypeID="",SpecimenTypeDesc=""
		If $IsObject(obj.EHSpecimenTypeDr){
			Set SpecimenTypeID=obj.EHSpecimenTypeDr.%Id()
			Set SpecimenTypeDesc=obj.EHSpecimenTypeDr.BTDesc
		}
		Set IsActive 		= obj.EHIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set HospID="",HospDesc=""
		If $IsObject(obj.EHHospDr){
			Set HospID=obj.EHHospDr.%Id()
			Set HospDesc=obj.EHHospDr.BTDesc
		}
		Set LocID="",LocDesc=""
		If $IsObject(obj.EHLocationDr){
			Set LocID=obj.EHLocationDr.%Id()
			Set LocDesc=obj.EHLocationDr.BTDesc
		}
		Continue:(aAlis'="")&&(ObjectDesc'[aAlis)&&(ObjectDesc2'[aAlis)&&(SpecimenTypeDesc'[aAlis)&&(LocDesc'[aAlis)
		Set Data=$lb(xID,ObjectDesc,SpecimenTypeID,SpecimenTypeDesc,IsActive,IsActDesc,HospID,HospDesc,ObjectDesc2,LocID,LocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryEvObjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvObjectExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvObjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvObjectExecute ]
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

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  查询监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyObjectSrv","QryEvObjectByLoc","1")
Query QryEvObjectByLoc(aLocDr As %String = "") As %Query(ROWSPEC = "ID:%String,ObjectDesc:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,IsActive:%String,IsActDesc:%String,HospID:%String,HospDesc:%String,ObjectDesc2:%String,LocID:%String,LocDesc:%String")
{
}

ClassMethod QryEvObjectByLocExecute(ByRef qHandle As %Binary, aLocDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyObjectD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.EnviHyObject).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set ObjectDesc  = obj.EHObjDesc
		Set ObjectDesc2  = obj.EHObjDesc2
		Set:ObjectDesc2'="" ObjectDesc=ObjectDesc2
		Set SpecimenTypeID="",SpecimenTypeDesc=""
		If $IsObject(obj.EHSpecimenTypeDr){
			Set SpecimenTypeID=obj.EHSpecimenTypeDr.%Id()
			Set SpecimenTypeDesc=obj.EHSpecimenTypeDr.BTDesc
		}
		Set IsActive 		= obj.EHIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set HospID="",HospDesc=""
		If $IsObject(obj.EHHospDr){
			Set HospID=obj.EHHospDr.%Id()
			Set HospDesc=obj.EHHospDr.BTDesc
		}
		Set LocID="",LocDesc=""
		If $IsObject(obj.EHLocationDr){
			Set LocID=obj.EHLocationDr.%Id()
			Set LocDesc=obj.EHLocationDr.BTDesc
		}
		Continue:(aLocDr'="")&&(aLocDr'=LocID)
		Set Data=$lb(xID,ObjectDesc,SpecimenTypeID,SpecimenTypeDesc,IsActive,IsActDesc,HospID,HospDesc,ObjectDesc2,LocID,LocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryEvObjectByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvObjectByLocExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvObjectByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvObjectByLocExecute ]
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

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  根据监测项目对象类型查询监测对象
/// Table：       DHCHAI.IR.EnviHyObject
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyObjectSrv","QryEvObjByItem",5)
Query QryEvObjByItem(aItemID As %String = "") As %Query(ROWSPEC = "ID:%String,ObjectDesc:%String,SpecimenTypeID:%String,SpecimenTypeDesc:%String,IsActive:%String,IsActDesc:%String")
{
}

ClassMethod QryEvObjByItemExecute(ByRef qHandle As %Binary, aItemID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aItemID="" $$$OK
	
	Set objEvItem = ##class(DHCHAI.IR.EnviHyItem).GetObjById(aItemID)
	Quit:'$IsObject(objEvItem) $$$OK
	
	Set SpecimenTypeDr = objEvItem.EHSpecimenTypeDr
	Quit:'$IsObject(SpecimenTypeDr) $$$OK
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.EnviHyObjectI("IndexOnSpecimenType",SpecimenTypeDr.%Id(),xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.IR.EnviHyObject).GetObjById(xID)
		Continue:'$IsObject(obj)
	
		Set ObjectDesc  = obj.EHObjDesc
		Set SpecimenTypeID="",SpecimenTypeDesc=""
		If $IsObject(obj.EHSpecimenTypeDr){
			Set SpecimenTypeID=obj.EHSpecimenTypeDr.%Id()
			Set SpecimenTypeDesc=obj.EHSpecimenTypeDr.BTDesc
		}
		Set IsActive = obj.EHIsActive
		Continue:IsActive'=1
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
		Set Data=$lb(xID,ObjectDesc,SpecimenTypeID,SpecimenTypeDesc,IsActive,IsActDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryEvObjByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvObjByItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvObjByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvObjByItemExecute ]
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
