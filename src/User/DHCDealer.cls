Class User.DHCDealer Extends (%Persistent, User.Abstract) [ SqlRowIdName = DL_RowId, SqlTableName = DHC_Dealer ]
{

/// 公司
Property DLCoCodeDR As CTCompany [ SqlColumnNumber = 2, SqlFieldName = DL_CoCode_DR ];

/// 代码
Property DLCode As %String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = DL_Code ];

/// 名称
Property DLName As %String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = DL_Name ];

/// 地址
Property DLAddr As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DL_Addr, SqlListType = SUBNODE ];

/// 城市
Property DLCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = DL_City_DR ];

/// Des Ref to CTSTT
Property DLStateDR As CTState [ SqlColumnNumber = 7, SqlFieldName = DL_State_DR ];

/// 邮编
Property DLZipDR As CTZip [ SqlColumnNumber = 8, SqlFieldName = DL_Zip_DR ];

/// 电话
Property DLTel As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DL_Tel ];

/// 银行
Property DLContPerson As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DL_ContPerson ];

/// 账户
Property DLCtrlAcctDR As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DL_CtrlAcct_DR ];

/// 信贷限额采购额
Property DLCrLimit As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 12, SqlFieldName = DL_CrLimit ];

/// 贴现率
Property DLDiscRate As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 13, SqlFieldName = DL_DiscRate ];

/// 折扣天
Property DLDiscDays As %Float(MAXVAL = 999, MINVAL = 1) [ SqlColumnNumber = 14, SqlFieldName = DL_DiscDays ];

/// Credit Terms
Property DLCrTerm As %Float(MAXVAL = 9999, MINVAL = 1) [ SqlColumnNumber = 15, SqlFieldName = DL_CrTerm ];

/// 分类
Property DLCategoryDR As APCVendCat [ SqlColumnNumber = 16, SqlFieldName = DL_Category_DR ];

/// 注册资金
Property DLCrAvail As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 17, SqlFieldName = DL_CrAvail ];

/// 前一月
Property DLPrevBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 18, SqlFieldName = DL_PrevBal ];

/// 当前月
Property DLCurBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 19, SqlFieldName = DL_CurBal ];

/// 下一月
Property DLFwdBal As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 20, SqlFieldName = DL_FwdBal ];

/// 合同截止日期
Property DLLstPoDate As %Date [ SqlColumnNumber = 21, SqlFieldName = DL_LstPoDate ];

/// 最后支付日期
Property DLLstPayDate As %Date [ SqlColumnNumber = 22, SqlFieldName = DL_LstPayDate ];

/// 最后发票日期
Property DLLstInvDate As %Date [ SqlColumnNumber = 23, SqlFieldName = DL_LstInvDate ];

/// Des Ref to GLCCC
Property DLCostCentDR As GLCCC [ SqlColumnNumber = 24, SqlFieldName = DL_CostCent_DR ];

/// Des Ref to GLCAC
Property DLAcctCodeDR As GLCAcct [ SqlColumnNumber = 25, SqlFieldName = DL_AcctCode_DR ];

/// 存档标志
Property DLRcFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DL_RcFlag ];

/// 简称
Property DLShName As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlComputeCode = { s {DL_ShName}=$e({DL_Name},1,22)
}, SqlComputed, SqlFieldName = DL_ShName, Transient ];

/// 传真
Property DLFax As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = DL_Fax ];

/// 等级
Property DLGrading As %String(COLLATION = "Exact", DISPLAYLIST = ",Good,Bad,Average", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",G,B,A") [ SqlColumnNumber = 29, SqlFieldName = DL_Grading ];

/// 法人
Property DLPresident As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DL_President ];

/// 三证合一证号
Property DLRegistration As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DL_Registration ];

/// 状态A使用 S停用
Property DLStatus As %String(COLLATION = "Exact", DISPLAYLIST = ",Active,Suspended", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",A,S") [ SqlColumnNumber = 32, SqlFieldName = DL_Status ];

/// 信用条件
Property DLCreditTermDR As INCCreditTerms [ SqlColumnNumber = 33, SqlFieldName = DL_CreditTerm_DR ];

