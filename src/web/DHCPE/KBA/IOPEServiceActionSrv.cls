/// 名称: web.DHCPE.KBA.IOPEServiceActionSrv
/// 描述: 导出导入WebService业务代码对照
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEServiceActionSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出WebService业务代码对照（公有）
/// Table：      User.DHCPEServiceAction
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEServiceActionSrv","QryServiceAction",152)
Query QryServiceAction(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ActionCode:%String,ActionName:%String,ClassName:%String,MethodName:%String")
{
}

ClassMethod QryServiceActionExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEServiceActionI("UnqIdxCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEServiceActionI("UnqIdxCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEServiceAction).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEServiceAction).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set ActionCode    = obj.ActionCode
			Set ActionName    = obj.ActionName
			Set ClassName     = obj.ClassName
			Set MethodName    = obj.MethodName
			
			Set Data=$lb(xID,ActionCode,ActionName,ClassName,MethodName)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入WebService业务代码对照（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEServiceActionSrv).SaveServiceAction()
ClassMethod SaveServiceAction(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ActionCode    = $p(aInputStr,aDelimiter,2)    //业务代码
	Set ActionName    = $p(aInputStr,aDelimiter,3)    //业务描述
	Set ClassName     = $p(aInputStr,aDelimiter,4)    //类名
	Set MethodName    = $p(aInputStr,aDelimiter,5)    //方法名
	Quit:(ActionCode="")||(ActionName="") return
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEServiceActionI("UnqIdxCode"," "_$zcvt(ActionCode,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEServiceAction).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEServiceAction).%New()
		}Else{
			Set obj=##class(User.DHCPEServiceAction).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.ActionCode       = ActionCode
		Set obj.ActionName       = ActionName
		Set obj.ClassName        = ClassName
		Set obj.MethodName       = MethodName
		
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
		Set flg=##class(User.DHCPEServiceAction).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
