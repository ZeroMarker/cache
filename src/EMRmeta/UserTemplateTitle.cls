/// 名称: 用户模板标题关联表
/// 描述: 用户模板标题关联表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplateTitle Extends %Persistent
{

Index IdxTitleCode On TitleCode;

Index IdxCode On Code;

Index IdxCodeAndTitleCode On (Code, TitleCode);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标题编码
Property TitleCode As %String;

/// 标题名称
Property TitleName As %String;

Storage Default
{
<Data name="UserTemplateTitleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>TitleCode</Value>
</Value>
<Value name="4">
<Value>TitleName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateTitleD</DataLocation>
<DefaultData>UserTemplateTitleDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateTitleD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateTitleI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
