/// 运算逻辑参数明细
Class EPRservice.Quality.OperationLogic.OperationSubItem Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Items";

Parameter XMLSEQUENCE = 1;

Property Level As %String(MAXLEN = "", XMLNAME = "Level", XMLPROJECTION = "ELEMENT");

Property Grade As %String(MAXLEN = "", XMLNAME = "Grade", XMLPROJECTION = "ELEMENT");

Property Ruler As %String(MAXLEN = "", XMLNAME = "Ruler", XMLPROJECTION = "ELEMENT");

Property SpecialRuler As %String(MAXLEN = "", XMLNAME = "SpecialRuler", XMLPROJECTION = "ELEMENT");

}
