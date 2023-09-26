/// 名称：		EMRmeta.EMRTemplateGroupLoc
/// 描述：		病历分组科室关联表
/// 编写者：	yejian
/// 编写时间：	2017-8-15
Class EMRmeta.EMRTemplateGroupLoc Extends %Persistent
{

/// 模板组合ID
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// 模板组合名称
Property TemplateGroupName As %String(TRUNCATE = 1);

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

Index IdxCodeCTLocID On (TemplateGroupCode, CTLocID) [ Unique ];

Index IdxCTLocIDCode On (CTLocID, TemplateGroupCode);

Storage Default
{
<Data name="EMRTemplateGroupLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateGroupCode</Value>
</Value>
<Value name="3">
<Value>TemplateGroupName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateGroupLocD</DataLocation>
<DefaultData>EMRTemplateGroupLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplateGroupLocD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateGroupLocI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateGroupLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
