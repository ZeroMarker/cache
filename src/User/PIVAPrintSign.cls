Class User.PIVAPrintSign Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPS_RowID, SqlTableName = PIVA_PrintSign, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PPS_PHCSC_Dr
Property PPSPHCSCDr As User.PHCSubCat [ SqlColumnNumber = 2, SqlFieldName = PPS_PHCSC_Dr ];

/// PPS_Sign
Property PPSSign As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPS_Sign ];

/// PPS_PHCDF_DR
Property PPSPHCDFDr As User.PHCDrgForm [ SqlColumnNumber = 4, SqlFieldName = PPS_PHCDF_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVAPS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PPS_PHCDF_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPS_PHCSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPS_Sign">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PIVAPS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PPS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCDF">
<Global>^PIVAPS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCDF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPS_PHCDF_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhcsc">
<Global>^PIVAPS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCSC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPS_PHCSC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAPrintSignS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
