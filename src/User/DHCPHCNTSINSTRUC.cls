Class User.DHCPHCNTSINSTRUC Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINST_RowID, SqlTableName = DHC_PHCNTSINSTRUC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PINST_Inst_Dr
Property PINSTInstDr As User.PHCInstruc [ SqlColumnNumber = 2, SqlFieldName = PINST_Inst_Dr ];

/// PINST_Form_Dr
Property PINSTFormDr As User.PHCForm [ SqlColumnNumber = 3, SqlFieldName = PINST_Form_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCINST)</SqlIdExpression>
<SQLMap name="DataDHCPCINST">
<Data name="PINST_Form_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINST_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PINST_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSINSTRUCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
