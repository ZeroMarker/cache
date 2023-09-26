Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property theme As %Library.String(XMLNAME = "theme");

Property handtype As %Library.String(XMLNAME = "handtype");

Property PaidentifierList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paidentifier(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PaaddressList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Paaddress(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PatientInfoList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PatientInfo(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PAAdmInfoList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmInfo(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PAAdmTransactionList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmTransaction(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PAAllergyInfoList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAllergyInfo(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property PADiagnoseInfoList As list Of web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PADiagnoseInfo(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
