/// 名称: DHCHAI.RMES.ThemeTypeSrv
/// 描述: 主题分类相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-10
Class DHCHAI.RMES.ThemeTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-10
/// Description:  根据词库版本ID查询主题分类信息
/// Table：       DHCHAI.RME.ThemeType
/// Input：       aVersionDr:   语义词库版本ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThemeTypeSrv","QryThemeType")
Query QryThemeType(aVersionDr As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,VerID:%String,VerCode:%String,VerDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String")
{
}

ClassMethod QryThemeTypeExecute(ByRef qHandle As %Binary, aVersionDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCHAI.RME.ThemeTypeI("IndexCode",xCode))
		Quit:xCode=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.RME.ThemeTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			
			Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(xID)
			Continue:'$isobject(objThemeType)
			
			Set Code     = objThemeType.BTCode
			Set Desc     = objThemeType.BTDesc
			Set IsActive = objThemeType.BTIsActive
			If $IsObject(objThemeType.BTVersionDr) {
				Set VerID   = objThemeType.BTVersionDr.%Id()  
				Set VerCode = objThemeType.BTVersionDr.BTCode
				Set VerDesc = objThemeType.BTVersionDr.BTDesc
		    }Else {
				Set (VerID,VerCode,VerDesc)=""   
			}
			Continue:(aVersionDr'="")&&(aVersionDr'=VerID)
			Set ActDate = objThemeType.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objThemeType.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set ActUser = objThemeType.BTActUser
			
			Set Data = $lb(xID,Code,Desc,IsActive,VerID,VerCode,VerDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryThemeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThemeTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThemeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThemeTypeExecute ]
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
/// Description:  导入主题分类
/// w ##Class(DHCHAI.RMES.ThemeTypeSrv).ImportDic("^INF-HAI^感染主题词库（通用）^RME-HAI")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Set Version = $p(aInputStr,"^",4)
	Quit:(Code="")||(Desc="") return
	
	Set objVersion=##class(DHCHAI.RME.Version).GetObjByCode(Version)
	Quit:'$IsObject(objVersion) return
	Set VersionDr=objVersion.%Id()
	
	Set ThemeTypeDr=""
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(Code)
	If $IsObject(objThemeType) {
		Set ThemeTypeDr=objThemeType.%Id()
	}
	
	Set InputStr=ThemeTypeDr_"^"_Code_"^"_Desc_"^"_VersionDr_"^"_1_"^^^"
	Set return=##Class(DHCHAI.RME.ThemeType).Update(InputStr,"^")
	Quit return
}

}
