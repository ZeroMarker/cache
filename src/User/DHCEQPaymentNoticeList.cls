Class User.DHCEQPaymentNoticeList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PNL_RowID, SqlTableName = DHC_EQPaymentNoticeList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PNL_PaymentNoticeDR
Property PNLPaymentNoticeDR As User.DHCEQPaymentNotice [ SqlColumnNumber = 2, SqlFieldName = PNL_PaymentNoticeDR ];

/// PNL_SourceType
Property PNLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PNL_SourceType ];

/// PNL_SourceID
Property PNLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PNL_SourceID ];

/// PNL_ExtendType
Property PNLExtendType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PNL_ExtendType ];

/// PNL_ExtendID
Property PNLExtendID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PNL_ExtendID ];

/// PNL_ProviderDR
Property PNLProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = PNL_ProviderDR ];

/// PNL_AmountFee
Property PNLAmountFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PNL_AmountFee ];

/// PNL_Remark
Property PNLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PNL_Remark ];

/// PNL_UpdateUserDR
Property PNLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PNL_UpdateUserDR ];

/// PNL_UpdateDate
Property PNLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PNL_UpdateDate ];

/// PNL_UpdateTime
Property PNLUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PNL_UpdateTime ];

/// PNL_Hold1
Property PNLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PNL_Hold1 ];

/// PNL_Hold2
Property PNLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PNL_Hold2 ];

/// PNL_Hold3
Property PNLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PNL_Hold3 ];

/// PNL_Hold4
Property PNLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PNL_Hold4 ];

/// PNL_Hold5
Property PNLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PNL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPaymentNoticeList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PNL_AmountFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PNL_ExtendID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PNL_ExtendType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PNL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PNL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PNL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PNL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PNL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PNL_PaymentNoticeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PNL_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PNL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PNL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PNL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PNL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PNL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PNL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQPaymentNoticeList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PNL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PNL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountNoDR">
<Global>^DHCEQPaymentNoticeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PNL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PaymentNoticeDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PNL_PaymentNoticeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PNL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtend">
<Global>^DHCEQPaymentNoticeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PNL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Extend"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PNL_ExtendType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PNL_ExtendID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PNL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQPaymentNoticeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PNL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PNL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PNL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PNL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPaymentNoticeListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
