/// 名称: web.DHCCPW.MRC.ImportBaseDic
/// 描述: 临床路径基础字典导入程序
/// 编写者：zhufei
/// 编写日期: 2012-05-28
Class web.DHCCPW.MRC.ImportBaseDic Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 导入参数配置数据
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ImportBaseConfig()
ClassMethod ImportBaseConfig(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set Desc=$tr(Desc,$c(9),"")
	Set Value=$p(argInput,"^",4)
	Set Value=$tr(Value,$c(9),"")
	Set Resume=$p(argInput,"^",5)
	Set Resume=$tr(Resume,$c(9),"")
	Quit:(Code="")||(Desc="") return
	
	Set RowId=$o(^DHCMRCi("BC",0,"IndexCode"," "_Code,0))
	If RowId="" {
		Set obj=##class(User.DHCMRCBaseConfig).%New()
	} Else {
		Set obj=##class(User.DHCMRCBaseConfig).%OpenId(RowId)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BCCode=Code                    // 代码
	Set obj.BCDesc=Desc                    // 描述
	Set obj.BCValue=Value                  // 值
	Set obj.BCResume=Resume                // 备注
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导出参数配置数据
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ExportBaseConfig()
ClassMethod ExportBaseConfig() As %String
{
	New
	Set return=""
	
	Set ID=0
	For {
		Set ID=$o(^DHCMRC("BC",ID))
		Quit:ID=""
		
		Set obj=##class(web.DHCCPW.MRC.BaseConfig).GetObjById(ID)
		Continue:'$IsObject(obj)
		Set Code=obj.BCCode                    // 代码
		Set Desc=obj.BCDesc                    // 描述
		Set Desc=$tr(Desc,$c(2),"")
		Set Value=obj.BCValue                  // 值
		Set Resume=obj.BCResume                // 备注
		Set Resume=$tr(Resume,$c(2),"")
		
		Set strRec=Code_$c(2)_Desc_$c(2)_Value_$c(2)_Resume
		Set strRec=$tr(strRec,$c(0),"")
		Set strRec=$tr(strRec,$c(1),"")
		
		Set return=return_$c(1)_strRec
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// 导入临床路径类型字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ImportCPWType()
ClassMethod ImportCPWType(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set ID=0,RowId=""
	For {
		Set ID=$o(^DHCMRC("CLPT",ID))
		Quit:ID=""
		Quit:RowId'=""
		Set obj=##class(web.DHCCPW.MRC.PathWayType).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.CLPTCode'=Code
		Set RowId=ID
	}
	
	If RowId="" {
		Set obj=##Class(User.DHCMRCClinPathType).%New()
	} Else {
		Set obj=##Class(User.DHCMRCClinPathType).%OpenId(RowId)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CLPTCode=Code
	Set obj.CLPTDesc=Desc
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc) 
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入项目大类字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateItemCat()
ClassMethod UpdateItemCat(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set DateFrom=$p(argInput,"^",4)
	Set DateTo=$p(argInput,"^",5)
	Quit:(Code="")||(Desc="") return
	
	Set ID=0,RowId=""
	For {
		Set ID=$o(^DHCMRC("SIC",ID))
		Quit:ID=""
		Quit:RowId'=""
		Set obj=##class(web.DHCCPW.MRC.StepItemCategory).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.SICCode'=Code
		Set RowId=ID
	}
	
	If RowId="" {
		Set obj=##Class(User.DHCMRCStepItemCategory).%New()
	} Else {
		Set obj=##Class(User.DHCMRCStepItemCategory).%OpenId(RowId)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SICCode=Code
	Set obj.SICDesc=Desc
	Set obj.SICDateFrom=DateFrom
	Set obj.SICDateTo=DateTo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入项目子类字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateItemSubCat()
ClassMethod UpdateItemSubCat(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set CatID=$p(argInput,"^",1)
	Set Code=$p(argInput,"^",3)
	Set Desc=$p(argInput,"^",4)
	Set DateFrom=$p(argInput,"^",5)
	Set DateTo=$p(argInput,"^",6)
	Set Power=$p(argInput,"^",7)
	//Quit:(CatID="")||(Code="")||(Desc="") return
	
	Set SubID=0,RowID=""
	For {
		Set SubID=$o(^DHCMRC("SIC",CatID,"SUB",SubID))
		Quit:SubID=""
		Quit:RowID'=""
		Set obj=##class(web.DHCCPW.MRC.StepItemSubCategory).GetObjById(CatID_"||"_SubID)
		Continue:'$IsObject(obj)
		Continue:obj.SISCCode'=Code
		Set RowID=CatID_"||"_SubID
	}
	
	If RowID="" {
		Set obj=##Class(User.DHCMRCStepItemSubCategory).%New()
		Set obj.SISCParRef=##class(web.DHCCPW.MRC.StepItemCategory).GetObjById(CatID)
	} Else {
		Set obj=##Class(User.DHCMRCStepItemSubCategory).%OpenId(RowID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SISCCode=Code
	Set obj.SISCDesc=Desc
	Set obj.SISCDateFrom=DateFrom
	Set obj.SISCDateTo=DateTo
	Set obj.SISCPower=Power
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
		
	Quit return
}

/// 导入项目大类+项目子类字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ImportItemCateg("^01^主要诊疗工作^61901^^01-01^主要诊疗工作^61901^^D")
ClassMethod ImportItemCateg(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	Quit:argInput="" return
	
	TStart
	
	Set return=-2
	Set SICCode=$p(argInput,"^",1)
	Set SICDesc=$p(argInput,"^",2)
	Set SICDateFrom=$p(argInput,"^",3)
	Set:SICDateFrom["-" SICDateFrom=$zdh(SICDateFrom,3)
	Set SICDateTo=$p(argInput,"^",4)
	Set:SICDateTo["-" SICDateTo=$zdh(SICDateTo,3)
	Set InputStr=""
	Set InputStr=InputStr_"^"_SICCode
	Set InputStr=InputStr_"^"_SICDesc
	Set InputStr=InputStr_"^"_SICDateFrom
	Set InputStr=InputStr_"^"_SICDateTo
	Set flg=..UpdateItemCat(InputStr)
	If (+flg)<0 {
		TRollBack
		Quit return
	}
	Set CatID=flg
	Set return=+flg
	
	Set SISCCode=$p(argInput,"^",5)
	Set SISCDesc=$p(argInput,"^",6)
	Set SISCDateFrom=$p(argInput,"^",7)
	Set:SISCDateFrom["-" SISCDateFrom=$zdh(SISCDateFrom,3)
	Set SISCDateTo=$p(argInput,"^",8)
	Set:SISCDateTo["-" SISCDateTo=$zdh(SISCDateTo,3)
	Set SISCPower=$p(argInput,"^",9)
	If (SISCCode'="")||(SISCDesc'="")
	{
		Set return=-3
		Set InputStr=CatID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_SISCCode
		Set InputStr=InputStr_"^"_SISCDesc
		Set InputStr=InputStr_"^"_SISCDateFrom
		Set InputStr=InputStr_"^"_SISCDateTo
		Set InputStr=InputStr_"^"_SISCPower
		Set flg=..UpdateItemSubCat(InputStr)
		If (+flg)<0 {
			TRollBack
			Quit return
		}
		Set return=+flg
	}
	TCommit
	
	Quit return
}

/// 导入变异原因分类
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateVarCat("")
ClassMethod UpdateVarCat(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set Color=$p(argInput,"^",4)
	Set DateFrom=$p(argInput,"^",5)
	Set DateTo=$p(argInput,"^",6)
	Set Type=$p(argInput,"^",7)
	Quit:(Code="")||(Desc="") return
	
	Set ID=0,RowID=""
	For {
		Set ID=$o(^DHCMRC("VC",ID))
		Quit:ID=""
		Quit:RowID'=""
		
		Set obj=##class(web.DHCCPW.MRC.VarianceCategory).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.VCCode'=Code
		Set RowID=ID
	}
	
	If RowID=""{
		Set obj=##Class(User.DHCMRCVarianceCategory).%New()
	} Else{
		Set obj=##Class(User.DHCMRCVarianceCategory).%OpenId(RowID)	
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VCCode=Code
	Set obj.VCDesc=Desc
	Set obj.VCColour=Color
	Set obj.VCDateFrom=DateFrom
	Set obj.VCDateTo=DateTo
	Set obj.VCType=Type
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入变异原因字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateVarReason("")
ClassMethod UpdateVarReason(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set CatID=$p(argInput,"^",4)
	Set DateFrom=$p(argInput,"^",5)
	Set DateTo=$p(argInput,"^",6)	
	Set Type=$p(argInput,"^",7)
	Set VCActive=$p(argInput,"^",8)
	//Quit:(Code="")||(Desc="")||(CatID="") return
	
	Set ID=0,RowID=""
	For {
		Set ID=$o(^DHCMRC("VR",ID))
		Quit:ID=""
		Quit:RowID'=""
		
		Set obj=##class(web.DHCCPW.MRC.VarianceReason).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.VRCode'=Code	
		Set RowID=ID
	}
	
	If RowID=""{
		Set obj=##Class(User.DHCMRCVarianceReason).%New()
	} Else{
		Set obj=##Class(User.DHCMRCVarianceReason).%OpenId(RowID)	
	}
	Quit:'$IsObject(obj) return
	
	Set obj.VRCode=Code
	Set obj.VRDesc=Desc
	Set obj.VRVarCategDR=##class(web.DHCCPW.MRC.VarianceCategory).GetObjById(CatID)
	Set obj.VRDateFrom=DateFrom
	Set obj.VRDateTo=DateTo
	Set obj.VRType=Type
	Set obj.VRActive=VCActive
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入变异原因分类+变异原因字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ImportVarDic("^A^与病人相关的出径原因^#CC0000^61970^^O^1^病情变化(含并发症)^61970^^M")
ClassMethod ImportVarDic(argInput As %String) As %String
{
	New (argInput)
	Set return=1
	Quit:argInput="" -1
	
	TStart
	
	Set return=-2
	Set VCCode=$p(argInput,"^",1)
	Set VCDesc=$p(argInput,"^",2)
	Set VCColor=$p(argInput,"^",3)
	Set VCDateFrom=$p(argInput,"^",4)
	Set:VCDateFrom["-" VCDateFrom=$zdh(VCDateFrom,3)
	Set VCDateTo=$p(argInput,"^",5)
	Set:VCDateTo["-" VCDateTo=$zdh(VCDateTo,3)
	Set VCType=$p(argInput,"^",6)
	Set InputStr=""
	Set InputStr=InputStr_"^"_VCCode
	Set InputStr=InputStr_"^"_VCDesc
	Set InputStr=InputStr_"^"_VCColor
	Set InputStr=InputStr_"^"_VCDateFrom
	Set InputStr=InputStr_"^"_VCDateTo
	Set InputStr=InputStr_"^"_VCType
	Set flg=..UpdateVarCat(InputStr)
	If (+flg)<0 {
		TRollBack 
		Quit return
	}
	Set CatID=flg
	Set return=flg
	
	Set VRCode=$p(argInput,"^",7)
	Set VRDesc=$p(argInput,"^",8)
	Set VRDateFrom=$p(argInput,"^",9)
	Set:VRDateFrom["-" VRDateFrom=$zdh(VRDateFrom,3)
	Set VRDateTo=$p(argInput,"^",10)
	Set:VRDateTo["-" VRDateTo=$zdh(VRDateTo,3)
	Set VRType=$p(argInput,"^",11)
	Set VCActive=$p(argInput,"^",12)
	Set:VCActive="" VCActive="Y"
	If (VRCode'="")||(VRDesc'="")
	{
		Set return=-3
		Set InputStr=""
		Set InputStr=InputStr_"^"_VRCode
		Set InputStr=InputStr_"^"_VRDesc
		Set InputStr=InputStr_"^"_CatID
		Set InputStr=InputStr_"^"_VRDateFrom
		Set InputStr=InputStr_"^"_VRDateTo
		Set InputStr=InputStr_"^"_VRType
		Set InputStr=InputStr_"^"_VCActive
		Set flg=..UpdateVarReason(InputStr)
		If (+flg)<0 {
			TRollBack
			Quit return
		}
		Set return=flg
	}
	TCommit
	
	Quit return
}

/// 导入基础项目分类
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateBaseDicCat("")
ClassMethod UpdateBaseDicCat(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set ID=0,RowId=""
	For {
		Set ID=$o(^DHCMRC("BDC",ID))
		Quit:ID=""
		Quit:RowId'=""
		Set obj=##class(web.DHCCPW.MRC.BaseDicCategory).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.BDCCode'=Code
		Set RowId=ID
	}
	
	If RowId="" {
		Set obj=##Class(User.DHCMRCBaseDicCategory).%New()
	} Else {
		Set obj=##Class(User.DHCMRCBaseDicCategory).%OpenId(RowId)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BDCCode=Code
	Set obj.BDCDesc=Desc
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc) 
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入基础项目
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateBaseDicSubCat("")
ClassMethod UpdateBaseDicSubCat(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set CatID=$p(argInput,"^",1)
	Set Code=$p(argInput,"^",3)
	Set Desc=$p(argInput,"^",4)
	Set MultiSel=$p(argInput,"^",5)
	Set Type=$p(argInput,"^",6)
	//Quit:(CatID="")||(Code="")||(Desc="") return
	
	Set ID=0,RowID=""
	For {
		Set ID=$o(^DHCMRC("BDC",CatID,"SUB",ID))
		Quit:(ID="")
		Quit:RowID'=""
		Set obj=##Class(User.DHCMRCBaseDicSubCategory).%OpenId(CatID_"||"_ID)
		If obj'="" Do obj.%Close()
		Continue:'$IsObject(obj)
		Continue:obj.BDSCCode'=Code
		Set RowID=CatID_"||"_ID
	}
	
	If (RowID="")
	{
		Set obj=##Class(User.DHCMRCBaseDicSubCategory).%New()
		Set obj.BDSCParRef=##Class(User.DHCMRCBaseDicCategory).%OpenId(CatID)
	} Else {
		Set obj=##Class(User.DHCMRCBaseDicSubCategory).%OpenId(RowID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BDSCCode=Code
	Set obj.BDSCDesc=Desc
	Set obj.BDSCMultiSelect=MultiSel
	Set obj.BDSCType=Type
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入基础项目字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).UpdateBaseDic("")
ClassMethod UpdateBaseDic(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set TypeID=$p(argInput,"^",4)
	Set Active=$p(argInput,"^",5)
	//Quit:(Code="")||(Desc="") return
	
	Set ID=0,RowId=""
	For {
		Set ID=$o(^DHCMRC("BD",ID))
		Quit:ID=""
		Quit:RowId'=""
		Set obj=##class(web.DHCCPW.MRC.BaseDictionary).GetObjById(ID)
		Continue:'$IsObject(obj)
		Continue:obj.BDCode'=Code
		Set RowId=ID
	}
	
	If RowId="" {
		Set obj=##Class(User.DHCMRCBaseDictionary).%New()
	} Else {
		Set obj=##Class(User.DHCMRCBaseDictionary).%OpenId(RowId)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BDCode=Code
	Set obj.BDDesc=Desc
	Set obj.BDTypeDR=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(TypeID)
	Set obj.BDActive=Active
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc) 
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	If obj'="" Do obj.%Close()
	
	Quit return
}

/// 导入基础项目字典
/// w ##Class(web.DHCCPW.MRC.ImportBaseDic).ImportBaseDic("004^步骤类型^STEPTYPE^步骤类型^^DIC^01^诊断及药物治疗^Y")
ClassMethod ImportBaseDic(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	Quit:argInput="" return
	
	TStart
	
	Set return=-2
	Set BDCCode=$p(argInput,"^",1)
	Set BDCDesc=$p(argInput,"^",2)
	Set InputStr=""
	Set InputStr=InputStr_"^"_BDCCode
	Set InputStr=InputStr_"^"_BDCDesc
	Set flg=..UpdateBaseDicCat(InputStr)
	If (+flg)<0 {
		TRollBack
		Quit return
	}
	Set CatID=flg
	Set return=flg
	
	Set BDSCCode=$p(argInput,"^",3)
	Set BDSCDesc=$p(argInput,"^",4)
	Set BDSCMultiSel=$p(argInput,"^",5)
	Set BDSCType=$p(argInput,"^",6)
	If (BDSCCode'="")&&(BDSCDesc'="")
	{
		Set return=-3
		Set InputStr=CatID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_BDSCCode
		Set InputStr=InputStr_"^"_BDSCDesc
		Set InputStr=InputStr_"^"_BDSCMultiSel
		Set InputStr=InputStr_"^"_BDSCType
		Set flg=..UpdateBaseDicSubCat(InputStr)
		If (+flg)<0 {
			TRollBack 
			Quit return
		}
		Set SubCatRowId=flg
		Set return=flg
		
		Set BDCode=$p(argInput,"^",7)
		Set BDDesc=$p(argInput,"^",8)
		Set BDActive=$p(argInput,"^",9)
		If (BDCode'="")&&(BDDesc'="")
		{
			Set return=-4
			Set InputStr=""
			Set InputStr=InputStr_"^"_BDCode
			Set InputStr=InputStr_"^"_BDDesc
			Set InputStr=InputStr_"^"_SubCatRowId
			Set InputStr=InputStr_"^"_BDActive
			Set flg=..UpdateBaseDic(InputStr)
			If (+flg)<0 {
				TRollBack
				Quit return
			}
			Set return=flg
		}
	}
	
	TCommit
	
	Quit return
}

Storage Default
{
<Data name="ImportBaseDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MRC.ImportBaseDicD</DataLocation>
<DefaultData>ImportBaseDicDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MRC.ImportBaseDicD</IdLocation>
<IndexLocation>^web.DHCCPW.MRC.ImportBaseDicI</IndexLocation>
<StreamLocation>^web.DHCCPW.MRC.ImportBaseDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
