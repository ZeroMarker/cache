Class DHCEPRFS.META.MRStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 状态编码
Property StatusCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 状态名称
Property StatusName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 是否有效
Property IsActive As %Boolean [ SqlColumnNumber = 4 ];

Index IdxMain On StatusCode [ Unique ];

Storage Default
{
<Data name="MRStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>StatusName</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRStatusD</DataLocation>
<DefaultData>MRStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRStatusD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRStatusI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
