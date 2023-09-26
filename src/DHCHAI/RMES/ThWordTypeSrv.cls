/// 名称: DHCHAI.RMES.ThWordTypeSrv
/// 描述: 主题词分类相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-10
Class DHCHAI.RMES.ThWordTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  查询主题词分类信息
/// Table：       DHCHAI.RME.ThWordType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThWordTypeSrv","QryThWordType")
Query QryThWordType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ThemeTypeID:%String,ThemeTypeDesc:%String")
{
}

ClassMethod QryThWordTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.ThWordTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.ThWordTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objThWordType = ##class(DHCHAI.RME.ThWordType).GetObjById(xID)
			Continue:'$isobject(objThWordType)
			
			Set Code = objThWordType.BTCode
			Set Desc = objThWordType.BTDesc
			Set ThemeTypeID="",ThemeTypeDesc=""
			If $IsObject(objThWordType.BTThemeTypeDr) {
				Set ThemeTypeID=objThWordType.BTThemeTypeDr.%Id()
				Set ThemeTypeDesc=objThWordType.BTThemeTypeDr.BTDesc
			}
			
			Set Data = $lb(xID,Code,Desc,ThemeTypeID,ThemeTypeDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryThWordTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThWordTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThWordTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThWordTypeExecute ]
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
/// Description:  导入主题词分类
/// w ##Class(DHCHAI.RMES.ThWordTypeSrv).ImportDic("^HAI01^放射学检查^HAI")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Set ThemeCode = $p(aInputStr,"^",4)
	Quit:(Code="")||(Desc="") return
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(ThemeCode)
	Quit:'$IsObject(objThemeType) return
	Set ThemeTypeDr=objThemeType.%Id()
	
	Set ThWordTypeDr=""
	Set objThWordType=##class(DHCHAI.RME.ThWordType).GetObjByCode(Code)
	If $IsObject(objThWordType) {
		Set ThWordTypeDr=objThWordType.%Id()
	}
	
	Set InputStr=ThWordTypeDr_"^"_Code_"^"_Desc_"^"_ThemeTypeDr
	Set return=##Class(DHCHAI.RME.ThWordType).Update(InputStr,"^")
	Quit return
}

}
