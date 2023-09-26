/// 名称: web.DHCPE.KBA.IOPEVIPLevelSrv
/// 描述: 导出导入VIP等级
/// 编写者：zhufei
/// 编写日期: 2022-01-21
Class web.DHCPE.KBA.IOPEVIPLevelSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-21
/// Description: 导出VIP等级（公有）
/// Table：      User.DHCPEVIPLevel
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEVIPLevelSrv","QryVIPLevel",152)
Query QryVIPLevel(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Active:%String")
{
}

ClassMethod QryVIPLevelExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^CT.PE.VIPLevelI("IdxOfCode",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^CT.PE.VIPLevelI("IdxOfCode",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEVIPLevel).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEVIPLevel).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.VLNoActive="N"  //无效数据过滤
			Set Code        = obj.VLCode
			Set Desc        = obj.VLDesc
			Set Active      = obj.VLNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,Code,Desc,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-21
/// Description:  导入VIP等级（公有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEVIPLevelSrv).SaveVIPLevel()
ClassMethod SaveVIPLevel(aInputStr As %String, aDelimiter As %String = "^") As %String
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
	Quit:(Code="")||(Desc="") return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CT.PE.VIPLevelI("IdxOfCode"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEVIPLevel).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEVIPLevel).%New()
		}Else{
			Set obj=##class(User.DHCPEVIPLevel).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.VLCode          = Code
		Set obj.VLDesc          = Desc
		Set obj.VLNoActive      = Active
		Set obj.VLUpdateDate    = +$h
		Set obj.VLUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEVIPLevel).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-21
/// Description: 导出科室VIP等级详情（绝对私有）
/// Table：      User.DHCPELocVIPLevel
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEVIPLevelSrv","QryLocVIPLevel",152)
Query QryLocVIPLevel(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,VLCode:%String,VLDesc:%String,Secret:%String,Defale:%String,Template:%String,FeeTypeDR:%String,FeeTypeDesc:%String,HPCode:%String,OrdSetsDR:%String,OrdSetsDesc:%String,ZYDInfo:%String,ZYDTemplate:%String,HMServiceCode:%String,HMServiceDesc:%String,CutInLine:%String,GeneralType:%String,GeneralTypeDesc:%String,Active:%String")
{
}

ClassMethod QryLocVIPLevelExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xVIPLevelDR=""
	For {
		Set xVIPLevelDR=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_aLocId,xVIPLevelDR))
		Quit:xVIPLevelDR=""
		
		Set xID=0
		For {
			Set xID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_aLocId,xVIPLevelDR,xID))
			Quit:xID=""
			Continue:##class(User.DHCPELocVIPLevel).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPELocVIPLevel).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.LVLVIPLevelDR)
			
			Continue:obj.LVLVIPLevelDR.VLNoActive="N"  //无效数据过滤
			Set VLCode=obj.LVLVIPLevelDR.VLCode
			Set VLDesc=obj.LVLVIPLevelDR.VLDesc
			
			Continue:obj.LVLNoActive="N"  //无效数据过滤
			Set Secret      = obj.LVLSecret
			Set Defale      = obj.LVLDefale
			Set Template    = obj.LVLTemplate
			Set FeeTypeDR   = obj.LVLFeeTypeDR
			Set FeeTypeDesc = $p($g(^PAC("SUBT",+FeeTypeDR)),"^",2)
			Set HPCode      = obj.LVLHPCode
			Set OrdSetsDR   = obj.LVLOrdSetsDR
			Set OrdSetsDesc = $p($g(^ARCOS(+OrdSetsDR)),"^",2)
			Set ZYDInfo     = obj.LVLZYDInfo
			Set ZYDTemplate = obj.LVLZYDTemplate
			Set (HMServiceDR,HMServiceCode,HMServiceDesc)=""
			If $IsObject(obj.LVLHMServiceDR){
				Set HMServiceDR = obj.LVLHMServiceDR.%Id()
				Set HMServiceCode = $lg($g(^User.DHCHMCServiceClassD(+HMServiceDR)),3)
				Set HMServiceDesc = $lg($g(^User.DHCHMCServiceClassD(+HMServiceDR)),4)
			}
			Set CutInLine   = obj.LVLCutInLine
			Set GeneralType = obj.LVLGeneralType
			Set GeneralTypeDesc=$s(GeneralType="JKTJ":"健康体检",GeneralType="RZTJ":"入职体检",GeneralType="GWY":"公务员",GeneralType="ZYJK":"职业健康",GeneralType="JKZ":"健康证",GeneralType="OTHER":"其他",1:GeneralType)
			Set Active      = obj.LVLNoActive
			Set:Active="" Active="Y"
			
			Set Data=$lb(xID,VLCode,VLDesc,Secret,Defale,Template,FeeTypeDR,FeeTypeDesc,HPCode,OrdSetsDR,OrdSetsDesc,ZYDInfo,ZYDTemplate,HMServiceCode,HMServiceDesc,CutInLine,GeneralType,GeneralTypeDesc,Active)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-21
