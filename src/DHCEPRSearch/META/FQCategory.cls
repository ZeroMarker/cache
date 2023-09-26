Class DHCEPRSearch.META.FQCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 4 ];

/// 编码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxMain On Code;

Index IdxSequence On Sequence;

Storage Default
{
<Data name="FQCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.META.FQCategoryD</DataLocation>
<DefaultData>FQCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.META.FQCategoryD</IdLocation>
<IndexLocation>^DHCEPRSearch.META.FQCategoryI</IndexLocation>
<StreamLocation>^DHCEPRSearch.META.FQCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
