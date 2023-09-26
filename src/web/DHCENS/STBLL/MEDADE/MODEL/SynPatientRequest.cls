Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 消息头
Property Header As web.DHCENS.STBLL.MEDADE.MODEL.Header;

/// 消息体
Property Body As web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRtList;

}
