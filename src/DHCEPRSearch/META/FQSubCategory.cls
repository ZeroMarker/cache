Class DHCEPRSearch.META.FQSubCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档病历子类名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历子类描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 4 ];

/// 归档病历大类ID
Property FQCategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 编码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Index IdxMain On Code;

Index IdxFQCategoryID On FQCategoryID;

Index IdxSequence On (FQCategoryID, Sequence);

Storage Default
{
<Data name="FQSubCategoryDefaultData">
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
<Value>FQCategoryID</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.META.FQSubCateD</DataLocation>
<DefaultData>FQSubCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.META.FQSubCateD</IdLocation>
<IndexLocation>^DHCEPRSearch.META.FQSubCateI</IndexLocation>
<StreamLocation>^DHCEPRSearch.META.FQSubCateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
