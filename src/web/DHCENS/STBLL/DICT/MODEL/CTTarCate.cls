Class web.DHCENS.STBLL.DICT.MODEL.CTTarCate Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ChargeCategory";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 收费大类代码
Property CTCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_Code");

/// 收费大类描述
Property CTCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Desc");

/// 代码表类型
Property CTCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_CodesystemCode");

/// 备注
Property CTCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Remarks");

/// 状态
Property CTCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCC_Status");

/// 最后更新人编码
Property CTCCUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_UpdateUserCode");

/// 最后更新日期
Property CTCCUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_UpdateDate");

/// 最后更新时间
Property CTCCUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_UpdateTime");

}
