/// 名称: DHCMA.CPW.BTS.PathEntitySrv
/// 描述: 病种字典 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathEntitySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询临床路径病种字典
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathEntitySrv","QryPathEntity")
Query QryPathEntity(aIsActive As %String, aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String,BTActUserDesc:%String")
{
}

ClassMethod QryPathEntityExecute(ByRef qHandle As %Binary, aIsActive As %String, aHospID As %String = "") As %Status
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
	 	Set xID = $o(^DHCMA.CPW.BT.PathEntityD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.CPW.BT.PathEntity).GetObjById(xID)
		Continue:'$IsObject(obj)
		If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathEntity",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
		
	 	Set Code      = obj.BTCode
	 	Set Desc      = obj.BTDesc
	 	Set TypeID="",TypeDesc=""
	 	If $IsObject(obj.BTTypeDr) {
			Set TypeID  =obj.BTTypeDr.%Id()
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
		}
		Set IsActive  = obj.BTIsActive
	 	Set ActDate   = obj.BTActDate
	 	Set ActTime   = obj.BTActTime
	 	Set ActUserID = obj.BTActUserID
	 	
	 	Set IsActive  = $s(IsActive=1:"是",1:"否")
	 	Continue:IsActive="否"&aIsActive="1" //区分列表与维护查询状态为否的查询
	 	Set:ActDate'="" ActDate=$zd(ActDate,3)
	 	Set:ActTime'="" ActTime=$zt(ActTime,1)
	 	Set ActUserDesc= "" 
	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("DHCMA.CPW.BT.PathEntity","BTDesc",Desc,Languages)
	 	Set:TypeDesc'="" TypeDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("DHCMA.CPW.BT.PathType","BTDesc",TypeDesc,Languages)
	 	Set:IsActive'="" IsActive=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("DHCMA.Util.BT.Dictionary","BTDesc",IsActive,Languages)
		Set:ActUserDesc'="" ActUserDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTCareProv","CTPCPDesc",ActUserDesc,Languages)
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathEntityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathEntityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathEntityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathEntityExecute ]
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
