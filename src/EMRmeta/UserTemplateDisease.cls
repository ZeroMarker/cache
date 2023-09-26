/// 名称: 病种诊断关联
/// 描述: 病种诊断关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRmeta.UserTemplateDisease Extends %Persistent
{

Index IdxCode On Code;

Index IdxDiagnosCode On DiagnosCode;

Index IdxCodeAndDCode On (Code, DiagnosCode);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(TRUNCATE = 1);

/// 病种代码EMRmeta.Diagnos的DiagnosName
Property DiagnosName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserTemplateDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DiagnosCode</Value>
</Value>
<Value name="4">
<Value>DiagnosName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateDiseaseD</DataLocation>
<DefaultData>UserTemplateDiseaseDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateDiseaseD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateDiseaseI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
