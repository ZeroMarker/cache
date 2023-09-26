Class DHCCL.Code.BloodType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodType ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="BloodTypeDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.BloodTypeD</DataLocation>
<DefaultData>BloodTypeDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.BloodTypeD</IdLocation>
<IndexLocation>^DHCCL.Code.BloodTypeI</IndexLocation>
<StreamLocation>^DHCCL.Code.BloodTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
