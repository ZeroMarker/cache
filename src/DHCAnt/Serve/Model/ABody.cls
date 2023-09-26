/// CTOR: QP
/// DATE: 2021-08-04
/// DESC: ROOT
Class DHCAnt.Serve.Model.ABody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SynAntiRtList As list Of DHCAnt.Serve.Model.ASynAntiRt(XMLNAME = "SynAntiRt", XMLPROJECTION = "ELEMENT");

}
