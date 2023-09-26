Class DHCEPRFS.META.MRViewItem Extends %Persistent
{

// 浏览子类

Property Name As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

// 父级Code

Property ParentCode As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

// 生成归档子类的实际MRItemID，为0表示归档里面还没有

Property MRItemID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

// 默认顺序，建议自增，为0表示不参与排序

Property Sequence As %Integer [ Required, SqlColumnNumber = 5 ];

Index IdxMain On MRItemID;

Index IdxParent On ParentCode;

Storage Default
{
<Data name="MRViewItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ParentCode</Value>
</Value>
<Value name="4">
<Value>MRItemID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRViewItemD</DataLocation>
<DefaultData>MRViewItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.MRViewItemD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRViewItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRViewItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
