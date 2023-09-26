Class web.DHCENS.STBLL.DICT.MODEL.CTIdentifierType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTITCode As %Library.String(MAXLEN = 2, XMLNAME = "CTIT_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTITCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIT_CodesystemCode");

/// 描述
Property CTITDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTIT_Desc");

/// 备注
Property CTITRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTIT_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTITStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTIT_Status");

/// 最后更新日期
Property CTITUpdateDate As %Library.Date(XMLNAME = "CTIT_UpdateDate");

/// 最后更新时间
Property CTITUpdateTime As %Library.Time(XMLNAME = "CTIT_UpdateTime");

/// 最后更新人编码
Property CTITUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTIT_UpdateUserCode");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_IdentifierType";

}
