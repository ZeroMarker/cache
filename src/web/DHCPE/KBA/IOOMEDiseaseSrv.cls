/// 名称: web.DHCPE.KBA.IOOMEDiseaseSrv
/// 描述: 导出导入职业病诊断相关
/// 编写者：zhufei
/// 编写日期: 2022-01-27
Class web.DHCPE.KBA.IOOMEDiseaseSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业病分类与目录（公有）
/// Table：      User.DHCPEOMEDisease
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryOMEDisease",152)
Query QryOMEDisease(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Level:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryOMEDiseaseExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OMEDiseaseI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OMEDiseaseI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEDisease).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOMEDisease).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDActive'="Y"  //无效数据过滤
			Set Code        = obj.EDCode
			Set Desc        = obj.EDDesc
			Set Level       = obj.EDLevel
			Set Active      = obj.EDActive
			Set ExpInfo     = obj.EDExpInfo
			Set Remark      = obj.EDRemark
			
			Set Data=$lb(xID,Code,Desc,Level,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业病分类与目录（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveOMEDisease()
ClassMethod SaveOMEDisease(aInputStr As %String, aDelimiter As %String = "^") As %String
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
			Set xID=$o(^CT.PE.OMEDiseaseI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEDisease).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOMEDisease).%New()
		}Else{
			Set obj=##class(User.DHCPEOMEDisease).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCode          = Code
		Set obj.EDDesc          = Desc
		Set obj.EDLevel         = Level
		Set obj.EDActive        = Active
		Set obj.EDExpInfo       = ExpInfo
		Set obj.EDRemark        = Remark
		Set obj.EDUpdateDate    = +$h
		Set obj.EDUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOMEDisease).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业病诊断标准（公有）
/// Table：      User.DHCPEDiagnosticCriteria
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryDiagnosticCriteria",152)
Query QryDiagnosticCriteria(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ReplacedCode:%String,PublicDate:%String,EffectDate:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryDiagnosticCriteriaExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEDiagnosticCriteriaI("DCCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEDiagnosticCriteriaI("DCCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEDiagnosticCriteria).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEDiagnosticCriteria).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.DCActive'="Y"  //无效数据过滤
			Set Code        = obj.DCCode
			Set Desc        = obj.DCDesc
			Set ReplacedCode= obj.DCReplacedCode
			Set PublicDate  = obj.DCPublicDate
			Set:PublicDate'="" PublicDate=$zd(PublicDate,3)
			Set EffectDate  = obj.DCEffectDate
			Set:EffectDate'="" EffectDate=$zd(EffectDate,3)
			Set Active      = obj.DCActive
			Set ExpInfo     = obj.DCExpInfo
			Set Remark      = obj.DCRemark
			
			Set Data=$lb(xID,Code,Desc,ReplacedCode,PublicDate,EffectDate,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业病诊断标准（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveDiagnosticCriteria()
ClassMethod SaveDiagnosticCriteria(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    Set aLocId=$p(aLocId,"^",1)
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //标准代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //国家职业卫生标准
	Set ReplacedCode  = $p(aInputStr,aDelimiter,4)    //代替标准代码
	Set PublicDate    = $p(aInputStr,aDelimiter,5)    //发布时间
	Set EffectDate    = $p(aInputStr,aDelimiter,6)    //实施时间
	Set Active        = $p(aInputStr,aDelimiter,7)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,8)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,9)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	Set:PublicDate'="" PublicDate=$zdh(PublicDate,3)
	Set:EffectDate'="" EffectDate=$zdh(EffectDate,3)
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEDiagnosticCriteriaI("DCCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEDiagnosticCriteria).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEDiagnosticCriteria).%New()
		}Else{
			Set obj=##class(User.DHCPEDiagnosticCriteria).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.DCCode          = Code
		Set obj.DCDesc          = Desc
		Set obj.DCReplacedCode  = ReplacedCode
		Set obj.DCPublicDate    = PublicDate
		Set obj.DCEffectDate    = EffectDate
		Set obj.DCActive        = Active
		Set obj.DCExpInfo       = ExpInfo
		Set obj.DCRemark        = Remark
		Set obj.DCUpdateDate    = +$h
		Set obj.DCUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEDiagnosticCriteria).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业禁忌证（公有）
