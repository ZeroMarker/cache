/// 支付方式
Class web.DHCENS.STBLL.DICTNew.MODEL.CTPayMode Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PayMode";

/// 代码
Property CTPMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPM_Code");

/// 代码表类型
Property CTPMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPM_CodesystemCode");

/// 描述
Property CTPMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPM_Desc");

/// 备注
Property CTPMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPM_Remarks");

/// 最后更新日期
Property CTPMUpdateDate As %Library.Date(XMLNAME = "CTPM_UpdateDate");

/// 最后更新时间
Property CTPMUpdateTime As %Library.Time(XMLNAME = "CTPM_UpdateTime");

/// 最后更新人编码
Property CTPMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPM_UpdateUserCode");

/// 创建日期
Property CTPMCreatDate As %Library.Date(XMLNAME = "CTPM_CreatDate");

/// 创建时间
Property CTPMCreatTime As %Library.Time(XMLNAME = "CTPM_CreatTime");

/// 原代码
Property CTPMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPM_OriginalCode");

/// 原描述
Property CTPMOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPM_OriginalDesc");

/// 有效开始日期
Property CTPMStartDate As %Library.Date(XMLNAME = "CTPM_StartDate");

/// 有效结束日期
Property CTPMEndDate As %Library.Date(XMLNAME = "CTPM_EndDate");

/// 医院代码
Property CTPMHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPM_HosCode");

/// 状态
Property CTPMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPM_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
