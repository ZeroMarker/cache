/// Desc:       批量签名类型字典表
/// Creator:    Candy
/// CreateDate: 2017-9-26
Class EMRmeta.GroupSignType Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

Index IdxCode On Code;

Index IdxCategory On Category;

Index IdxCodeType On (Code, Type);

/// 类型代码
Property Code As %String(TRUNCATE = 1);

/// 类型名称
Property Name As %String(TRUNCATE = 1);

/// 术语集代码
Property GlossaryCode As %String(TRUNCATE = 1);

/// 分类
Property Category As %String(TRUNCATE = 1);

/// 中西医类型（中医：Chinese 西医：""）
Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="GroupSignTypeDefaultData">
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
<Value>GlossaryCode</Value>
</Value>
<Value name="5">
<Value>Category</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.GroupSignTypeD</DataLocation>
<DefaultData>GroupSignTypeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.GroupSignTypeD</IdLocation>
<IndexLocation>^DHCEMRM.GroupSignTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.GroupSignTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
