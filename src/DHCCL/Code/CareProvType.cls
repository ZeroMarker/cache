/// 医护人员类型
Class DHCCL.Code.CareProvType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CareProvType ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="CareProvTypeDefaultData">
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
<DataLocation>^DHCCL.Code.CareProvTypeD</DataLocation>
<DefaultData>CareProvTypeDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.CareProvTypeD</IdLocation>
<IndexLocation>^DHCCL.Code.CareProvTypeI</IndexLocation>
<StreamLocation>^DHCCL.Code.CareProvTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
