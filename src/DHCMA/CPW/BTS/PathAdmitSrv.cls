/// 名称: DHCMA.CPW.BTS.PathAdmitSrv
/// 描述: 维护 服务类
/// 编写者：chenjb
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathAdmitSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2018-09-07
/// Description:  查询临床路径准入标准
/// Table：       DHCMA.CPW.BT.PathAdmit
/// Input：       
/// output: 
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathAdmitSrv","QryPathAdmit","1")
Query QryPathAdmit(aBTPathDr As %String) As %Query(ROWSPEC = "ID:%String,BTPathDr:%String,BTTypeDr:%String,BTTypeDrCode:%String,BTTypeDrDesc:%String,BTICD10:%String,BTICDKeys:%String,BTOperICD:%String,BTOperKeys:%String,BTIsICDAcc:%String,BTIsOperAcc:%String,BTIsActive")
{
}

ClassMethod QryPathAdmitExecute(ByRef qHandle As %Binary, aBTPathDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:aBTPathDr="" $$$OK	
 	Set xTypeID=""
 	For {
	 	Set xTypeID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aBTPathDr,xTypeID))
	 	Quit:xTypeID=""
		Set objDict = ##class(DHCMA.Util.BT.Dictionary).GetObjById(xTypeID)
		Continue:'$IsObject(objDict)
		Set BTTypeDr =objDict.%Id()
		Set BTTypeDrDesc = objDict.BTDesc
		Set BTTypeDrCode = objDict.BTCode
	 	Set xID = ""
	 	For {
		 	Set xID = $o(^DHCMA.CPW.BT.PathAdmitI("IdxofPathType",aBTPathDr,xTypeID,xID))
		 	Quit:xID=""
		 	Set obj = ##class(DHCMA.CPW.BT.PathAdmit).GetObjById(xID)
		 	Continue:'$IsObject(obj)
		 	
		 	Continue:'$Isobject(obj.BTPathDr)
		 	Set BTPathDr = obj.BTPathDr.%Id()
		 	Set BTICD10 =obj.BTICD10
		 	Set BTICDKeys = obj.BTICDKeys
		 	Set BTOperICD = obj.BTOperICD
		 	Set BTOperKeys = obj.BTOperKeys
		 	Set BTIsICDAcc = obj.BTIsICDAcc
		 	Set BTIsOperAcc = obj.BTIsOperAcc
		 	Set BTIsActive = obj.BTIsActive
		 	Set (BTIsICDAccD,BTIsOperAccD,BTIsActiveD)="否"
		 	Set:BTIsICDAcc=1 BTIsICDAccD="是"
		 	Set:BTIsOperAcc=1 BTIsOperAccD="是"
		 	Set:BTIsActive=1 BTIsActiveD="是"
		 	Set Data=$lb(xID,BTPathDr,BTTypeDr,BTTypeDrCode,BTTypeDrDesc,BTICD10,BTICDKeys,BTOperICD,BTOperKeys,BTIsICDAccD,BTIsOperAccD,BTIsActiveD)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}		
 	}	
	Quit $$$OK
}

ClassMethod QryPathAdmitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathAdmitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathAdmitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathAdmitExecute ]
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
