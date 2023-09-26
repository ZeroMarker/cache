/// 核算大类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTEMChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_EMChargeCategory";

/// 核算大类代码
Property CTEMCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCC_Code");

/// 代码表类型
Property CTEMCCCodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_CodesystemCode");

/// 核算大类名称
Property CTEMCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_Desc");

/// 备注
Property CTEMCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_Remarks");

/// 最后更新日期
Property CTEMCCUpdateDate As %Library.Date(XMLNAME = "CTEMCC_UpdateDate");

/// 最后更新时间
Property CTEMCCUpdateTime As %Library.Time(XMLNAME = "CTEMCC_UpdateTime");

/// 最后更新人代码
Property CTEMCCUpdateUserCode As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_UpdateUserCode");

/// 创建日期
Property CTEMCCCreateDate As %Library.Date(XMLNAME = "CTEMCC_CreateDate");

/// 创建时间
Property CTEMCCCreateTime As %Library.Time(XMLNAME = "CTEMCC_CreateTime");

/// 源代码
Property CTEMCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCC_OriginalCode");

/// 原描述
Property CTEMCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_OriginalDesc");

/// 有效开始日期
Property CTEMCCStartDate As %Library.Date(XMLNAME = "CTEMCC_startDate");

/// 有效结束日期
Property CTEMCCEndDate As %Library.Date(XMLNAME = "CTEMCC_EndDate");

/// 医院代码
Property CTEMCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCC_HosCode");

/// 状态
Property CTEMCCStatus As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
