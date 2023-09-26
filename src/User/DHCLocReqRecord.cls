Class User.DHCLocReqRecord Extends (%Persistent, User.Abstract) [ SqlRowIdName = LRR_RowId, SqlTableName = DHC_LocReqRecord, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCLocReqRecorditm As User.DHCLocReqRecorditm [ Cardinality = children, Inverse = LRRIParrfe ];

/// 科室
Property LRRCTLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LRR_CTLoc_DR ];

/// 日期
Property LRRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = LRR_Date ];

/// 领用累计额
Property LRRUsedAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 4, SqlFieldName = LRR_UsedAmt ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCLRR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LRR_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRR_UsedAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCLRR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LRR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LRR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCLRR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LRR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRR_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LRR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LRR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocReqRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLRR)
	s oldI = +$g(^mdata("DHCLOCREQRECORD"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLRR = maxI
	s ^mdata("DHCLOCREQRECORD") = maxI
}

}
