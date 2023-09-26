/// 科室列表
Class DHCCL.Config.LocationList Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LocationList ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="LocationListDefaultData">
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
<DataLocation>^DHCCL.Config.LocationListD</DataLocation>
<DefaultData>LocationListDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.LocationListD</IdLocation>
<IndexLocation>^DHCCL.Config.LocationListI</IndexLocation>
<StreamLocation>^DHCCL.Config.LocationListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
