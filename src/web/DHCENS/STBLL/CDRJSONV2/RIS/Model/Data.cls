Class web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property risorderList As list Of web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risorder(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property risreportList As list Of web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
