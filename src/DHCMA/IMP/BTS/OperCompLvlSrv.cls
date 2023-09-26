/// 名称: DHCMA.IMP.BTS.OperCompDicSrv
/// 描述: 手术并发症分级 服务类
/// 编写者：dengshaopeng
/// 编写日期: 2020-05-28
Class DHCMA.IMP.BTS.OperCompLvlSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dengshaopeng
/// CreatDate：   2020-05-28
/// Description:  查询手术并发症分级
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.OperCompLvlSrv","QryOperCompLvl")
Query QryOperCompLvl(aIsActive As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTLinkLevel:%String,BTIsActive:%String,BTOrder:%String,BTActDate:%String,BTActTime:%String,BTActUserID:%String")
{
}

ClassMethod QryOperCompLvlExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=""
 	For {
	 	Set xID = $o(^CT.MA.IMP.BTOperCompLvLD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(xID)
		Continue:'$IsObject(obj)
	 	Set BTCode      = obj.BTCode
	 	Set BTDesc      = obj.BTDesc
	 	Set BTLnkLevel  = obj.BTLnkLevel
		Set BTIsActive  = obj.BTIsActive
	 	Set BTOrder     = obj.BTOrder
	 	Set BTActDate   = obj.BTActDate  
	    Set BTActTime   = obj.BTActTime  
		Set BTActUserID = obj.BTActUserID
	 	
	 	Set BTIsActive  = $s(BTIsActive=1:"是",1:"否")
	 	Continue:BTIsActive="否"&aIsActive="1" //区分列表与维护查询状态为否的查询
		Set:BTDesc'="" BTDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",BTDesc)
	 	
		Set Data=$lb(xID,BTCode,BTDesc,BTLnkLevel,BTIsActive,BTOrder,BTActDate,BTActTime,BTActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryOperCompLvlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperCompLvlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperCompLvlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperCompLvlExecute ]
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

/// Creator：     dengshaopeng
/// CreatDate：   2020-05-28
/// Description:  查询手术并发症分级
/// Table：       DHCMA.CPW.BT.PathEntity
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.OperCompLvlSrv","QryOperCompLvlIsCheck")
Query QryOperCompLvlIsCheck(aIsActive As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTLnkLevel:%String,BTIsActive:%String,BTOrder:%String,IsCheck:%String,IsChildCode:%String")
{
}

ClassMethod QryOperCompLvlIsCheckExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=""
 	For {
	 	Set xID = $o(^CT.MA.IMP.BTOperCompLvLD(xID))
	 	Quit:xID=""

	 	Set obj = ##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(xID)
		Continue:'$IsObject(obj)
	 	Set BTCode      = obj.BTCode
	 	Set BTDesc      = obj.BTDesc
	 	Set BTLnkLevel  =obj.BTLnkLevel
		Set BTIsActive  = obj.BTIsActive
	 	Set BTOrder     = obj.BTOrder
	 	Set IsCheck=1
	 	Set IsChildCode = 1
	 	b ;2
	 	Set:BTCode=BTLnkLevel IsCheck   =..GetIsCheck(BTCode,BTLnkLevel),IsChildCode=0
	 	Set BTIsActive     = $s(BTIsActive=1:"是",1:"否")
	 	Continue:BTIsActive="否"&aIsActive="1" //区分列表与维护查询状态为否的查询
		Set:BTDesc'="" BTDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",BTDesc)
	 	
		Set Data=$lb(xID,BTCode,BTDesc,BTLnkLevel,BTIsActive,BTOrder,IsCheck,IsChildCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryOperCompLvlIsCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOperCompLvlIsCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOperCompLvlIsCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOperCompLvlIsCheckExecute ]
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

ClassMethod GetIsCheck(aCode As %String, aLinkLevel As %String)
{
	new (aCode,aLinkLevel)
	
	Set return = 1
	Set aID=""
	For{
		Set aID = $o(^CT.MA.IMP.BTOperCompLvLI("IdxOfLnkLevel"," "_$zcvt(aLinkLevel,"U"),aID))
		Quit:aID=""
		Set obj=##class(DHCMA.IMP.BT.OperCompLvL).GetObjById(aID)
		Set Code = obj.BTCode
		b ;1
		Set:aCode'=Code return = 0
		}
		
	Quit return
}

}
