Class web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property theme As %Library.String(XMLNAME = "theme");

Property LisItemResultList As list Of web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisItemResult(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property LisReportResultList As list Of web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property LisSenItemResultList As list Of web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property LisSpecimenReportList As list Of web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

Property OeordSpecimenList As list Of web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen(XMLNAME = "data", XMLPROJECTION = "ELEMENT");

}
