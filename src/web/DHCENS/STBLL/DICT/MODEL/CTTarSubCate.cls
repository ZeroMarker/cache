Class web.DHCENS.STBLL.DICT.MODEL.CTTarSubCate Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ChargeChildCategory";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 收费大类代码
Property CTCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_ParentCode");

/// 收费子类代码
Property CTCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_Code");

/// 收费大类描述
Property CTCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCCC_Desc");

/// 代码表类型
Property CTCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_CodesystemCode");

/// 备注
Property CTCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCCC_Remarks");

/// 状态
Property CTCCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCCC_Status");

/// 最后更新人编码
Property CTCCCUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTCCC_UpdateUserCode");

/// 最后更新日期
Property CTCCCUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCCC_UpdateDate");

/// 最后更新时间
Property CTCCCUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTCCC_UpdateTime");

}
