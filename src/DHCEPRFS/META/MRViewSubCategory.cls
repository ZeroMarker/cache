Class DHCEPRFS.META.MRViewSubCategory Extends %Persistent
{

Property ParentCode As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Name As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property Description As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Integer [ Required, SqlColumnNumber = 6 ];

Index IdxCode On Code [ Unique ];

Index IdxParent On ParentCode;

Storage Default
{
<Data name="MRViewSubCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentCode</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRViewSubCategoryD</DataLocation>
<DefaultData>MRViewSubCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.MRViewSubCategoryD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRViewSubCategoryI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRViewSubCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
