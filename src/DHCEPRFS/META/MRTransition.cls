Class DHCEPRFS.META.MRTransition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作前状态编码
Property PrevStatusCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 操作编码
Property ActionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 操作后状态编码
Property PostStatusCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxMain On (PrevStatusCode, ActionCode) [ Unique ];

Index IdxTrans On (IsActive, PrevStatusCode, ActionCode, PostStatusCode);

Storage Default
{
<Data name="MRTransitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>PostStatusCode</Value>
</Value>
<Value name="4">
<Value>PrevStatusCode</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRTransitionD</DataLocation>
<DefaultData>MRTransitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRTransitionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRTransitionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRTransitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
