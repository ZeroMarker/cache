Class web.DHCENS.STBLL.DICTNew.MODEL.CTAddressType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_EncounterType";

/// 代码
Property CTATCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_Code");

/// 描述
Property CTATDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAT_Desc");

/// 标识分类代码
Property CTATCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_CodesystemCode");

/// 状态
Property CTATStatus As %Library.String(MAXLEN = 200, XMLNAME = "CTAT_Status");

/// 更新人代码
Property CTATUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAT_UpdateUserCode");

/// 备注
Property CTATRemarks As %Library.String(MAXLEN = 200, XMLNAME = "CTAT_Remarks");

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 200, XMLNAME = "BusinessFieldCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
