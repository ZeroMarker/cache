Class DHCCPH.DITAN.InterFace.Msg.BMsg.BMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

//BMsg RequesterNumber="1" Country="0" Code="0" Barcode="17" Quantity="0"/>

Property RequesterNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Country As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Code As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property BarCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Quantity As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

}
