/// 名称: User.DHCINVPRTZYPayMode.cls
/// 描述: 住院发票支付方式表
/// 编写者: ZhYW
/// 编写日期: 2022-12-21
/// 产品组：计费医保组
Class User.DHCINVPRTZYPayMode Extends (%Persistent, User.Abstract) [ SqlRowIdName = IPM_RowId, SqlTableName = DHC_INVPRTZYPayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IPMSub [ IdKey, PrimaryKey, Unique ];

Relationship IPMPRTParRef As User.DHCINVPRTZY [ Cardinality = parent, Inverse = ChildINVPRTZYPayMode, Required, SqlFieldName = IPM_PRT_ParRef ];

Property IPMSub As %Float [ InitialExpression = {$i(^DHCINVPRTZY($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"P",0))}, SqlColumnNumber = 2, SqlFieldName = IPM_Sub ];

Property IPMPayModeDR As User.CTPayMode(CAPTION = "支付方式ID") [ Required, SqlColumnNumber = 3, SqlFieldName = IPM_PayMode_DR ];

Property IPMBankDR As User.CMCBankMas(CAPTION = "银行ID") [ SqlColumnNumber = 4, SqlFieldName = IPM_Bank_DR ];

Property IPMAmt As %Float(CAPTION = "金额") [ SqlColumnNumber = 5, SqlFieldName = IPM_Amt ];

Property IPMCardChequeNo As %String(CAPTION = "卡号/支票号", COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IPM_CardChequeNo ];

Property IPMBankCardTypeDR As User.ARCBankCardType(CAPTION = "银行卡类型ID") [ SqlColumnNumber = 7, SqlFieldName = IPM_BankCardType_DR ];

Property IPMPayAccNo As %String(CAPTION = "账户号", COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IPM_PayAccNo ];

Property IPMChequeDate As %Date(CAPTION = "支票日期", FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = IPM_ChequeDate ];

Property IPMUnitDR As User.CTHealthCareProvider(CAPTION = "公费单位ID") [ SqlColumnNumber = 10, SqlFieldName = IPM_Unit_DR ];

Property IPMInsuFlag As %String(CAPTION = "是否医保支付方式标识", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = IPM_InsuFlag ];

Property IPMTransFlag As %String(CAPTION = "转账标识", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = IPM_TransFlag ];

Property IPMETPDR As User.DHCBillExtTradePay(CAPTION = "第三方支付订单表ID") [ SqlColumnNumber = 13, SqlFieldName = IPM_ETP_DR ];

Property IPMOptUserDR As User.SSUser(CAPTION = "创建人ID") [ SqlColumnNumber = 14, SqlFieldName = IPM_OptUser_DR ];

Property IPMOptDate As %Date(CAPTION = "创建日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 15, SqlFieldName = IPM_OptDate ];

Property IPMOptTime As %Time(CAPTION = "创建时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 16, SqlFieldName = IPM_OptTime ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="IPM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPM_BankCardType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPM_Bank_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPM_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPM_InsuFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPM_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPM_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPM_OptUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPM_PayAccNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPM_TransFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPM_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINVPRTZY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTZY.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVPRTZY.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPMDR">
<Global>^DHCINVPRTZYi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_INVPRTZY.PRT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>IPM_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_INVPRTZY.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPM_PayMode_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnitDR">
<Global>^DHCINVPRTZYi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INVPRTZY.PRT_Rowid</Field>
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
<Expression>{DHC_INVPRTZY.PRT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPM_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTZYPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
