/// 名称: 门诊病历分类后台表（协和用过）
/// 描述: 门诊病历分类后台表
/// 编写者：yejian
/// 编写日期: 2019-7-11
Class EMRmeta.TemplateClassify Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 根节点为 ctloc + ctlocid
Property ParentID As %String(TRUNCATE = 1);

Property DocID As %String(TRUNCATE = 1);

Index IdxParentID On ParentID;

Storage Default
{
<Data name="TemplateClassifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ParentID</Value>
</Value>
<Value name="4">
<Value>DocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateClassifyD</DataLocation>
<DefaultData>TemplateClassifyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TemplateClassifyD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateClassifyI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateClassifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
