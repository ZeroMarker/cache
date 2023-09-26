/// ABO血型字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTABOBloodType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ABOBloodType";

/// 代码
Property CTABOBTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTABOBT_Code");

/// 代码表类型
Property CTABOBTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTABOBT_CodesystemCode");

/// 描述
Property CTABOBTDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTABOBT_Desc");

/// 备注
Property CTABOBTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTABOBT_Remarks");

/// 最后更新日期
Property CTABOBTUpdateDate As %Library.Date(XMLNAME = "CTABOBT_UpdateDate");

/// 最后更新时间
Property CTABOBTUpdateTime As %Library.Time(XMLNAME = "CTABOBT_UpdateTime");

/// 最后更新人编码
Property CTABOBTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTABOBT_UpdateUserCode");

/// 创建日期
Property CTABOBTCreatDate As %Library.Date(XMLNAME = "CTABOBT_CreatDate");

/// 创建时间
Property CTABOBTCreatTime As %Library.Time(XMLNAME = "CTABOBT_CreatTime");

/// 原代码
Property CTABOBTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTABOBT_OriginalCode");

/// 原描述
Property CTABOBTOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTABOBT_OriginalDesc");

/// 有效开始日期
Property CTABOBTStartDate As %Library.Date(XMLNAME = "CTABOBT_StartDate");

/// 有效结束日期
Property CTABOBTEndDate As %Library.Date(XMLNAME = "CTABOBT_EndDate");

/// 医院代码
Property CTABOBTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTABOBT_HosCode");

/// 状态
Property CTABOBTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTABOBT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
