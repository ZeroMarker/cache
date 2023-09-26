Class User.DHCBankCheck Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BC_RowId, SqlTableName = DHC_BankCheck, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCBankCheckSub As User.DHCBankCheckSub [ Cardinality = children, Inverse = BCSParRef ];

/// BC_TransactionId
Property BCTransactionId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BC_TransactionId ];

/// BC_UserID
Property BCUserID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BC_UserID ];

/// BC_ClientAddress
Property BCClientAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BC_ClientAddress ];

/// BC_CheckDate
Property BCCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = BC_CheckDate ];

/// BC_CheckTime
Property BCCheckTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = BC_CheckTime ];

/// BC_BookCount
Property BCBookCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BC_BookCount ];

/// 取消预约笔数
Property BCReBookCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BC_ReBookCount ];

/// BC_PayCount
Property BCPayCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BC_PayCount ];

/// 支付金额
Property BCPayFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BC_PayFee ];

/// 取消支付笔数
Property BCRePayCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BC_RePayCount ];

/// 取消支付金额
Property BCRePayFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BC_RePayFee ];

/// BC_CheckFee
Property BCCheckFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BC_CheckFee ];

/// BC_UpdateDate
Property BCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = BC_UpdateDate ];

/// BC_UpdateTime
Property BCUpdateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = BC_UpdateTime ];

/// BC_UpdateUser
Property BCUpdateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = BC_UpdateUser ];

/// BC_CheckFlag
Property BCCheckFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = BC_CheckFlag ];

/// BC_Remark
Property BCRemark As list Of %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BC_Remark, SqlListType = SUBNODE ];

/// 冲正笔数
Property BCAutoPayCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BC_AutoPayCount ];

/// 冲正金额
Property BCAutoPayFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BC_AutoPayFee ];

/// 取消冲正笔数
Property BCReAutoPayCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BC_ReAutoPayCount ];

/// 取消冲正金额
Property BCReAutoPayFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BC_ReAutoPayFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBC)</SqlIdExpression>
<SQLMap name="IndexCheckDateData">
<Global>^DHCBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CheckDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BC_CheckDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMasterData">
<Data name="BC_AutoPayCount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BC_AutoPayFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BC_BookCount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BC_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BC_CheckFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BC_CheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BC_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BC_ClientAddress">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BC_PayCount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BC_PayFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BC_ReAutoPayCount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BC_ReAutoPayFee">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BC_ReBookCount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BC_RePayCount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BC_RePayFee">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BC_Remark">
<Node>"BCR"</Node>
</Data>
<Data name="BC_TransactionId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BC_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BC_UserID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTransactionIdData">
<Global>^DHCBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TransactionId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BC_TransactionId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDateData">
<Global>^DHCBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BC_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserIDData">
<Global>^DHCBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BC_UserID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBankCheckS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
