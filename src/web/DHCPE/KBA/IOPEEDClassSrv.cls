/// 名称: web.DHCPE.KBA.IOPEEDClassSrv
/// 描述: 导出导入建议级别
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEEDClassSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出建议级别（私有）
/// Table：      User.DHCPEEDClass
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEEDClassSrv","QryEDClass",152)
Query QryEDClass(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod QryEDClassExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^DHCPEEDC(0,"Code",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCPEEDC(0,"Code",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEDClass).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEEDClass).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDCNoActive="N"  //无效数据过滤
			Set Code        = obj.EDCCode
			Set Desc        = obj.EDCDesc
			Set Active      = obj.EDCNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,Code,Desc,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入建议级别（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEEDClassSrv).SaveEDClass()
ClassMethod SaveEDClass(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEEDC(0,"Code",Code,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEDClass).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDClass).%New()
		}Else{
			Set obj=##class(User.DHCPEEDClass).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCCode          = Code
		Set obj.EDCDesc          = Desc
		Set obj.EDCNoActive      = Active
		Set obj.EDCUpdateDate    = +$h
		Set obj.EDCUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEEDClass).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出建议关键词（私有）
/// Table：      User.DHCPEEDKey
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEEDClassSrv","QryEDKey",152)
Query QryEDKey(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Desc:%String,Color:%String,Active:%String")
{
}

ClassMethod QryEDKeyExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xDesc=""
	For {
		Set xDesc=$o(^User.DHCPEEDKeyI("EDKDescIndex",xDesc))
		Quit:xDesc=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEEDKeyI("EDKDescIndex",xDesc,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEDKey).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEEDKey).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDKNoActive="N"  //无效数据过滤
			Set Desc        = obj.EDKDesc
			Set Color       = obj.EDKColor
			Set Active      = obj.EDKNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,Desc,Color,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入建议关键词（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEEDClassSrv).SaveEDKey()
ClassMethod SaveEDKey(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                = $p(aInputStr,aDelimiter,1)    //ID
	Set Desc              = $p(aInputStr,aDelimiter,2)    //关键词
	Set Color             = $p(aInputStr,aDelimiter,3)    //颜色
	Set Active            = $p(aInputStr,aDelimiter,4)    //激活
	Quit:(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEEDKeyI("EDKDescIndex"," "_$zcvt(Desc,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEDKey).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDKey).%New()
		}Else{
			Set obj=##class(User.DHCPEEDKey).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDKDesc          = Desc
		Set obj.EDKColor         = Color
		Set obj.EDKNoActive      = Active
		Set obj.EDKUpdateDate    = +$h
		Set obj.EDKUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEEDKey).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
