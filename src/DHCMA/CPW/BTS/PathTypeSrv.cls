/// 名称: DHCMA.CPW.BTS.PathTypeSrv
/// 描述: 路径类型 维护 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-27
Class DHCMA.CPW.BTS.PathTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询临床路径类型字典
/// Table：       DHCMA.CPW.BT.PathType
/// output: BTID:%String,BTCode As %String,BTDesc As %String
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathTypeSrv","QryPathType")
Query QryPathType(aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String")
{
}

ClassMethod QryPathTypeExecute(ByRef qHandle As %Binary, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
 	For {
	 	Set xID        = $o(^DHCMA.CPW.BT.PathTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj        = ##class(DHCMA.CPW.BT.PathType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code       = obj.BTCode
	 	Set Desc       = obj.BTDesc
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathType",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathType","BTDesc",Desc,LangID)
		Set Data=$lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathTypeExecute ]
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