/// 最后业务日期
Property DLLstBsDate As %Date [ SqlColumnNumber = 34, SqlFieldName = DL_LstBsDate ];

/// 账期
Property DLAccountPeriod As %Float(MAXVAL = 999999999999, MINVAL = 1) [ SqlColumnNumber = 35, SqlFieldName = DL_AccountPeriod ];

/// 法人身份证的效期
Property DLPresidentIDDate As %Date [ SqlColumnNumber = 36, SqlFieldName = DL_PresidentIDDate ];

/// 云平台供应商ID
Property DLCloudID As %String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 37, SqlFieldName = DL_CloudID ];

/// 省采购平台代码
Property DLProPurPCode As %String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 38, SqlFieldName = DL_ProPurPCode ];

/// 供应商
Property DLVendorDr As User.APCVendor [ SqlColumnNumber = 39, SqlFieldName = DL_Vendor_DR ];

/// 上级经销商
Property DLParDealerDr As User.DHCDealer [ SqlColumnNumber = 40, SqlFieldName = DL_ParDealer_DR ];

/// 简称
Property DLAbbrev As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DL_Abbrev ];

/// 邮箱
Property DLEmail As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = DL_Email ];

/// 供应商条码编码前缀
Property DLBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = DL_BarCode ];

/// 短信催货标志
Property DLExpdtBySms As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = DL_ExpdtBySms ];

/// 平台催货标志
Property DLExpdtByPurchPlat As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = DL_ExpdtByPurchPlat ];

/// 备注
Property DLRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = DL_Remarks ];

/// 别名
Property DLAlias As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = DL_Alias ];

/// 医院
Property DLHospitalDR As User.CTHospital [ SqlColumnNumber = 48, SqlFieldName = DL_Hospital_DR ];

/// 开户行许可证核准号
Property DLBankLicApprovalNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = DL_BankLicApprovalNo ];

/// 开户行许可证编号
Property DLBankLicNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = DL_BankLicNo ];

/// 营业期限
Property DLBusinessTerm As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 51, SqlFieldName = DL_BusinessTerm ];

/// 成立日期
Property DLEstablishedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = DL_EstablishedDate ];

/// 公司更名标志
Property DLCoRenameFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = DL_CoRenameFlag ];

/// 转配送标志
Property DLCarryFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = DL_CarryFlag ];

/// 负责人
Property DLResponsiblePerson As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = DL_ResponsiblePerson ];

/// 质量管理人
Property DLQualityManager As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = DL_QualityManager ];

/// 仓库地址
Property DLDepotAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = DL_DepotAddress ];

/// 备案凭证
Property DLFilingVoucher As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = DL_FilingVoucher ];

/// 经营范围(选择官方分类)
Property DLMatCatOfficialDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = DL_MatCatOfficial_DR ];

/// 付款汇总标志(标志为Y才进行付款)
Property DLPayStatFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = DL_PayStatFlag ];

/// 合同编号
Property DLContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 61, SqlFieldName = DL_ContractNo ];

/// 网下标识 (线下交易标识，区分网上交易)
Property DLOfflineTradingFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = DL_OfflineTradingFlag ];

/// 工商执照注册地址
Property DLRegAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = DL_RegAddress ];

Index Code On DLCode As Exact;

Index Desc On DLName As Exact;

