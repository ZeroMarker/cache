/// 名称: web.DHCPE.KBA.IOPEExpertDiagnosSrv
/// 描述: 导出导入专家建议
/// 编写者：zhufei
/// 编写日期: 2022-01-22
Class web.DHCPE.KBA.IOPEExpertDiagnosSrv Extends web.DHCPE.KBA.IOBaseSetting [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出专家建议（私有）
/// Table：      User.DHCPEExpertDiagnosis
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEExpertDiagnosSrv","QryExpertDiagnosis",152)
Query QryExpertDiagnosis(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Code:%String,DiagnoseConclusion:%String,Detail:%String,Illness:%String,CommonIllness:%String,HighRisk:%String,YGCheck:%String,STCode:%String,STDesc:%String,STLDesc:%String,SexDR:%String,SexDesc:%String,Sort:%String,Active:%String,KBXCode:%String")
{
}

ClassMethod QryExpertDiagnosisExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xCode=""
	For {
		Set xCode=$o(^DHCPEED(0,"CODE",xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCPEED(0,"CODE",xCode,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
			
			Set obj=##class(User.DHCPEExpertDiagnosis).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:obj.EDActive'="Y"  //无效数据过滤
			Set Code        = obj.EDCode
			Set DiagnoseConclusion= obj.EDDiagnoseConclusion
			Set Detail      = obj.EDDetail
			Set Illness     = obj.EDIllness
			Set CommonIllness= obj.EDCommonIllness
			Set (STID,STCode,STDesc)=""
			If $IsObject(obj.EDStationDR){
				Set STID=obj.EDStationDR.%Id()
				Set STCode=obj.EDStationDR.STCode
				Set STDesc=obj.EDStationDR.STDesc
			}
			Set HighRisk    = obj.EDHighRisk
			Set Sort        = obj.EDSort
			Set (STLID,STLDesc)=""
			If $IsObject(obj.EDStationLocID){
				Set STLID=obj.EDStationLocID.%Id()
				Set STLDesc=obj.EDStationLocID.STLLocDesc
			}
			
			Set SexDR       = obj.EDSexDR
			Set SexDesc=$p($g(^CT("SEX",+SexDR)),"^",2)
			Set YGCheck     = obj.EDYGCheck
			Set Active      = obj.EDActive
			Set KBXCode     = obj.EDKBXCode
			
			Set Data=$lb(xID,Code,DiagnoseConclusion,Detail,Illness,CommonIllness,HighRisk,YGCheck,STCode,STDesc,STLDesc,SexDR,SexDesc,Sort,Active,KBXCode)
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入专家建议（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEExpertDiagnosSrv).SaveExpertDiagnosis("^000001^支气管哮喘^避免食用或接触容易引起过敏的物质，如花粉、海鲜及刺激性气体（如汽油、油烟、冷空气等）；防止受凉。必要时去呼吸内科就诊。^Y^Y^N^^102^内科^^^^^Y^1")
ClassMethod SaveExpertDiagnosis(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                 = $p(aInputStr,aDelimiter,1)    //ID
	Set Code               = $p(aInputStr,aDelimiter,2)    //建议代码
	Set DiagnoseConclusion = $p(aInputStr,aDelimiter,3)    //主检结论
	Set Detail             = $p(aInputStr,aDelimiter,4)    //专家建议
	Set Illness            = $p(aInputStr,aDelimiter,5)    //是否疾病
	Set CommonIllness      = $p(aInputStr,aDelimiter,6)    //是否常见病
	Set HighRisk           = $p(aInputStr,aDelimiter,7)    //高危标志
	Set YGCheck            = $p(aInputStr,aDelimiter,8)    //乙肝标志
	Set STCode             = $p(aInputStr,aDelimiter,9)    //站点代码
	Set STDesc             = $p(aInputStr,aDelimiter,10)    //站点描述
	Set STLDesc            = $p(aInputStr,aDelimiter,11)    //站点分类描述
	Set SexDR              = $p(aInputStr,aDelimiter,12)    //性别ID
	Set SexDesc            = $p(aInputStr,aDelimiter,13)    //性别描述
	Set Sort               = $p(aInputStr,aDelimiter,14)    //顺序号
	Set Active             = $p(aInputStr,aDelimiter,15)    //激活
	Set KBXCode            = $p(aInputStr,aDelimiter,16)    //知识库代码
	Quit:(DiagnoseConclusion="")||(STCode="") return
	
	Set STID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(STCode),0))
	Quit:STID="" return
	
	Set Active=$s(Active["Y":"Y",Active["是":"Y",1:"N")
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set STLID=""
		If STLDesc'="" {
			Set xSTLID=0
			For {
				Set xSTLID=$o(^DHCPEST(0,"STL","Desc",$$ALPHAUP^SSUTIL4(STLDesc),STID,xSTLID))
				Quit:xSTLID=""
				Continue:##class(User.DHCPEStationLoc).GetLocShowDataFlag(STID_"||"_xSTLID,xInLocID)'["Y"  //无显示权限退出
				Set STLID=STID_"||"_xSTLID
			}
		}
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEED(0,"CODE",Code,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEExpertDiagnosis).%New()
		}Else{
			Set obj=##class(User.DHCPEExpertDiagnosis).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDCode               = Code                  //建议代码
		Set obj.EDDiagnoseConclusion = DiagnoseConclusion    //主检结论
		Set obj.EDDetail             = Detail                //专家建议
		Set obj.EDIllness            = Illness               //是否疾病
		Set obj.EDCommonIllness      = CommonIllness         //是否常见病
		Set obj.EDHighRisk           = HighRisk              //高危标志
		Set obj.EDYGCheck            = YGCheck               //乙肝标志
		Set obj.EDStationDR          = ##class(User.DHCPEStation).GetObjById(STID)
		Set obj.EDStationLocID       = ##class(User.DHCPEStationLoc).GetObjById(STLID)
		Set obj.EDSexDR              = SexDR                 //性别ID
		Set obj.EDSort               = Sort                  //顺序号
		Set obj.EDActive             = Active                //激活
		Set obj.EDKBXCode            = KBXCode               //知识库代码
		Set obj.EDDateUpdate         = +$h
		Set obj.EDTimeUpdate         = $p($h,",",2)
		
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
		Set flg=##class(User.DHCPEExpertDiagnosis).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出专家建议别名（私有）
/// Table：      User.DHCPEEDAlias
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEExpertDiagnosSrv","QryEDAlias",152)
Query QryEDAlias(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,EDCode:%String,EDDesc:%String,Text:%String")
{
}

ClassMethod QryEDAliasExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xEDID=""
	For {
		Set xEDID=$o(^DHCPEEDA(0,"EDAlias",xEDID))
		Quit:xEDID=""
		Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xEDID,aLocId)'["Y"  //无显示权限退出
		
		Set xText=""
		For {
			Set xText=$o(^DHCPEEDA(0,"EDAlias",xEDID,xText))
			Quit:xText=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCPEEDA(0,"EDAlias",xEDID,xText,xID))
				Quit:xID=""
				Continue:##class(User.DHCPEEDAlias).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
				
				Set obj=##class(User.DHCPEEDAlias).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set (EDCode,EDDesc)=""
				If $IsObject(obj.EDAEDDR){
					Set EDCode=obj.EDAEDDR.EDCode
					Set EDDesc=obj.EDAEDDR.EDDiagnoseConclusion
				}
				Set Text = obj.EDAText
				
				Set Data=$lb(xID,EDCode,EDDesc,Text)
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
		}
		
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入专家建议别名（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEExpertDiagnosSrv).SaveEDAlias("^000010^冠心病^GXB")
ClassMethod SaveEDAlias(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID                = $p(aInputStr,aDelimiter,1)    //ID
	Set EDCode            = $p(aInputStr,aDelimiter,2)    //建议代码
	Set EDDesc            = $p(aInputStr,aDelimiter,3)    //主检结论
	Set Text              = $p(aInputStr,aDelimiter,4)    //别名
	Quit:(EDCode="")||(Text="") return
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		Set EDID=""
		Set xEDID=0
		For {
			Set xEDID=$o(^DHCPEED(0,"CODE",EDCode,xEDID))
			Quit:xEDID=""
			Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xEDID,xInLocID)'["Y"  //无显示权限退出
			Set EDID=xEDID
		}
		Continue:EDID=""
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^DHCPEEDA(0,"EDAlias",EDID,$$ALPHAUP^SSUTIL4(Text),xID))
			Quit:xID=""
			Continue:##class(User.DHCPEEDAlias).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEEDAlias).%New()
		}Else{
			Set obj=##class(User.DHCPEEDAlias).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EDAEDDR = ##class(User.DHCPEExpertDiagnosis).GetObjById(EDID)
		Set obj.EDAText = Text
		
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
		Set flg=##class(User.DHCPEEDAlias).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

/// Creator：    zhufei
/// CreatDate：  2022-01-22
/// Description: 导出建议表达式（私有）
/// Table：      User.DHCPEExpress
/// Input:       无
/// Return：     ROWSPEC = 
/// d ##class(%ResultSet).RunQuery("web.DHCPE.KBA.IOPEExpertDiagnosSrv","QryExpress",152)
Query QryExpress(aLocId As %String = "") As websys.Query(ROWSPEC = "ID:%String,Type:%String,TypeDesc:%String,SourceID:%String,SourceCode:%String,SourceDesc:%String,KBItemDtlCode:%String,KBItemDtlDesc:%String,STCode:%String,STDesc:%String,ODCode:%String,ODDesc:%String,ODSTextVal:%String,PreBracket:%String,Operator:%String,Reference:%String,AfterBracket:%String,Relation:%String,Sex:%String,NoBloodFlag:%String,AgeRange:%String,KBXCode:%String")
{
}

ClassMethod QryExpressExecute(ByRef qHandle As %Binary, aLocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set:aLocId="" aLocId=..#OutLocID
    Quit:aLocId="" $$$OK
    
    Set xType=""
	For {
		Set xType=$o(^User.DHCPEExpressI("SourceIDIndex",xType))
		Quit:xType=""
		
		Set SourceID=""
		For {
			Set SourceID=$o(^User.DHCPEExpressI("SourceIDIndex",xType,SourceID))
			Quit:SourceID=""
			
			Set xID=0
			For {
				Set xID=$o(^User.DHCPEExpressI("SourceIDIndex",xType,SourceID,xID))
				Quit:xID=""
				Continue:##class(User.DHCPEExpress).GetLocShowDataFlag(xID,aLocId)'["Y"  //无显示权限退出
				
				Set obj=##class(User.DHCPEExpress).GetObjById(xID)
				Continue:'$IsObject(obj)
				Set Type=obj.EType
				Set TypeDesc=$s(Type="ED":"建议表达式",Type="PR":"阳性记录",1:Type)
				Set SourceID=obj.ESourceID
				Set SourceDesc=""
				Set SourceCode=""
				If (Type="ED")&&(SourceID'="") {
					Set SourceCode=$p($g(^DHCPEED(SourceID,1)),"^",6)
					Set SourceDesc=$p($g(^DHCPEED(SourceID,1)),"^",1)
				}
				If (Type="PR")&&(SourceID'="") {
					Set SourceCode=$lg($g(^User.DHCPEPositiveRecordD(SourceID)),2)
					Set SourceDesc=$lg($g(^User.DHCPEPositiveRecordD(SourceID)),3)
				}
				Set PreBracket=obj.EPreBracket
				Set (ODID,ODCode,ODDesc,STCode,STDesc)=""
				If $IsObject(obj.EItemDR){
					Set ODID=obj.EItemDR.%Id()
					Set ODCode=obj.EItemDR.ODCode
					Set ODDesc=obj.EItemDR.ODDesc
					Set STCode=obj.EItemDR.ODParRef.STCode
					Set STDesc=obj.EItemDR.ODParRef.STDesc
				}
				Set Operator=obj.EOperator
				Set (ODSID,ODSTextVal)=""
				If $IsObject(obj.EODStandardDR){
					Set ODSID=obj.EODStandardDR.%Id()
					Set ODSTextVal=obj.EODStandardDR.ODSTextVal
					Set ODSMax=obj.EODStandardDR.ODSMax
					Set ODSMin=obj.EODStandardDR.ODSMin
					Set:ODSTextVal="" ODSTextVal=ODSMin_"-"_ODSMax
				}
				Set Reference=obj.EReference
				Set AfterBracket=obj.EAfterBracket
				Set Relation=obj.ERelation
				Set Sex=obj.ESex
				Set NoBloodFlag=obj.ENoBloodFlag
				Set AgeRange=obj.EAgeRange
				Set KBXCode=obj.EKBXCode
				Set KBItemDtlCode=obj.EKBItemDtlCode
				Set KBItemDtlDesc=obj.EKBItemDtlDesc
				
				Set Data=$lb(xID,Type,TypeDesc,SourceID,SourceCode,SourceDesc,KBItemDtlCode,KBItemDtlDesc,STCode,STDesc,ODCode,ODDesc,ODSTextVal,PreBracket,Operator,Reference,AfterBracket,Relation,Sex,NoBloodFlag,AgeRange,KBXCode)
				Set ^CacheTemp(repid,ind)=Data
		    	Set ind=ind+1
			}
		}
    }
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2022-01-22
/// Description:  导入建议表达式（私有）
/// Input：       aInpurtStr：各属性列表
///               aDelimiter: 分隔符，默认"^"分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(web.DHCPE.KBA.IOPEExpertDiagnosSrv).SaveExpress("^ED^建议表达式^1^000001^支气管哮喘^U000012^既往史(内)^^^^^^^[^支气管哮喘^^&&^N^Y^^1")
ClassMethod SaveExpress(aInputStr As %String, aDelimiter As %String = "^") As %String
{
	New (aInputStr,aDelimiter)
	Set return=0
	Quit:aInputStr="" return
	
    Set aLocId=..#InLocID
    Quit:aLocId="" "-100" //目标科室未设置
    
	Set:$g(aDelimiter)="" aDelimiter=..#Delimiter
	Set ID             = $p(aInputStr,aDelimiter,1)    //ID
	Set Type           = $p(aInputStr,aDelimiter,2)    //类型
	Set TypeDesc       = $p(aInputStr,aDelimiter,3)    //类型描述
	Set SourceID       = $p(aInputStr,aDelimiter,4)    //建议ID
	Set SourceCode     = $p(aInputStr,aDelimiter,5)    //建议代码
	Set SourceDesc     = $p(aInputStr,aDelimiter,6)    //专家建议
	Set KBItemDtlCode  = $p(aInputStr,aDelimiter,7)    //KB细项代码
	Set KBItemDtlDesc  = $p(aInputStr,aDelimiter,8)    //KB细项名称
	Set STCode         = $p(aInputStr,aDelimiter,9)    //站点代码
	Set STDesc         = $p(aInputStr,aDelimiter,10)    //站点名称
	Set ODCode         = $p(aInputStr,aDelimiter,11)    //细项代码
	Set ODDesc         = $p(aInputStr,aDelimiter,12)    //细项名称
	Set ODSTextVal     = $p(aInputStr,aDelimiter,13)    //细项选项
	Set PreBracket     = $p(aInputStr,aDelimiter,14)    //前置括号
	Set Operator       = $p(aInputStr,aDelimiter,15)    //操作符
	Set Reference      = $p(aInputStr,aDelimiter,16)    //比较值
	Set AfterBracket   = $p(aInputStr,aDelimiter,17)    //后置括号
	Set Relation       = $p(aInputStr,aDelimiter,18)    //逻辑运算符
	Set Sex            = $p(aInputStr,aDelimiter,19)    //性别限定
	Set NoBloodFlag    = $p(aInputStr,aDelimiter,20)    //非血标志
	Set AgeRange       = $p(aInputStr,aDelimiter,21)    //年龄范围
	Set KBXCode        = $p(aInputStr,aDelimiter,22)    //知识库代码
	Quit:(Type="")||(SourceID="") return
	
	Set STID=""
	Set:STCode'="" STID=$o(^DHCPEST(0,"Code",$$ALPHAUP^SSUTIL4(STCode),0))
	
	For idxInLoc=1:1:$l(aLocId,"^"){
		Set xInLocID=$p(aLocId,"^",idxInLoc)
		Continue:xInLocID=""
		
		//通过代码转换成ID
		If (Type="ED")&&(SourceCode'="") {
			Set SourceID=""
			Set xSourceID=0
			For {
				Set xSourceID=$o(^DHCPEED(0,"CODE",SourceCode,xSourceID))
				Quit:xSourceID=""
				Continue:##class(User.DHCPEExpertDiagnosis).GetLocShowDataFlag(xSourceID,xInLocID)'["Y"  //无显示权限退出
				Set SourceID=xSourceID
			}
		}
		If (Type="PR")&&(SourceCode'="") {
			Set SourceID=""
			Set xSourceID=0
			For {
				Set xSourceID=$o(^User.DHCPEPositiveRecordI("PCodeUnqIdx1"," "_$zcvt(SourceCode,"U"),xSourceID))
				Quit:xSourceID=""
				Continue:##class(User.DHCPEPositiveRecord).GetLocShowDataFlag(xSourceID,xInLocID)'["Y"  //无显示权限退出
				Set SourceID=xSourceID
			}
		}
		
		Set ODID="",ODSID=""
		If (STID'="")&&(ODCode'="") {
			Set xODID=0
			For {
				Set xODID=$o(^DHCPEST(0,"OD_Code",$$ALPHAUP^SSUTIL4(ODCode),STID,xODID))
				Quit:xODID=""
				Continue:##class(User.DHCPEOrderDetail).GetLocShowDataFlag(STID_"||"_xODID,xInLocID)'["Y"  //无显示权限退出
				Set ODID=STID_"||"_xODID
				
				Set xSub=0
				For {
					Set xSub=$o(^DHCPEST(+ODID,"OD",+$p(ODID,"||",2),"ODS",xSub))
					Quit:xSub=""
					
					Set objODStandard=##class(User.DHCPEODStandard).GetObjById(ODID_"||"_xSub)
					Continue:'$IsObject(objODStandard)
					Set tODSTextVal=objODStandard.ODSTextVal
					Set tODSMax=objODStandard.ODSMax
					Set tODSMin=objODStandard.ODSMin
					Set:tODSTextVal="" tODSTextVal=tODSMin_"-"_tODSMax
					Continue:ODSTextVal'=tODSTextVal
					Set ODSID=ODID_"||"_xSub
					Quit
				}
				Quit
			}
		}
		
		Set xID=0,tID=""
		For {
			Set xID=$o(^User.DHCPEExpressI("SourceIDIndex",Type,SourceID,xID))
			Quit:xID=""
			Continue:##class(User.DHCPEExpress).GetLocShowDataFlag(xID,xInLocID)'["Y"  //无显示权限退出
			Set tID=xID
		}
		Set:ID="" ID=tID
		Continue:(tID'="")&(ID'=tID) //返回错误提示：名称不唯一
		
		If ID="" {
			Set obj=##class(User.DHCPEExpress).%New()
		}Else{
			Set obj=##class(User.DHCPEExpress).%OpenId(ID)
		}
		Continue:'$IsObject(obj)
		
		Set obj.EType           = Type
		Set obj.ESourceID       = SourceID
		Set obj.EKBItemDtlCode  = KBItemDtlCode
		Set obj.EKBItemDtlDesc  = KBItemDtlDesc
		Set obj.EItemDR         = ##class(User.DHCPEOrderDetail).GetObjById(ODID)
		Set obj.EODStandardDR   = ##class(User.DHCPEODStandard).GetObjById(ODSID)
		Set obj.EPreBracket     = PreBracket
		Set obj.EOperator       = Operator
		Set obj.EReference      = Reference
		Set obj.EAfterBracket   = AfterBracket
		Set obj.ERelation       = Relation
		Set obj.ESex            = Sex
		Set obj.ENoBloodFlag    = NoBloodFlag
		Set obj.EAgeRange       = AgeRange
		Set obj.EKBXCode        = KBXCode
		
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
		Set flg=##class(User.DHCPEExpress).SaveDataToPowerControl(obj.%Id(),xInLocID,"")
	}
	Quit return
}

}
