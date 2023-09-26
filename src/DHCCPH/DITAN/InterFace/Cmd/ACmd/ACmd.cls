Class DHCCPH.DITAN.InterFace.Cmd.ACmd.ACmd Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property RequesterNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property OrderNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property OutputNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Record As list Of Record(XMLPROJECTION = "ELEMENT");

}
