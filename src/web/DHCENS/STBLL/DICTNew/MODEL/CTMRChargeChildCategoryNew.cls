Class web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategoryNew Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_MRChargeChildCategoryNew";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 病案大类代码
Property CTMRCCCNParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCCN_ParentCode");

/// 代码
Property CTMRCCCNCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCCN_Code");

/// 代码表类型
Property CTMRCCCNCodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCCN_CodesystemCode");

/// 名称
Property CTMRCCCNDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTMRCCCN_Desc");

/// 备注
Property CTMRCCCNRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCCN_Remarks");

/// 状态
Property CTMRCCCNStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTMRCCCN_Status");

/// 最后更新日期
Property CTMRCCCNUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTMRCCCN_UpdateDate");

/// 最后更新时间
Property CTMRCCCNUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTMRCCCN_UpdateTime");

/// 最后更新人编码
Property CTMRCCCNUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCCN_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTMRCCCNCreatDate As %Library.Date(XMLNAME = "CTMRCCCN_CreatDate");

/// 创建时间
Property CTMRCCCNCreatTime As %Library.Time(XMLNAME = "CTMRCCCN_CreatTime");

/// 原代码
Property CTMRCCCNOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCCN_OriginalCode");

/// 原描述
Property CTMRCCCNOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTMRCCCN_OriginalDesc");

/// 有效开始日期
Property CTMRCCCNStartDate As %Library.Date(XMLNAME = "CTMRCCCN_StartDate");

/// 有效结束日期
Property CTMRCCCNEndDate As %Library.Date(XMLNAME = "CTMRCCCN_EndDate");

/// 医院代码
Property CTMRCCCNHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCCN_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
