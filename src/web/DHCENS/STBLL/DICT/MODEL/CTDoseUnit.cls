Class web.DHCENS.STBLL.DICT.MODEL.CTDoseUnit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DoseUnit";

/// 代码
Property CTDUCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDU_Code");

/// 描述
Property CTDUDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDU_Desc");

/// 代码表类型
Property CTDUCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDU_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDUStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDU_Status");

/// 最后更新人编码
Property CTDUUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTDU_UpdateUserCode");

/// 最后更新日期
Property CTDUUpdateDate As %Library.Date(XMLNAME = "CTDU_UpdateDate");

/// 最后更新时间
Property CTDUUpdateTime As %Library.Time(XMLNAME = "CTDU_UpdateTime");

/// 备注
Property CTDURemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDU_Remarks");

}
