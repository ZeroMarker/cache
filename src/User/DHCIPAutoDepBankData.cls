Class User.DHCIPAutoDepBankData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADBDRowID, SqlTableName = DHCIPAutoDepBankData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TradeCode	交易代码
Property TradeCode As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// TerminalID	终端编码
Property TerminalID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// HospitalId	医院唯一编号
Property HospitalId As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// ExtUserID	操作员代码
Property ExtUserID As User.SSUser [ SqlColumnNumber = 5 ];

/// PatientCard	卡号
Property PatientCard As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// CardTypeCode	卡类型
Property CardTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// Adm	就诊号
Property Adm As User.PAAdm [ SqlColumnNumber = 8 ];

/// PayModeCode	支付方式 1=现金 2=银行卡	
Property PayModeCode As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// TransactionId	交易流水号(由自助机生成,现金充值时必输)
Property TransactionId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// BankCode	交易银行
Property BankCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// BankAccDate	银行交易日期
Property BankAccDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12 ];

/// BankAccTime	银行交易时间
Property BankAccTime As %Library.Time [ SqlColumnNumber = 13 ];

/// HISTradeDate	HIS交易日期
Property HISTradeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14 ];

/// HISTradeTime	HIS交易时间
Property HISTradeTime As %Library.Time [ SqlColumnNumber = 15 ];

/// BankTransactionId	银行交易流水号
Property BankTransactionId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// BankCardNo	银行卡号
Property BankCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// Amount	银行交易金额
Property Amount As %Library.Float [ SqlColumnNumber = 18 ];

/// PrtDeposit_DR	HIS押金表指针
Property PrtDepositDR As User.dhcsfprintdetail [ SqlColumnNumber = 19, SqlFieldName = PrtDeposit_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPAutoDepBankData)</SqlIdExpression>
<SQLMap name="IndexBankAccDate">
<Global>^DHCIPAutoDepBankData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADBDRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BankAccDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BankAccDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBankTransactionId">
<Global>^DHCIPAutoDepBankData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADBDRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BankTransactionId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BankTransactionId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISTradeDate">
<Global>^DHCIPAutoDepBankData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADBDRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"HISTradeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HISTradeDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrtDepositDR">
<Global>^DHCIPAutoDepBankData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADBDRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PrtDepoistDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PrtDeposit_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransactionId">
<Global>^DHCIPAutoDepBankData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADBDRowID</Field>
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
<Expression>{TransactionId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterIndex">
<Data name="Adm">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Amount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BankAccDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BankAccTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BankCardNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BankCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BankTransactionId">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CardTypeCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ExtUserID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HISTradeDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HISTradeTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HospitalId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PatientCard">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PayModeCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PrtDeposit_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TerminalID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TradeCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TransactionId">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCIPAutoDepBankData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADBDRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ADBDRowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIPAutoDepBankDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
