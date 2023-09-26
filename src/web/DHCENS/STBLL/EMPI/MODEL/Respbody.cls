Class web.DHCENS.STBLL.EMPI.MODEL.Respbody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %Library.String(XMLNAME = "ResultCode");

Property ResultContent As %Library.String(XMLNAME = "ResultContent");

Property VitalSignInfos As list Of web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfo(XMLNAME = "VitalSignInfoList");

}
