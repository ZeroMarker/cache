Class User.DHCINGdRecCover Extends (%Persistent, User.Abstract) [ SqlRowIdName = CVR_RowId, SqlTableName = DHC_INGdRec_Cover, StorageStrategy = SQLStorage1 ]
{

Relationship ChildDHCINGdRecCoverItm As User.DHCINGdRecCoverItm [ Cardinality = children, Inverse = CVRIParref ];

Property CVRNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CVR_No ];

Property CVRCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = CVR_CTLOC_DR ];

Property CVRDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CVR_Date ];

Property CVRTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CVR_Time ];

Property CVRSSUSRDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = CVR_SSUSR_DR ];

Property CVRMonth As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CVR_Month ];

/// 票据张数
Property CVRVoucherCount As %Float [ SqlColumnNumber = 8, SqlFieldName = CVR_VoucherCount ];

/// 进价金额
Property CVRRpAmt As %Float [ SqlColumnNumber = 9, SqlFieldName = CVR_RpAmt ];

/// 售价金额
Property CVRSpAmt As %Float [ SqlColumnNumber = 10, SqlFieldName = CVR_SpAmt ];

Storage SQLStorage1
{
<SqlIdExpression>$i(^DHCINGRCover(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CVR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CVR_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CVR_Month">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CVR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CVR_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CVR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CVR_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CVR_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CVR_VoucherCount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCINGRCover</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CVR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CVR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINGRCover</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CVR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CVR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CVR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CVR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCINGRCover</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CVR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MONTH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CVR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CVR_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CVR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCINGRCover</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CVR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CVR_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CVR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CVR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINGdRecCoverS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
