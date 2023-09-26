/// 名称: DHCMA.Util.BTS.ImportDicSrv
/// 描述: 导入基础字典、字典类型等数据
/// 编写者：蒋朋朋
/// 编写日期: 2018-11-01
Class DHCMA.Util.BTS.ImportDicSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 导入模块角色授权信息
/// w ##class(DHCMA.Util.BTS.ImportDicSrv).ImportMdlRole("EPDReport^传染病报告^admin^管理员^EPD")
ClassMethod ImportMdlRole(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:(aInputStr="") return
	
	Set MdlCode=$p(aInputStr,"^",1)
	Set MdlDesc=$p(aInputStr,"^",2)
	Set RoleCode=$p(aInputStr,"^",3)
	Set RoleDesc=$p(aInputStr,"^",4)
	Set ProCode=$p(aInputStr,"^",5)
	Quit:(MdlCode="")||(MdlDesc="") return
	Quit:(RoleCode="")||(RoleDesc="") return
	Quit:(ProCode="") return
	
	Set objPro=##class(DHCMA.Util.BT.Product).GetObjByCode(ProCode)
	Quit:'$IsObject(objPro) return
	Set ProID=objPro.%Id()
	
	Set objMdlDef=##class(DHCMA.Util.BT.MdlDef).GetObjByCode(MdlCode)
	If $IsObject(objMdlDef){
		Set MdlID=objMdlDef.%Id()
	} Else {
		Set InputStr="^"_MdlCode_"^"_MdlDesc_"^"_ProID
		Set MdlID=##class(DHCMA.Util.BT.MdlDef).Update(InputStr,"^")
		Quit:(+MdlID)<1 return
	}
	
	Set InputStr=MdlID_"^"_""_"^"_RoleCode_"^"_RoleDesc
	Set return=##class(DHCMA.Util.BT.MdlRole).Update(InputStr,"^")
	Quit return
}

ClassMethod ImportDicType(aCode As %String, aDesc As %String, aProCode As %String) As %String
{
	New (aCode,aDesc,aProCode)
	Set return=""
	Quit:(aCode="")||(aDesc="")||(aProCode="") return
	
	Set objPro=##class(DHCMA.Util.BT.Product).GetObjByCode(aProCode)
	Quit:'$IsObject(objPro) return
	
	Set ProID=objPro.%Id()
	
	Set ID=""
	Set input=ID_"^"_aCode_"^"_aDesc_"^"_ProID
	Set ret=##class(DHCMA.Util.BT.DicType).Update(input,"^")
	Set return=ret
	
	Quit return
}

ClassMethod ImportDictionary(aCode As %String, aDesc As %String, TypeCode As %String, IndNo As %String) As %String
{
	New (aCode,aDesc,TypeCode,IndNo)
	Set return=""
	Quit:(aCode="")||(aDesc="")||(TypeCode="") return
	
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjByCode(TypeCode)
	Quit:'$IsObject(objType) return
	
	Set TypeID=objType.%Id()
	
	Set ID=""
	Set input=ID_"^"_aCode_"^"_aDesc_"^"_TypeID_"^"_IndNo_"^"_1
	Set ret=##class(DHCMA.Util.BT.Dictionary).Update(input,"^")
	Set return=ret
	
	Quit return
}

// w ##class(DHCMA.Util.BTS.ImportDicSrv).ImportConfig("ewe^test^1^2^CPW^11")

ClassMethod ImportConfig(aInputs As %String) As %String
{
	New (aInputs)
	Set return=""
	Quit:(aInputs="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
	Set aSeparete="^"
	Set ID       = ""
	Set Code     = $p(aInputs,aSeparete,1)
	Set Desc     = $p(aInputs,aSeparete,2)
	Set Value    = $p(aInputs,aSeparete,3)
	Set HospID    = $p(aInputs,aSeparete,4)_"!!"_SYSDr
	Set ProductCode= $p(aInputs,aSeparete,5)
	Set objPro=##class(DHCMA.Util.BT.Product).GetObjByCode(ProductCode)
	Quit:'$IsObject(objPro) return
	
	Set ProductID=objPro.%Id()
	Set Comments = $p(aInputs,aSeparete,6)
	Set IsActiveDesc = $p(aInputs,aSeparete,7)
	Set:IsActiveDesc="" IsActiveDesc="是"
	Set IsActive = $s(IsActiveDesc="是":1,1:0)
	Set ActUserID = ""
	
	Set Inputs=ID_"^"_Code_"^"_Desc_"^"_Value_"^"_HospID_"^"_ProductID_"^"_IsActive_"^"_ActUserID_"^"_Comments
	Set ret=##class(DHCMA.Util.BT.Config).Update(Inputs,"^")
	
	Quit ret
}

// add by liuzhenhe  2019-01-16  路径类型字典

ClassMethod ImportPathType(aInputs As %String) As %String
{
	New (aInputs)
	Set return=""
	Quit:(aInputs="") return
	
	Set aSeparete="^"
	Set ID       = ""
	Set Code     = $p(aInputs,aSeparete,1)
	Set Desc     = $p(aInputs,aSeparete,2)
	
	Set Inputs=ID_"^"_Code_"^"_Desc
	Set ret= ##class(DHCMA.CPW.BT.PathType).Update(Inputs,"^")
	Quit ret
}

// add by liuzhenhe  2019-01-16  变异原因分类

ClassMethod ImportPathVarCat(aInputs As %String) As %String
{
	New (aInputs)
	Set return=""
	Quit:(aInputs="") return
	
	Set aSeparete="^"
	Set ID       = ""
	Set Code     = $p(aInputs,aSeparete,1)
	Set Desc     = $p(aInputs,aSeparete,2)
	
	Set Inputs=ID_"^"_Code_"^"_Desc
	Set ret= ##class(DHCMA.CPW.BT.PathVarCat).Update(Inputs,"^")

	Quit ret
}

// add by liuzhenhe  2019-01-16  表单项目分类

ClassMethod ImportPathItemCat(aInputs As %String) As %String
{
	New (aInputs)
	Set return=0
	Quit:(aInputs="") return
	
	Set aSeparete="^"
	Set ID       = ""
	Set Code     = $p(aInputs,aSeparete,1)
	Set Desc     = $p(aInputs,aSeparete,2)
	Set ItemTypeCode = $p(aInputs,aSeparete,3)
	Set DicTypeCode = $p(aInputs,aSeparete,4)
	Set PowerCode = $p(aInputs,aSeparete,5)
	
	Set objType= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode(DicTypeCode,ItemTypeCode)
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set objPower= ##class(DHCMA.Util.BT.Dictionary).GetObjByCode("CPWItemPowerType",PowerCode)
	Quit:'$IsObject(objPower) return
	Set PowerDr=objPower.%Id()
	
	Set Inputs=ID_"^"_Code_"^"_Desc_"^"_TypeDr_"^"_PowerDr
	Set ret= ##class(DHCMA.CPW.BT.PathItemCat).Update(Inputs,"^")
	
	Quit ret
}

}
