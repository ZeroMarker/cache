Class DHCEPRFS.META.EstimatePagesItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 欲统计页数项目编码
Property ItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 欲统计页数项目名称
Property ItemName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 欲统计页数项目描述
Property ItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 项目参数
Property TypeParam As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 项目参数类型(可以与集中打印类型一致)
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 是否启用
Property Available As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 顺序号
Property Sequence As %Integer [ SqlColumnNumber = 8 ];

/// 一起算的相关项目，多个以^分割
Property RelatedItems As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxMain On ItemCode [ Unique ];

Index IdxSequence On (Available, Sequence);

Storage Default
{
<Data name="EstimatePagesItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>ItemDesc</Value>
</Value>
<Value name="5">
<Value>TypeParam</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>Available</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>RelatedItems</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.EstimatePageD</DataLocation>
<DefaultData>EstimatePagesItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.EstimatePageD</IdLocation>
<IndexLocation>^DHCEPRFS.META.EstimatePageI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.EstimatePageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
