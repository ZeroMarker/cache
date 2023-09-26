/// 账单子类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTBillChildCat Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_BillChildCat";

/// 账单子类代码
Property CTBCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBCC_Code");

/// 账单子类描述
Property CTBCCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTBCC_Desc");

/// 账单大类代码
Property CTBCCBillCategory As %Library.String(MAXLEN = 128, XMLNAME = "CTBCC_BillCategory");

/// 代码表类型
Property CTBCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBCC_CodesystemCode");

/// 最后更新人编码
Property CTBCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBCC_UpdateUserCode");

/// 备注
Property CTBCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTBCC_Remarks");

/// 有效开始日期
Property CTBCCStartDate As %Library.String(XMLNAME = "CTBCC_StartDate");

/// 状态
Property CTBCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTBCC_Status");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTBCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBCC_OriginalCode");

/// 原描述
Property CTBCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBCC_OriginalDesc");

/// 创建日期
Property CTBCCCreatDate As %Library.Date(XMLNAME = "CTBCC_CreatDate");

/// 创建时间
Property CTBCCCreatTime As %Library.Time(XMLNAME = "CTBCC_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
