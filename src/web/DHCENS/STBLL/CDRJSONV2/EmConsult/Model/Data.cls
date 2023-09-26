Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property theme As %Library.String(XMLNAME = "theme");

Property dhcemconsultList As list Of web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsult(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property dhcemconsultitmList As list Of web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
