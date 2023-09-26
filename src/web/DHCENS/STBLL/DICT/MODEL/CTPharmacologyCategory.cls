Class web.DHCENS.STBLL.DICT.MODEL.CTPharmacologyCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_PharmacologyCategory";

/// 代码
Property CTCCode As %Library.String(MAXLEN = 20, XMLNAME = "CTC_Code");

/// 代码表类型
Property CTCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CodesystemCode");

/// 描述
Property CTCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Desc");

/// 备注
Property CTCRemarks As %Library.String(MAXLEN = 1000, XMLNAME = "CTC_Remarks");

/// 状态
Property CTCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTC_Status");

/// 最后更新日期
Property CTCUpdateDate As %Library.Date(XMLNAME = "CTC_UpdateDate");

/// 最后更新时间
Property CTCUpdateTime As %Library.Time(XMLNAME = "CTC_UpdateTime");

/// 最后更新人编码
Property CTCUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTC_UpdateUserCode");

}
