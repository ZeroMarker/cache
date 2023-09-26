Class web.DHCENS.STBLL.LIS.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property PATPatientInfo As web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew(XMLNAME = "PATPatientInfo", XMLPROJECTION = "ELEMENT");

Property PATAdmInfo As web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo(XMLNAME = "PATAdmInfo", XMLPROJECTION = "ELEMENT");

Property PatLisOrdList As web.DHCENS.STBLL.LIS.MODEL.PatLisOrdListInfo(XMLNAME = "SendPatOrdListRt");

Property CriticalValueList As web.DHCENS.STBLL.LIS.MODEL.CriticalValueInfo(XMLNAME = "ReCriticalValuesRt");

/// 诊断信息 2019-10-02
Property PAADMDiagnose As web.DHCENS.STBLL.LIS.MODEL.DiagnosisList(XMLNAME = "PAADMDiagnose", XMLPROJECTION = "ELEMENT");

Property AmountOfTubeList As list Of web.DHCENS.STBLL.LIS.MODEL.AmountOfTube;

}
