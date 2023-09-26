/// 名称: DHCHAI.IR.ComTemplateDef
/// 描述: 院感公共模板扩展项目
/// 编写者: zhoubo
/// 编写日期: 2022-10-11
Class DHCHAI.IR.ComTempDefExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.ComTemplateDef [ Cardinality = parent, Inverse = ChildExt ];

/// 代码(六位编码)
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目分类
Property BTExtType As DHCHAI.BT.Dictionary;

/// 数据格式（S列表、T文本、N0整数、N1小数、B1是/否、B2有/无）
Property BTDatType As DHCHAI.BT.Dictionary;

/// 关联字典
Property BTDicType As DHCHAI.BT.DicType;

/// 该扩展项目是否必填
Property BTIsRequired As %Boolean;

/// 代码索引
Index IndexCode On (Parref, BTCode As Exact);

/// 分类索引
Index IndexType On (Parref, BTExtType As Exact);

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  根据ID取公共模板扩展项目
/// Table：       DHCHAI.IR.ComTempDefExt
/// Input：       aId : DHCHAI.IR.ComTempDefExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ComTempDefExt).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ComTempDefExt
{
	New (aId)
	Quit:'##class(DHCHAI.IR.ComTempDefExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.ComTempDefExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  更新公共模板扩展项目
/// Table：       DHCHAI.IR.ComTempDefExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTempDefExt).Update("1^13^001011^曾接受职业暴露知识培训^379^459")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref	   = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set Code	   = $p(aInputStr,aSeparete,3)
	Set Desc	   = $p(aInputStr,aSeparete,4)
	Set ExtTypeDr  = $p(aInputStr,aSeparete,5)
	Set DatTypeDr  = $p(aInputStr,aSeparete,6)
	Set DicTypeDr  = $p(aInputStr,aSeparete,7)
	Set IsRequired   = $p(aInputStr,aSeparete,8)
	Quit:(Parref="")||(Code="")||(Desc="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set objParref=##class(DHCHAI.IR.ComTemplateDef).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCHAI.BT.Dictionary).GetObjById(ExtTypeDr)
	Quit:'$IsObject(objType) return
	Set objDat=##class(DHCHAI.BT.Dictionary).GetObjById(DatTypeDr)
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicTypeDr)
	Set objDicType="" 
	If $IsObject(objDic) {
		Set objDicType=##class(DHCHAI.BT.DicType).GetObjByCode(objDic.BTCode)
	}
	Set tID=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexCode",Parref,Code,0))
	Quit:(tID'="")&(ChildSub'=tID) -2
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.ComTempDefExt).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.ComTempDefExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
   
	Set obj.Parref	    = objParref
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTExtType 	= objType
	Set obj.BTDatType 	= objDat
	Set obj.BTDicType 	= objDicType
	Set obj.BTIsRequired  = IsRequired

	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  导入扩展项目定义
/// w ##Class(DHCHAI.IR.ComTempDefExt).ImportExt("血透个案调查表^020100^乙型肝炎病毒感染^经血传播病原体感染情况^单选字典^BPIsNoCheck","^")
ClassMethod ImportExt(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ExpType = $p(aInputStr,aSeparate,1)
	Set Code    = $p(aInputStr,aSeparate,2)
	Set Desc    = $p(aInputStr,aSeparate,3)
	Set ExtType = $p(aInputStr,aSeparate,4)
	Set DatType = $p(aInputStr,aSeparate,5)
	Set DicType = $p(aInputStr,aSeparate,6)

	Quit:'$d(^CT.MA.HAI.IR.ComTemplateDefI("IndexDesc",ExpType)) return
	
    Set Parref =$o(^CT.MA.HAI.IR.ComTemplateDefI("IndexDesc",ExpType,0))
    Set ChildSub=$o(^CT.MA.HAI.IR.ComTemplateDefI("EXT","IndexCode",Parref,Code,0))
    Set ExtTypeDr =""
    
    Set objExtType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("BPItemType",ExtType)
    Set:$IsObject(objExtType) ExtTypeDr = objExtType.%Id()
    
    Set DatTypeDr =""
    Set objDatType = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("BPDataType",DatType)
    Set:$IsObject(objDatType) DatTypeDr = objDatType.%Id()
    
    Set DicTypeDr =""
    Set objDicType = ##class(DHCHAI.BT.Dictionary).GetObjByCode("BPDicType",DicType)
    Set:$IsObject(objDicType) DicTypeDr = objDicType.%Id()
	Set InputStr=Parref_aSeparate_ChildSub_aSeparate_Code_aSeparate_Desc_aSeparate_ExtTypeDr_aSeparate_DatTypeDr_aSeparate_DicTypeDr
	
	Set return=##Class(DHCHAI.IR.ComTempDefExt).Update(InputStr,aSeparate)
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  删除公共模板扩展项目
/// Table：       DHCHAI.IR.ComTempDefExt
/// Input：       aId : DHCHAI.IR.ComTempDefExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTempDefExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ComTempDefExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ComTempDefExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTExtType</Value>
</Value>
<Value name="5">
<Value>BTDatType</Value>
</Value>
<Value name="6">
<Value>BTDicType</Value>
</Value>
<Value name="7">
<Value>BTIsRequired</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>ComTempDefExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.ComTemplateDefI("EXT")</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.ComTempDefExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
