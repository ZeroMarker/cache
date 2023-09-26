Class User.PIVAInstruc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINST_RowId, SqlTableName = PIVA_Instruc, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTLOC
Property PINSTCtlocdr As CTLoc [ SqlColumnNumber = 2, SqlFieldName = PINST_Ctloc_dr ];

/// Des Ref to CTLOC
Property PINSTInstrDr As PHCInstruc [ SqlColumnNumber = 3, SqlFieldName = PINST_Instr_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PIVAINST(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PINST_Ctloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINST_Instr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PIVAINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PINST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocInst">
<Global>^PIVAINST</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCINST"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINST_Ctloc_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PINST_Instr_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PINST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PINST_RowId</SqlRowIdName>
<StreamLocation>^User.PIVAInstrucS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
