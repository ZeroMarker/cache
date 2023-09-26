/// 病区
Class DHCCL.Config.Ward Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Ward ]
{

Property Code As %String [ SqlColumnNumber = 2 ];

Property Description As %String [ SqlColumnNumber = 3 ];

Property Location As DHCCL.Config.Location [ SqlColumnNumber = 4 ];

Property Active As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

Property ActiveDate As %Date [ SqlColumnNumber = 6 ];

Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

Property ExternalID As %String [ SqlColumnNumber = 8 ];

Index Loc On Location;

Index Ext On ExternalID;

Index Code On Code [ Unique ];

Index Active On Active As Exact;

Storage Default
{
<Data name="WardDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Location</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.WardD</DataLocation>
<DefaultData>WardDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.WardD</IdLocation>
<IndexLocation>^DHCCL.Config.WardI</IndexLocation>
<StreamLocation>^DHCCL.Config.WardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
