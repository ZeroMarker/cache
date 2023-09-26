/// 入院病情-病案
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitConditOfMedicalRcd Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_AdmitConditOfMedicalRcd";

/// 代码
Property CTACOMRCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACOMR_Code");

/// 代码表类型
Property CTACOMRCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACOMR_CodesystemCode");

/// 描述
Property CTACOMRDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTACOMR_Desc");

/// 备注
Property CTACOMRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTACOMR_Remarks");

/// 最后更新日期
Property CTACOMRUpdateDate As %Library.Date(XMLNAME = "CTACOMR_UpdateDate");

/// 最后更新时间
Property CTACOMRUpdateTime As %Library.Time(XMLNAME = "CTACOMR_UpdateTime");

/// 最后更新人编码
Property CTACOMRUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACOMR_UpdateUserCode");

/// 创建日期
Property CTACOMRCreatDate As %Library.Date(XMLNAME = "CTACOMR_CreatDate");

/// 创建时间
Property CTACOMRCreatTime As %Library.Time(XMLNAME = "CTACOMR_CreatTime");

/// 原代码
Property CTACOMROriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACOMR_OriginalCode");

/// 原描述
Property CTACOMROriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTACOMR_OriginalDesc");

/// 有效开始日期
Property CTACOMRStartDate As %Library.Date(XMLNAME = "CTACOMR_StartDate");

/// 有效结束日期
Property CTACOMREndDate As %Library.Date(XMLNAME = "CTACOMR_EndDate");

/// 医院代码
Property CTACOMRHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTACOMR_HosCode");

/// 状态
Property CTACOMRStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTACOMR_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
