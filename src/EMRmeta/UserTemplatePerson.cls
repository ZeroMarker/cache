/// 名称: 用户模板和用户关联表
/// 描述: 用户模板和用户关联表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplatePerson Extends %Persistent
{

Index IdxUserID On UserID;

Index IdxCode On Code;

Index IdxUserIDAndCode On (UserID, Code);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户名
Property UserName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserTemplatePersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplatePersonD</DataLocation>
<DefaultData>UserTemplatePersonDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplatePersonD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplatePersonI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplatePersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
