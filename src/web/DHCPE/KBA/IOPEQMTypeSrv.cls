/// 名称: web.DHCPE.KBA.IOPEQMTypeSrv
/// 描述: 导出导入体检质量错误类型
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEQMTypeSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出体检质量错误类型（管控）
/// Table：      User.DHCPEQMType
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEQMTypeSrv","QryQMType",152)
Query QryQMType(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,ExpStr:%String,Remark:%String")
{
}

ClassMethod QryQMTypeExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEQMTypeI("QMTCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEQMTypeI("QMTCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEQMType).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEQMType).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.QMTActiveFlag'="Y"  //无效数据过滤
			Set Code        = obj.QMTCode
			Set Desc        = obj.QMTDesc
			Set Active      = obj.QMTActiveFlag
			Set ExpStr      = obj.QMTExpStr
			Set Remark      = obj.QMTRemark
			
			Set Data=$lb(xID,Code,Desc,Active,ExpStr,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入体检质量错误类型（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEQMTypeSrv).SaveQMType()
ClassMethod SaveQMType(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //激活
	Set ExpStr        = $p(aInputStr,aDelimiter,5)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,6)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEQMTypeI("QMTCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEQMType).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEQMType).%New()
		}Else{
			Set obj=##class(User.DHCPEQMType).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.QMTCode          = Code
		Set obj.QMTDesc          = Desc
		Set obj.QMTActiveFlag    = Active
		Set obj.QMTExpStr        = ExpStr
		Set obj.QMTRemark        = Remark
		Set obj.QMTUpdateDate    = +$h
		Set obj.QMTUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEQMType).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
