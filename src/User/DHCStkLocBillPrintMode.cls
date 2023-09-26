Class User.DHCStkLocBillPrintMode Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRT_RowId, SqlTableName = DHC_StkLocBillPrintMode, StorageStrategy = SqlStorage1 ]
{

Property PRTCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PRT_CTLOC_DR ];

Property PRTSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = PRT_SCG_DR ];

Property PRTPrtMode As %Library.String(MAXLEN = 2) [ SqlColumnNumber = 4, SqlFieldName = PRT_PrtMode ];

Storage SqlStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCStkLocBillPrintMode(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRT_PrtMode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRT_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCStkLocBillPrintMode</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PRT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkLocBillPrintModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
