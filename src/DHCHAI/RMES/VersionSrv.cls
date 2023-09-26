/// 名称: DHCHAI.RMES.VersionSrv
/// 描述: 语义词版本相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-09
Class DHCHAI.RMES.VersionSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  查询语义词版本信息
/// Table：       DHCHAI.RME.Version
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.VersionSrv","QryVersion")
Query QryVersion() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,LCode:%String")
{
}

ClassMethod QryVersionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.VersionI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.VersionI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objVersion = ##class(DHCHAI.RME.Version).GetObjById(xID)
			Continue:'$isobject(objVersion)
			
			Set Code = objVersion.BTCode
			Set Desc = objVersion.BTDesc
			Set LCode= objVersion.BTLCode
			
			Set Data = $lb(xID,Code,Desc,LCode)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryVersionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVersionExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVersionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVersionExecute ]
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
/// Description:  导入版本定义
/// w ##Class(DHCHAI.RMES.VersionSrv).ImportDic("^RME-HAI^HaI语义分析词库")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Set LCode   = $p(aInputStr,"^",4)
	Quit:(Code="")||(Desc="") return
	
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.Version).GetObjByCode(Code)
	If $IsObject(objVersion) {
		Set VersionDr=objVersion.%Id()
	}
	
	Set InputStr=VersionDr_"^"_Code_"^"_Desc_"^"_LCode
	Set return=##Class(DHCHAI.RME.Version).Update(InputStr,"^")
	Quit return
}

}
