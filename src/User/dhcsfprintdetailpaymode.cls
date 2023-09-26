/// 名称: User.dhcsfprintdetailpaymode.cls
/// 描述: 住院押金支付方式表
/// 编写者: ZhYW
/// 编写日期: 2022-12-19
/// 产品组：计费医保组
Class User.dhcsfprintdetailpaymode Extends (%Persistent, User.Abstract) [ SqlRowIdName = dpm_rowid, SqlTableName = dhc_sfprintdetailpaymode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On dpmsub [ IdKey, PrimaryKey, Unique ];

Relationship dpmprtparref As User.dhcsfprintdetail [ Cardinality = parent, Inverse = childsfprintdetailpaymode, Required, SqlFieldName = dpm_prt_parref ];

Property dpmsub As %Float [ InitialExpression = {$i(^DHCSFPRINTDETAIL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"P",0))}, SqlColumnNumber = 2, SqlFieldName = dpm_sub ];

Property dpmpaymodedr As User.CTPayMode(CAPTION = "支付方式ID") [ Required, SqlColumnNumber = 3, SqlFieldName = dpm_paymode_dr ];

Property dpmbankdr As User.CMCBankMas(CAPTION = "银行ID") [ SqlColumnNumber = 4, SqlFieldName = dpm_bank_dr ];

Property dpmamt As %Float(CAPTION = "金额") [ SqlColumnNumber = 5, SqlFieldName = dpm_amt ];

Property dpmcardchequeno As %String(CAPTION = "卡号/支票号", COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = dpm_cardchequeno ];

Property dpmbankcardtypedr As User.ARCBankCardType(CAPTION = "银行卡类型ID") [ SqlColumnNumber = 7, SqlFieldName = dpm_bankcardtype_dr ];

Property dpmpayaccno As %String(CAPTION = "账户号", COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = dpm_payaccno ];

Property dpmchequedate As %Date(CAPTION = "支票日期", FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = dpm_chequedate ];

Property dpmunitdr As User.CTHealthCareProvider(CAPTION = "公费单位ID") [ SqlColumnNumber = 10, SqlFieldName = dpm_unit_dr ];

Property dpmetpdr As User.DHCBillExtTradePay(CAPTION = "第三方支付订单表ID") [ SqlColumnNumber = 11, SqlFieldName = dpm_etp_dr ];

Property dpmoptuserdr As User.SSUser(CAPTION = "创建人ID") [ SqlColumnNumber = 12, SqlFieldName = dpm_optuser_dr ];

Property dpmoptdate As %Date(CAPTION = "创建日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = dpm_optdate ];

Property dpmopttime As %Time(CAPTION = "创建时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = dpm_opttime ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="dpm_amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="dpm_bank_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="dpm_bankcardtype_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="dpm_cardchequeno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="dpm_chequedate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="dpm_etp_dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="dpm_optdate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="dpm_opttime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="dpm_optuser_dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="dpm_payaccno">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="dpm_paymode_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="dpm_unit_dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCSFPRINTDETAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>dhc_sfprintdetail.prt_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>dpm_sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{dhc_sfprintdetail.prt_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{dpm_sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChequeNo">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>dhc_sfprintdetail.prt_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>dpm_sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{dpm_cardchequeno}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{dhc_sfprintdetail.prt_rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{dpm_sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPMDR">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>dhc_sfprintdetail.prt_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>dpm_sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{dhc_sfprintdetail.prt_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{dpm_paymode_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{dpm_sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.dhcsfprintdetailpaymodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
