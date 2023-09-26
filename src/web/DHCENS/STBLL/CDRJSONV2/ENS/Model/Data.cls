Class web.DHCENS.STBLL.CDRJSONV2.ENS.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ensstatusList As list Of web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatus(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property ensstatuslogList As list Of web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatuslog(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
