Class DHCCPH.DITAN.InterFace.Msg.KMsg.KMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property RequesterNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property StartCountry As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property StartCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property StartBarCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Record As list Of Record(XMLPROJECTION = "ELEMENT");

}
