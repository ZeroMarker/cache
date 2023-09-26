Class web.DHCENS.STBLL.DOCU.MODEL.Documents Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Documents";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// Property DocumentList As list Of web.DHCENS.STBLL.DOCU.MODEL.DocuAcess(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");
Property DocumentList As web.DHCENS.STBLL.DOCU.MODEL.AccDocument(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

}
