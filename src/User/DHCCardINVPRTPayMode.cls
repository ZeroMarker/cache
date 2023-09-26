Class User.DHCCardINVPRTPayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CPM_RowID, SqlTableName = DHC_CardINVPRTPayMode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CPMSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CardINVPRT Parent Reference
Relationship CPMCIPParRef As User.DHCCardINVPRT [ Cardinality = parent, Inverse = ChildDHCCardINVPRTPayMode, Required, SqlFieldName = CPM_CIP_ParRef ];

/// CPM_Sub
Property CPMSub As %Library.Float [ InitialExpression = {$i(^DHCCARDINVPRT($p($s($d(initvalue):initvalue,1:+%d(0)),$c(1)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = CPM_Sub ];

/// CPM_PayMode_DR
Property CPMPayModeDR As %Library.String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPM_PayMode_DR ];

/// CPM_CMBank_DR
Property CPMCMBankDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPM_CMBank_DR ];

/// CPM_Amt
Property CPMAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CPM_Amt ];

/// CPM_CardChequeNo
Property CPMCardChequeNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CPM_CardChequeNo ];

/// CPM_Card_DR
Property CPMCardDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CPM_Card_DR ];

/// CPM_Date
Property CPMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = CPM_Date ];

/// CPM_Time
Property CPMTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CPM_Time ];

/// CPM_Unit
Property CPMUnit As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CPM_Unit ];

/// CPM_AccPayNO
Property CPMAccPayNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CPM_AccPayNO ];

/// CPM_ETP_DR 2022-09-29 ZhYW 第三方支付交易表指针
Property CPMETPDR As User.DHCBillExtTradePay [ SqlColumnNumber = 12, SqlFieldName = CPM_ETP_DR ];

/// CPM_Note2
Property CPMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CPM_Note2 ];

/// CPM_Note3
Property CPMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CPM_Note3 ];

/// CPM_Note4
Property CPMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CPM_Note4 ];

/// CPM_Note5
Property CPMNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CPM_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CPM_AccPayNO">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CPM_Note5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPM_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPM_Unit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCARDINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CardINVPRT.CIP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CPM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_CardINVPRT.CIP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CPM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCardINVPRTPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
