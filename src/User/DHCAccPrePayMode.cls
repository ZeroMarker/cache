Class User.DHCAccPrePayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APPM_RowID, SqlTableName = DHC_AccPrePayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APPMSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccPreDeposit Parent Reference
Relationship APPMAccPDParRef As User.DHCAccPreDeposit [ Cardinality = parent, Inverse = ChildDHCAccPrePayMode, Required, SqlFieldName = APPM_AccPD_ParRef ];

/// APPM_Sub 
Property APPMSub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",+$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AccPD",$p($p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),$c(1)),"||",2),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = APPM_Sub ];

/// APPM_PayMode_DR
Property APPMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = APPM_PayMode_DR ];

/// APPM_Card_DR
Property APPMCardDR As User.ARCBankCardType [ SqlColumnNumber = 4, SqlFieldName = APPM_Card_DR ];

/// APPM_CardChequeNo
Property APPMCardChequeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = APPM_CardChequeNo ];

/// APPM_CMBank_DR
Property APPMCMBankDR As User.CMCBankMas [ SqlColumnNumber = 6, SqlFieldName = APPM_CMBank_DR ];

/// APPM_Unit
Property APPMUnit As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = APPM_Unit ];

/// APPM_Amt
Property APPMAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = APPM_Amt ];

/// APPM_PayAccNO
Property APPMPayAccNO As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = APPM_PayAccNO ];

/// APPM_ChequeDate
Property APPMChequeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = APPM_ChequeDate ];

/// APPM_Date
Property APPMDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = APPM_Date ];

/// APPM_Time
Property APPMTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = APPM_Time ];

/// APPM_AccPayInv_DR 集中打印发票医保分解时存集中打印的的id
Property APPMAccPayInvDR As User.DHCAccPayINV [ SqlColumnNumber = 13, SqlFieldName = APPM_AccPayInv_DR ];

/// APPMETPDR 第三方支付交易表指针
Property APPMETPDR As User.DHCBillExtTradePay [ SqlColumnNumber = 14, SqlFieldName = APPM_ETP_DR ];

/// APPM_Note2
Property APPMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = APPM_Note2 ];

/// APPM_Note3
Property APPMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = APPM_Note3 ];

/// APPM_Note4
Property APPMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = APPM_Note4 ];

/// APPM_Note5
Property APPMNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = APPM_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APPM_AccPayInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APPM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPM_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APPM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APPM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="APPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="APPM_Note5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="APPM_PayAccNO">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPM_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APPM_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_AccPreDeposit.AccPD_Sub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AccPD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_AccPreDeposit.AccPD_Sub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{APPM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPrePayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
