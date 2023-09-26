/// 用药途径
Class DHCCL.Code.Instruction Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Instruction ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property LocalDesc As %String [ SqlColumnNumber = 3 ];

Property ForeignDesc As %String [ SqlColumnNumber = 4 ];

Property ShortDesc As %String [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="InstructionDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>LocalDesc</Value>
</Value>
<Value name="3">
<Value>ForeignDesc</Value>
</Value>
<Value name="4">
<Value>ShortDesc</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.InstructionD</DataLocation>
<DefaultData>InstructionDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.InstructionD</IdLocation>
<IndexLocation>^DHCCL.Code.InstructionI</IndexLocation>
<StreamLocation>^DHCCL.Code.InstructionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
