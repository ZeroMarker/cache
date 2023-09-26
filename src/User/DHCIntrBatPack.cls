Class User.DHCIntrBatPack Extends %Persistent [ SqlRowIdName = Tbp_RowId, SqlTableName = DHC_IntrBatPack, StorageStrategy = SQLStorage ]
{

/// /此表为码表与发药孙表 多对一的关系  by zhaoxinlong 2018-1-17 20:03:05 扫码发药建
/// Tbp_Pointer  
Property TbpPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = Tbp_Pointer ];

/// Tbp_InBP_dr
Property TbpInBPdr As User.DHCIncBatPack [ SqlColumnNumber = 3, SqlFieldName = Tbp_InBP_dr ];

/// Tbp_Inci_dr
Property TbpIncidr As User.INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = Tbp_Inci_dr ];

/// Tbp_BQty 此码发药的基本单位数量
Property TbpBQty As %String [ InitialExpression = 0, SqlColumnNumber = 5, SqlFieldName = Tbp_BQty ];

/// Tbp_Inclb_dr
Property TbpInclbdr As User.INCItmLcBt [ SqlColumnNumber = 6, SqlFieldName = Tbp_Inclb_dr ];

/// Tbp_Date
Property TbpDate As %Library.Date [ Required, SqlColumnNumber = 7, SqlFieldName = Tbp_Date ];

/// Tbp_Time
Property TbpTime As %Library.Time [ Required, SqlColumnNumber = 8, SqlFieldName = Tbp_Time ];

/// Tbp_Type  同库存台账类型F--门诊发药。H--门诊退药
Property TbpType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Tbp_Type ];

/// 追溯码，TbpInBPdr和TbpBarCode二者必有一个
Property TbpBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Tbp_BarCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^INCTBP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Tbp_BQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Tbp_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Tbp_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Tbp_InBP_dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Tbp_Inci_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Tbp_Inclb_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Tbp_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Tbp_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Tbp_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^INCTBP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{Tbp_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Tbp_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPhdItm">
<Global>^INCTBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Tbp_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$p({Tbp_Pointer},"||",1,2)</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Tbp_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIntrBatPackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INCTBP)
	s oldI = +$g(^mdata("DHCINTRBATPACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INCTBP = maxI
	s ^mdata("DHCINTRBATPACK") = maxI
}

}
