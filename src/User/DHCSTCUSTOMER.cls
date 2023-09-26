Class User.DHCSTCUSTOMER Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STCUS_RowId, SqlTableName = DHC_STCUSTOMER, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PY of hospital 
Property STCUSID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = STCUS_ID ];

/// hospital name
Property STCUSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STCUS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^STCUS)</SqlIdExpression>
<SQLMap name="STCUS">
<Data name="STCUS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STCUS_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^STCUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STCUS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STCUS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSTCUSTOMERS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
