/// 名称: DHCMA.CPW.BTS.PathComplSrv
/// 描述: 路径并发症 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathComplSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-22
/// Description:  查询合并症
/// Table：       DHCMA.CPW.BT.PathCompl
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathComplSrv","QryPathCompl")
Query QryPathCompl(aIsActive As %String = "", aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,BTIsActiveDesc:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String,BTActUserDesc:%String")
{
}

ClassMethod QryPathComplExecute(ByRef qHandle As %Binary, aIsActive As %String = "", aHospID As %String = "") As %Status
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
	 	Set xID=$o(^DHCMA.CPW.BT.PathComplD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.BT.PathCompl).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathCompl",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	 	Set IsActive     = obj.BTIsActive
	 	Set ActDate      = obj.BTActDate
	 	Set ActTime      = obj.BTActTime
	 	Set ActUserID    = obj.BTActUserID
	 	Continue:(aIsActive'="")&&(aIsActive'=IsActive)
	 	
	 	Set IsActiveDesc = $s(IsActive=1:"是",1:"否")
	 	Set:ActDate'="" ActDate=$zd(ActDate,3)
	 	Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserDesc = ""
	 	Set objUser = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathCompl","BTDesc",Desc,LangID)
	 	Set:IsActiveDesc'="" IsActiveDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathcompledit.csp",IsActiveDesc,LangID)
	 	Set:ActUserDesc'="" ActUserDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTCareProv","CTPCPDesc",ActUserDesc,Languages)
		Set Data=$lb(xID,Code,Desc,IsActive,IsActiveDesc,ActDate,ActTime,ActUserID,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathComplClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathComplExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathComplFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathComplExecute ]
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
