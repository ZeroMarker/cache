Class web.DHCENS.STBLL.DOCU.MODEL.AccDocument Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Document";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property DocumentID As %String;

Property DocumentContent As %GlobalCharacterStream;

Property repotUrl As %String;

Property UpdateUser As %String;

Property UpdateDate As %String;

Property UpdateTime As %String;

}
