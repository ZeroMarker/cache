Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRtList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者输血信息列表
Property SynBloodRtList As list Of web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRt(XMLNAME = "SynBloodRt", XMLPROJECTION = "ELEMENT");

}
