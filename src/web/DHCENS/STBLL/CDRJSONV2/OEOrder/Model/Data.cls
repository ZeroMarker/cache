Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property oeorditemList As list Of web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeorditem(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property oeordexecList As list Of web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property oeordexecstatusList As list Of web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
