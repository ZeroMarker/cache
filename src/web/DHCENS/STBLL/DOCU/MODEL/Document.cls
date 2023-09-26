/// 文档检索结果
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.Document Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Document";

Property DocumentID As %String;

Property DocumentPath As %String;

Property DocumentTitle As %String;

Property DocumentType As %String;

Property UpdateUser As %String;

Property UpdateDate As %String;

Property UpdateTime As %String;

}
