Class User.DHCIncBatPack Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INBP_ROWID, SqlTableName = DHC_IncBatPack, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INBP_INCIB_Dr
Property INBPINCIBDr As User.INCItmBat [ Required, SqlColumnNumber = 2, SqlFieldName = INBP_INCIB_Dr ];

/// INBP_BarCode
Property INBPBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INBP_BarCode ];

/// INBP_Uom_Dr
Property INBPUomDr As User.CTUOM [ Required, SqlColumnNumber = 4, SqlFieldName = INBP_Uom_Dr ];

/// 拆分的条码数量
Property INBPQty As %Float [ SqlColumnNumber = 5, SqlFieldName = INBP_Qty ];

/// 父条码
Property INBPParBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INBP_ParBarCode ];

/// 打印的标签次数
Property INBPPrintNum As %Library.Integer [ SqlColumnNumber = 7, SqlFieldName = INBP_PrintNum ];

/// 创建条码科室
Property INBPLocDr As User.CTLoc [ Required, SqlColumnNumber = 8, SqlFieldName = INBP_Loc_Dr ];

/// 打印标志
Property INBPPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INBP_PrintFlag ];

/// 转移子表ID
Property INBPINITIDr As %Library.String [ SqlColumnNumber = 10, SqlFieldName = INBP_INITI_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINBP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INBP_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INBP_INCIB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INBP_INITI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INBP_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INBP_ParBarCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INBP_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INBP_PrintNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INBP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INBP_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INBP_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INBP_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBP_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIB">
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INBP_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInti">
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INTI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBP_INITI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParBar">
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ParBar"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INBP_ParBarCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintFlag">
<Global>^DHCINBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{INBP_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBP_PrintFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBP_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INBP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIncBatPackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINBP)
	s oldI = +$g(^mdata("DHCINCBATPACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINBP = maxI
	s ^mdata("DHCINCBATPACK") = maxI
}

}
