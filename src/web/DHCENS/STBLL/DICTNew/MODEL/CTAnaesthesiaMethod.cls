/// 麻醉方式
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaMethod Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_AnaesthesiaMethod";

Parameter XMLIGNAMEINVALIDTAG = 1;

Parameter XMLIGNAMENULL = 1;

/// 代码
Property CTAMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_Code");

/// 代码表类型
Property CTAMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_CodesystemCode");

/// 描述
Property CTAMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAM_Desc");

/// 备注
Property CTAMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAM_Remarks");

/// 最后更新人编码
Property CTAMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_UpdateUserCode");

/// 最后更新日期
Property CTAMUpdateDate As %Library.String(XMLNAME = "CTAM_UpdateDate");

/// 最后更新时间
Property CTAMUpdateTime As %Library.String(XMLNAME = "CTAM_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTAMCreatDate As %Library.String(XMLNAME = "CTAM_CreatDate");

/// 创建时间
Property CTAMCreatTime As %Library.String(XMLNAME = "CTAM_CreatTime");

/// 原代码
Property CTAMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_OriginalCode");

/// 原描述
Property CTAMOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAM_OriginalDesc");

/// 有效开始日期
Property CTAMStartDate As %Library.String(XMLNAME = "CTAM_StartDate");

/// 有效结束日期
Property CTAMEndDate As %Library.String(XMLNAME = "CTAM_EndDate");

/// 医院编号
Property CTAMHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAM_HosCode");

/// 状态（1启用0停用-1删除）
Property CTAMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAM_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
