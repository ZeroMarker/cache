Class web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaLevel Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_AnaesthesiaLevel";

Parameter XMLIGNAMEINVALIDTAG = 1;

Parameter XMLIGNAMENULL = 1;

/// 代码
Property CTALCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAL_Code");

/// 代码表类型
Property CTALCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAL_CodesystemCode");

/// 描述
Property CTALDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAL_Desc");

/// 备注
Property CTALRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAL_Remarks");

/// 最后更新人编码
Property CTALUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAL_UpdateUserCode");

/// 最后更新日期
Property CTALUpdateDate As %Library.String(XMLNAME = "CTAL_UpdateDate");

/// 最后更新时间
Property CTALUpdateTime As %Library.String(XMLNAME = "CTAL_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTALCreatDate As %Library.String(XMLNAME = "CTAL_CreatDate");

/// 创建时间
Property CTALCreatTime As %Library.String(XMLNAME = "CTAL_CreatTime");

/// 原代码
Property CTALOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAL_OriginalCode");

/// 原描述
Property CTALOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAL_OriginalDesc");

/// 有效开始日期
Property CTALStartDate As %Library.String(XMLNAME = "CTAL_StartDate");

/// 有效结束日期
Property CTALEndDate As %Library.String(XMLNAME = "CTAL_EndDate");

/// 医院编号
Property CTALHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAL_HosCode");

/// 状态（1启用0停用-1删除）
Property CTALStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAL_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
