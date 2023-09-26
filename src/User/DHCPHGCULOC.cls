/// curr phgloc
Class User.DHCPHGCULOC Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHGC_ROWID, SqlTableName = DHC_PHGCULOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHGC_PHG_DR
Property PHGCPHGDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHGC_PHG_DR ];

/// PHGC_PHGL_DR
Property PHGCPHGLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHGC_PHGL_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHGC)</SqlIdExpression>
<SQLMap name="PHGCMASTER">
<Data name="PHGC_PHGL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHGC_PHG_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHGC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHGC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHGC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHGCULOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
