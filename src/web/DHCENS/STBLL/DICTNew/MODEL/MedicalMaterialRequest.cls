Class web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

Property header As web.DHCENS.STBLL.DICTNew.MODEL.Header(XMLNAME = "Header");

Property body As web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialBody(XMLNAME = "Body");

}
