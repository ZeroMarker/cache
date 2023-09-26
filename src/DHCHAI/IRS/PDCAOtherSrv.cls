/// 名称: DHCHAI.IRS.PDCAOtherSrv
/// 描述: PDCA报告其他服务
/// 编写者：ShenC
/// 编写日期: 2022-08-22
Class DHCHAI.IRS.PDCAOtherSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2022-09-19
/// Description:  查询责任人关联PDCA科室
/// Table：       DHCHAI.BT.Location
///               aUserID  : 用户ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.PDCAOtherSrv","QryLocGroupUser","1")
Query QryLocGroupUser(aUserID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,LocDesc2:%String") [ SqlProc ]
{
}

ClassMethod QryLocGroupUserExecute(ByRef qHandle As %Binary, aUserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aUserID="" $$$OK
	Set GroupID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("CCLocGroupType","PDCA工作分组","1")
	Quit:GroupID="" $$$OK
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.CCLocGroupI("IndexUserGroup",aUserID,GroupID,xID))
		Quit:xID=""
		
	    Set Data=$g(^DHCHAI.IR.CCLocGroupD(xID))
	    Continue:Data=""
	    Set LocID=$lg(Data,2)
		Set LocData=$g(^DHCHAI.BT.LocationD(LocID))
		Continue:LocData=""
		Set LocCode=$lg(LocData,2)
		Set LocDesc=$lg(LocData,3)
		Set LocDesc2=$lg(LocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		
		Set Data=$lb(LocID,LocCode,LocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryLocGroupUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGroupUserExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocGroupUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGroupUserExecute ]
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

}
