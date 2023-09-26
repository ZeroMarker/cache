Class web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property hosDocuments As list Of web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.RegisterDocumentRt(XMLNAME = "RegisterDocumentRt", XMLPROJECTION = "ELEMENT");

}
