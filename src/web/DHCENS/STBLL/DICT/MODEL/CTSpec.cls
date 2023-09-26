Class web.DHCENS.STBLL.DICT.MODEL.CTSpec Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Spec";

/// 代码
Property CTSPCCode As %Library.String(MAXLEN = 30, XMLNAME = "CTSPC_Code");

/// 描述
Property CTSPCDesc As %Library.String(MAXLEN = 512, XMLNAME = "CTSPC_Desc");

/// 代码表类型
Property CTSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTS_Status");

/// 最后更新人编码
Property CTSUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTS_UpdateUserCode");

/// 最后更新日期
Property CTSUpdateDate As %Library.Date(XMLNAME = "CTS_UpdateDate");

}
