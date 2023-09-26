/// 名称: DHCMA.IMP.BTS.OperCompDicSrv
/// 描述: 手术并发症字典 服务类
/// 编写者：dengshaopeng
/// 编写日期: 2020-05-28
Class DHCMA.IMP.BTS.OperCompDicSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2020-05-28
/// Description:  查询手术并发症字典
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.OperCompDicSrv","QryOperCompDic")
Query QryOperCompDic(aIsActive As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,BTOrder:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String")
{
}

ClassMethod QryOperCompDicExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=""
 	For {
	 	Set xID = $o(^CT.MA.IMP.BTOperCompDicD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.IMP.BT.OperCompDic).GetObjById(xID)
		Continue:'$IsObject(obj)
	 	Set BTCode      = obj.BTCode
	 	Set BTDesc      = obj.BTDesc
		Set BTIsActive  = obj.BTIsActive
	 	Set BTOrder     = obj.BTOrder
	 	Set BTActDate   = obj.BTActDate
	 	Set BTActTime   = obj.BTActTime
	 	Set BTActUserID = obj.BTActUserID
	 	
	 	Set:BTActDate'="" BTActDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BTActDate)
	 	Set:BTActTime'="" BTActTime = $zt(BTActTime,2)
	 	
	 	Set BTIsActive  = $s(BTIsActive=1:"是",1:"否")
	 	Continue:BTIsActive="否"&aIsActive="1" //区分列表与维护查询状态为否的查询
		Set:BTDesc'="" BTDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",BTDesc)
	 	
		Set Data=$lb(xID,BTCode,BTDesc,BTIsActive,BTOrder,BTActDate,BTActTime,BTActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryOperCompDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperCompDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperCompDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperCompDicExecute ]
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
