Class User.DHCEQContractPayment Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CTP_RowID, SqlTableName = DHC_EQContractPayment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CTP_Remark
Property CTPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CTP_Remark ];

/// CTP_PayNo
Property CTPPayNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CTP_PayNo ];

/// CTP_PayFee
Property CTPPayFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CTP_PayFee ];

/// CTP_PayDate
Property CTPPayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = CTP_PayDate ];

/// CTP_ContractDR
Property CTPContractDR As User.DHCEQContract [ SqlColumnNumber = 6, SqlFieldName = CTP_ContractDR ];

/// CTP_InvoiceNo
Property CTPInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CTP_InvoiceNo ];

/// CTP_InvoiceFee
Property CTPInvoiceFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = CTP_InvoiceFee ];

/// CTP_InvoiceDate
Property CTPInvoiceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = CTP_InvoiceDate ];

/// CTP_InvalidFlag
Property CTPInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CTP_InvalidFlag ];

/// CTP_UpdateUserDR
Property CTPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CTP_UpdateUserDR ];

/// CTP_UpdateDate
Property CTPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CTP_UpdateDate ];

/// CTP_UpdateTime
Property CTPUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = CTP_UpdateTime ];

/// CTP_PayedFee
Property CTPPayedFee As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = CTP_PayedFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContractPayment("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CTP_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTP_InvoiceDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTP_InvoiceFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTP_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTP_PayDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTP_PayFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTP_PayNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTP_PayedFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQContractPayment</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CTP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractPaymentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
