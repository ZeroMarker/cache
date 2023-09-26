Class web.DHCENS.STBLL.DICT.MODEL.CTChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ChildCategory";

/// 代码
Property CTCCCode As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_Code");

/// 描述
Property CTCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Desc");

/// 医嘱大类代码
Property CTCCCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_Category");

/// 代码表类型
Property CTCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCC_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCC_Status");

/// 最后更新人编码
Property CTCCUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTCC_UpdateUserCode");

/// 最后更新日期
Property CTCCUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_UpdateDate");

/// 最后更新时间
Property CTCCUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTCC_UpdateTime");

/// 备注
Property CTCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCC_Remarks");

}
