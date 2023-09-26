Class web.DHCENS.STBLL.DICTNew.MODEL.CTCustomer Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_Code");

/// 代码表类型
Property CTCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CodesystemCode");

/// 名称
Property CTCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTC_Desc");

/// 别名
Property CTCAlias As %Library.String(MAXLEN = 50, XMLNAME = "CTC_Alias");

/// 拼音码
Property CTCSpell As %Library.String(MAXLEN = 50, XMLNAME = "CTC_Spell");

/// 详细描述
Property CTCDetailedIntro As %Library.String(MAXLEN = 5000, XMLNAME = "CTC_DetailedIntro");

/// 类型
Property CTCType As %Library.String(MAXLEN = 50, XMLNAME = "CTC_Type");

/// 供应商代码
Property CTCVendorCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_VendorCode");

/// 国家代码
Property CTCCountryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CountryCode");

/// 备注
Property CTCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Remarks");

/// 状态
Property CTCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTC_Status");

/// 邮箱
Property CTCEmail As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Email");

/// 传真
Property CTCFax As %Library.String(MAXLEN = 20, XMLNAME = "CTC_Fax");

/// 网站
Property CTCOfficalNetwork As %Library.String(MAXLEN = 200, XMLNAME = "CTC_OfficalNetwork");

/// 法人代表
Property CTCLawPerson As %Library.String(MAXLEN = 100, XMLNAME = "CTC_LawPerson");

/// 成立日期
Property CTCEstablishDate As %Library.Date(XMLNAME = "CTC_EstablishDate");

/// 注册地址
Property CTCRegisteredAddress As %Library.String(MAXLEN = 200, XMLNAME = "CTC_RegisteredAddress");

/// 注册资本（万元）
Property CTCRegisteredCapital As %Library.String(MAXLEN = 100, XMLNAME = "CTC_RegisteredCapital");

/// 开户银行
Property CTCBankName As %Library.String(MAXLEN = 100, XMLNAME = "CTC_BankName");

/// 开户账号
Property CTCBankAccount As %Library.String(MAXLEN = 20, XMLNAME = "CTC_BankAccount");

/// 负责人
Property CTCPersonInCharge As %Library.String(MAXLEN = 100, XMLNAME = "CTC_PersonInCharge");

/// 最后更新日期
Property CTCUpdateDate As %Library.Date(XMLNAME = "CTC_UpdateDate");

/// 最后更新时间
Property CTCUpdateTime As %Library.Time(XMLNAME = "CTC_UpdateTime");

/// 最后更新人编码
Property CTCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_UpdateUserCode");

/// 创建日期
Property CTCCreatDate As %Library.Date(XMLNAME = "CTC_CreatDate");

/// 创建时间
Property CTCCreatTime As %Library.Time(XMLNAME = "CTC_CreatTime");

/// 原代码
Property CTCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_OriginalCode");

/// 原描述
Property CTCOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTC_OriginalDesc");

/// 有效开始日期
Property CTCStartDate As %Library.Date(XMLNAME = "CTC_StartDate");

/// 有效结束日期
Property CTCEndDate As %Library.Time(XMLNAME = "CTC_EndDate");

/// 医院代码
Property CTCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_HosCode");

/// 统一社会信用代码
Property CTCUniSocialCreditCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_UniSocialCreditCode");

/// 员工数
Property CTCEmployeesNum As %Library.String(MAXLEN = 50, XMLNAME = "CTC_EmployeesNum");

/// 公司电话
Property CTCTelphone As %Library.String(MAXLEN = 20, XMLNAME = "CTC_Telphone");

/// 股票代码
Property CTCStockCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_StockCode");

/// 上级客户ID
Property CTCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_ParentCode");

/// 公司地址
Property CTCAddress As %Library.String(MAXLEN = 200, XMLNAME = "CTC_Address");

/// 联系人1
Property CTCContact1 As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Contact1");

/// 联系电话1
Property CTCContactTelephone1 As %Library.String(MAXLEN = 20, XMLNAME = "CTC_ContactTelephone1");

/// 联系地址1
Property CTCContactAddress1 As %Library.String(MAXLEN = 200, XMLNAME = "CTC_ContactAddress1");

/// 联系人2
Property CTCContact2 As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Contact2");

/// 联系电话2
Property CTCTelephone2 As %Library.String(MAXLEN = 20, XMLNAME = "CTC_Telephone2");

/// 联系地址2
Property CTCContactAddress2 As %Library.String(MAXLEN = 200, XMLNAME = "CTC_ContactAddress2");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Customer";

}