Storage Default
{
<Data name="DHCDealerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLCoCodeDR</Value>
</Value>
<Value name="3">
<Value>DLCode</Value>
</Value>
<Value name="4">
<Value>DLName</Value>
</Value>
<Value name="5">
<Value>DLAddr</Value>
</Value>
<Value name="6">
<Value>DLCityDR</Value>
</Value>
<Value name="7">
<Value>DLStateDR</Value>
</Value>
<Value name="8">
<Value>DLZipDR</Value>
</Value>
<Value name="9">
<Value>DLTel</Value>
</Value>
<Value name="10">
<Value>DLContPerson</Value>
</Value>
<Value name="11">
<Value>DLCtrlAcctDR</Value>
</Value>
<Value name="12">
<Value>DLCrLimit</Value>
</Value>
<Value name="13">
<Value>DLDiscRate</Value>
</Value>
<Value name="14">
<Value>DLDiscDays</Value>
</Value>
<Value name="15">
<Value>DLCrTerm</Value>
</Value>
<Value name="16">
<Value>DLCategoryDR</Value>
</Value>
<Value name="17">
<Value>DLCrAvail</Value>
</Value>
<Value name="18">
<Value>DLPrevBal</Value>
</Value>
<Value name="19">
<Value>DLCurBal</Value>
</Value>
<Value name="20">
<Value>DLFwdBal</Value>
</Value>
<Value name="21">
<Value>DLLstPoDate</Value>
</Value>
<Value name="22">
<Value>DLLstPayDate</Value>
</Value>
<Value name="23">
<Value>DLLstInvDate</Value>
</Value>
<Value name="24">
<Value>DLCostCentDR</Value>
</Value>
<Value name="25">
<Value>DLAcctCodeDR</Value>
</Value>
<Value name="26">
<Value>DLRcFlag</Value>
</Value>
<Value name="27">
<Value>DLShName</Value>
</Value>
<Value name="28">
<Value>DLFax</Value>
</Value>
<Value name="29">
<Value>DLGrading</Value>
</Value>
<Value name="30">
<Value>DLPresident</Value>
</Value>
<Value name="31">
<Value>DLRegistration</Value>
</Value>
<Value name="32">
<Value>DLStatus</Value>
</Value>
<Value name="33">
<Value>DLCreditTermDR</Value>
</Value>
<Value name="34">
<Value>DLLstBsDate</Value>
</Value>
<Value name="35">
<Value>DLAccountPeriod</Value>
</Value>
<Value name="36">
<Value>DLPresidentIDDate</Value>
</Value>
<Value name="37">
<Value>DLCloudID</Value>
</Value>
<Value name="38">
<Value>DLProPurPCode</Value>
</Value>
<Value name="39">
<Value>DLVendorDr</Value>
</Value>
<Value name="40">
<Value>DLParDealerDr</Value>
</Value>
<Value name="41">
<Value>DLAbbrev</Value>
</Value>
<Value name="42">
<Value>DLEmail</Value>
</Value>
<Value name="43">
<Value>DLBarCode</Value>
</Value>
<Value name="44">
<Value>DLExpdtBySms</Value>
</Value>
<Value name="45">
<Value>DLExpdtByPurchPlat</Value>
</Value>
<Value name="46">
<Value>DLRemarks</Value>
</Value>
<Value name="47">
<Value>DLAlias</Value>
</Value>
<Value name="48">
<Value>DLHospitalDR</Value>
</Value>
<Value name="49">
<Value>DLBankLicApprovalNo</Value>
</Value>
<Value name="50">
<Value>DLBankLicNo</Value>
</Value>
<Value name="51">
<Value>DLBusinessTerm</Value>
</Value>
<Value name="52">
<Value>DLEstablishedDate</Value>
</Value>
<Value name="53">
<Value>DLCoRenameFlag</Value>
</Value>
<Value name="54">
<Value>DLCarryFlag</Value>
</Value>
<Value name="55">
<Value>DLResponsiblePerson</Value>
</Value>
<Value name="56">
<Value>DLQualityManager</Value>
</Value>
<Value name="57">
<Value>DLDepotAddress</Value>
</Value>
<Value name="58">
<Value>DLFilingVoucher</Value>
</Value>
<Value name="59">
<Value>DLMatCatOfficialDR</Value>
</Value>
<Value name="60">
<Value>DLPayStatFlag</Value>
</Value>
<Value name="61">
<Value>DLContractNo</Value>
</Value>
<Value name="62">
<Value>DLOfflineTradingFlag</Value>
</Value>
<Value name="63">
<Value>DLRegAddress</Value>
</Value>
</Data>
<DataLocation>^User.DHCDealerD</DataLocation>
<DefaultData>DHCDealerDefaultData</DefaultData>
<IdLocation>^User.DHCDealerD</IdLocation>
<IndexLocation>^User.DHCDealerI</IndexLocation>
<StreamLocation>^User.DHCDealerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
