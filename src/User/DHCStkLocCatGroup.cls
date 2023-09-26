Class User.DHCStkLocCatGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLCG_RowId, SqlTableName = DHC_StkLocCatGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkLocUserCatGrp As User.DHCStkLocUserCatGrp [ Cardinality = children, Inverse = USLCGParref ];

/// SLCG_CTLoc_Dr
Property SLCGCTLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = SLCG_CTLoc_Dr ];

/// SLCG_StkCatGrp_Dr
Property SLCGStkCatGrpDr As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = SLCG_StkCatGrp_Dr ];

/// SLCG_Type
Property SLCGType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SLCG_Type ];

/// SLCG_Default
Property SLCGDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SLCG_Default ];

/// SLCG_StkMonFlag - 月报标志
Property SLCGStkMonFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SLCG_StkMonFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSLCG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SLCG_CTLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLCG_Default">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLCG_StkCatGrp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLCG_StkMonFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLCG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSLCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SLCG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SLCG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^DHCSLCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLCG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLCG_CTLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SLCG_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SLCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCat">
<Global>^DHCSLCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLCG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCCAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SLCG_CTLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SLCG_StkCatGrp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SLCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkLocCatGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSLCG)
	s oldI = +$g(^mdata("DHCSTKLOCDRUGGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSLCG = maxI
	s ^mdata("DHCSTKLOCDRUGGROUP") = maxI
}

}
