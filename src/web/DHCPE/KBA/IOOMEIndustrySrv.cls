/// 名称: web.DHCPE.KBA.IOOMEIndustrySrv
/// 描述: 导出导入行业/作业/工种相关
/// 编写者：zhufei
/// 编写日期: 2022-01-27
Class web.DHCPE.KBA.IOOMEIndustrySrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出行业维护（公有）
/// Table：      User.DHCPEIndustry
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEIndustrySrv","QryIndustry",152)
Query QryIndustry(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Level:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryIndustryExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEIndustryI("ICodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEIndustryI("ICodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIndustry).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEIndustry).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.IActive'="Y"  //无效数据过滤
			Set Code        = obj.ICode
			Set Desc        = obj.IDesc
			Set Level       = obj.ILevel
			Set Active      = obj.IActive
			Set ExpInfo     = obj.IExpInfo
			Set Remark      = obj.IRemark
			
			Set Data=$lb(xID,Code,Desc,Level,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入行业维护（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEIndustrySrv).SaveIndustry()
ClassMethod SaveIndustry(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //行业代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //行业名称
	Set Level         = $p(aInputStr,aDelimiter,4)    //层级分类（上级目录代码）
	Set Active        = $p(aInputStr,aDelimiter,5)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,6)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,7)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEIndustryI("ICodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEIndustry).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEIndustry).%New()
		}Else{
			Set obj=##class(User.DHCPEIndustry).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.ICode          = Code
		Set obj.IDesc          = Desc
		Set obj.ILevel         = Level
		Set obj.IActive        = Active
		Set obj.IExpInfo       = ExpInfo
		Set obj.IRemark        = Remark
		Set obj.IUpdateDate    = +$h
		Set obj.IUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEIndustry).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出工种维护（公有）
/// Table：      User.DHCPEWorkType
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEIndustrySrv","QryWorkType",152)
Query QryWorkType(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryWorkTypeExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEWorkTypeI("WTCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEWorkTypeI("WTCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEWorkType).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEWorkType).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.WTActive'="Y"  //无效数据过滤
			Set Code        = obj.WTCode
			Set Desc        = obj.WTDesc
			Set Active      = obj.WTActive
			Set ExpInfo     = obj.WTExpInfo
			Set Remark      = obj.WTRemark
			
			Set Data=$lb(xID,Code,Desc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入工种维护（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEIndustrySrv).SaveWorkType()
ClassMethod SaveWorkType(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //工种代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //工种描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,5)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,6)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEWorkTypeI("WTCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEWorkType).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEWorkType).%New()
		}Else{
			Set obj=##class(User.DHCPEWorkType).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.WTCode          = Code
		Set obj.WTDesc          = Desc
		Set obj.WTActive        = Active
		Set obj.WTExpInfo       = ExpInfo
		Set obj.WTRemark        = Remark
		Set obj.WTUpdateDate    = +$h
		Set obj.WTUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEWorkType).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出作业类别（公有）
/// Table：      User.DHCPEOperationType
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEIndustrySrv","QryOperationType",152)
Query QryOperationType(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,ExpInfo:%String,AccidentType:%String,Remark:%String")
{
}

ClassMethod QryOperationTypeExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OperationTypeI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OperationTypeI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOperationType).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOperationType).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.OTActive'="Y"  //无效数据过滤
			Set Code        = obj.OTCode
			Set Desc        = obj.OTDesc
			Set Active      = obj.OTActive
			Set ExpInfo     = obj.OTExpInfo
			Set AccidentType= obj.OTAccidentType
			Set Remark      = obj.OTRemark
			
			Set Data=$lb(xID,Code,Desc,Active,ExpInfo,AccidentType,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入作业类别（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEIndustrySrv).SaveOperationType()
ClassMethod SaveOperationType(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,5)    //扩展信息
	Set AccidentType  = $p(aInputStr,aDelimiter,6)    //可能造成的事故类型
	Set Remark        = $p(aInputStr,aDelimiter,7)    //备注(举例)
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CT.PE.OperationTypeI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOperationType).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOperationType).%New()
		}Else{
			Set obj=##class(User.DHCPEOperationType).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.OTCode          = Code
		Set obj.OTDesc          = Desc
		Set obj.OTActive        = Active
		Set obj.OTExpInfo       = ExpInfo
		Set obj.OTAccidentType  = AccidentType
		Set obj.OTRemark        = Remark
		Set obj.OTUpdateDate    = +$h
		Set obj.OTUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOperationType).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出防护措施（公有）
