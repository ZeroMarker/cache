/// 名称: CT.IPMR.FPS.AreaSrv
/// 描述: 行政区划代码服务
/// 创建者：liyi
/// 创建日期: 2022-01-22
Class CT.IPMR.FPS.AreaSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询省区划代码
/// Table：       CT.IPMR.FPS.AreaSrv
/// Input：       
/// output:       参数配置列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.AreaSrv","QryProvince")
Query QryProvince(aAlias As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String") [ SqlProc ]
{
}

ClassMethod QryProvinceExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.FP.AREA.ProvinceD(xID))
		Quit:xID=""
		Set obj = ##class(CT.IPMR.FP.AREA.Province).GetObjById(xID)
		Continue:'$IsObject(obj)
		
		Set Code = obj.APCode
		Set Desc = obj.APDesc
		Set DateFrom  = obj.APDateFrom
		Set DateTo = obj.APDateTo
		IF aAlias'="" {
			Continue:'((Code[aAlias)||(Desc[aAlias))
		}
		if aIsActive'="" {
			Set CurrDate = +$h
			Set IsActive = 1 
			Set:CurrDate<DateFrom IsActive=0
			Set:(DateTo'="")&&(CurrDate>DateTo) IsActive=0
			Continue:aIsActive'=IsActive
		}
		
		Set Data=$lb(xID,Code,Desc,DateFrom,DateTo)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryProvinceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProvinceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryProvinceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProvinceExecute ]
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
