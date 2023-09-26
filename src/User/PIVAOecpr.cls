Class User.PIVAOecpr Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PO_RowID, SqlTableName = PIVA_Oecpr, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PO_OECPR_Dr
Property POOECPRDr As User.OECPriority [ SqlColumnNumber = 2, SqlFieldName = PO_OECPR_Dr ];

/// PO_Ctloc_Dr
Property POCtlocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PO_Ctloc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAO)</SqlIdExpression>
<SQLMap name="IndexPriority">
<Global>^PIVAO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OECPR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PO_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PO_OECPR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterPIVAOecpr">
<Data name="PO_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PO_OECPR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVAO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PO_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAOecprS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