/// Description:  导入科室VIP等级详情（绝对私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEVIPLevelSrv).SaveLocVIPLevel()
ClassMethod SaveLocVIPLevel(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                = $p(aInputStr,aDelimiter,1)    //ID
	Set VLCode            = $p(aInputStr,aDelimiter,2)    //VIP等级
	Set VLDesc            = $p(aInputStr,aDelimiter,3)    //VIP等级描述
	Set Secret            = $p(aInputStr,aDelimiter,4)    //保密
	Set Defale            = $p(aInputStr,aDelimiter,5)    //默认
	Set Template          = $p(aInputStr,aDelimiter,6)    //模板名称
	Set FeeTypeDR         = $p(aInputStr,aDelimiter,7)    //体检类别
	Set FeeTypeDesc       = $p(aInputStr,aDelimiter,8)    //体检类别描述
	Set HPCode            = $p(aInputStr,aDelimiter,9)    //体检号编码
	Set OrdSetsDR         = $p(aInputStr,aDelimiter,10)    //默认套餐
	Set OrdSetsDesc       = $p(aInputStr,aDelimiter,11)    //默认套餐名称
	Set ZYDInfo           = $p(aInputStr,aDelimiter,12)    //指引单指示
	Set ZYDTemplate       = $p(aInputStr,aDelimiter,13)    //指引单模板
	Set HMServiceCode     = $p(aInputStr,aDelimiter,14)    //问卷服务级别
	Set HMServiceDesc     = $p(aInputStr,aDelimiter,15)    //问卷服务级别描述
	Set CutInLine         = $p(aInputStr,aDelimiter,16)    //是否插队
	Set GeneralType       = $p(aInputStr,aDelimiter,17)    //总检类型
	Set GeneralTypeDesc   = $p(aInputStr,aDelimiter,18)    //总检类型描述
	Set Active            = $p(aInputStr,aDelimiter,19)    //激活
	Quit:(VLCode="")||(VLDesc="") return
	
	Set VLID=$o(^CT.PE.VIPLevelI("IdxOfCode"," "_$zcvt(VLCode,"U"),0))
	Quit:VLID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set ServiceClassID=""
		Set xServiceClassID=0
		For {
			Set xServiceClassID=$o(^User.DHCHMCServiceClassI("SCCodeIndex"," "_$zcvt(HMServiceCode,"U"),xServiceClassID))
			Quit:xServiceClassID=""
			Continue:##class(User.DHCHMCServiceClass).GetLocShowDataFlag(xServiceClassID,xInLocID)'["Y"  //无显示权限退出
			Set ServiceClassID=xServiceClassID
		}
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_xInLocID,VLID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPELocVIPLevel).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPELocVIPLevel).%New()
		}Else{
			Set obj=##class(User.DHCPELocVIPLevel).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.LVLLocDR         = xInLocID
		Set obj.LVLVIPLevelDR    = ##class(User.DHCPEVIPLevel).GetObjById(VLID)
		Set obj.LVLSecret        = Secret
		Set obj.LVLDefale        = Defale
		Set obj.LVLTemplate      = Template
		Set obj.LVLFeeTypeDR     = FeeTypeDR
		Set obj.LVLHPCode        = HPCode
		Set obj.LVLOrdSetsDR     = OrdSetsDR
		Set obj.LVLZYDInfo       = ZYDInfo
		Set obj.LVLZYDTemplate   = ZYDTemplate
		Set obj.LVLHMServiceDR   = ##class(User.DHCHMCServiceClass).GetObjById(ServiceClassID)
		Set obj.LVLCutInLine     = CutInLine
		Set obj.LVLGeneralType   = GeneralType
		Set obj.LVLNoActive      = Active
		Set obj.LVLUpdateDate    = +$h
		Set obj.LVLUpdateTime    = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPELocVIPLevel).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
