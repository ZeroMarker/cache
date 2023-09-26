/// 床位类型
Class DHCCL.Config.BedType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BedType ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ArchivedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

Property ICUFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

Property DaySurgeryFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

Property ActiveDate As %Date [ SqlColumnNumber = 7 ];

Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

Property ExternalID As %String [ SqlColumnNumber = 9 ];

Index ICU On ICUFlag As Exact;

Index DaySurgery On DaySurgeryFlag As Exact;

Index Ext On ExternalID;

Index Code On Code [ Unique ];

Storage Default
{
<Data name="BedTypeDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ArchivedFlag</Value>
</Value>
<Value name="4">
<Value>ICUFlag</Value>
</Value>
<Value name="5">
<Value>DaySurgeryFlag</Value>
</Value>
<Value name="6">
<Value>ActiveDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
<Value name="8">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.BedTypeD</DataLocation>
<DefaultData>BedTypeDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.BedTypeD</IdLocation>
<IndexLocation>^DHCCL.Config.BedTypeI</IndexLocation>
<StreamLocation>^DHCCL.Config.BedTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
