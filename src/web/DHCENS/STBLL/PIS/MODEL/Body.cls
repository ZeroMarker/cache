Class web.DHCENS.STBLL.PIS.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property PATPatientInfo As web.DHCENS.STBLL.EMPI.MODEL.PaPatient(XMLNAME = "PATPatientInfo", XMLPROJECTION = "ELEMENT");

Property PATAdmInfo As web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo(XMLNAME = "PATAdmInfo", XMLPROJECTION = "ELEMENT");

Property AppBills As web.DHCENS.STBLL.PIS.MODEL.PisAppInfo(XMLNAME = "AddRisAppBillRt");

Property PISAppBills As web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo(XMLNAME = "AddPisAppBillRt", XMLPROJECTION = "ELEMENT");

}
