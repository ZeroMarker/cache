/// 单位
Class DHCCL.Config.Uom Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Uom ]
{

Property Code As %String(COLLATION = "Upper", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property LocalDesc As %String(COLLATION = "Upper", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ForeignDesc As %String(COLLATION = "Upper", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Property Alias As %String(MAXLEN = 220) [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="UomDefaultData">
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
<Value>ExternalID</Value>
</Value>
<Value name="5">
<Value>Alias</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.UomD</DataLocation>
<DefaultData>UomDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.UomD</IdLocation>
<IndexLocation>^DHCCL.Config.UomI</IndexLocation>
<StreamLocation>^DHCCL.Config.UomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