/// Table：      User.DHCPEOMEContraIndic
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryOMEContraIndic",152)
Query QryOMEContraIndic(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryOMEContraIndicExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OMEContraIndicI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OMEContraIndicI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEContraIndic).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOMEContraIndic).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.CIActive'="Y"  //无效数据过滤
			Set Code        = obj.CICode
			Set Desc        = obj.CIDesc
			Set Active      = obj.CIActive
			Set ExpInfo     = obj.CIExpInfo
			Set Remark      = obj.CIRemark
			
			Set Data=$lb(xID,Code,Desc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业禁忌证（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveOMEContraIndic()
ClassMethod SaveOMEContraIndic(aInputStr As %String, aDelimiter As %String = "^") As %String
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
			Set xID=$o(^CT.PE.OMEContraIndicI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEContraIndic).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOMEContraIndic).%New()
		}Else{
			Set obj=##class(User.DHCPEOMEContraIndic).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.CICode          = Code
		Set obj.CIDesc          = Desc
		Set obj.CIActive        = Active
		Set obj.CIExpInfo       = ExpInfo
		Set obj.CIRemark        = Remark
		Set obj.CIUpdateDate    = +$h
		Set obj.CIUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOMEContraIndic).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出健康指标代码表（公有）
/// Table：      User.DHCPEOMEHealthIndex
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryOMEHealthIndex",152)
Query QryOMEHealthIndex(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Level:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryOMEHealthIndexExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OMEHealthIndexI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OMEHealthIndexI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEHealthIndex).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOMEHealthIndex).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.HIActive'="Y"  //无效数据过滤
			Set Code        = obj.HICode
			Set Desc        = obj.HIDesc
			Set Level       = obj.HILevel
			Set Active      = obj.HIActive
			Set ExpInfo     = obj.HIExpInfo
			Set Remark      = obj.HIRemark
			
			Set Data=$lb(xID,Code,Desc,Level,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入健康指标代码表（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveOMEHealthIndex()
ClassMethod SaveOMEHealthIndex(aInputStr As %String, aDelimiter As %String = "^") As %String
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
			Set xID=$o(^CT.PE.OMEHealthIndexI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEHealthIndex).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOMEHealthIndex).%New()
		}Else{
			Set obj=##class(User.DHCPEOMEHealthIndex).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.HICode          = Code
		Set obj.HIDesc          = Desc
		Set obj.HILevel         = Level
		Set obj.HIActive        = Active
		Set obj.HIExpInfo       = ExpInfo
		Set obj.HIRemark        = Remark
		Set obj.HIUpdateDate    = +$h
		Set obj.HIUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOMEHealthIndex).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业病症状询问（公有）
