/// 名称: DHCMA.Util.BTS.SYSTEMSrv
/// 描述: 系统定义 服务类
/// 编写者：zhufei
/// 编写日期: 2018-08-24
Class DHCMA.Util.BTS.SYSTEMSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-08-24
/// Description:  根据Code取应用系统ID（传空取默认值）
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aCode : DHCMA.Util.BT.SYSTEM.BTCode
/// Return：      返回String
/// w ##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
ClassMethod GetSYSDr(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	
	If aCode="" {
		Set xID=0
		For {
			Set xID=$o(^DHCMA.Util.BT.SYSTEMD(xID))
			Quit:xID=""
			Set obj=##class(DHCMA.Util.BT.SYSTEM).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.SYSExCode'="localhost"
			Set return=obj.%Id()
		}
	} Else {
		Set ID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set:ID="" ID=##class(DHCMA.Util.BT.SYSTEM).Update("^"_aCode_"^待修正^^自动生成","^")
		Quit:ID="" return
		Set obj=##class(DHCMA.Util.BT.SYSTEM).GetObjById(ID)
		Quit:'$IsObject(obj) return
		Set return=obj.%Id()
	}
	Quit return
}

/// 取当前menu的操作权限信息
/// w flg=##class(DHCMA.Util.BTS.SYSTEMSrv).GetLoginParams(aSystemCode,aModuleCode)
ClassMethod GetLoginParams(aSystemCode As %String, aModuleCode As %String) As %String
{
	New (%session,aSystemCode,aModuleCode)
	Set return=0
	
	Set SYSDr=..GetSYSDr(aSystemCode)
	Quit:SYSDr="" return
	
	Write !,"<script language='javascript' type='text/javascript'>"
	
	Set SSGroupID=""
	If $d(%session){
		Set SSUserID=$g(%session.Data("LOGON.USERID"))     //用户ID
		Set SSGroupID=$g(%session.Data("LOGON.GROUPID"))   //安全组ID
		Set CTLocID=$g(%session.Data("LOGON.CTLOCID"))     //科室ID
		Set CTWardID=$g(%session.Data("LOGON.WARDID")) 		//病区ID
		Set CTHospID=$g(%session.Data("LOGON.HOSPID"))       //医院ID
		Set SSUserID=SSUserID_"!!"_SYSDr
		Set SSGroupID=SSGroupID_"!!"_SYSDr
		Set CTLocID=CTLocID_"!!"_SYSDr
		Set CTWardID=CTWardID_"!!"_SYSDr
		Set CTHospID=CTHospID_"!!"_SYSDr
		
		Write !,"    if (!session) var session=new Array();"
		Write !,"    session['DHCMA.USERID']='"_SSUserID_"';"
		Write !,"    session['DHCMA.GROUPID']='"_SSGroupID_"';"
		Write !,"    session['DHCMA.CTLOCID']='"_CTLocID_"';"
		Write !,"    session['DHCMA.CTWARDID']='"_CTWardID_"';"
		Write !,"    session['DHCMA.HOSPID']='"_CTHospID_"';"
	}
	
	If (aModuleCode'="")&(SSGroupID'="") {
		Set objModule=##class(DHCMA.Util.BT.MdlDef).GetObjByCode(aModuleCode)
		If $IsObject(objModule) {
			Set MdlDefDr=objModule.%Id()
			Write !,"    var tDHCMAModuleRole=new Array();"
			Set xID=0
			For {
				Set xID=$o(^DHCMA.Util.BT.MdlPowerI("IdxOfMdlGrp",MdlDefDr," "_$zcvt(SSGroupID,"U"),xID))
				Quit:xID=""
				
				Set objMdlPower=##class(DHCMA.Util.BT.MdlPower).GetObjById(xID)
				Continue:'$IsObject(objMdlPower)
				Set IsActive=objMdlPower.BTIsActive
				Continue:IsActive'=1
				Continue:'$IsObject(objMdlPower.BTMdlRoleDr)
				Set RoleCode=objMdlPower.BTMdlRoleDr.BTCode
				Set RoleDesc=objMdlPower.BTMdlRoleDr.BTDesc
				Continue:RoleCode=""
				Write !,"    tDHCMAModuleRole['"_RoleCode_"']="_1_";  //"_RoleDesc
			}
		}
	}
	
	Write !,"</script>"
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-10-12
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.Util.BTS.SYSTEMSrv).CheckPTCode("",)
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.Util.BT.SYSTEMI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-10-12
/// Description:  查询系统信息
/// Table：       DHCMA.Util.BT.SYSTEM
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.SYSTEMSrv","QrySystem")
Query QrySystem() As %Query(ROWSPEC = "SYSID:%String,SYSCode:%String,SYSDesc:%String,SYSExCode:%String,SYSNote:%String")
{
}

ClassMethod QrySystemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID        = $o(^DHCMA.Util.BT.SYSTEMD(xID))
	 	Quit:xID=""
	 	
	 	Set obj        = ##class(DHCMA.Util.BT.SYSTEM).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code       = obj.SYSCode
	 	Set Desc       = obj.SYSDesc
	 	Set ExCode       = obj.SYSExCode
	 	Set Note       = obj.SYSNote
	 	
		Set Data=$lb(xID,Code,Desc,ExCode,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}		
	Quit $$$OK
}

ClassMethod QrySystemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySystemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySystemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySystemExecute ]
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
