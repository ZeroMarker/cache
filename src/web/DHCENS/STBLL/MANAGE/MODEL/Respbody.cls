Class web.DHCENS.STBLL.MANAGE.MODEL.Respbody Extends (%RegisteredObject, %XML.Adaptor)
{

// Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %Library.String(XMLNAME = "ResultCode");

Property ResultContent As %Library.String(XMLNAME = "ResultContent");

Property ResultFlag As %Library.String(XMLNAME = "ResultFlag");

Property DischStatus As %Library.String(XMLNAME = "DischStatus");

}
