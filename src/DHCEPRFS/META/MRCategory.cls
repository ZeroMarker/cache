/// Desc: 归档病历大类
Class DHCEPRFS.META.MRCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档病历大类名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历大类编码
Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

/// 归档病历大类描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 5 ];

Index IdxMain On Code [ Unique ];

Index IdxSequence On Sequence;

Storage Default
{
<Data name="MRCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRCategoryD</DataLocation>
<DefaultData>MRCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
