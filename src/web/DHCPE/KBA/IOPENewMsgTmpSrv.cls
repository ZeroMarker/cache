/// 名称: web.DHCPE.KBA.IOPENewMsgTmpSrv
/// 描述: 导出导入科室短信模板
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPENewMsgTmpSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出科室短信模板（绝对私有）
/// Table：      User.DHCPENewMessageTemplet
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPENewMsgTmpSrv","QryMsgTmp",152)
Query QryMsgTmp(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Type:%String,Default:%String,Templet:%String,VIPLevelCode:%String,VIPLevelDesc:%String,Active:%String")
{
}

ClassMethod QryMsgTmpExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
	Set xID=0
	For {
		Set xID=$o(^User.DHCPENewMessageTempletD(xID))
		Quit:xID=""
		Continue:##class(User.DHCPENewMessageTemplet).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
		
		Set obj=##class(User.DHCPENewMessageTemplet).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.NMTActive'=1  //无效数据过滤
		Set Type        = obj.NMTType
		Set Default     = obj.NMTDefault
		Set Templet     = obj.NMTTemplet
		Set VIPLevel    = obj.NMTVIPLevel
		Set VIPLevelCode= $lg($g(^CT.PE.VIPLevelD(+VIPLevel)),2)
		Set VIPLevelDesc= $lg($g(^CT.PE.VIPLevelD(+VIPLevel)),3)
		Set Active      = obj.NMTActive
		Set Active=$s(Active=1:"Y",1:"N")
		
		Set Data=$lb(xID,Type,Default,Templet,VIPLevelCode,VIPLevelDesc,Active)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入科室短信模板（绝对私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPENewMsgTmpSrv).SaveMsgTmp("^VIP短信^0^MICVIP短信模板1^5^职业病^Y")
ClassMethod SaveMsgTmp(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Type          = $p(aInputStr,aDelimiter,2)    //短信类型
	Set Default       = $p(aInputStr,aDelimiter,3)    //默认标志
	Set Templet       = $p(aInputStr,aDelimiter,4)    //模板内容
	Set VIPLevelCode  = $p(aInputStr,aDelimiter,5)    //VIP等级代码
	Set VIPLevelDesc  = $p(aInputStr,aDelimiter,6)    //VIP等级名称
	Set Active        = $p(aInputStr,aDelimiter,7)    //激活
	Quit:(Type="")||(VIPLevelCode="") return
	
	Set Active=$s(Active["Y":1,Active["是":1,1:0)
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set VIPLevelID=""
		Set xVIPLevelID=0
		For {
			Set xVIPLevelID=$o(^CT.PE.VIPLevelI("IdxOfCode"," "_$zcvt(VIPLevelCode,"U"),xVIPLevelID))
			Quit:xVIPLevelID=""
			Continue:##class(User.DHCPEVIPLevel).GetLocShowDataFlag(xVIPLevelID,xInLocID)'["Y"  //无显示权限退出
			Set VIPLevelID=xVIPLevelID
		}
		Continue:VIPLevelID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",xInLocID,$zcvt(Type,"U"),VIPLevelID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPENewMessageTemplet).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPENewMessageTemplet).%New()
		}Else{
			Set obj=##class(User.DHCPENewMessageTemplet).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.NMTLocDR         = xInLocID
		Set obj.NMTType          = Type
		Set obj.NMTDefault       = Default
		Set obj.NMTTemplet       = Templet
		Set obj.NMTVIPLevel      = VIPLevelID
		Set obj.NMTActive        = Active
		Set obj.NMTUpdateDate    = +$h
		Set obj.NMTUpdateTime    = $p($h,",",2)
		
		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
	   		Quit
		}Else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
		
		//保存表记录授权
		Set flg=##class(User.DHCPENewMessageTemplet).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
