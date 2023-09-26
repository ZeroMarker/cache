Class User.PIVAArcic Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PA_RowID, SqlTableName = PIVA_Arcic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PA_ARCIC_Dr
Property PAARCICDr As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = PA_ARCIC_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAA)</SqlIdExpression>
<SQLMap name="DATAMasterPIVAArcic">
<Data name="PA_ARCIC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVAA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcic">
<Global>^PIVAA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_ARCIC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAArcicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
