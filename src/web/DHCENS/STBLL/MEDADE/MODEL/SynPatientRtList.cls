Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRtList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者基本信息+就诊信息列表
Property SynPatientRtList As list Of web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRt(XMLNAME = "SynPatientRt", XMLPROJECTION = "ELEMENT");

}
