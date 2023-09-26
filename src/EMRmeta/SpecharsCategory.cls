/// Desc:       特殊字符分类
/// Creaotr:    Candy
/// CreateDate: 2015-3-3
Class EMRmeta.SpecharsCategory Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 代码
Property CategoryCode As %String(TRUNCATE = 1);

/// 描述
Property CategoryDesc As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Relationship Spechars As EMRmeta.Spechars [ Cardinality = children, Inverse = Category ];

Index IdxSequence On Sequence;

Storage Default
{
<Data name="SpecharsCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CharCode</Value>
</Value>
<Value name="3">
<Value>CharDesc</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>CategoryCode</Value>
</Value>
<Value name="6">
<Value>CategoryDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SpecharsCategoryD</DataLocation>
<DefaultData>SpecharsCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.SpecharsCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.SpecharsCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.SpecharsCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
