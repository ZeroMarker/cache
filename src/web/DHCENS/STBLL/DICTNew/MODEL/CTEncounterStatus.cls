Class web.DHCENS.STBLL.DICTNew.MODEL.CTEncounterStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_EncounterStatus";

/// 代码
Property CTESCode As %Library.String(MAXLEN = 50, XMLNAME = "CTES_Code");

/// 描述
Property CTESDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTES_Desc");

/// 标识分类代码
Property CTESCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTES_CodesystemCode");

/// 状态
Property CTESStatus As %Library.String(MAXLEN = 200, XMLNAME = "CTES_Status");

/// 更新人代码
Property CTESUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTES_UpdateUserCode");

/// 备注
Property CTESRemarks As %Library.String(MAXLEN = 200, XMLNAME = "CTES_Remarks");

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 200, XMLNAME = "BusinessFieldCode");

}
