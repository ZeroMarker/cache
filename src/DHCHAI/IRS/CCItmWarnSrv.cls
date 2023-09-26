/// 名称: DHCHAI.IRS.CCItmWarnSrv
/// 描述: 暴发预警项目定义服务
/// 编写者：pylian
/// 编写日期: 2017-07-27
Class DHCHAI.IRS.CCItmWarnSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-07-27
/// Description:  查询暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCItmWarnSrv","QryWarnSrv","")
Query QryWarnSrv(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,Desc:%String,Desc2:%String,KeyWords:%String,IndNo:%String,Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String,Arg5:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryWarnSrvExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.IR.CCItmWarnD(xID))
		Quit:xID=""
		
		Set objWarn = ##class(DHCHAI.IR.CCItmWarn).GetObjById(xID)
		Continue:'$isobject(objWarn)
		
	 	Set Desc        = objWarn.CCDesc
		Set Desc2       = objWarn.CCDesc2
		Set KeyWords    = objWarn.CCKeyWords
		Set IndNo		= objWarn.CCIndNo
		Set Arg1        = objWarn.CCArg1    
		Set Arg2        = objWarn.CCArg2    
		Set Arg3        = objWarn.CCArg3    
		Set Arg4        = objWarn.CCArg4    
		Set Arg5        = objWarn.CCArg5  
		Set IsActive    = objWarn.CCIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",IsActive=0:"否",1:"是")
		
		Set ActDate     = objWarn.CCActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime     = objWarn.CCActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
		If $IsObject(objWarn.CCActUserDr) {
			Set ActUser     = objWarn.CCActUserDr.BTCode
			Set ActUserDesc = objWarn.CCActUserDr.BTDesc
		}

		Set Data = $lb(xID,Desc,Desc2,KeyWords,IndNo,Arg1,Arg2,Arg3,Arg4,Arg5,IsActive,IsActDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryWarnSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWarnSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnSrvExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-03-15
/// Description:  根据Code取暴发预警项目定义
/// Table：       DHCHAI.IR.CCItmWarn
/// Input：       aCode : DHCHAI.IR.CCItmWarn.CCDesc
/// Return：      返回Obj
/// w ##class(DHCHAI.IRS.CCItmWarnSrv).GetStrByDesc("发热")
ClassMethod GetStrByDesc(aDesc As %String) As %String
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set obj=##class(DHCHAI.IR.CCItmWarn).GetObjByDesc(aDesc)
	Quit:'$IsObject(obj) return
	Set $p(return,"^",1)=obj.CCDesc      // 项目名称
	Set $p(return,"^",2)=obj.CCDesc2     // 项目名称2
	Set $p(return,"^",3)=obj.CCKeyWords  // 关键词(多值“,”分割)
	Set $p(return,"^",4)=obj.CCIndNo     // 排序码
	Set $p(return,"^",5)=obj.CCArg1      // 参数1
	Set $p(return,"^",6)=obj.CCArg2      // 参数2
	Set $p(return,"^",7)=obj.CCArg3      // 参数3
	Set $p(return,"^",8)=obj.CCArg4      // 参数4
	Set $p(return,"^",9)=obj.CCArg5      // 参数5
	Set $p(return,"^",10)=obj.CCIsActive // 是否有效
	Quit return
}

}
