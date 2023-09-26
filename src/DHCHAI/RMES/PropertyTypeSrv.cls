/// 名称: DHCHAI.RMES.PropertyTypeSrv
/// 描述: 属性类型相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-10
Class DHCHAI.RMES.PropertyTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  查询属性类型信息
/// Table：       DHCHAI.RME.PropertyType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.PropertyTypeSrv","QryPropertyType")
Query QryPropertyType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryPropertyTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.PropertyTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.PropertyTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objProType = ##class(DHCHAI.RME.PropertyType).GetObjById(xID)
			Continue:'$isobject(objProType)
			
			Set Code = objProType.BTCode
			Set Desc = objProType.BTDesc
			
			Set Data = $lb(xID,Code,Desc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPropertyTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPropertyTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPropertyTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPropertyTypeExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2018-08-26
/// Description:  导入结果类型
/// w ##Class(DHCHAI.RMES.PropertyTypeSrv).ImportDic("^<TIME_HAPPEN>^开始时间")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set PropertyTypeDr=""
	Set objPropertyType=##class(DHCHAI.RME.PropertyType).GetObjByCode(Code)
	If $IsObject(objPropertyType) {
		Set PropertyTypeDr=objPropertyType.%Id()
	}
	Set InputStr=PropertyTypeDr_"^"_Code_"^"_Desc
	Set return=##Class(DHCHAI.RME.PropertyType).Update(InputStr,"^")
	Quit return
}

}
