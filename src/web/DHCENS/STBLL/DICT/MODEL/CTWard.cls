Class web.DHCENS.STBLL.DICT.MODEL.CTWard Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Ward";

/// 代码
Property CTWCode As %Library.String(MAXLEN = 50, XMLNAME = "CTW_Code");

/// 描述
Property CTWDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTW_Desc");

/// 代码表类型 
Property CTWCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTW_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTWStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTW_Status");

/// 最后更新人编码
Property CTWUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTW_UpdateUserCode");

/// 最后更新日期
Property CTWUpdateDate As %Library.Date(XMLNAME = "CTW_UpdateDate");

/// 最后更新时间
Property CTWUpdateTime As %Library.Time(XMLNAME = "CTW_UpdateTime");

/// 备注
Property CTWRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTW_Remarks");

/// 医院编号
Property CTWHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTW_HosCode");

}
