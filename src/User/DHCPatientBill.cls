/// DHC Patient Bill Master
Class User.DHCPatientBill Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PB_RowId, SqlTableName = DHC_PatientBill, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPatBillOrder As User.DHCPatBillOrder [ Cardinality = children, Inverse = PBOPBParRef ];

/// PA_Adm Reference
Property PBAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PB_Adm_Dr ];

/// Patient Admission Date
Property PBAdmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PB_AdmDate ];

/// Patient Discharge Date
Property PBDisChargeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PB_DisChargeDate ];

/// Patient Insurance Reference
Property PBPatInsTypeDR As User.PACAdmReason [ SqlColumnNumber = 5, SqlFieldName = PB_PatInsType_DR ];

/// Patient Episode SubCategory
Property PBPatAdmTypeDR As User.PACEpisodeSubType [ SqlColumnNumber = 6, SqlFieldName = PB_PatAdmType_DR ];

/// Bill Start Date
Property PBDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PB_DateFrom ];

/// Bill End Date
Property PBDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PB_DateTo ];

/// Bill Total Amount
Property PBTotalAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PB_TotalAmount ];

/// Bill Discount Amount
Property PBDiscAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PB_DiscAmount ];

/// Discount Type
Property PBDiscType As %Library.String(DISPLAYLIST = ",Patient,Item", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",P,I") [ SqlColumnNumber = 11, SqlFieldName = PB_DiscType ];

/// Insurance Share
Property PBPayorShare As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PB_PayorShare ];

/// Patient Share
Property PBPatientShare As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PB_PatientShare ];

/// Paid Amount
Property PBAmountPaid As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PB_AmountPaid ];

/// Should Pay Amount
Property PBAmountToPay As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = PB_AmountToPay ];

/// Bill Type
Property PBBillType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PB_BillType ];

/// PB_PayedFlag
Property PBPayedFlag As %Library.String(DISPLAYLIST = ",Bill,Paid", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",B,P") [ SqlColumnNumber = 17, SqlFieldName = PB_PayedFlag ];

/// Refund Flag
Property PBRefundFlag As %Library.String(DISPLAYLIST = ",Refund,BeRefund", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",R,B") [ SqlColumnNumber = 18, SqlFieldName = PB_RefundFlag ];

/// Reference to Self
Property PBOriginalBillDR As User.DHCPatientBill [ SqlColumnNumber = 19, SqlFieldName = PB_OriginalBill_DR ];

/// Update Date
Property PBUpdateDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 20, SqlFieldName = PB_UpdateDate ];

/// Update Time
Property PBUpdateTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 21, SqlFieldName = PB_UpdateTime ];

/// Update User
Property PBUpdateUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = PB_UpdateUser ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PB_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PB_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PB_AmountPaid">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PB_AmountToPay">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PB_BillType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PB_DisChargeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PB_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PB_DiscType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PB_OriginalBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PB_PatAdmType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PB_PatInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PB_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PB_PayedFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PB_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PB_RefundFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PB_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PB_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCPB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXBillType">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_BillType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXInsDate">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"iINSDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_PatInsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXPAAdm">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXPayedFlag">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PayedFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_PayedFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXUpdateDate">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAdmDate">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PB_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPatientBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
