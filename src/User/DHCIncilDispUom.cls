/// 药房发药单位
Class User.DHCIncilDispUom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ILDU_RowId, SqlTableName = DHC_IncilDispUom, StorageStrategy = SQLStorage ]
{

/// UOM
Property ILDUDispUom As User.CTUOM [ SqlColumnNumber = 2, SqlFieldName = ILDU_DispUom ];

/// ILDU_Active
Property ILDUActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ILDU_Active ];

/// ILDU_DateFrom
Property ILDUDateFrom As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = ILDU_DateFrom ];

/// ILDU_DateTo
Property ILDUDateTo As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = ILDU_DateTo ];

/// ILDU_INCIL_DR
Property ILDUINCILDR As User.INCItmLoc [ SqlColumnNumber = 6, SqlFieldName = ILDU_INCIL_DR ];

/// 规格
Property ILDUSpec As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ILDU_Spec ];

/// 库存数
Property ILDUQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ILDU_Qty ];

/// 补充标准
Property ILDURepLev As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ILDU_RepLev ];

/// 就诊类型
Property ILDUAdmType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = ILDU_AdmType ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCILDU)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ILDU_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILDU_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ILDU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILDU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ILDU_DispUom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILDU_INCIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ILDU_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ILDU_RepLev">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ILDU_Spec">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCILDU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILDU_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ILDU_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCIL">
<Global>^DHCILDU</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ILDU_INCIL_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ILDU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ILDU_RowId</SqlRowIdName>
<StreamLocation>^User.DHCIncilDispUomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCILDU)
	s oldI = +$g(^mdata("DHCINCILDISPUOM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCILDU = maxI
	s ^mdata("DHCINCILDISPUOM") = maxI
}

}
