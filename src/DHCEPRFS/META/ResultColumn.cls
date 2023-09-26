/// Desc:综合查询结果列
/// Creator:Candy
Class DHCEPRFS.META.ResultColumn Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 结果列描述
Property ColDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 结果列名称
Property ColName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 是否有效
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 5 ];

Index IdxIsActive On (IsActive, Sequence);

Storage Default
{
<Data name="ResultColumnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ColDesc</Value>
</Value>
<Value name="3">
<Value>ColName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResultColumnD</DataLocation>
<DefaultData>ResultColumnDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.ResultColumnD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResultColumnI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResultColumnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
