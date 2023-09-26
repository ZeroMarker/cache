/// 过敏源字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAllergySource Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_AllergySource";

/// 代码
Property CTASCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_Code");

/// 代码表类型
Property CTASCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_CodesystemCode");

/// 描述
Property CTASDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAS_Desc");

/// 备注
Property CTASRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAS_Remarks");

/// 最后更新日期
Property CTASUpdateDate As %Library.Date(XMLNAME = "CTAS_UpdateDate");

/// 最后更新时间
Property CTASUpdateTime As %Library.Time(XMLNAME = "CTAS_UpdateTime");

/// 最后更新人编码
Property CTASUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_UpdateUserCode");

/// 创建日期
Property CTASCreatDate As %Library.Date(XMLNAME = "CTAS_CreatDate");

/// 创建时间
Property CTASCreatTime As %Library.Time(XMLNAME = "CTAS_CreatTime");

/// 原代码
Property CTASOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_OriginalCode");

/// 原描述
Property CTASOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAS_OriginalDesc");

/// 有效开始日期
Property CTASStartDate As %Library.Date(XMLNAME = "CTAS_StartDate");

/// 有效结束日期
Property CTASEndDate As %Library.Date(XMLNAME = "CTAS_EndDate");

/// 医院代码
Property CTASHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAS_HosCode");

/// 状态
Property CTASStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAS_Status");

/// 过敏类别
Property CTASType As %Library.String(MAXLEN = 2, XMLNAME = "CTAS_Type");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
