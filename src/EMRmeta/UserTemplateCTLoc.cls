/// 名称: 用户模板科室关联表
/// 描述: 用户模板科室关联表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplateCTLoc Extends %Persistent
{

Index IdxCTLocID On CTLocID;

Index IdxCode On Code;

Index IdxCTLocIDAndCode On (CTLocID, Code);

Index IdxCodeAndCTLocID On (Code, CTLocID);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

/// CT_Loc名称
Property CTLocName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserTemplateCTLocDefaultData">
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
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateCTLocD</DataLocation>
<DefaultData>UserTemplateCTLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateCTLocD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateCTLocI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateCTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
