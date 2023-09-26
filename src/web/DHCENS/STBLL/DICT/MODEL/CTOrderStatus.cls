Class web.DHCENS.STBLL.DICT.MODEL.CTOrderStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_OrderStatus";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTOSCode As %Library.String(MAXLEN = 20, XMLNAME = "CTOS_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTOSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOS_CodesystemCode");

/// 描述
Property CTOSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOS_Desc");

/// 备注
Property CTOSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOS_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTOSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOS_Status");

/// 最后更新日期
Property CTOSUpdateDate As %Library.Date(XMLNAME = "CTOS_UpdateDate");

/// 最后更新时间
Property CTOSUpdateTime As %Library.Time(XMLNAME = "CTOS_UpdateTime");

/// 最后更新人编码
Property CTOSUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTOS_UpdateUserCode");

}
