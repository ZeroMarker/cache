Class web.DHCENS.STBLL.RIS.MODEL.Response.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property GetAppFormReturn As list Of web.DHCENS.STBLL.RIS.MODEL.Response.RisAppInfo(XMLNAME = "GetAppFormReturn", XMLPROJECTION = "ELEMENT");

}
