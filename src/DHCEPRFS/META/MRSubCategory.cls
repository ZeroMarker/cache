/// Desc: 归档病历子类
Class DHCEPRFS.META.MRSubCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 归档病历子类名称
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历子类编码
Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

/// 归档病历子类描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 归档病历大类ID
Property MRCategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 6 ];

/// 参数，新版电子病历用来存储cgID
Property TypeParam As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Index IdxMain On Code [ Unique ];

Index IdxMRCategoryID On MRCategoryID;

Index IdxSequence On (MRCategoryID, Sequence);

Storage Default
{
<Data name="MRSubCategoryDefaultData">
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
<Value>MRCategoryID</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>TypeParam</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRSubCategoryD</DataLocation>
<DefaultData>MRSubCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRSubCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRSubCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRSubCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
