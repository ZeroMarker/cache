Class web.DHCENS.STBLL.DICT.MODEL.CTCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Category";

/// 代码
Property CTCCode As %Library.String(MAXLEN = 20, XMLNAME = "CTC_Code");

/// 描述
Property CTCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Desc");

/// 代码表类型
Property CTCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTC_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTC_Status");

/// 最后更新人编码
Property CTCUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTC_UpdateUserCode");

/// 最后更新日期
Property CTCUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTC_UpdateDate");

/// 最后更新时间
Property CTCUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTC_UpdateTime");

/// 备注
Property CTCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTC_Remarks");

}
