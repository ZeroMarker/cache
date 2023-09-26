Class User.DHCEQInvoice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IV_RowID, SqlTableName = DHC_EQInvoice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IV_Code
Property IVCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IV_Code ];

/// IV_No
Property IVNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IV_No ];

/// IV_Date
Property IVDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = IV_Date ];

/// IV_AmountFee
Property IVAmountFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IV_AmountFee ];

/// IV_ProviderDR
Property IVProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IV_ProviderDR ];

/// IV_TypeDR
Property IVTypeDR As User.DHCEQCInvoiceType [ SqlColumnNumber = 7, SqlFieldName = IV_TypeDR ];

/// IV_Customer
Property IVCustomer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IV_Customer ];

/// IV_InvoiceDept
Property IVInvoiceDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IV_InvoiceDept ];

/// IV_PayedAmountFee
Property IVPayedAmountFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = IV_PayedAmountFee ];

/// IV_Status
Property IVStatus As %Library.String(DISPLAYLIST = ",新增,帐物审核,提交", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 11, SqlFieldName = IV_Status ];

/// IV_SubmitUserDR
Property IVSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IV_SubmitUserDR ];

/// IV_SubmitDate
Property IVSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = IV_SubmitDate ];

/// IV_SubmitTime
Property IVSubmitTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = IV_SubmitTime ];

/// IV_Remark
Property IVRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IV_Remark ];

/// IV_CertificateDR
Property IVCertificateDR As User.DHCEQCertificate [ SqlColumnNumber = 16, SqlFieldName = IV_CertificateDR ];

/// IV_InvolidFlag
Property IVInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = IV_InvalidFlag ];

/// IV_Hold1
Property IVHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IV_Hold1 ];

/// IV_Hold2
Property IVHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IV_Hold2 ];

/// IV_Hold3
Property IVHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IV_Hold3 ];

/// IV_Hold4
Property IVHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IV_Hold4 ];

/// IV_Hold5
Property IVHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IV_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInvoice("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IV_AmountFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IV_CertificateDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IV_Customer">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IV_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IV_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IV_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IV_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IV_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IV_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IV_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IV_InvoiceDept">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IV_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IV_PayedAmountFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IV_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IV_Remark">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IV_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IV_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IV_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IV_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IV_TypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQInvoice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvoiceNo">
<Global>^DHCEQInvoice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvoiceNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IV_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusProvider">
<Global>^DHCEQInvoice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusProvider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IV_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IV_ProviderDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubmitUser">
<Global>^DHCEQInvoice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubmitUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IV_SubmitUserDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInvoiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
