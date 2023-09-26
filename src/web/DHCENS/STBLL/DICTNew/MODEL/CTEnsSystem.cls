Class web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_EnsSystem";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property businessrowid As %Library.String(COLLATION = "EXACT", XMLNAME = "businessrowid");

/// 代码
Property CTESYSCode As %Library.String(COLLATION = "EXACT", XMLNAME = "CTESYS_Code");

/// 描述
Property CTESYSDesc As %Library.String(COLLATION = "EXACT", XMLNAME = "CTESYS_Desc");

/// 代码表类型 ct_codesystem.ctcscode
Property CTESYSCodesystemCode As %Library.String(COLLATION = "EXACT", XMLNAME = "CTESYS_CodesystemCode");

/// 有效标志（Y:启用；N:停用）
Property CTESYSEffectiveFlag As %Library.String(COLLATION = "EXACT", XMLNAME = "CTESYS_EffectiveFlag");

/// 系统分类代码 对应表：Ens_SystemType
Property CTESYStypeCode As %Library.String(COLLATION = "EXACT", XMLNAME = "CTESYS_typeCode");

}
