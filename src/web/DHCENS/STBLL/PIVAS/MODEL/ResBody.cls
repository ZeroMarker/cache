Class web.DHCENS.STBLL.PIVAS.MODEL.ResBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %String;

Property ResultContent As %String;

Property OEORIInfoList As web.DHCENS.STBLL.PIVAS.MODEL.OEORIInfoList(XMLNAME = "OEORIInfoList");

}
