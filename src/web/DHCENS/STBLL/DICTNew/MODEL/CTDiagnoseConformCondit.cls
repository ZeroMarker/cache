/// 诊断符合情况[病案]字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnoseConformCondit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DiagnoseConformCondit";

/// 代码
Property CTDCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCC_Code");

/// 代码表类型
Property CTDCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCC_CodesystemCode");

/// 描述
Property CTDCCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDCC_Desc");

/// 备注
Property CTDCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDCC_Remarks");

/// 最后更新日期
Property CTDCCUpdateDate As %Library.Date(XMLNAME = "CTDCC_UpdateDate");

/// 最后更新时间
Property CTDCCUpdateTime As %Library.Time(XMLNAME = "CTDCC_UpdateTime");

/// 最后更新人编码
Property CTDCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCC_UpdateUserCode");

/// 创建日期
Property CTDCCCreatDate As %Library.Date(XMLNAME = "CTDCC_CreatDate");

/// 创建时间
Property CTDCCCreatTime As %Library.Time(XMLNAME = "CTDCC_CreatTime");

/// 原代码
Property CTDCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCC_OriginalCode");

/// 原描述
Property CTDCCOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDCC_OriginalDesc");

/// 有效开始日期
Property CTDCCStartDate As %Library.Date(XMLNAME = "CTDCC_StartDate");

/// 有效结束日期
Property CTDCCEndDate As %Library.Date(XMLNAME = "CTDCC_EndDate");

/// 医院代码
Property CTDCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCC_HosCode");

/// 状态
Property CTDCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
