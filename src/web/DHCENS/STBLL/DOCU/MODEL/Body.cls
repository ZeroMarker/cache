Class web.DHCENS.STBLL.DOCU.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property hosDocuments As list Of web.DHCENS.STBLL.DOCU.MODEL.HOSDocument(XMLNAME = "RegisterDocumentRt", XMLPROJECTION = "ELEMENT");

Property mohDocuments As list Of web.DHCENS.STBLL.DOCU.MODEL.MOHDocument(XMLNAME = "MOH_DocumentList");

}
