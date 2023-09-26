Class DHCEPRFS.META.ItemCorrelation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 关联类型
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 要关联其它项目的归档项目ID
Property MRItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 被关联的归案项目ID
Property ReleatedMRItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index IdxMain On (Type, MRItemID, ReleatedMRItemID) [ Unique ];

Index IdxReleatedMRItemID On ReleatedMRItemID;

Index IdxMRItemID On MRItemID;

Storage Default
{
<Data name="ItemCorrelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>MRItemID</Value>
</Value>
<Value name="4">
<Value>ReleatedMRItemID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ItemCorrelationD</DataLocation>
<DefaultData>ItemCorrelationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.ItemCorrelationD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ItemCorrelationI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ItemCorrelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
