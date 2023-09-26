/// 离院方式
Class web.DHCENS.STBLL.DICTNew.MODEL.CTDischMeans Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DischMeans";

/// 代码
Property CTDMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDM_Code");

/// 代码表类型
Property CTDMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDM_CodesystemCode");

/// 描述
Property CTDMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDM_Desc");

/// 备注
Property CTDMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDM_Remarks");

/// 最后更新日期
Property CTDMUpdateDate As %Library.Date(XMLNAME = "CTDM_UpdateDate");

/// 最后更新时间
Property CTDMUpdateTime As %Library.Time(XMLNAME = "CTDM_UpdateTime");

/// 最后更新人编码
Property CTDMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDM_UpdateUserCode");

/// 创建日期
Property CTDMCreatDate As %Library.Date(XMLNAME = "CTDM_CreatDate");

/// 创建时间
Property CTDMCreatTime As %Library.Time(XMLNAME = "CTDM_CreatTime");

/// 原代码
Property CTDMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDM_OriginalCode");

/// 原描述
Property CTDMOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDM_OriginalDesc");

/// 有效开始日期
Property CTDMStartDate As %Library.Date(XMLNAME = "CTDM_StartDate");

/// 有效结束日期
Property CTDMEndDate As %Library.Date(XMLNAME = "CTDM_EndDate");

/// 医院代码
Property CTDMHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDM_HosCode");

/// 状态
Property CTDMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDM_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
