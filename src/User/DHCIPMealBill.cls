Class User.DHCIPMealBill Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMB_RowID, SqlTableName = DHC_IPMealBill, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCIPMealBillDetail As User.DHCIPMealBillDetail [ Cardinality = children, Inverse = DHCMBDDHCMBParref ];

/// DHCMB_Adm_Dr
Property DHCMBAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCMB_Adm_Dr ];

/// DHCMB_DateFrom
Property DHCMBDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCMB_DateFrom ];

/// DHCMB_DateTo
Property DHCMBDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCMB_DateTo ];

/// DHCMB_TotalAmount
Property DHCMBTotalAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCMB_TotalAmount ];

/// DHCMB_UpdateDate
Property DHCMBUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCMB_UpdateDate ];

/// DHCMB_UpdateTime
Property DHCMBUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCMB_UpdateTime ];

/// DHCMB_UpdateUser_Dr
Property DHCMBUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCMB_UpdateUser_Dr ];

/// DHCMB_PaidFlag
Property DHCMBPaidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DHCMB_PaidFlag ];

/// DHCMB_Origianal_Dr
Property DHCMBOrigianalDr As User.DHCIPMealBill [ SqlColumnNumber = 10, SqlFieldName = DHCMB_Origianal_Dr ];

/// DHCMB_RefundFlag
Property DHCMBRefundFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCMB_RefundFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIPMEALBILL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCMB_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMB_Origianal_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMB_PaidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMB_RefundFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMB_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMB_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCIPMEALBILL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMB_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaidFlag">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PaidFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMB_PaidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMB_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
