/// 三单一致配置
Class DHCEPRFS.META.RecordCheck Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目名称
Property CheckName As %String(TRUNCATE = 1);

/// 项目描述
Property CheckDesc As %String(TRUNCATE = 1);

/// 连接URL
Property CheckURL As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 类型
Property CheckType As %String(TRUNCATE = 1);

/// 是否有效
Property IsValid As %String(TRUNCATE = 1);

/// 次序号
Property Sequence As %Integer;

Index IdxCheckType On CheckType;

Index IdxCheckName On CheckName;

Index IdxSequence On (CheckType, Sequence);

Storage Default
{
<Data name="RecordCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckName</Value>
</Value>
<Value name="3">
<Value>CheckDesc</Value>
</Value>
<Value name="4">
<Value>CheckURL</Value>
</Value>
<Value name="5">
<Value>CheckType</Value>
</Value>
<Value name="6">
<Value>IsValid</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.RecordCheckD</DataLocation>
<DefaultData>RecordCheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.RecordCheckD</IdLocation>
<IndexLocation>^DHCEPRFS.META.RecordCheckI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.RecordCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
