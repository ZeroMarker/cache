/// 名称: DHCHAI.IRS.CRuleRBAbSrv
/// 描述: 影像学筛查标准相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-02
Class DHCHAI.IRS.CRuleRBAbSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  查询影像学筛查标准列表
/// Table：       DHCHAI.IR.CRuleRBAb
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CRuleRBAbSrv","QryCRuleRBAb")
Query QryCRuleRBAb() As %Query(ROWSPEC = "ID:%String,RBCode:%String,RBPos:%String,RBNote:%String,RBCFlag:%String") [ SqlProc ]
{
}

ClassMethod QryCRuleRBAbExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.IR.CRuleRBAbD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.IR.CRuleRBAb).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set RBCode   = obj.BTRBCode
	 	Set RBPos    = obj.BTRBPos
		Set RBNote   = obj.BTRBNote
		Set RBCFlag  = obj.BTRBCFlag
		
		Set Data=$lb(xID,RBCode,RBPos,RBNote,RBCFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCRuleRBAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCRuleRBAbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCRuleRBAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCRuleRBAbExecute ]
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
