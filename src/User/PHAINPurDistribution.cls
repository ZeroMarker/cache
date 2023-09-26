/// 配送点编码维护
Class User.PHAINPurDistribution Extends %Persistent [ SqlRowIdName = PPD_RowId, SqlTableName = PHAIN_PurDistribution, StorageStrategy = CacheStorage ]
{

/// 编码
Property PPDCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PPD_Code ];

/// 名称
Property PPDDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PPD_Desc ];

/// 地址
Property PPDAddress As %String [ Required, SqlColumnNumber = 4, SqlFieldName = PPD_Address ];

/// 联系人姓名
Property PPDReceiver As %String [ Required, SqlColumnNumber = 5, SqlFieldName = PPD_Receiver ];

/// 电话
Property PPDReceiverTell As %String [ Required, SqlColumnNumber = 6, SqlFieldName = PPD_ReceiverTell ];

/// 邮政编码
Property PPDYZBM As %String [ Required, SqlColumnNumber = 7, SqlFieldName = PPD_YZBM ];

/// 备注
Property PPDRemarks As %String [ SqlColumnNumber = 8, SqlFieldName = PPD_Remarks ];

Storage CacheStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.PurDistribution)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PPD_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPD_Receiver">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPD_ReceiverTell">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPD_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPD_YZBM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^CD.PHA.IN.PurDistribution</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAINPurDistributionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.IN.PurDistribution)
	s oldI = +$g(^mdata("PHAINPurDistribution"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.IN.PurDistribution = maxI
	s ^mdata("PHAINPurDistribution") = maxI
}

}
