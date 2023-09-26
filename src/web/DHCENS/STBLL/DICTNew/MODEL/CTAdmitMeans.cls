/// 入院途径字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitMeans Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_AdmitMeans";

/// 代码
Property CTAMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_Code");

/// 代码表类型
Property CTAMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_CodesystemCode");

/// 描述
Property CTAMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAM_Desc");

/// 备注
Property CTAMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAM_Remarks");

/// 最后更新日期
Property CTAMUpdateDate As %Library.Date(XMLNAME = "CTAM_UpdateDate");

/// 最后更新时间
Property CTAMUpdateTime As %Library.Time(XMLNAME = "CTAM_UpdateTime");

/// 最后更新人编码
Property CTAMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_UpdateUserCode");

/// 创建日期
Property CTAMCreatDate As %Library.Date(XMLNAME = "CTAM_CreatDate");

/// 创建时间
Property CTAMCreatTime As %Library.Time(XMLNAME = "CTAM_CreatTime");

/// 原代码
Property CTAMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_OriginalCode");

/// 原描述
Property CTAMOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAM_OriginalDesc");

/// 有效开始日期
Property CTAMStartDate As %Library.Date(XMLNAME = "CTAM_StartDate");

/// 有效结束日期
Property CTAMEndDate As %Library.Date(XMLNAME = "CTAM_EndDate");

/// 医院代码
Property CTAMHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_HosCode");

/// 状态
Property CTAMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAM_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
