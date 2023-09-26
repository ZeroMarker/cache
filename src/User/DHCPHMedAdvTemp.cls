Class User.DHCPHMedAdvTemp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMAT_RowID, SqlTableName = DHC_PHMedAdvTemp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMAT_Type
Property PHMATType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHMAT_Type ];

/// PHMAT_Pointer
Property PHMATPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMAT_Pointer ];

/// PHMAT_DSD_Dr
Property PHMATDSDDr As User.DHCPHDrgSugDic [ SqlColumnNumber = 4, SqlFieldName = PHMAT_DSD_Dr ];

/// CR - CareRemark，关注备注 , AD - Adivce，用药建议
Property PHMATGroup As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHMAT_Group ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMAT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMAT_DSD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMAT_Group">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMAT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMAT_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMAT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMAT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupPointor">
<Global>^DHCPHMAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHMAT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GroupPointer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMAT_Group}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMAT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMAT_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointor">
<Global>^DHCPHMAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHMAT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMAT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMAT_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMAT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMedAdvTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHMAT)
	s oldI = +$g(^mdata("DHCPHMEDADVTEMP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHMAT = maxI
	s ^mdata("DHCPHMEDADVTEMP") = maxI
}

}
