Class web.DHCENS.STBLL.DICT.MODEL.CTDoseForms Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DoseForms";

/// 代码
Property CTDFCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDF_Code");

/// 描述
Property CTDFDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDF_Desc");

/// 代码表类型
Property CTDFCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDF_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDFStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDF_Status");

/// 最后更新人编码
Property CTDFUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTDF_UpdateUserCode");

/// 最后更新日期
Property CTDFUpdateDate As %Library.Date(XMLNAME = "CTDF_UpdateDate");

/// 最后更新时间
Property CTDFUpdateTime As %Library.Time(XMLNAME = "CTDF_UpdateTime");

/// 备注
Property CTDFRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDF_Remarks");

}
