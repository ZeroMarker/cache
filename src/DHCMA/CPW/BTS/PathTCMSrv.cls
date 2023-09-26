/// 名称: DHCMA.CPW.BTS.PathTCMSrv
/// 描述: 中药方剂 维护 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-27
Class DHCMA.CPW.BTS.PathTCMSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询中药方剂字典
/// Table：       DHCMA.CPW.BT.PathTCM
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathTCMSrv","QryPathTCM")
Query QryPathTCM(aWay As %String, aHospID As %String = "") As %Query(ROWSPEC = "BTID:%Integer,BTCode:%String,BTDesc:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String,BTActUserDesc:%String")
{
}

ClassMethod QryPathTCMExecute(ByRef qHandle As %Binary, aWay As %String, aHospID As %String = "") As %Status
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
	 	Set xID       = $o(^DHCMA.CPW.BT.PathTCMD(xID))
	 	Quit:xID=""
	 	
	 	Set obj       	 = ##class(DHCMA.CPW.BT.PathTCM).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathTCM",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	 	Set IsActive 	 = obj.BTIsActive
	 	Set ActDate      = obj.BTActDate
	 	Set ActTime      = obj.BTActTime 
	 	Set ActUserID    = obj.BTActUserID 
	 	
	 	Set IsActive=$s(IsActive=1:"是",1:"否")
		Continue:(aWay="droplist")&(IsActive="否")   //区分状态为否时，下拉列表不显示。add by dsp
		Set:ActDate'="" ActDate=$ZD(ActDate,3)   
	 	Set:ActTime'="" ActTime=$ZT(ActTime,1) 
	    Set ActUserDesc    = "" 
	 	Set objUser    = ##class(DHCMA.Util.EP.SSUser).GetObjByOID(ActUserID)
	 	if ($IsObject(objUser)) {
	 		Set ActUserDesc= objUser.BTDesc
	 	}
	 	
	 	Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathTCM","BTDesc",Desc,LangID)
	 	Set:IsActive'="" IsActive = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathtcmedit.csp",IsActive,LangID)
	 	Set:ActUserDesc'="" ActUserDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTCareProv","CTPCPDesc",ActUserDesc,Languages)
	 	
		Set Data=$lb(xID,Code,Desc,IsActive,ActDate,ActTime,ActUserID,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryPathTCMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathTCMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathTCMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathTCMExecute ]
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
