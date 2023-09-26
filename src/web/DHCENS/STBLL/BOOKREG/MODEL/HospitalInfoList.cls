Class web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfoList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "HospitalInfo";

/// 医院
Property HospitalInfo As list Of web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfo(XMLNAME = "HospitalInfo", XMLPROJECTION = "ELEMENT");

}
