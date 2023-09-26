Class web.DHCENS.STBLL.DICTNew.MODEL.CTACChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ACChargeCategory";

/// 会计大类代码
Property CTACCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCC_Code");

/// 会计大类名称
Property CTACCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTACCC_Desc");

/// 代码表类型
Property CTACCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCC_CodesystemCode");

/// 备注
Property CTACCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTACCC_Remarks");

/// 最后更新日期
Property CTACCCUpdateDate As %Library.Date(XMLNAME = "CTACCC_UpdateDate");

/// 最后更新时间
Property CTACCCUpdateTime As %Library.Time(XMLNAME = "CTACCC_UpdateTime");

/// 最后更新人
Property CTACCCUpdateUserCode As %Library.String(XMLNAME = "CTACCC_UpdateUserCode");

/// 创建日期
Property CTACCCCreatDate As %Library.Date(XMLNAME = "CTACCC_CreatDate");

/// 创建时间
Property CTACCCCreatTime As %Library.Time(XMLNAME = "CTACCC_CreatTime");

/// 原代码
Property CTACCCOriginalCode As %Library.String(XMLNAME = "CTACCC_OriginalCode");

/// 原描述
Property CTACCCOriginalDesc As %Library.String(XMLNAME = "CTACCC_OriginalDesc");

/// 有效开始日期
Property CTACCCStartDate As %Library.Date(XMLNAME = "CTACCC_StartDate");

/// 有效结束日期
Property CTACCCEndDate As %Library.Date(XMLNAME = "CTACCC_EndDate");

/// 医院代码
Property CTACCCHosCode As %Library.String(XMLNAME = "CTACCC_HosCode");

/// 状态代码
Property CTACCCStatus As %Library.String(XMLNAME = "CTACCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
