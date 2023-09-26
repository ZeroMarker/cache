Class User.DHCBillKPITaskType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_BillKPITaskType, StorageStrategy = SQLStorage ]
{

/// BKTT_Code
Property BKTTCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BKTT_Code ];

/// BKTT_Desc
Property BKTTDesc As %Library.String [ Required, SqlColumnNumber = 3, SqlFieldName = BKTT_Desc ];

Index BKTTCodeUnqIdx On BKTTCode [ Unique ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCBILLKPITASKTYPE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BKTT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BKTT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBILLKPITASKTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BKTT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BKTT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCBILLKPITASKTYPEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BKTT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({BKTT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BKTT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BKTT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillKPITaskTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
