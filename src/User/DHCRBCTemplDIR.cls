Class User.DHCRBCTemplDIR Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDIR_RowID, SqlTableName = DHCRBC_TemplDIR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDIR_TempCat_DR
Property DDIRTempCatDR As User.DHCRBCTemplCat [ SqlColumnNumber = 2, SqlFieldName = DDIR_TempCat_DR ];

/// DDIR_Level
Property DDIRLevel As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DDIR_Level ];

/// DDIR_Desc
Property DDIRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DDIR_Desc ];

/// DDIR_TopDR
Property DDIRTopDR As User.DHCRBCTemplDIR [ SqlColumnNumber = 5, SqlFieldName = DDIR_TopDR ];

/// DDIR_HasChild
Property DDIRHasChild As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DDIR_HasChild ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTempl(0,"TemplDir"))</SqlIdExpression>
<SQLMap name="IndexTempCat">
<Global>^DHCRBCTempli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDIR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TempCatDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDIR_TempCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDIR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopDR">
<Global>^DHCRBCTempli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDIR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TopDir"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDIR_TopDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDIR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DDIR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDIR_HasChild">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDIR_Level">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDIR_TempCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDIR_TopDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCTempl</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDIR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TemplDir"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDIR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCTemplDIRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
