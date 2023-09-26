Class User.DHCInStkTkWindow Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STTKW_RowID, SqlTableName = DHC_InStkTkWindow, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LW_CTLOC_DR
Property STTKWCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = STTKW_CTLOC_DR ];

/// LW_Code
Property STTKWCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STTKW_Code ];

/// LW_Desc
Property STTKWDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = STTKW_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTTKW)</SqlIdExpression>
<SQLMap name="DataMasterSTTKWindow">
<Data name="STTKW_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STTKW_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STTKW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTTKW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STTKW_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STTKW_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCSTTKW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STTKW_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STTKW_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STTKW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCode">
<Global>^DHCSTTKWi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STTKW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOCCODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STTKW_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STTKW_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STTKW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDesc">
<Global>^DHCSTTKW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STTKW_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCDESC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STTKW_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STTKW_Desc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{STTKW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInStkTkWindowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTTKW)
	s oldI = +$g(^mdata("DHCLOCWINDOW"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTTKW = maxI
	s ^mdata("DHCLOCWINDOW") = maxI
}

}
