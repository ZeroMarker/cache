Class User.DHCPHCNTSADVICE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCA_RowID, SqlTableName = DHC_PHCNTSADVICE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCA_Code
Property PCACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCA_Code ];

/// PCA_Desc
Property PCADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCA_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCADVICE)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="PCA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPCADVICE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSADVICES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
