Class web.DHCENS.STBLL.DICT.MODEL.CTDuration Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Duration";

/// 代码
Property CTDCode As %Library.String(MAXLEN = 20, XMLNAME = "CTD_Code");

/// 描述
Property CTDDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_Desc");

/// 代码表类型
Property CTDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTD_Status");

/// 最后更新人编码
Property CTDUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTD_UpdateUserCode");

/// 最后更新日期
Property CTDUpdateDate As %Library.Date(XMLNAME = "CTD_UpdateDate");

/// 最后更新时间
Property CTDUpdateTime As %Library.Time(XMLNAME = "CTD_UpdateTime");

/// 备注
Property CTDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTD_Remarks");

}