/// Table：      User.DHCPEOMESymptomInqu
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryOMESymptomInqu",152)
Query QryOMESymptomInqu(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Level:%String,HICode:%String,HIDesc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryOMESymptomInquExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OMESymptomInquI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OMESymptomInquI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMESymptomInqu).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOMESymptomInqu).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.SIActive'="Y"  //无效数据过滤
			Set Code        = obj.SICode
			Set Desc        = obj.SIDesc
			Set Level       = obj.SILevel
			Set (HICode,HIDesc)=""
			If $IsObject(obj.SIOMEHIDR){
				Set HICode = obj.SIOMEHIDR.HICode
				Set HIDesc = obj.SIOMEHIDR.HIDesc
			}
			Set Active      = obj.SIActive
			Set ExpInfo     = obj.SIExpInfo
			Set Remark      = obj.SIRemark
			
			Set Data=$lb(xID,Code,Desc,Level,HICode,HIDesc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业病症状询问（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveOMESymptomInqu()
ClassMethod SaveOMESymptomInqu(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Set Desc          = $p(aInputStr,aDelimiter,3)    //症状询问
	Set Level         = $p(aInputStr,aDelimiter,4)    //层级分类（上级目录代码）
	Set HICode        = $p(aInputStr,aDelimiter,5)    //健康指标代码
	Set HIDesc        = $p(aInputStr,aDelimiter,6)    //健康指标
	Set Active        = $p(aInputStr,aDelimiter,7)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,8)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,9)    //备注
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xHIID=0,HIID=""
		For {
			Set xHIID=$o(^CT.PE.OMEHealthIndexI("IdxOfCode"," "_$zcvt(HICode,"U"),xHIID))
			Quit:xHIID=""
			Continue:##class(User.DHCPEOMEHealthIndex).GetLocShowDataFlag(xHIID,xInLocID)'["Y"  //无显示权限退出
			Set HIID=xHIID
		}
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CT.PE.OMESymptomInquI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMESymptomInqu).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOMESymptomInqu).%New()
		}Else{
			Set obj=##class(User.DHCPEOMESymptomInqu).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.SICode          = Code
		Set obj.SIDesc          = Desc
		Set obj.SILevel         = Level
		Set obj.SIOMEHIDR       = ##class(User.DHCPEOMEHealthIndex).GetObjById(HIID)
		Set obj.SIActive        = Active
		Set obj.SIExpInfo       = ExpInfo
		Set obj.SIRemark        = Remark
		Set obj.SIUpdateDate    = +$h
		Set obj.SIUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOMESymptomInqu).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出危害因素代码表（公有）
/// Table：      User.DHCPEOMEEndanger
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEDiseaseSrv","QryOMEEndanger",152)
Query QryOMEEndanger(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,TypeCode:%String,TypeDesc:%String,CASNo:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryOMEEndangerExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.OMEEndangerI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.OMEEndangerI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEEndanger).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEOMEEndanger).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDActive'="Y"  //无效数据过滤
			Set Code        = obj.EDCode
			Set Desc        = obj.EDDesc
			Set (TypeCode,TypeDesc)=""
			If $IsObject(obj.EDTypeDR){
				Set TypeCode = obj.EDTypeDR.EDTCode
				Set TypeDesc = obj.EDTypeDR.EDTDesc
			}
			Set CASNo       = obj.EDCASNo
			Set Active      = obj.EDActive
			Set ExpInfo     = obj.EDExpInfo
			Set Remark      = obj.EDRemark
			
			Set Data=$lb(xID,Code,Desc,TypeCode,TypeDesc,CASNo,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入危害因素代码表（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEDiseaseSrv).SaveOMEEndanger("^02374^乙酸异丙酯^108-21-4^02^接触化学因素类^Y^^")
ClassMethod SaveOMEEndanger(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Set CASNo         = $p(aInputStr,aDelimiter,4)    //CAS号
	Set TypeCode      = $p(aInputStr,aDelimiter,5)    //分类代码
	Set TypeDesc      = $p(aInputStr,aDelimiter,6)    //分类描述
	Set Active        = $p(aInputStr,aDelimiter,7)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,8)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,9)    //备注
	Quit:(Code="")||(Desc="")||(TypeCode="") return
	
	Set TypeID=$o(^User.DHCPEEndangerTypeI("EDTCodeIndex"," "_$zcvt(TypeCode,"U"),0))
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CT.PE.OMEEndangerI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEOMEEndanger).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEOMEEndanger).%New()
		}Else{
			Set obj=##class(User.DHCPEOMEEndanger).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCode          = Code
		Set obj.EDDesc          = Desc
		Set obj.EDTypeDR        = ##class(User.DHCPEEndangerType).GetObjById(TypeID)
		Set obj.EDCASNo         = CASNo
		Set obj.EDActive        = Active
		Set obj.EDExpInfo       = ExpInfo
		Set obj.EDRemark        = Remark
		Set obj.EDUpdateDate    = +$h
		Set obj.EDUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEOMEEndanger).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
