Class web.DHCENS.STBLL.DICTNew.MODEL.CTEncounterType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_EncounterType";

/// 代码
Property CTETCode As %Library.String(MAXLEN = 50, XMLNAME = "CTET_Code");

/// 描述
Property CTETDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTET_Desc");

/// 标识分类代码
Property CTETCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTET_CodesystemCode");

/// 状态
Property CTETStatus As %Library.String(MAXLEN = 200, XMLNAME = "CTET_Status");

/// 更新人代码
Property CTETUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTET_UpdateUserCode");

/// 备注
Property CTETRemarks As %Library.String(MAXLEN = 200, XMLNAME = "CTET_Remarks");

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 200, XMLNAME = "BusinessFieldCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
