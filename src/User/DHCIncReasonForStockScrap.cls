Class User.DHCIncReasonForStockScrap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = REASON_ScrapRowID, SqlTableName = DHC_IncReasonForStockScrap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property REASONScrapCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = REASON_ScrapCode ];

Property REASONScrapDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = REASON_ScrapDesc ];

Property REASONScrapType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 4, SqlFieldName = REASON_ScrapType ];

/// 激活标记(缺省为Y)
Property REASONScrapActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = REASON_ScrapActiveFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTREASON("SCRAP"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REASON_ScrapActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REASON_ScrapCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REASON_ScrapDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REASON_ScrapType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTREASON</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REASON_ScrapRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SCRAP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{REASON_ScrapRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIncReaso1D73S</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTREASON("SCRAP"))
	s oldI = +$g(^mdata("DHCINCREASONFORSTOCKSCRAP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTREASON("SCRAP") = maxI
	s ^mdata("DHCINCREASONFORSTOCKSCRAP") = maxI
}

}
