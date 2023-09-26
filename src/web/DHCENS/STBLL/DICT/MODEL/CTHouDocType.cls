Class web.DHCENS.STBLL.DICT.MODEL.CTHouDocType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_HouDocType";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTHDTCode As %Library.String(MAXLEN = 20, XMLNAME = "CTHDT_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTHDTCodeSystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHDT_CodeSystemCode");

/// 描述
Property CTHDTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTHDT_Desc");

/// 备注
Property CTHDTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTHDT_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTHDTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTHDT_Status");

/// 最后更新日期
Property CTHDTUpdateDate As %Library.Date(XMLNAME = "CTHDT_UpdateDate");

/// 最后更新时间
Property CTHDTUpdateTime As %Library.Time(XMLNAME = "CTHDT_UpdateTime");

/// 最后更新人编码
Property CTHDTUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTHDT_UpdateUserCode");

}
