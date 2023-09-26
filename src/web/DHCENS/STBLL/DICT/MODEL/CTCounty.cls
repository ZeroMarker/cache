Class web.DHCENS.STBLL.DICT.MODEL.CTCounty Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 城市代码 代码CT_City.CTCCode
Property CTCCCode As %Library.String(MAXLEN = 6, XMLNAME = "CTC_CCode");

/// 代码
Property CTCCode As %Library.String(MAXLEN = 6, XMLNAME = "CTC_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CodesystemCode");

/// 描述
Property CTCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Desc");

/// 备注
Property CTCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTC_Status");

/// 最后更新日期
Property CTCUpdateDate As %Library.Date(XMLNAME = "CTC_UpdateDate");

/// 最后更新时间
Property CTCUpdateTime As %Library.Time(XMLNAME = "CTC_UpdateTime");

/// 最后更新人编码
Property CTCUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTC_UpdateUserCode");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_County";

}
