/// Desc:分类目录
/// Creator:Candy
Class DHCEPRFS.META.QueryCategory Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 字段名称
Property CategoryName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 字段描述
Property CategoryDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxSequence On Sequence;

Storage Default
{
<Data name="QueryCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryDesc</Value>
</Value>
<Value name="3">
<Value>CategoryName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryCategoryD</DataLocation>
<DefaultData>QueryCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
