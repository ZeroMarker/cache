/// 治疗结果[病案]字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTTreatmentResult Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_TreatmentResult";

/// 代码
Property CTTRCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTR_Code");

/// 代码表类型
Property CTTRCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTR_CodesystemCode");

/// 描述
Property CTTRDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTTR_Desc");

/// 备注
Property CTTRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTTR_Remarks");

/// 最后更新日期
Property CTTRUpdateDate As %Library.Date(XMLNAME = "CTTR_UpdateDate");

/// 最后更新时间
Property CTTRUpdateTime As %Library.Time(XMLNAME = "CTTR_UpdateTime");

/// 最后更新人编码
Property CTTRUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTR_UpdateUserCode");

/// 创建日期
Property CTTRCreatDate As %Library.Date(XMLNAME = "CTTR_CreatDate");

/// 创建时间
Property CTTRCreatTime As %Library.Time(XMLNAME = "CTTR_CreatTime");

/// 原代码
Property CTTROriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTR_OriginalCode");

/// 原描述
Property CTTROriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTTR_OriginalDesc");

/// 有效开始日期
Property CTTRStartDate As %Library.Date(XMLNAME = "CTTR_StartDate");

/// 有效结束日期
Property CTTREndDate As %Library.Date(XMLNAME = "CTTR_EndDate");

/// 医院代码
Property CTTRHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTTR_HosCode");

/// 状态
Property CTTRStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTTR_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
