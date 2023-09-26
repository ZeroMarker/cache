/// 名称: EMRmeta.TitleLoc
/// 描述: 标题科室配置表(科室)
/// 编写者：yejian
/// 编写日期: 2015-12-17
Class EMRmeta.TitleLoc Extends (%Persistent, %XML.Adaptor)
{

/// 标题ID
Property TitleID As %String;

/// 标题名称(冗余字段)
Property TitleName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

Index IdxCTLocIDTitleID On (TitleID, CTLocID);

Storage Default
{
<Data name="TitleLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TitleID</Value>
</Value>
<Value name="3">
<Value>TitleName</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
<Value name="5">
<Value>CTLocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TitleLocD</DataLocation>
<DefaultData>TitleLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.TitleLocD</IdLocation>
<IndexLocation>^DHCEMRM.TitleLocI</IndexLocation>
<StreamLocation>^DHCEMRM.TitleLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
