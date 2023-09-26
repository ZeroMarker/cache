Class User.DHCEQFinancialReviewFunds Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQFinancialReviewFunds, StorageStrategy = SQLStorage ]
{

/// FRF_FinancialReviewEquipDR
Property FRFFinancialReviewEquipDR As DHCEQFinancialReviewEquip [ SqlColumnNumber = 2, SqlFieldName = FRF_FinancialReviewEquipDR ];

/// FRF_FundsTypeDR
Property FRFFundsTypeDR As DHCEQCFundsType [ SqlColumnNumber = 3, SqlFieldName = FRF_FundsTypeDR ];

/// FRF_OrigianlFee
Property FRFOrigianlFee As %Float [ SqlColumnNumber = 4, SqlFieldName = FRF_OrigianlFee ];

/// FRF_NetFee
Property FRFNetFee As %Float [ SqlColumnNumber = 5, SqlFieldName = FRF_NetFee ];

/// FRF_DepreTotalFee
Property FRFDepreTotalFee As %Float [ SqlColumnNumber = 6, SqlFieldName = FRF_DepreTotalFee ];

/// FRF_DepreFee
Property FRFDepreFee As %Float [ SqlColumnNumber = 7, SqlFieldName = FRF_DepreFee ];

/// FRF_ChangeFee
Property FRFChangeFee As %Float [ SqlColumnNumber = 8, SqlFieldName = FRF_ChangeFee ];

/// FRF_ChangeDepreTotal
Property FRFChangeDepreTotal As %Float [ SqlColumnNumber = 9, SqlFieldName = FRF_ChangeDepreTotal ];

/// FRF_Hold1
Property FRFHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = FRF_Hold1 ];

/// FRF_Hold2
Property FRFHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FRF_Hold2 ];

/// FRF_Hold3
Property FRFHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FRF_Hold3 ];

/// FRF_Hold4
Property FRFHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = FRF_Hold4 ];

/// FRF_Hold5
Property FRFHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = FRF_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQFinancialReviewFunds("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FRF_ChangeDepreTotal">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FRF_ChangeFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FRF_DepreFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FRF_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FRF_FinancialReviewEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FRF_FundsTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FRF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FRF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FRF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FRF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FRF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FRF_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FRF_OrigianlFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQFinancialReviewFunds</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FRF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{FRF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFinancialReviewEquip">
<Global>^DHCEQFinancialReviewFunds</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FRF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FinancialReviewEquip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FRF_FinancialReviewEquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FRF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FRF_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQFinancialReviewFundsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
