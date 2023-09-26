Class web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystemType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_EnsSystemType";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property businessrowid As %Library.String(COLLATION = "EXACT", XMLNAME = "businessrowid");

/// 代码
Property CTESTCode As %Library.String(COLLATION = "EXACT", XMLNAME = "CTEST_Code");

/// 代码
Property CTESTDesc As %Library.String(COLLATION = "EXACT", XMLNAME = "CTEST_Desc");

/// 代码表类型 ct_codesystem.ctcscode
Property CTESTCodesystemCode As %Library.String(COLLATION = "EXACT", XMLNAME = "CTEST_CodesystemCode");

}
