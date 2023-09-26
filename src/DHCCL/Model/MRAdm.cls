/// 就诊诊断
Class DHCCL.Model.MRAdm Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MRAdm ]
{

Property Diastolic As %String [ SqlColumnNumber = 2 ];

Property Systolic As %String [ SqlColumnNumber = 3 ];

Property Pulse As %String [ SqlColumnNumber = 4 ];

Property Resp As %String [ SqlColumnNumber = 5 ];

Property BloodType As DHCCL.Code.BloodType [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="MRAdmDefaultData">
<Value name="1">
<Value>Diastolic</Value>
</Value>
<Value name="2">
<Value>Systolic</Value>
</Value>
<Value name="3">
<Value>Pulse</Value>
</Value>
<Value name="4">
<Value>Resp</Value>
</Value>
<Value name="5">
<Value>BloodType</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.MRAdmD</DataLocation>
<DefaultData>MRAdmDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.MRAdmD</IdLocation>
<IndexLocation>^DHCCL.Model.MRAdmI</IndexLocation>
<StreamLocation>^DHCCL.Model.MRAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
