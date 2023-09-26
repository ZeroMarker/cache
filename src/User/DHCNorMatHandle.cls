Class User.DHCNorMatHandle Extends (%Persistent, User.Abstract) [ SqlRowIdName = NMH_RowId, SqlTableName = DHC_NorMatHandle, StorageStrategy = SQLStorage ]
{

Property NMHINTRANDR As User.DHCINTRANS [ SqlColumnNumber = 2, SqlFieldName = NMH_INTRAN_DR ];

/// 提取日期
Property NMHDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = NMH_Date ];

/// 提取时间
Property NMHTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = NMH_Time ];

Property NMHSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = NMH_SSUSR_DR ];

Property NMHRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = NMH_Remark ];

/// 补录入库单标志
Property NMHIngrFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = NMH_IngrFlag ];

/// 补录入库明细
Property NMHINGRIDR As User.DHCINGdRecItm [ SqlColumnNumber = 8, SqlFieldName = NMH_INGRI_DR ];

/// 平台发送标志
Property NMHPlatSentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = NMH_PlatSentFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCNMHR)</SqlIdExpression>
<SQLMap name="IndexIntr">
<Global>^DHCNMHR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NMH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INTRAN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NMH_INTRAN_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NMH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="NMH_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NMH_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NMH_INTRAN_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NMH_IngrFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NMH_PlatSentFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NMH_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NMH_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NMH_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCNMHR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NMH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{NMH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NMH_RowId</SqlRowIdName>
<StreamLocation>^User.DHCNorMatHandleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCNMHR)
	s oldI = +$g(^mdata("DHCNorMatHandl"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCNMHR = maxI
	s ^mdata("DHCNorMatHandl") = maxI
}

}
