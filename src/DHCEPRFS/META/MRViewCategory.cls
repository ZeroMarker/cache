Class DHCEPRFS.META.MRViewCategory Extends %Persistent
{

// 浏览大类名称	

Property Name As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

// 浏览大类描述

Property Description As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

// 浏览大类code，对于多家医院用一个库，建议能区分，入NSTWD 南山体温单

Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

// 在同类中的排序，0 表示不参与排序

Property Sequence As %Integer [ Required, SqlColumnNumber = 5 ];

Index IdxCode On Code [ Unique ];

Storage Default
{
<Data name="MRViewCategoryDefaultData">
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
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRViewCategoryD</DataLocation>
<DefaultData>MRViewCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.MRViewCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRViewCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRViewCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
