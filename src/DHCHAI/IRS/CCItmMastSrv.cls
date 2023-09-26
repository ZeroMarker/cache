/// 名称: DHCHAI.IRS.CCItmMastSrv
/// 描述: 监控项目维护相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCItmMastSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-27
/// Description:  查询监控项目
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmMastSrv","QryItmMast","")
Query QryItmMast(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryItmMastExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmMastD(xID))
		Quit:xID=""
		
		Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xID)
		Continue:'$isobject(objItmMast)
		
		Set Code        = objItmMast.CCCode
		Set Desc        = objItmMast.CCDesc
		Set IsActive    = objItmMast.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		
		Set ActDate     = objItmMast.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objItmMast.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objItmMast.CCActUserDr) {
			Set ActUser     = objItmMast.CCActUserDr.BTCode
			Set ActUserDesc = objItmMast.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Code,Desc,IsActive,IsActDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItmMastExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItmMastExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-28
/// Description:  根据Code查询监控项目
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmMastSrv","QryMastByCode","CS1","")
Query QryMastByCode(aCode As %String, aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMastByCodeExecute(ByRef qHandle As %Binary, aCode As %String, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aCode="" $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmMastI("IdxofCode",aCode,xID))
		Quit:xID=""
		
		Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xID)
		Continue:'$isobject(objItmMast)
		
		Set Code        = objItmMast.CCCode
		Set Desc        = objItmMast.CCDesc
		Set IsActive    = objItmMast.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		Set ActDate     = objItmMast.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objItmMast.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objItmMast.CCActUserDr) {
			Set ActUser     = objItmMast.CCActUserDr.BTCode
			Set ActUserDesc = objItmMast.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Code,Desc,IsActive,IsActDesc,ActDate,ActTime,ActUser,ActUserDesc)
	    Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMastByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMastByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMastByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMastByCodeExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-28
/// Description:  根据Desc查询监控项目
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmMastSrv","QryMastByDesc","测试1","")
Query QryMastByDesc(aDesc As %String, aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMastByDescExecute(ByRef qHandle As %Binary, aDesc As %String, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aDesc="" $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmMastD(xID))
		Quit:xID=""
			
		Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xID)
		Continue:'$isobject(objItmMast)
		
		Set Code        = objItmMast.CCCode
		Set Desc        = objItmMast.CCDesc
		Continue:(aDesc'="")&&(aDesc'=Desc)
		Set IsActive    = objItmMast.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		Set ActDate     = objItmMast.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objItmMast.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objItmMast.CCActUserDr) {
			Set ActUser     = objItmMast.CCActUserDr.BTCode
			Set ActUserDesc = objItmMast.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Code,Desc,IsActive,IsActDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryMastByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMastByDescExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMastByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMastByDescExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-28
/// Description:  模糊查询监控项目
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmMastSrv","QryItmMastSrv","CS","测试","","","")
Query QryItmMastSrv(aCode As %String, aDesc As %String, aActive As %String = "", aScreening As %String = "", aWarning As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,IsScreening:%String,IsWarning:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryItmMastSrvExecute(ByRef qHandle As %Binary, aCode As %String, aDesc As %String, aActive As %String = "", aScreening As %String = "", aWarning As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmMastD(xID))
		Quit:xID=""
			
		Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xID)
		Continue:'$isobject(objItmMast)
		
		Set Code        = objItmMast.CCCode
		Continue:(aCode'="")&&($zcvt(Code,"U")'[$zcvt(aCode,"U"))
		Set Desc        = objItmMast.CCDesc
		Continue:(aDesc'="")&&(Desc'[aDesc)
		Set IsActive    = objItmMast.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActive=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		Set IsScreening = objItmMast.CCIsScreening
		Continue:(aScreening'="")&&(IsScreening'=aScreening)
		Set IsScreening=$s(IsScreening=1:"是",IsScreening=0:"否",1:"是")
		Set IsWarning   = objItmMast.CCIsWarning
		Continue:(aWarning'="")&&(IsWarning'=aWarning)
		Set IsWarning=$s(IsWarning=1:"是",IsWarning=0:"否",1:"是")
		Set ActDate     = objItmMast.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objItmMast.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objItmMast.CCActUserDr) {
			Set ActUser     = objItmMast.CCActUserDr.BTCode
			Set ActUserDesc = objItmMast.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Code,Desc,IsActive,IsScreening,IsWarning,ActDate,ActTime,ActUser,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryItmMastSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItmMastSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryItmMastSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItmMastSrvExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-28
/// Description:  获得监控项目
/// Table：       DHCHAI.IR.CCItmMast
/// Input：       aCode : DHCHAI.IR.CCItmMast.CCCode
/// Return：      返回Obj
/// w ##class(DHCHAI.IRS.CCItmMastSrv).GetItmMastInfo()
ClassMethod GetItmMastInfo() As %String
{

	Set return=""
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmMastD(xID))
		Quit:xID=""
			
		Set objItmMast = ##class(DHCHAI.IR.CCItmMast).GetObjById(xID)
		Continue:'$isobject(objItmMast)
		Set IsActive    = objItmMast.CCIsActive
		Continue:(IsActive'=1)
		Set Code        = objItmMast.CCCode
		Set Desc        = objItmMast.CCDesc
		
		Set return=return_$c(1)_Code_"^"_Desc
		
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
