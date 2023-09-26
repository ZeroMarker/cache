Class web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRtList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者处方信息列表
Property SynPrescRtList As list Of web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRt(XMLNAME = "SynMedRt", XMLPROJECTION = "ELEMENT");

}
