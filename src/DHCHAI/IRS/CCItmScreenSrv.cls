/// 名称: DHCHAI.IRS.CCItmScreenSrv
/// 描述: 疑似筛查项目定义服务
/// 编写者：pylian
/// 编写日期: 2017-07-27
Class DHCHAI.IRS.CCItmScreenSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-07-27
/// Description:  查询疑似筛查项目定义
/// Table：       DHCHAI.IR.CCItmScreen
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmScreenSrv","QryScreenSrv","")
Query QryScreenSrv(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,Desc2:%String,KeyWords:%String,Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String,Arg5:%String,Arg6:%String,Arg7:%String,Arg8:%String,Arg9:%String,Arg10:%String,Score:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryScreenSrvExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmScreenD(xID))
		Quit:xID=""
		
		Set objScreen = ##class(DHCHAI.IR.CCItmScreen).GetObjById(xID)
		Continue:'$isobject(objScreen)
		
	 	Set Desc        = objScreen.CCDesc
		Set Desc2       = objScreen.CCDesc2
		Set KeyWords    = objScreen.CCKeyWords
		Set Arg1        = objScreen.CCArg1    
		Set Arg2        = objScreen.CCArg2    
		Set Arg3        = objScreen.CCArg3    
		Set Arg4        = objScreen.CCArg4    
		Set Arg5        = objScreen.CCArg5
		Set Arg6        = objScreen.CCArg6    
		Set Arg7        = objScreen.CCArg7    
		Set Arg8        = objScreen.CCArg8    
		Set Arg9        = objScreen.CCArg9    
		Set Arg10       = objScreen.CCArg10
		Set Score       = objScreen.CCScore
		Set IsActive    = objScreen.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		
		Set ActDate     = objScreen.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objScreen.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objScreen.CCActUserDr) {
			Set ActUser     = objScreen.CCActUserDr.BTCode
			Set ActUserDesc = objScreen.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Desc,Desc2,KeyWords,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Score,IsActive,IsActDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryScreenSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryScreenSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenSrvExecute ]
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
