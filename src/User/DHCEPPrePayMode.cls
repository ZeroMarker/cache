Class User.DHCEPPrePayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EPDPM_RowID, SqlTableName = DHC_EPPrePayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EPDPMSub [ IdKey, PrimaryKey, Unique ];

/// EPDPM_EPMD_Parref Parent Reference
Relationship EPDPMEPMDParref As User.DHCEPPreDeposit [ Cardinality = parent, Inverse = ChildDHCEPPrePayMode, Required, SqlFieldName = EPDPM_EPMD_Parref ];

/// EPDPM_Sub 
Property EPDPMSub As %Library.Float [ InitialExpression = {$i(^DHCEPM("EPM",+$p($s($d(p1):p1,1:%d(0)),$c(1)),"EPMD",$p($p($p($s($d(p1):p1,1:%d(0)),$c(1)),$c(1)),"||",2),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = EPDPM_Sub ];

/// EPDPM_PayMode_DR
Property EPDPMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = EPDPM_PayMode_DR ];

/// EPDPM_Card_DR
Property EPDPMCardDR As User.ARCBankCardType [ SqlColumnNumber = 4, SqlFieldName = EPDPM_Card_DR ];

/// EPDPM_CardChequeNo
Property EPDPMCardChequeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EPDPM_CardChequeNo ];

/// EPDPM_CMBank_DR
Property EPDPMCMBankDR As User.CMCBankMas [ SqlColumnNumber = 6, SqlFieldName = EPDPM_CMBank_DR ];

/// EPDPM_Unit
Property EPDPMUnit As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EPDPM_Unit ];

/// EPDPM_Amt
Property EPDPMAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = EPDPM_Amt ];

/// EPDPM_ChequeDate
Property EPDPMChequeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = EPDPM_ChequeDate ];

/// EPDPM_Date
Property EPDPMDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = EPDPM_Date ];

/// EPDPM_Time
Property EPDPMTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = EPDPM_Time ];

/// EPDPM_Remark
Property EPDPMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EPDPM_Remark ];

/// EPDPM_PayAccNO
Property EPDPMPayAccNO As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EPDPM_PayAccNO ];

/// EPDPM_ETP_DR 第三方支付交易表指针
Property EPDPMETPDR As User.DHCBillExtTradePay [ SqlColumnNumber = 14, SqlFieldName = EPDPM_ETP_DR ];

/// EPDPM_Note3
Property EPDPMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EPDPM_Note3 ];

/// EPDPM_Note4
Property EPDPMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EPDPM_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EPDPM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPDPM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPDPM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPDPM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPDPM_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPDPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPDPM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EPDPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EPDPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EPDPM_PayAccNO">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EPDPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPDPM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EPDPM_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EPDPM_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_EPPreDeposit.EPMD_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>EPDPM_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPMD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPPreDeposit.EPMD_Sub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{EPDPM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEPPrePayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
