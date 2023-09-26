Class User.DHCMedAppendixCard Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MAC_Rowid, SqlTableName = DHC_MedAppendixCard, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedAppendixCardItem As User.DHCMedAppendixCardItem [ Cardinality = children, Inverse = MACIParRef ];

/// MAC_Code
Property MACCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MAC_Code ];

/// MAC_Desc
Property MACDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MAC_Desc ];

/// MAC_Active
Property MACActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MAC_Active ];

/// MAC_Type
Property MACType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MAC_Type ];

/// MAC_Date
Property MACDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MAC_Date ];

/// MAC_Demo
Property MACDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MAC_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMAC)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MAC_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MAC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MAC_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MAC_Demo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MAC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MAC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MAC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MAC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAppendixCardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
