Class User.DHCAdvExpFieldLink Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvExpFieldLink ]
{

/// 代码
Property LinkCode As %String;

/// 描述
Property LinkDesc As %String;

/// 表单code
Property FormNameCode As %String;

/// code索引
Index IndexCode On LinkCode As AlphaUp;

/// 表单code索引
Index IndexFormNameCode On FormNameCode As AlphaUp;

Storage Default
{
<Data name="DHCAdvExpFieldLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkCode</Value>
</Value>
<Value name="3">
<Value>LinkDesc</Value>
</Value>
<Value name="4">
<Value>FormNameCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvExpFieldLinkD</DataLocation>
<DefaultData>DHCAdvExpFieldLinkDefaultData</DefaultData>
<IdLocation>^User.DHCAdvExpFieldLinkD</IdLocation>
<IndexLocation>^User.DHCAdvExpFieldLinkI</IndexLocation>
<StreamLocation>^User.DHCAdvExpFieldLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
