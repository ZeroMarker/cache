Class User.DHCItmChargeType Extends (%Persistent, User.Abstract) [ SqlRowIdName = ICT_RowId, SqlTableName = DHC_ItmChargeType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property ICTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICT_Code ];

Property ICTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCItmChgType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCItmChgType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ICT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmChargeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
