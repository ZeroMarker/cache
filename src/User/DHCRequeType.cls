Class User.DHCRequeType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = REQType_Rowid, SqlTableName = DHC_RequeType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRequSystem As User.DHCRequSystem [ Cardinality = children, Inverse = DHCPBPParRef ];

/// REQType_Desc
Property REQTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = REQType_Desc ];

/// REQType_Code
Property REQTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = REQType_Code ];

/// REQType_Dep
Property REQTypeDep As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = REQType_Dep ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCREQSYS)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="REQType_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQType_Dep">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQType_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REQType_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCREQSYS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>REQType_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{REQType_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRequeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
