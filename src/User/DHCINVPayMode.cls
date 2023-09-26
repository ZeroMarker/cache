Class User.DHCINVPayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPM_RowID, SqlTableName = DHC_INVPayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IPMSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRT Parent Reference
Relationship IPMPRTParRef As User.DHCINVPRT [ Cardinality = parent, Inverse = ChildDHCINVPayMode, Required, SqlFieldName = IPM_PRT_ParRef ];

/// IPM_Sub
Property IPMSub As %Float [ InitialExpression = {$i(^DHCINVPRT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = IPM_Sub ];

/// IPM_PayMode_DR
Property IPMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = IPM_PayMode_DR ];

/// IPM_CMBank_DR
Property IPMCMBankDR As User.CMCBankMas [ SqlColumnNumber = 4, SqlFieldName = IPM_CMBank_DR ];

/// IPM_Amt
Property IPMAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = IPM_Amt ];

/// IPM_CardChequeNo
Property IPMCardChequeNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPM_CardChequeNo ];

/// IPM_Card_DR
Property IPMCardDR As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IPM_Card_DR ];

/// IPM_Date
Property IPMDate As %Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IPM_Date ];

/// IPM_Time
Property IPMTime As %Time [ SqlColumnNumber = 9, SqlFieldName = IPM_Time ];

/// IPM_AccPL_DR
Property IPMAccPLDR As User.DHCAccPayList [ SqlColumnNumber = 10, SqlFieldName = IPM_AccPL_DR ];

/// IPM_Unit_DR 合同单位
Property IPMUnitDR As User.CTHealthCareProvider [ SqlColumnNumber = 11, SqlFieldName = IPM_Unit_DR ];

/// IPM_PayAccNO
Property IPMPayAccNO As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IPM_PayAccNO ];

/// IPM_ChequeDate
Property IPMChequeDate As %Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = IPM_ChequeDate ];

/// IPM_Note3 自费支付方式标志，1:自费，空:医保支付
Property IPMNote3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IPM_Note3 ];

/// IPM_Note4 商业保险单位指针--陈曦在杭州美华用
Property IPMNote4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IPM_Note4 ];

/// IPM_EPayL_DR 留观押金支付表指针
Property IPMEPayLDR As User.DHCEPPayList [ SqlColumnNumber = 16, SqlFieldName = IPM_EPayL_DR ];

///  IPMETPDR 第三方支付交易表指针
Property IPMETPDR As User.DHCBillExtTradePay [ SqlColumnNumber = 17, SqlFieldName = IPM_ETP_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IPM_AccPL_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPM_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPM_EPayL_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPM_PayAccNO">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPM_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPM_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCINVPRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IPM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccPLDR">
<Global>^DHCINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AccPLDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IPM_AccPL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPM_Sub</Field>
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
<Expression>{IPM_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEPayLDR">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EPayLDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPM_EPayL_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPMDR">
<Global>^DHCINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PMDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IPM_PayMode_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDR">
<Global>^DHCINVPRTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRT.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UnitDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPM_Unit_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INVPRT.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
