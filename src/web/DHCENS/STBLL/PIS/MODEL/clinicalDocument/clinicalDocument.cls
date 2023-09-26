Class web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.clinicalDocument Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "clinicalDocument";

Property documentHeader As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.documentHeader(XMLNAME = "documentHeader");

Property structuredBody As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.structuredBody(XMLNAME = "structuredBody");

}
