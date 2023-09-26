Class web.DHCENS.STBLL.LIS.MODEL.DiagnosisList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "DiagnosisList";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 诊断信息
Property Diagnosis As list Of web.DHCENS.STBLL.LIS.MODEL.Diagnosis(XMLNAME = "Diagnosis", XMLPROJECTION = "ELEMENT");

}
