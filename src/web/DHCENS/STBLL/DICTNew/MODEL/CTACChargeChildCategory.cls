Class web.DHCENS.STBLL.DICTNew.MODEL.CTACChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ACChargeChildCategory";

/// 会计大类代码
Property CTACCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCCC_ParentCode");

/// 会计子类代码
Property CTACCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCCC_Code");

/// 会计子类名称
Property CTACCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTACCCC_Desc");

/// 代码表类型
Property CTACCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCCC_CodesystemCode");

/// 备注
Property CTACCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTACCCC_Remarks");

/// 最后更新人代码
Property CTACCCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCCC_UpdateUserCode");

/// 最后更新日期
Property CTACCCCUpdateDate As %Library.Date(XMLNAME = "CTACCCC_UpdateDate");

/// 最后更新时间
Property CTACCCCUpdateTime As %Library.Time(XMLNAME = "CTACCCC_UpdateTime");

/// 创建日期
Property CTACCCCCreatDate As %Library.Date(XMLNAME = "CTACCCC_CreatDate");

/// 创建时间
Property CTACCCCCreatTime As %Library.Time(XMLNAME = "CTACCCC_CreatTime");

/// 原代码
Property CTACCCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACCCC_OriginalCode");

/// 原描述
Property CTACCCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTACCCC_OriginalDesc");

/// 有效开始日期
Property CTACCCCStartDate As %Library.Date(XMLNAME = "CTACCCC_StartDate");

/// 有效结束日期
Property CTACCCCEndDate As %Library.Date(XMLNAME = "CTACCCC_EndDate");

/// 医院代码
Property CTACCCCHosCode As %Library.String(XMLNAME = "CTACCCC_HosCode");

/// 状态
Property CTACCCCStatus As %Library.String(XMLNAME = "CTACCCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
