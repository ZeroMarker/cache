/// CTOR: QP
/// DATE: 2021-08-04
/// DESC: ROOT
Class DHCAnt.Serve.Model.ARoot Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property BodyList As list Of DHCAnt.Serve.Model.ABody(XMLNAME = "Body", XMLPROJECTION = "ELEMENT");

}
