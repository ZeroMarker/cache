/// 收费项大类字典
Class web.DHCENS.STBLL.DICTNew.MODEL.CTChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ChargeCategory";

/// 代码
Property CTCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Code");

/// 代码表类型
Property CTCCCodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_CodesystemCode");

/// 描述
Property CTCCDesc As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Desc");

/// 最后更新日期
Property CTCCUpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_UpdateDate");

/// 最后更新时间
Property CTCCUpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_UpdateTime");

/// 最后更新人代码
Property CTCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_UpdateUserCode");

/// 原代码
Property CTCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_OriginalCode");

/// 原描述
Property CTCCOriginalDesc As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_OriginalDesc");

/// 有效开始日期
Property CTCCStartDate As %Library.Date(XMLNAME = "CTCC_StartDate");

/// 有效结束日期
Property CTCCEndDate As %Library.Date(XMLNAME = "CTCC_EndDate");

/// 医院代码
Property CTCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_HosCode");

/// 状态
Property CTCCStatus As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Status");

/// 状态
Property CTCCRemarks As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Remarks");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
