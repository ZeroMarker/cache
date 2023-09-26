/// 名称: DHCHAI.STAS.NavigationSrv
/// 描述: 统计指标导航服务
/// 编写者：pylian
/// 编写日期: 2017-08-22
Class DHCHAI.STAS.NavigationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-08-22
/// Description:  根据统计指标
/// Table：       DHCHAI.STA.Navigation
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.NavigationSrv","QryNavigation")
Query QryNavigation() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,StatCode:%String,StatDesc:%String,IndNo:%String,Method:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryNavigationExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID=""
	For {
		Set xID=$o(^DHCHAI.STA.NavigationD(xID))
		Quit:xID=""
		
		Set objNav=##class(DHCHAI.STA.Navigation).GetObjById(xID)
		Continue:'$Isobject(objNav)
		
	    Set Code     = objNav.BTCode
	    Continue:Code'["IIHAI"
	    Set Desc     = objNav.BTDesc
		Set StatCode = objNav.BTStatCode
		Set StatDesc = objNav.BTStatDesc
		Set IndNo    = objNav.BTIndNo
		Set Method   = objNav.BTMethod
		Set ActDate  = objNav.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objNav.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
	    Set ActUser=""
	    If $IsObject(objNav.BTActUserDr){
			Set ActUser=objNav.BTActUserDr.BTDesc
	    }
       
		Set Data=$lb(xID,Code,Desc,StatCode,StatDesc,IndNo,Method,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryNavigationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNavigationExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryNavigationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNavigationExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-02-20
/// Description:  感染信息化现场检查量表
/// Table：       DHCHAI.STA.Navigation
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STAS.NavigationSrv","QryMMSE")
Query QryMMSE() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,StatCode:%String,StatDesc:%String,IndNo:%String,Method:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMMSEExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID=""
	For {
		Set xID=$o(^DHCHAI.STA.NavigationD(xID))
		Quit:xID=""
		
		Set objNav=##class(DHCHAI.STA.Navigation).GetObjById(xID)
		Continue:'$Isobject(objNav)
		
	    Set Code     = objNav.BTCode
	    Continue:Code'["2017-"
	    Set Desc     = objNav.BTDesc
		Set StatCode = objNav.BTStatCode
		Set StatDesc = objNav.BTStatDesc
		Set IndNo    = objNav.BTIndNo
		Set Method   = objNav.BTMethod
		Set ActDate  = objNav.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objNav.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
	    Set ActUser=""
	    If $IsObject(objNav.BTActUserDr){
			Set ActUser=objNav.BTActUserDr.BTDesc
	    }
       
		Set Data=$lb(xID,Code,Desc,StatCode,StatDesc,IndNo,Method,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMMSEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMMSEExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMMSEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMMSEExecute ]
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
