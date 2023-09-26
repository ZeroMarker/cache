/// Desc:特殊字符库
/// Creaotr:Candy
/// CreateDate:2015-3-3
Class EMRmeta.Spechars Extends (%Persistent, %XML.Adaptor)
{

/// 代码
Property CharCode As %String(TRUNCATE = 1);

/// 描述
Property CharDesc As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Relationship Category As EMRmeta.SpecharsCategory [ Cardinality = parent, Inverse = Spechars ];

Index IdxCategorySequence On (Category, Sequence);

Storage Default
{
<Data name="SpecharsDefaultData">
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
<Value>CharType</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Spechars")</DataLocation>
<DefaultData>SpecharsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Spechars")</IdLocation>
<IndexLocation>^DHCEMRM.SpecharsI</IndexLocation>
<StreamLocation>^DHCEMRM.SpecharsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
