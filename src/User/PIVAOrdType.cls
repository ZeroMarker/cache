Class User.PIVAOrdType Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POTY_Rowid, SqlTableName = PIVA_OrdType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// POTY_SubCat_Dr
Property POTYSubCatDr As User.PHCSubCat [ SqlColumnNumber = 2, SqlFieldName = POTY_SubCat_Dr ];

/// POTY_PhcCat_Dr
Property POTYPhcCatDr As User.PHCCat [ SqlColumnNumber = 3, SqlFieldName = POTY_PhcCat_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVATY)</SqlIdExpression>
<SQLMap name="DataMasterPIVATY">
<Data name="POTY_PhcCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POTY_SubCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVATY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POTY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{POTY_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPhaCat">
<Global>^PIVATY</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCCAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POTY_PhcCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCat">
<Global>^PIVATY</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBCAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POTY_SubCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POTY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrdTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
