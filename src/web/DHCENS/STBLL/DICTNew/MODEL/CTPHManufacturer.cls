Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHManufacturer Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_SCManufacturer";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTSCMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCM_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCM_CodesystemCode");

/// 描述
Property CTSCMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCM_Desc");

/// 备注
Property CTSCMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCM_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSCMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCM_Status");

/// 最后更新日期
Property CTSCMUpdateDate As %Library.Date(XMLNAME = "CTSCM_UpdateDate");

/// 最后更新时间
Property CTSCMUpdateTime As %Library.Time(XMLNAME = "CTSCM_UpdateTime");

/// 最后更新人编码
Property CTSCMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCM_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTSCMCreatDate As %Library.Date(XMLNAME = "CTSCM_CreatDate");

/// 创建时间
Property CTSCMCreatTime As %Library.Time(XMLNAME = "CTSCM_CreatTime");

/// 原代码
Property CTSCMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCM_OriginalCode");

/// 原描述
Property CTSCMOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCM_OriginalDesc");

/// 有效开始日期
Property CTSCMStartDate As %Library.String(XMLNAME = "CTSCM_StartDate");

/// 有效结束日期
Property CTSCMEndDate As %Library.String(XMLNAME = "CTSCM_EndDate");

/// 医院代码
Property CTSCMHosCode As %Library.String(XMLNAME = "CTSCM_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
