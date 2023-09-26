Class web.DHCENS.STBLL.PIS.MODEL.Specimen Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Specimen";

/// 标本名称代码
Property SpecimenCode As %Library.String(MAXLEN = 20, XMLNAME = "SpecimenCode");

/// 标本名称
Property SpecimenDesc As %Library.String(MAXLEN = 50, XMLNAME = "SpecimenDesc");

/// 标本ID
Property TSROWID As %Library.String(MAXLEN = 50, XMLNAME = "TSROWID");

}
