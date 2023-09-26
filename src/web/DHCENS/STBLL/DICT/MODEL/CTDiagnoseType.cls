Class web.DHCENS.STBLL.DICT.MODEL.CTDiagnoseType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DiagnoseType";

/// 代码
Property CTDTCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDT_Code");

/// 描述
Property CTDTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDT_Desc");

/// 代码表类型
Property CTDTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDT_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDT_Status");

/// 最后更新人编码
Property CTDTUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTDT_UpdateUserCode");

/// 最后更新日期
Property CTDTUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTDT_UpdateDate");

/// 最后更新时间
Property CTDTUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTDT_UpdateTime");

/// 备注
Property CTDTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDT_Remarks");

}
