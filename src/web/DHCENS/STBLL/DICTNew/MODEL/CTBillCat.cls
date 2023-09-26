Class web.DHCENS.STBLL.DICTNew.MODEL.CTBillCat Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_BillCat";

/// 账单大类代码
Property CTBCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBC_Code");

/// 账单大类描述
Property CTBCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTBC_Desc");

/// 代码表类型
Property CTBCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBC_CodesystemCode");

/// 最后更新人编码
Property CTBCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBC_UpdateUserCode");

/// 最后更新日期
Property CTBCUpdateDate As %Library.Date(XMLNAME = "CTBC_UpdateDate");

/// 最后更新时间
Property CTBCUpdateTime As %Library.Time(XMLNAME = "CTBC_UpdateTime");

/// 备注
Property CTBCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTBC_Remarks");

/// 有效开始日期
Property CTBCStartDate As %Library.String(XMLNAME = "CTBC_StartDate");

/// 有效结束日期
Property CTBCEndDate As %Library.String(XMLNAME = "CTBC_EndDate");

/// 医院代码
Property CTBCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBC_HosCode");

/// 状态
Property CTBCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTBC_Status");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTBCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBC_OriginalCode");

/// 原描述
Property CTBCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBC_OriginalDesc");

/// 创建日期
Property CTBCCreatDate As %Library.Date(XMLNAME = "CTBC_CreatDate");

/// 创建时间
Property CTBCCreatTime As %Library.Time(XMLNAME = "CTBC_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
