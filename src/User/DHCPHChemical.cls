/// 化学通用名
Class User.DHCPHChemical Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCM_RowId, SqlTableName = DHC_PHChemical, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 代码
Property PHCMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHCM_Code ];

/// 描述
Property PHCMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCM_Desc ];

/// 药理学分类
Property PHCMPHCCDr As User.DHCPHCCat [ SqlColumnNumber = 4, SqlFieldName = PHCM_PHCC_Dr ];

/// 类组
Property PHCMSCGDr As User.DHCStkCatGroup [ SqlColumnNumber = 5, SqlFieldName = PHCM_SCG_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCM)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PHCM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCM_PHCC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCM_SCG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHCM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHCM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHCMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCM_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHCMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCM_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCC">
<Condition>{PHCM_PHCC_Dr}'=""</Condition>
<ConditionFields>PHCM_PHCC_Dr</ConditionFields>
<Global>^DHCPHCMi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHCM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHCC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCM_PHCC_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHChemicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCM)
	s oldI = +$g(^mdata("DHCPHCHEMICAL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCM = maxI
	s ^mdata("DHCPHCHEMICAL") = maxI
}

}
