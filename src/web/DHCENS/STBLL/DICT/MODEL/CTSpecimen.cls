Class web.DHCENS.STBLL.DICT.MODEL.CTSpecimen Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Specimen";

/// 标本代码
Property CTSCode As %Library.String(MAXLEN = 20, XMLNAME = "CTS_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTS_CodesystemCode");

/// 标本名称
Property CTSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTS_Desc");

/// 备注
Property CTSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTS_Status");

/// 最后更新日期
Property CTSUpdateDate As %Library.Date(XMLNAME = "CTS_UpdateDate");

/// 最后更新时间
Property CTSUpdateTime As %Library.Time(XMLNAME = "CTS_UpdateTime");

/// 最后更新人编码
Property CTSUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTS_UpdateUserCode");

}
