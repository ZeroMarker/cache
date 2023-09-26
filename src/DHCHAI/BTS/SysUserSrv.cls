/// 名称: DHCHAI.BTS.ConfigSrv
/// 描述: 系统用户相关服务
/// 编写者：pylian
/// 编写日期: 2017-03-21
Class DHCHAI.BTS.SysUserSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-03-23
/// Description:  查询用户列表
/// Table：       DHCHAI.BT.SysUser
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.SysUserSrv","QrySysUser",1)
Query QrySysUser(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,UserCode:%String,UserDesc:%String,LocCode:%String,LocDesc:%String,TypeCode:%String,TypeDesc:%String,HISUserID,Active:%String,ActiveDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QrySysUserExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.BT.SysUserD(xID))
		Quit:xID=""
		
		Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(xID)
		Continue:'$isobject(objUser)
		
		Set UserCode      = objUser.BTCode	   
	    Set UserDesc 	  = objUser.BTDesc
	    Set LocCode="",LocDesc=""
	    If $IsObject(objUser.BTLocDr) {	   
			Set LocCode   = objUser.BTLocDr.BTCode
			Set LocDesc   = objUser.BTLocDr.BTDesc
	    }
		Set TypeCode="",TypeDesc=""
	    If $IsObject(objUser.BTTypeDr) {	   
			Set TypeCode  = objUser.BTTypeDr.BTCode
			Set TypeDesc  = objUser.BTTypeDr.BTDesc
	    }
	    Set HISUserID 	  = objUser.BTXCode		
	    Set Active 		  = objUser.BTIsActive
		Continue:(aActive'="")&&(aActive'=Active)
		Set:+Active=1 ActiveDesc = "是"
		Set:+Active=0 ActiveDesc = "否"	
	    Set ActDate 	  = objUser.BTActDate	
	    Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime 	  = objUser.BTActTime	
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		
		Set ActUser="",ActUserDesc=""
	    If $IsObject(objUser.BTActUserDr) {	   
			Set ActUser    = objUser.BTActUserDr.BTCode
			Set ActUserDesc= objUser.BTActUserDr.BTDesc
	    }
		Set Data=$lb(xID,UserCode,UserDesc,LocCode,LocDesc,TypeCode,TypeDesc,HISUserID,Active,ActiveDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySysUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySysUserExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySysUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySysUserExecute ]
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
/// CreatDate：   2017-03-23
/// Description:  根据条件查询用户列表
/// Table：       DHCHAI.BT.SysUser
/// Input：       aLocID:科室ID ,aTypeID:类型ID, aUserName:用户名称,aUserCode:用户工号
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.SysUserSrv","QrySysUserList","","","W","","")
Query QrySysUserList(aLocID As %String = "", aTypeID As %String = "", aUserName As %String = "", aUserCode As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,UserCode:%String,UserDesc:%String,LocCode:%String,LocDesc:%String,TypeCode:%String,TypeDesc:%String,HISUserID,Active:%String,ActiveDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QrySysUserListExecute(ByRef qHandle As %Binary, aLocID As %String = "", aTypeID As %String = "", aUserName As %String = "", aUserCode As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set xID=""
	For {
		Set xID = $o(^DHCHAI.BT.SysUserD(xID))
		Quit:xID=""
		
		Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(xID)
		Continue:'$isobject(objUser)
		
		Set UserCode 		= objUser.BTCode
		Continue:(aUserCode'="")&&($ZCVT(aUserCode,"U")'=$ZCVT(UserCode,"U"))	   
	    Set UserDesc 		= objUser.BTDesc
	    Continue:(aUserName'="")&&(($ZCVT(UserDesc,"U")'[$ZCVT(aUserName,"U"))&&($ZCVT(UserCode,"U")'[$ZCVT(aUserName,"U")))   	   
		Set LocID="",LocCode="",LocDesc=""
		If $IsObject(objUser.BTLocDr) {
			Set LocID=objUser.BTLocDr.%Id()
	        Set LocCode         = objUser.BTLocDr.BTCode
			Set LocDesc         = objUser.BTLocDr.BTDesc
		}
		Continue:(aLocID'="")&&(aLocID'=LocID)
		
		Set TypeID="",TypeCode="",TypeDesc=""
		If $IsObject(objUser.BTTypeDr) {
			Set TypeID=objUser.BTTypeDr.%Id()
			Set TypeCode        = objUser.BTTypeDr.BTCode
			Set TypeDesc        = objUser.BTTypeDr.BTCode
		}
		Continue:(aTypeID'="")&&(aTypeID'=TypeID)
	    Set HISUserID 		= objUser.BTXCode		
	    Set Active 			= objUser.BTIsActive
		Continue:(aActive'="")&&(aActive'=Active)
		Set:+Active=1 ActiveDesc = "是"
		Set:+Active=0 ActiveDesc = "否"	
	    Set ActDate 		= objUser.BTActDate	
	    Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime 		= objUser.BTActTime	
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser="",ActUserDesc=""
	    If $IsObject(objUser.BTActUserDr) {	   
			Set ActUser    = objUser.BTActUserDr.BTCode
			Set ActUserDesc= objUser.BTActUserDr.BTDesc
	    }
	    //多语言处理
	    Set UserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",UserDesc,"User.SSUser")
	    Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
		Set Data=$lb(xID,UserCode,UserDesc,LocCode,LocDesc,TypeCode,TypeDesc,HISUserID,Active,ActiveDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySysUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySysUserListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySysUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySysUserListExecute ]
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

/// w ##class(DHCHAI.BTS.SysUserSrv).QueryUsers("1","10")
ClassMethod QueryUsers(hospId As %String, locId As %String)
{
	new (hospId, locId, userObj, locObj, hospObj)
	Set return="", jsonObj = ##Class(%ArrayOfDataTypes).%New()
	
	Set xID = ""
	for {
		Set xID = $o(^DHCHAI.BT.SysUserD(xID))
		Quit:xID=""
		
		Set userObj = ##class(DHCHAI.BT.SysUser).GetObjById(xID)
		Continue:'userObj.BTIsActive
		
		// 取科室信息
		Set locObj = userObj.BTLocDr
		Continue:'$ISOBJECT(locObj)
		Continue:locObj.%Id()'=locId
		Do jsonObj.SetAt(locObj.%Id(), "locId")
		Do jsonObj.SetAt(locObj.BTCode, "locCode")
		Do jsonObj.SetAt(locObj.BTDesc_"||"_locObj.BTDesc2, "locDesc")
		// 取院区信息
		Set hospObj = ##class(DHCHAI.BT.Hospital).GetObjById(jsonObj.GetAt("locId"))
		if $ISOBJECT(hospObj) {
			Continue:hospObj.%Id()'=hospId
			Do jsonObj.SetAt(hospObj.%Id(), "hospId")
			//Set jsonObj.hospDesc = hospObj.BTDesc
		}
		// 取用户基本信息
		Do jsonObj.SetAt(userObj.%Id(), "userId")
		Do jsonObj.SetAt(userObj.BTDesc, "userName")
		Do jsonObj.SetAt(userObj.BTCode, "userCode")
		Set typeObj = userObj.BTTypeDr
		if $ISOBJECT(typeObj) {
			Do jsonObj.SetAt(typeObj.BTCode, "typeCode")
			Do jsonObj.SetAt(typeObj.BTDesc, "typeDesc")
		}
		Do jsonObj.SetAt(userObj.BTXCode, "hisId")
		//Set jsonObj.hisId = $p(userObj.BTXCode, "||", 2)
		
		Set JsonStr = ##class(ext.util.JsonObject).ObjToJson(jsonObj)
		if (return = "") {
			Set return = JsonStr
		}else{
			Set return=return_"#"_JsonStr
		}
	}
	quit return
}

}
