Class web.DHCENS.STBLL.DICT.MODEL.CTOccupation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Occupation";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOCode As %Library.String(MAXLEN = 20, XMLNAME = "CTO_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTO_CodesystemCode");

/// 描述
Property CTODesc As %Library.String(MAXLEN = 100, XMLNAME = "CTO_Desc");

/// 备注
Property CTORemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTO_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTO_Status");

/// 最后更新日期
Property CTOUpdateDate As %Library.Date(XMLNAME = "CTO_UpdateDate");

/// 最后更新时间
Property CTOUpdateTime As %Library.Time(XMLNAME = "CTO_UpdateTime");

/// 最后更新人编码
Property CTOUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTO_UpdateUserCode");

}
