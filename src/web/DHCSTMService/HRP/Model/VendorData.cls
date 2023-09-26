Class web.DHCSTMService.HRP.Model.VendorData Extends XmlCommon
{

Parameter XMLNAME = "VendorData";

Property HospitalCode As %Library.String(MAXLEN = "", XMLNAME = "HospitalCode");

/// 代码
Property VendorCode As %Library.String(MAXLEN = "", XMLNAME = "VendorCode");

/// 名称
Property VendorDesc As %Library.String(MAXLEN = "", XMLNAME = "VendorDesc");

/// 是否使用
Property VendorUseFlag As %Library.String(MAXLEN = "", XMLNAME = "VendorUseFlag");

/// 助记码
Property VendorAlias As %Library.String(MAXLEN = "", XMLNAME = "VendorAlias");

/// 法人(联系人)
Property VendorCorporation As %Library.String(MAXLEN = "", XMLNAME = "VendorCorporation");

/// 法人身份证
Property VendorPresident As %Library.String(MAXLEN = "", XMLNAME = "VendorPresident");

/// 法人联系电话
Property VendorPreTel As %Library.String(MAXLEN = "", XMLNAME = "VendorPreTel");

/// 账户
Property VendorAcct As %Library.String(MAXLEN = "", XMLNAME = "VendorAcct");

/// 开户银行
Property VendorBank As %Library.String(MAXLEN = "", XMLNAME = "VendorBank");

/// 注册资金
Property VendorCrAvail As %Library.String(MAXLEN = "", XMLNAME = "VendorCrAvail");

/// 合同截止日期
Property VendorlstPoDate As %Date;

/// 供应商地址
Property VendorAdd As %Library.String(MAXLEN = "", XMLNAME = "VendorAdd");

/// 供应商电话
Property VendorTel As %Library.String(MAXLEN = "", XMLNAME = "VendorTel");

/// 传真
Property VendorFax As %Library.String(MAXLEN = "", XMLNAME = "VendorFax");

/// 供应商简称
Property VendorAbbrev As %Library.String(MAXLEN = "", XMLNAME = "VendorAbbrev");

}
