/// 名称: web.DHCPE.KBA.IOOMEEndangerSrv
/// 描述: 导出导入职业健康检查相关
/// 编写者：zhufei
/// 编写日期: 2022-01-27
Class web.DHCPE.KBA.IOOMEEndangerSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业健康检查危害因素（管控）
/// Table：      User.DHCPEEndanger
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEEndangerSrv","QryEndanger",152)
Query QryEndanger(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,EDTCode:%String,EDTDesc:%String,EDCode:%String,EDDesc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryEndangerExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^User.DHCPEEndangerI("EDCodeIndex",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^User.DHCPEEndangerI("EDCodeIndex",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEndanger).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEEndanger).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDActive'="Y"  //无效数据过滤
			Set Code        = obj.EDCode
			Set Desc        = obj.EDDesc
			Set (EDTCode,EDTDesc)=""
			If $IsObject(obj.EDEDTypeDR){
				Set EDTCode = obj.EDEDTypeDR.EDTCode
				Set EDTDesc = obj.EDEDTypeDR.EDTDesc
			}
			Set (EDCode,EDDesc)=""
			If $IsObject(obj.EDOMEEDDR){
				Set EDCode = obj.EDOMEEDDR.EDCode
				Set EDDesc = obj.EDOMEEDDR.EDDesc
			}
			Set Active      = obj.EDActive
			Set ExpInfo     = obj.EDExpInfo
			Set Remark      = obj.EDRemark
			
			Set Data=$lb(xID,Code,Desc,EDTCode,EDTDesc,EDCode,EDDesc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业健康检查危害因素（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEEndangerSrv).SaveEndanger()
ClassMethod SaveEndanger(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set Code          = $p(aInputStr,aDelimiter,2)    //职业健康检查危害因素代码
	Set Desc          = $p(aInputStr,aDelimiter,3)    //职业健康检查危害因素及特殊作业
	Set EDTCode       = $p(aInputStr,aDelimiter,4)    //职业健康检查分类代码
	Set EDTDesc       = $p(aInputStr,aDelimiter,5)    //职业健康检查分类（危害因素分类）
	Set EDCode        = $p(aInputStr,aDelimiter,6)    //标准危害因素代码
	Set EDDesc        = $p(aInputStr,aDelimiter,7)    //标准危害因素
	Set Active        = $p(aInputStr,aDelimiter,8)    //激活
	Set ExpInfo       = $p(aInputStr,aDelimiter,9)    //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,10)   //备注
	Quit:(Code="")||(Desc="") return
	
	Set EDTID=$o(^User.DHCPEEndangerTypeI("EDTCodeIndex"," "_$zcvt(EDTCode,"U"),0))
	Set EDID=$o(^CT.PE.OMEEndangerI("IdxOfCode"," "_$zcvt(EDCode,"U"),0))
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEEndangerI("EDCodeIndex"," "_$zcvt(Code,"U"),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEndanger).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEndanger).%New()
		}Else{
			Set obj=##class(User.DHCPEEndanger).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCode          = Code
		Set obj.EDDesc          = Desc
		Set obj.EDEDTypeDR      = ##class(User.DHCPEEndangerType).GetObjById(EDTID)
		Set obj.EDOMEEDDR       = ##class(User.DHCPEOMEEndanger).GetObjById(EDID)
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
		Set flg=##class(User.DHCPEEndanger).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业健康检查目标疾病（管控）
/// Table：      User.DHCPEEDIllness
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEEndangerSrv","QryEDIllness",152)
Query QryEDIllness(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ECode:%String,EDesc:%String,ITCode:%String,ITDesc:%String,OMETCode:%String,OMETDesc:%String,ExpInfo:%String,Active:%String,EDCode:%String,EDDesc:%String,DCCode:%String,DCDesc:%String,CICode:%String,CIDesc:%String,Remark:%String")
{
}

ClassMethod QryEDIllnessExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xParRef=""
	For {
		Set xParRef=$o(^User.DHCPEEndangerD(xParRef))
		Quit:xParRef=""
		
		Set xSub=0
		For {
			Set xSub=$o(^User.DHCPEEndangerD(xParRef,"EDIllnessChild",xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDIllness).GetLocShowDataFlag(xParRef_"||"_xSub,aLocId)'["Y"  //无显示权限退出
			
			Set ID=xParRef_"||"_xSub
			Set obj=##class(User.DHCPEEDIllness).GetObjById(ID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.EDIIllndessDR)
			Continue:'$IsObject(obj.EDIOMETypeDR)
			Continue:obj.EDIActive'="Y"  //无效数据过滤
			
			Set ECode       = obj.EDIlParref.EDCode
			Set EDesc       = obj.EDIlParref.EDDesc
			Set ITCode      = obj.EDIIllndessDR.ITCode
			Set ITDesc      = obj.EDIIllndessDR.ITDesc
			Set OMETCode    = obj.EDIOMETypeDR.OMETCode
			Set OMETDesc    = obj.EDIOMETypeDR.OMETDesc
			Set Active      = obj.EDIActive
			Set ExpInfo     = obj.EDIExpInfo
			Set Remark      = obj.EDIRemark
			
			Set (EDCode,EDDesc)=""
			If $IsObject(obj.EDIOMEDiseaseDR){
				Set EDCode = obj.EDIOMEDiseaseDR.EDCode
				Set EDDesc = obj.EDIOMEDiseaseDR.EDDesc
			}
			Set (DCCode,DCDesc)=""
			If $IsObject(obj.EDIDCDR){
				Set DCCode = obj.EDIDCDR.DCCode
				Set DCDesc = obj.EDIDCDR.DCDesc
			}
			Set (CICode,CIDesc)=""
			If $IsObject(obj.EDIOMECIDR){
				Set CICode = obj.EDIOMECIDR.CICode
				Set CIDesc = obj.EDIOMECIDR.CIDesc
			}
			
			Set Data=$lb(ID,ECode,EDesc,ITCode,ITDesc,OMETCode,OMETDesc,ExpInfo,Active,EDCode,EDDesc,DCCode,DCDesc,CICode,CIDesc,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业健康检查目标疾病（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEEndangerSrv).SaveEDIllness()
ClassMethod SaveEDIllness(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ECode         = $p(aInputStr,aDelimiter,2)    //职业健康检查危害因素代码
	Set EDesc         = $p(aInputStr,aDelimiter,3)    //职业健康检查危害因素及特殊作业
	Set ITCode        = $p(aInputStr,aDelimiter,4)    //目标疾病分类代码
	Set ITDesc        = $p(aInputStr,aDelimiter,5)    //目标疾病分类描述
	Set OMETCode      = $p(aInputStr,aDelimiter,6)    //职业健康检查种类代码
	Set OMETDesc      = $p(aInputStr,aDelimiter,7)    //职业健康检查种类描述
	Set ExpInfo       = $p(aInputStr,aDelimiter,8)    //具体疾病
	Set Active        = $p(aInputStr,aDelimiter,9)    //激活
	Set EDCode        = $p(aInputStr,aDelimiter,10)   //职业病分类与目录代码
	Set EDDesc        = $p(aInputStr,aDelimiter,11)   //职业病分类与目录
	Set DCCode        = $p(aInputStr,aDelimiter,12)   //职业病诊断标准代码
	Set DCDesc        = $p(aInputStr,aDelimiter,13)   //职业病诊断标准
	Set CICode        = $p(aInputStr,aDelimiter,14)   //职业禁忌证代码
	Set CIDesc        = $p(aInputStr,aDelimiter,15)   //职业禁忌证
	Set Remark        = $p(aInputStr,aDelimiter,16)   //备注
	Quit:(ECode="")||(ITCode="")||(OMETCode="")||(ExpInfo="") return
	
	Set ITID=$o(^User.DHCPEOMEIllnessI("ITCodeIndex"," "_$zcvt(ITCode,"U"),0))
	Quit:ITID="" return
	Set OMETID=$o(^User.DHCPEOMETypeI("OMETCodeIndex"," "_$zcvt(OMETCode,"U"),0))
	Quit:OMETID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set (EDID,DCID,CIID)=""
	Set:EDCode'="" EDID=$o(^CT.PE.OMEDiseaseI("IdxOfCode"," "_$zcvt(EDCode,"U"),0))
	Set:DCCode'="" DCID=$o(^User.DHCPEDiagnosticCriteriaI("DCCodeIndex"," "_$zcvt(DCCode,"U"),0))
	Set:CICode'="" CIID=$o(^CT.PE.OMEContraIndicI("IdxOfCode"," "_$zcvt(CICode,"U"),0))
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xEID=0,EID=""
		For {
			Set xEID=$o(^User.DHCPEEndangerI("EDCodeIndex"," "_$zcvt(ECode,"U"),xEID))
			Quit:xEID=""
			Continue:##class(User.DHCPEEndanger).GetLocShowDataFlag(xEID,xInLocID)'["Y"  //无显示权限退出
			Set EID=xEID
		}
		Continue:EID=""
		
		Set xSub=0,tID=""
		For {
			Set xSub=$o(^User.DHCPEEDIllnessI("IdxOfIllTypeExpInfo",ITID,OMETID," "_$zcvt(ExpInfo,"U"),EID,xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDIllness).GetLocShowDataFlag(EID_"||"_xSub,xInLocID)'["Y"  //无显示权限退出
			Set tID=EID_"||"_xSub
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDIllness).%New()
		}Else{
			Set obj=##class(User.DHCPEEDIllness).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDIlParref      = ##class(User.DHCPEEndanger).GetObjById(EID)
		Set obj.EDIIllndessDR   = ##class(User.DHCPEOMEIllness).GetObjById(ITID)
		Set obj.EDIOMETypeDR    = ##class(User.DHCPEOMEType).GetObjById(OMETID)
		Set obj.EDIActive       = Active
		Set obj.EDIExpInfo      = ExpInfo
		Set obj.EDIOMEDiseaseDR = ##class(User.DHCPEOMEDisease).GetObjById(EDID)
		Set obj.EDIDCDR         = ##class(User.DHCPEDiagnosticCriteria).GetObjById(DCID)
		Set obj.EDIOMECIDR      = ##class(User.DHCPEOMEContraIndic).GetObjById(CIID)
		Set obj.EDIRemark       = Remark
		Set obj.EDIUpdateDate   = +$h
		Set obj.EDIUpdateTime   = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEEDIllness).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业健康检查周期（管控）
/// Table：      User.DHCPEEDCheckCycle
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEEndangerSrv","QryEDCheckCycle",152)
Query QryEDCheckCycle(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ECode:%String,EDesc:%String,Code:%String,Desc:%String,OMETCode:%String,OMETDesc:%String,Active:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryEDCheckCycleExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xParRef=""
	For {
		Set xParRef=$o(^User.DHCPEEndangerD(xParRef))
		Quit:xParRef=""
		
		Set xSub=0
		For {
			Set xSub=$o(^User.DHCPEEndangerD(xParRef,"EDCheckCycleChild",xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDCheckCycle).GetLocShowDataFlag(xParRef_"||"_xSub,aLocId)'["Y"  //无显示权限退出
			
			Set ID=xParRef_"||"_xSub
			Set obj=##class(User.DHCPEEDCheckCycle).GetObjById(ID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.EDCOMETypeDR)
			Continue:obj.EDCActive'="Y"  //无效数据过滤
			
			Set ECode       = obj.EDCParref.EDCode
			Set EDesc       = obj.EDCParref.EDDesc
			Set Code        = obj.EDCCode
			Set Desc        = obj.EDCDesc
			Set OMETCode    = obj.EDCOMETypeDR.OMETCode
			Set OMETDesc    = obj.EDCOMETypeDR.OMETDesc
			Set Active      = obj.EDCActive
			Set ExpInfo     = obj.EDCExpInfo
			Set Remark      = obj.EDCRemark
			
			Set Data=$lb(ID,ECode,EDesc,Code,Desc,OMETCode,OMETDesc,Active,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业健康检查周期（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEEndangerSrv).SaveEDCheckCycle()
ClassMethod SaveEDCheckCycle(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ECode         = $p(aInputStr,aDelimiter,2)    //职业健康检查危害因素代码
	Set EDesc         = $p(aInputStr,aDelimiter,3)    //职业健康检查危害因素及特殊作业
	Set OMETCode      = $p(aInputStr,aDelimiter,4)    //职业健康检查种类代码
	Set OMETDesc      = $p(aInputStr,aDelimiter,5)    //职业健康检查种类描述
	Set Code          = $p(aInputStr,aDelimiter,6)    //检查周期代码
	Set ExpInfo       = $p(aInputStr,aDelimiter,7)    //前置条件
	Set Desc          = $p(aInputStr,aDelimiter,8)    //检查周期描述
	Set Active        = $p(aInputStr,aDelimiter,9)    //激活
	Set Remark        = $p(aInputStr,aDelimiter,10)   //备注
	Quit:(ECode="")||(Code="")||(OMETCode="") return
	
	Set OMETID=$o(^User.DHCPEOMETypeI("OMETCodeIndex"," "_$zcvt(OMETCode,"U"),0))
	Quit:OMETID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xEID=0,EID=""
		For {
			Set xEID=$o(^User.DHCPEEndangerI("EDCodeIndex"," "_$zcvt(ECode,"U"),xEID))
			Quit:xEID=""
			Continue:##class(User.DHCPEEndanger).GetLocShowDataFlag(xEID,xInLocID)'["Y"  //无显示权限退出
			Set EID=xEID
		}
		Continue:EID=""
		
		Set xSub=0,tID=""
		For {
			Set xSub=$o(^User.DHCPEEDCheckCycleI("IdxOfOMETypeEDCCode",OMETID," "_$zcvt(Code,"U"),EID,xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDCheckCycle).GetLocShowDataFlag(EID_"||"_xSub,xInLocID)'["Y"  //无显示权限退出
			Set tID=EID_"||"_xSub
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDCheckCycle).%New()
		}Else{
			Set obj=##class(User.DHCPEEDCheckCycle).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCParref       = ##class(User.DHCPEEndanger).GetObjById(EID)
		Set obj.EDCCode         = Code
		Set obj.EDCDesc         = Desc
		Set obj.EDCOMETypeDR    = ##class(User.DHCPEOMEType).GetObjById(OMETID)
		Set obj.EDCActive       = Active
		Set obj.EDCExpInfo      = ExpInfo
		Set obj.EDCRemark       = Remark
		Set obj.EDCUpdateDate   = +$h
		Set obj.EDCUpdateTime   = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEEDCheckCycle).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-27
/// Description: 导出职业健康检查检查内容（管控）
/// Table：      User.DHCPEEDCheckItems
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOOMEEndangerSrv","QryEDCheckItems",152)
Query QryEDCheckItems(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,ECode:%String,EDesc:%String,OMETCode:%String,OMETDesc:%String,Code:%String,Category:%String,Desc:%String,UsableFlag:%String,Active:%String,HICode:%String,HIDesc:%String,ExpInfo:%String,Remark:%String")
{
}

ClassMethod QryEDCheckItemsExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xParRef=""
	For {
		Set xParRef=$o(^User.DHCPEEndangerD(xParRef))
		Quit:xParRef=""
		
		Set xSub=0
		For {
			Set xSub=$o(^User.DHCPEEndangerD(xParRef,"EDCI",xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDCheckItems).GetLocShowDataFlag(xParRef_"||"_xSub,aLocId)'["Y"  //无显示权限退出
			
			Set ID=xParRef_"||"_xSub
			Set obj=##class(User.DHCPEEDCheckItems).GetObjById(ID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.EDCIOMETypeDR)
			Continue:obj.EDCIActive'="Y"  //无效数据过滤
			
			Set ECode       = obj.EDCIParref.EDCode
			Set EDesc       = obj.EDCIParref.EDDesc
			Set Code        = obj.EDCICode
			Set Category    = obj.EDCICategory
			Set Desc        = obj.EDCIDesc
			Set UsableFlag  = obj.EDCIUsableFlag
			Set OMETCode    = obj.EDCIOMETypeDR.OMETCode
			Set OMETDesc    = obj.EDCIOMETypeDR.OMETDesc
			Set Active      = obj.EDCIActive
			Set ExpInfo     = obj.EDCIExpInfo
			Set Remark      = obj.EDCIRemark
			Set (HICode,HIDesc)=""
			If $IsObject(obj.EDCIOMEHIDR){
				Set HICode = obj.EDCIOMEHIDR.HICode
				Set HIDesc = obj.EDCIOMEHIDR.HIDesc
			}
			
			Set Data=$lb(ID,ECode,EDesc,OMETCode,OMETDesc,Code,Category,Desc,UsableFlag,Active,HICode,HIDesc,ExpInfo,Remark)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-27
/// Description:  导入职业健康检查检查内容（管控）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOOMEEndangerSrv).SaveEDCheckItems("^02001^铅及其无机化合物^01^上岗前检查^01^症状询问^症状询问^^Y^^^重点询问消化系统、神经系统及贫血等相关病史及症状，如：便秘、腹痛、头痛、头晕、乏力、失眠、多梦、记忆力减退、四肢麻木等^")
ClassMethod SaveEDCheckItems(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID            = $p(aInputStr,aDelimiter,1)    //ID
	Set ECode         = $p(aInputStr,aDelimiter,2)    //职业健康检查危害因素代码
	Set EDesc         = $p(aInputStr,aDelimiter,3)    //职业健康检查危害因素及特殊作业
	Set OMETCode      = $p(aInputStr,aDelimiter,4)    //职业健康检查种类代码
	Set OMETDesc      = $p(aInputStr,aDelimiter,5)    //职业健康检查种类描述
	Set Code          = $p(aInputStr,aDelimiter,6)    //检查内容代码
	Set Category      = $p(aInputStr,aDelimiter,7)    //检查内容分类
	Set Desc          = $p(aInputStr,aDelimiter,8)    //具体检查内容
	Set UsableFlag    = $p(aInputStr,aDelimiter,9)    //必选R/可选O
	Set Active        = $p(aInputStr,aDelimiter,10)   //激活
	Set HICode        = $p(aInputStr,aDelimiter,11)   //健康指标代码
	Set HIDesc        = $p(aInputStr,aDelimiter,12)   //健康指标描述
	Set ExpInfo       = $p(aInputStr,aDelimiter,13)   //扩展信息
	Set Remark        = $p(aInputStr,aDelimiter,14)   //备注
	Quit:(ECode="")||(Code="")||(OMETCode="") return
	
	Set OMETID=$o(^User.DHCPEOMETypeI("OMETCodeIndex"," "_$zcvt(OMETCode,"U"),0))
	Quit:OMETID="" return
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	Set HIID=""
	Set:HICode'="" HIID=$o(^CT.PE.OMEHealthIndexI("IdxOfCode"," "_$zcvt(HICode,"U"),0))
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set xEID=0,EID=""
		For {
			Set xEID=$o(^User.DHCPEEndangerI("EDCodeIndex"," "_$zcvt(ECode,"U"),xEID))
			Quit:xEID=""
			Continue:##class(User.DHCPEEndanger).GetLocShowDataFlag(xEID,xInLocID)'["Y"  //无显示权限退出
			Set EID=xEID
		}
		Continue:EID=""
		
		Set xSub=0,tID=""
		For {
			Set xSub=$o(^User.DHCPEEndangerI("EDCI","IdxOfOMETypeEDCICode",OMETID," "_$zcvt(Code,"U"),EID,xSub))
			Quit:xSub=""
			Continue:##class(User.DHCPEEDCheckItems).GetLocShowDataFlag(EID_"||"_xSub,xInLocID)'["Y"  //无显示权限退出
			Set tID=EID_"||"_xSub
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDCheckItems).%New()
		}Else{
			Set obj=##class(User.DHCPEEDCheckItems).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCIParref       = ##class(User.DHCPEEndanger).GetObjById(EID)
		Set obj.EDCICode         = Code
		Set obj.EDCICategory     = Category
		Set obj.EDCIDesc         = Desc
		Set obj.EDCIUsableFlag   = UsableFlag
		Set obj.EDCIOMETypeDR    = ##class(User.DHCPEOMEType).GetObjById(OMETID)
		Set obj.EDCIActive       = Active
		Set obj.EDCIOMEHIDR     = ##class(User.DHCPEOMEHealthIndex).GetObjById(HIID)
		Set obj.EDCIExpInfo      = ExpInfo
		Set obj.EDCIRemark       = Remark
		Set obj.EDCIUpdateDate   = +$h
		Set obj.EDCIUpdateTime   = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEEDCheckItems).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
