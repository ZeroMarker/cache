Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.clinicalDocument Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "clinicalDocument";

Property documentHeader As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader(XMLNAME = "documentHeader");

Property structuredBody As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.structuredBody(XMLNAME = "structuredBody");

}
