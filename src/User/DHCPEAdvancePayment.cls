Class User.DHCPEAdvancePayment Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_PE_AdvancePayment, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAdvancePayment";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEAPAmountChange As User.DHCPEAPAmountChange [ Cardinality = children, Inverse = APACParRef ];

Relationship ChildDHCPEAPStatusChange As User.DHCPEAPStatusChange [ Cardinality = children, Inverse = APSCParRef ];

/// AP_RegNo
Property APRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AP_RegNo ];

/// AP_CardNo
Property APCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AP_CardNo ];

/// AP_Type
Property APType As %Library.String(DISPLAYLIST = ",Relation,Independent,OrderRebate,CashCard", MAXLEN = 11, SELECTIVITY = "20.00000%", TRUNCATE = 1, VALUELIST = ",R,I,O,C") [ SqlColumnNumber = 4, SqlFieldName = AP_Type ];

/// AP_Amount
Property APAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AP_Amount ];

/// AP_Status
Property APStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AP_Status ];

/// AP_UpdateDate
Property APUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = AP_UpdateDate ];

/// AP_UpdateTime
Property APUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = AP_UpdateTime ];

/// AP_UpdateUser_DR
Property APUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AP_UpdateUser_DR ];

/// AP_Remark
Property APRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AP_Remark ];

/// AP_Password
Property APPassWord As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AP_PassWord ];

/// AP_1
Property AP1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AP_1 ];

/// Ap_2
Property Ap2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Ap_2 ];

/// AP_Hospital_DR  院区
Property APHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AP_Hospital_DR ];

/// AP_EndLineDate
Property APEndLineDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 15, SqlFieldName = AP_EndLineDate ];

/// AP_Rebate
Property APRebate As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = AP_Rebate ];

/// AP_Tel
Property APTel As %Library.String [ SqlColumnNumber = 17, SqlFieldName = AP_Tel ];

/// AP_IDCard
Property APIDCard As %Library.String [ SqlColumnNumber = 18, SqlFieldName = AP_IDCard ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEAP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_EndLineDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_IDCard">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AP_PassWord">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_Rebate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_Tel">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AP_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Ap_2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPEAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCardNo">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_CardNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCardType">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CardType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegNo">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RegNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_RegNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAdvancePaymentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
