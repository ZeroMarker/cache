Class web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategoryNew Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_MRChargeCategoryNew";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTMRCCNCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCN_Code");

/// 代码表类型
Property CTMRCCNCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCN_CodesystemCode");

/// 名称
Property CTMRCCNDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTMRCCN_Desc");

/// 备注
Property CTMRCCNRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTMRCCN_Remarks");

/// 状态
Property CTMRCCNStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTMRCCN_Status");

/// 最后更新日期
Property CTMRCCNUpdateDate As %Library.Date(XMLNAME = "CTMRCCN_UpdateDate");

/// 最后更新时间
Property CTMRCCNUpdateTime As %Library.Time(XMLNAME = "CTMRCCN_UpdateTime");

/// 最后更新人编码
Property CTMRCCNUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCN_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTMRCCNCreatDate As %Library.Date(XMLNAME = "CTMRCCN_CreatDate");

/// 创建时间
Property CTMRCCNCreatTime As %Library.Time(XMLNAME = "CTMRCCN_CreatTime");

/// 原代码
Property CTMRCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCC_OriginalCode");

/// 原描述
Property CTMRCCNOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTMRCCN_OriginalDesc");

/// 有效开始日期
Property CTMRCCNStartDate As %Library.Date(XMLNAME = "CTMRCCN_StartDate");

/// 有效结束日期
Property CTMRCCNEndDate As %Library.Date(XMLNAME = "CTMRCCN_EndDate");

/// 医院代码
Property CTMRCCNHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTMRCCN_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
