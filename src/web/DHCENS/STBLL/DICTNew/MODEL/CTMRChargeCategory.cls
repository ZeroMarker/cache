Class web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_MRChargeCategory";

/// 病案大类代码
Property CTMRCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_Code");

/// 病案大类描述
Property CTMRCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCC_Desc");

/// 代码表类型
Property CTMRCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_CodesystemCode");

/// 备注
Property CTMRCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCC_Remarks");

/// 最后更新日期
Property CTMRCCUpdateDate As %Library.Date(XMLNAME = "CTMRCC_UpdateDate");

/// 最后更新时间
Property CTMRCCUpdateTime As %Library.Time(XMLNAME = "CTMRCC_UpdateTime");

/// 最后更新人
Property CTMRCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_UpdateUserCode");

/// 创建日期
Property CTMRCCCreatDate As %Library.Date(XMLNAME = "CTMRCC_CreatDate");

/// 创建时间
Property CTMRCCCreatTime As %Library.Time(XMLNAME = "CTMRCC_CreatTime");

/// 原代码
Property CTMRCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_OriginalCode");

/// 原描述
Property CTMRCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCC_OriginalDesc");

/// 有效开始日期
Property CTMRCCStartDate As %Library.Date(XMLNAME = "CTMRCC_StartDate");

/// 有效开始日期
Property CTMRCCEndDate As %Library.Date(XMLNAME = "CTMRCC_EndDate");

/// 医院代码
Property CTMRCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_HosCode");

/// 状态
Property CTMRCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTMRCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