/// Table：      User.DHCPEProtectiveMeasures
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEIndustrySrv","QryProtectiveMeasures",152)
Query QryProtectiveMeasures(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryProtectiveMeasuresExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEProtectiveMeasuresI("PMCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEProtectiveMeasuresI("PMCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEProtectiveMeasures).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEProtectiveMeasures).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.PMActive'="Y"  //无效数据过滤
			Set Code        = obj.PMCode
			Set Desc        = obj.PMDesc
			Set Active      = obj.PMActive
			Set ExpInfo     = obj.PMExpInfo
			Set Remark      = obj.PMRemark
			
			Set Data=$lb(xID,Code,Desc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入防护措施（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEIndustrySrv).SaveProtectiveMeasures("^B31^绝缘手套^Y^使作业人员的手部与带电物体绝缘，免受电流伤害^")
ClassMethod SaveProtectiveMeasures(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //描述
	Set Active        = $p(aInputStr,aDelimiter,4)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,5)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,6)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEProtectiveMeasuresI("PMCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEProtectiveMeasures).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEProtectiveMeasures).%New()
		}Else{
			Set obj=##class(User.DHCPEProtectiveMeasures).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.PMCode          = Code
		Set obj.PMDesc          = Desc
		Set obj.PMActive        = Active
		Set obj.PMExpInfo       = ExpInfo
		Set obj.PMRemark        = Remark
		Set obj.PMUpdateDate    = +$h
		Set obj.PMUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEProtectiveMeasures).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出防护装备选用（公有）
/// Table：      User.DHCPEProtectiveEquip
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEIndustrySrv","QryProtectiveEquip",152)
Query QryProtectiveEquip(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,OTCode:%String,OTDesc:%String,PMCode:%String,PMDesc:%String,UsableFlag:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryProtectiveEquipExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xOTDR=""
	For {
		Set xOTDR=$o(^CT.PE.ProtectiveEquipI("IdxOfOTDR",xOTDR))
		Quit:xOTDR=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.ProtectiveEquipI("IdxOfOTDR",xOTDR,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEProtectiveEquip).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEProtectiveEquip).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.PEActive'="Y"  //无效数据过滤
			Set (OTCode,OTDesc)=""
			If $IsObject(obj.PEOTDR){
				Set OTCode        = obj.PEOTDR.OTCode
				Set OTDesc        = obj.PEOTDR.OTDesc
			}
			Set (PMCode,PMDesc)=""
			If $IsObject(obj.PEPMDR){
				Set PMCode        = obj.PEPMDR.PMCode
				Set PMDesc        = obj.PEPMDR.PMDesc
			}
			Set UsableFlag  = obj.PEUsableFlag
			Set Active      = obj.PEActive
			Set ExpInfo     = obj.PEExpInfo
			Set Remark      = obj.PERemark
			
			Set Data=$lb(xID,OTCode,OTDesc,PMCode,PMDesc,UsableFlag,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入防护装备选用（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEIndustrySrv).SaveProtectiveEquip("^A03^操作转动机械作业^B71^其他零星防护用品^U^Y^^")
ClassMethod SaveProtectiveEquip(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set OTCode        = $p(aInputStr,aDelimiter,2)    //作业类别代码
	Set OTDesc        = $p(aInputStr,aDelimiter,3)    //作业类别描述
	Set PMCode        = $p(aInputStr,aDelimiter,4)    //防护措施代码
	Set PMDesc        = $p(aInputStr,aDelimiter,5)    //防护措施描述
	Set UsableFlag    = $p(aInputStr,aDelimiter,6)    //可以使用/建议使用
	Set Active        = $p(aInputStr,aDelimiter,7)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,8)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,9)    //备注
	Quit:(OTCode="")||(PMCode="") return
	
	Set OTID=$o(^CT.PE.OperationTypeI("IdxOfCode"," "_$zcvt(OTCode,"U"),0))
	Quit:OTID="" return
	Set PMID=$o(^User.DHCPEProtectiveMeasuresI("PMCodeIndex"," "_$zcvt(PMCode,"U"),0))
	Quit:PMID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CT.PE.ProtectiveEquipI("IdxOfOTDRPMDR",OTID,PMID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEProtectiveEquip).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEProtectiveEquip).%New()
		}Else{
			Set obj=##class(User.DHCPEProtectiveEquip).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.PEOTDR          = ##class(User.DHCPEOperationType).GetObjById(OTID)
		Set obj.PEPMDR          = ##class(User.DHCPEProtectiveMeasures).GetObjById(PMID)
		Set obj.PEUsableFlag    = UsableFlag
		Set obj.PEActive        = Active
		Set obj.PEExpInfo       = ExpInfo
		Set obj.PERemark        = Remark
		Set obj.PEUpdateDate    = +$h
		Set obj.PEUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEProtectiveEquip).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
