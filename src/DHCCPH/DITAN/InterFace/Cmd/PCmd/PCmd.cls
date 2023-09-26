Class DHCCPH.DITAN.InterFace.Cmd.PCmd.PCmd Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property RequesterNumber As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//requestercode

Property Country As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//086

Property Code As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

//2

Property BarCode As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property ItemName As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property ItemTyp As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property ItemUnit As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

Property Date As %String(TRUNCATE = 1, XMLPROJECTION = "ATTRIBUTE");

}
