/// 入库子表附加
/// 20160530
Class User.DHCINGdRecItmAddionInfo Extends (%Persistent, User.Abstract) [ SqlRowIdName = INGRINFO_RowId, SqlTableName = DHC_INGdRecItmAddionInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property INGRINFODR As User.DHCINGdRecItm [ SqlColumnNumber = 2, SqlFieldName = INGRINFO_DR ];

/// 到货温度
Property INGRINFOAOGTemp As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INGRINFO_AOGTemp ];

/// "Y"代表外包装完好,"N"或空为外包装不完好
Property INGRINFOPackGood As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INGRINFO_PackGood ];

/// 验收结论
Property INGRINFOAcceptCon As %String(MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = INGRINFO_AcceptCon ];

Property INGRINFOReqLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = INGRINFO_ReqLoc_Dr ];

/// 验收日期
Property INGRINFOCheckDate As %Date [ SqlColumnNumber = 7, SqlFieldName = INGRINFO_CheckDate ];

/// 验收时间
Property INGRINFOCheckTime As %Time [ SqlColumnNumber = 8, SqlFieldName = INGRINFO_CheckTime ];

/// 验收人
Property INGRINFOCheckUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = INGRINFO_CheckUser_DR ];

/// 验收备注
Property INGRINFOCheckRemarks As %String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = INGRINFO_CheckRemarks ];

/// 产品标识
Property INGRINFOToken As %String(MAXLEN = 100) [ SqlColumnNumber = 11, SqlFieldName = INGRINFO_Token ];

/// 产品中文标识(用于进口物资)
Property INGRINFOLocalToken As %String(MAXLEN = 100) [ SqlColumnNumber = 12, SqlFieldName = INGRINFO_LocalToken ];

/// "Y"代表有合格证,"N"或空为无合格证
Property INGRINFOProdCertif As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INGRINFO_ProdCertif ];

/// 第三方批次
Property INGRINFODetailId As %String(MAXLEN = 100) [ SqlColumnNumber = 14, SqlFieldName = INGRINFO_DetailId ];

/// 灭菌日期
Property INGRINFOSterilizedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = INGRINFO_SterilizedDate ];

/// 冷链验收情况
Property INGRINFOColdChainAcceptStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INGRINFO_ColdChainAcceptStatus ];

/// 入库单号发送平台标志
Property INGRINFOInGRNoPlatSentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INGRINFO_InGRNoPlatSentFlag ];

Property INGRINFOUDICode As %Library.String [ SqlColumnNumber = 20, SqlFieldName = INGRINFO_UDICode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINGRINFO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INGRINFO_AOGTemp">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRINFO_AcceptCon">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRINFO_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRINFO_CheckRemarks">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRINFO_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRINFO_CheckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRINFO_ColdChainAcceptStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGRINFO_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRINFO_DetailId">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRINFO_InGRNoPlatSentFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGRINFO_LocalToken">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGRINFO_PackGood">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRINFO_ProdCertif">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGRINFO_ReqLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRINFO_SterilizedDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGRINFO_Token">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRINFO_UDICode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCINGRINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INGRINFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INGRINFO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINGRI">
<Global>^DHCINGRINFO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRINFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INGRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRINFO_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRINFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGRINFO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINGdRecItmAddionInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINGRINFO)
	s oldI = +$g(^mdata("DHCINGdRecItmAddionInfo"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINGRINFO = maxI
	s ^mdata("DHCINGdRecItmAddionInfo") = maxI
}

}
