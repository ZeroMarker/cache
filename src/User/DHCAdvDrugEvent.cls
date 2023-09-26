Class User.DHCAdvDrugEvent Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADVDE_RowID, SqlTableName = DHC_AdvDrugEvent, StorageStrategy = NewStorage1 ]
{

/// ADVDE_Code 
Property ADVDECode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADVDE_Code ];

/// ADVDE_Desc
Property ADVDEDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADVDE_Desc ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVDRUGEV)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADVDE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVDE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVDRUGEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVDE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVDE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCADVDRUGEV</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVDE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ADVDE_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVDE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDrugEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
