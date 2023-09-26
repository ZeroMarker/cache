Class DHCEPRFS.META.MRTransPage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作前状态编码
Property PrevStatusCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 操作编码
Property ActionCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 操作后状态编码
Property PostStatusCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 执行条件
Property ExecCondition As %String [ SqlColumnNumber = 6 ];

Index IdxMain On (PrevStatusCode, ActionCode) [ Data = ExecCondition, Unique ];

Index IdxTrans On (IsActive, PrevStatusCode, ActionCode, PostStatusCode) [ Data = ExecCondition ];

Storage Default
{
<Data name="MRTransPageDefaultData">
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
<Value name="6">
<Value>ExecCondition</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.MRTransPageD</DataLocation>
<DefaultData>MRTransPageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.MRTransPageD</IdLocation>
<IndexLocation>^DHCEPRFS.META.MRTransPageI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.MRTransPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
