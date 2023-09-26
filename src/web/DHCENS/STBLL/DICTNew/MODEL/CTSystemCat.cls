Class web.DHCENS.STBLL.DICTNew.MODEL.CTSystemCat Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_SystemCat";

/// 代码
Property CTSCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSC_Code");

/// 代码表类型
Property CTSCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSC_CodesystemCode");

/// 描述
Property CTSCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSC_Desc");

/// 备注
Property CTSCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSC_Remarks");

/// 最后更新日期
Property CTSCUpdateDate As %Library.Date(XMLNAME = "CTSC_UpdateDate");

/// 最后更新时间
Property CTSCUpdateTime As %Library.Time(XMLNAME = "CTSC_UpdateTime");

/// 最后更新人编码
Property CTSCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSC_UpdateUserCode");

/// 创建日期
Property CTSCCreatDate As %Library.Date(XMLNAME = "CTSC_CreatDate");

/// 创建时间
Property CTSCCreatTime As %Library.Time(XMLNAME = "CTSC_CreatTime");

/// 原代码
Property CTSCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSC_OriginalCode");

/// 原描述
Property CTSCOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSC_OriginalDesc");

/// 有效开始日期
Property CTSCStartDate As %Library.Date(XMLNAME = "CTSC_StartDate");

/// 有效结束日期
Property CTSCEndDate As %Library.Date(XMLNAME = "CTSC_EndDate");

/// 医院代码
Property CTSCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSC_HosCode");

/// 状态
Property CTSCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSC_Status");

}
