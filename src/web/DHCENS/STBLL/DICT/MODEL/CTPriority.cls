Class web.DHCENS.STBLL.DICT.MODEL.CTPriority Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Priority";

/// 代码
Property CTPCode As %Library.String(MAXLEN = 20, XMLNAME = "CTP_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_CodesystemCode");

/// 描述
Property CTPDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTP_Desc");

/// 备注
Property CTPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTP_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTP_Status");

/// 最后更新日期
Property CTPUpdateDate As %Library.Date(XMLNAME = "CTP_UpdateDate");

/// 最后更新时间
Property CTPUpdateTime As %Library.Time(XMLNAME = "CTP_UpdateTime");

/// 最后更新人编码
Property CTPUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTP_UpdateUserCode");

}
