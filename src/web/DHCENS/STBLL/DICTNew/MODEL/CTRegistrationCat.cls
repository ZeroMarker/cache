/// 挂号号别字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTRegistrationCat Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_RegistrationCat";

/// 代码
Property CTRCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRC_Code");

/// 代码表类型
Property CTRCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRC_CodesystemCode");

/// 描述
Property CTRCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTRC_Desc");

/// 备注
Property CTRCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRC_Remarks");

/// 最后更新日期
Property CTRCUpdateDate As %Library.Date(XMLNAME = "CTRC_UpdateDate");

/// 最后更新时间
Property CTRCUpdateTime As %Library.Time(XMLNAME = "CTRC_UpdateTime");

/// 最后更新人编码
Property CTRCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRC_UpdateUserCode");

/// 创建日期
Property CTRCCreatDate As %Library.Date(XMLNAME = "CTRC_CreatDate");

/// 创建时间
Property CTRCCreatTime As %Library.Time(XMLNAME = "CTRC_CreatTime");

/// 原代码
Property CTRCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRC_OriginalCode");

/// 原描述
Property CTRCOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTRC_OriginalDesc");

/// 有效开始日期
Property CTRCStartDate As %Library.Date(XMLNAME = "CTRC_StartDate");

/// 有效结束日期
Property CTRCEndDate As %Library.Date(XMLNAME = "CTRC_EndDate");

/// 医院代码
Property CTRCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRC_HosCode");

/// 状态
Property CTRCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
