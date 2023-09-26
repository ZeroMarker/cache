Class DHCEPRFS.Entity.EQuerySubItem Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "Items";

Parameter XMLSEQUENCE = 1;

Property Condition As %String(MAXLEN = "", TRUNCATE = 1, XMLNAME = "Condition", XMLPROJECTION = "ELEMENT");

Property Operator As %String(MAXLEN = "", TRUNCATE = 1, XMLNAME = "Operator", XMLPROJECTION = "ELEMENT");

Property Value As %String(MAXLEN = "", TRUNCATE = 1, XMLNAME = "Value", XMLPROJECTION = "ELEMENT");

Property DataType As %String(MAXLEN = "", TRUNCATE = 1, XMLNAME = "DataType", XMLPROJECTION = "ELEMENT");

}
