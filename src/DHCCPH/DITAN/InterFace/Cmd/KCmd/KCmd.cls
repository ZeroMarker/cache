Class DHCCPH.DITAN.InterFace.Cmd.KCmd.KCmd Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property RequesterNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//requestercode

Property StartCountry As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//086

Property StartCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//2

Property StartBarCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Count As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

}
