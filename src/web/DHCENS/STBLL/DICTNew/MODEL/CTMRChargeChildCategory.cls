Class web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_MRChargeChildCategory";

/// 病案大类代码
Property CTMRCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCC_ParentCode");

/// 病案子类代码
Property CTMRCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCC_Code");

/// 病案子类描述
Property CTMRCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCC_Desc");

/// 代码表类型
Property CTMRCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCC_CodesystemCode");

/// 最后更新人代码
Property CTMRCCCUpdateUserCode As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCC_UpdateUserCode");

/// 最后更新日期
Property CTMRCCCUpdateDate As %Library.Date(XMLNAME = "CTMRCCC_UpdateDate");

/// 最后更新时间
Property CTMRCCCUpdateTime As %Library.Time(XMLNAME = "CTMRCCC_UpdateTime");

/// 创建日期
Property CTMRCCCCreatDate As %Library.Date(XMLNAME = "CTMRCCC_CreatDate");

/// 创建时间
Property CTMRCCCCreatTime As %Library.Time(XMLNAME = "CTMRCCC_CreatTime");

/// 原代码
Property CTMRCCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCC_OriginalCode");

/// 原描述
Property CTMRCCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCC_OriginalDesc");

/// 有效开始日期
Property CTMRCCCStartDate As %Library.Date(XMLNAME = "CTMRCCC_StartDate");

/// 有效结束日期
Property CTMRCCCEndDate As %Library.Date(XMLNAME = "CTMRCCC_EndDate");

/// 医院代码
Property CTMRCCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCC_HosCode");

/// 状态
Property CTMRCCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTMRCCC_Status");

/// 备注
Property CTMRCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCC_Remarks");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
