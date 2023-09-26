/// Desc:      可重复模板的标题码表
/// Creator:   Candy
/// CreateDate:2014-3-28
Class EMRmeta.Titles Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 别名（拼音简写)
Property Alias As %String(TRUNCATE = 1);

/// 索引
Index IdxCode On Code [ Unique ];

Index IdxDescription On Description;

Storage Default
{
<Data name="TitlesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Alias</Value>
</Value>
<Value name="5">
<Value>ID</Value>
</Value>
<Value name="6">
<Value>TitleCategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TitlesD</DataLocation>
<DefaultData>TitlesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TitlesD</IdLocation>
<IndexLocation>^DHCEMRM.TitlesI</IndexLocation>
<StreamLocation>^DHCEMRM.TitlesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
