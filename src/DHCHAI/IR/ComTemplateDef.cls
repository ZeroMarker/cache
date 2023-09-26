/// 名称: DHCHAI.IR.ComTemplateDef
/// 描述: 院感公共模板类型定义
/// 编写者: zhoubo
/// 编写日期: 2022-10-11
Class DHCHAI.IR.ComTemplateDef Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.ComTempDefExt [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 备注（说明）
Property BTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 代码索引
Index IndexCode On BTCode As Exact;

/// 名称索引
Index IndexDesc On BTDesc As Exact;

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  根据ID取公共模板
/// Table：       DHCHAI.IR.ComTemplateDef
/// Input：       aId : DHCHAI.IR.ComTemplateDef.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.ComTemplateDef).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.ComTemplateDef
{
	New (aId)
	Quit:'##class(DHCHAI.IR.ComTemplateDef).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.ComTemplateDef).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-20
/// Description:  根据Code取模板ID
/// Table：       DHCHAI.IR.ComTemplateDef
/// Input：       aCode : DHCHAI.IR.ComTemplateDef.BTCode
/// Return：      返回String
/// w ##class(DHCHAI.IR.ComTemplateDef).GetValByCode("BP-REP")
ClassMethod GetValByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.MA.HAI.IR.ComTemplateDefI("IndexCode",aCode,0))
	Quit:ID="" return
	Set ConfigData=$g(^CT.MA.HAI.IR.ComTemplateDefD(ID))
	If (ConfigData'=""){
		Set return = ID
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-11
/// Description:  更新公共模板类型
/// Table：       DHCHAI.IR.ComTemplateDef
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTemplateDef).Update("^BP-REP^血透个案调查表^1^2022血透个案调查报告")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Desc		= $p(aInputStr,aSeparete,3)
	Set IsActive	= +$p(aInputStr,aSeparete,4)
	Set Resume		= $p(aInputStr,aSeparete,5)
	Quit:(Code="")||(Desc="") return
	
	Set Code=$zcvt(Code,"U")
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^CT.MA.HAI.IR.ComTemplateDefI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.ComTemplateDef).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.ComTemplateDef).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode	    = Code
	Set obj.BTDesc	    = Desc
	Set obj.BTIsActive 	= IsActive
	Set obj.BTResume 	= Resume
	
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
/// Description:  删除公共模板类型
/// Table：       DHCHAI.IR.ComTemplateDef
/// Input：       aId : DHCHAI.IR.ComTemplateDef.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ComTemplateDef).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.ComTemplateDef).%DeleteId(aId)
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
<Data name="ComTemplateDefDefaultData">
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
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTResume</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.ComTemplateDefD</DataLocation>
<DefaultData>ComTemplateDefDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.ComTemplateDefD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.ComTemplateDefI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.ComTemplateDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
