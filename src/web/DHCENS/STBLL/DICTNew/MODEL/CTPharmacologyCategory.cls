Class web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_PHCCategory";

/// 代码
Property CTPHCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCC_Code");

/// 代码表类型
Property CTPHCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCC_CodesystemCode");

/// 描述
Property CTPHCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCC_Desc");

/// 备注
Property CTPHCCRemarks As %Library.String(MAXLEN = 1000, XMLNAME = "CTPHCC_Remarks");

/// 状态
Property CTPHCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHCC_Status");

/// 最后更新日期
Property CTPHCCUpdateDate As %Library.Date(XMLNAME = "CTPHCC_UpdateDate");

/// 最后更新时间
Property CTPHCCUpdateTime As %Library.Time(XMLNAME = "CTPHCC_UpdateTime");

/// 最后更新人编码
Property CTPHCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCC_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTPHCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCC_OriginalCode");

/// 原描述
Property CTPHCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCC_OriginalDesc");

/// 有效开始日期
Property CTPHCCStartDate As %Library.Date(XMLNAME = "CTPHCC_StartDate");

/// 有效结束日期
Property CTPHCCEndDate As %Library.Date(XMLNAME = "CTPHCC_EndDate");

/// 创建日期
Property CTPHCCCreatDate As %Library.Date(XMLNAME = "CTPHCC_CreatDate");

/// 创建时间
Property CTHCreatTime As %Library.Time(XMLNAME = "CTH_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
