/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.ns1.stringArray Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://jaxb.dev.java.net/array";

Parameter XMLNAME = "stringArray";

Parameter XMLSEQUENCE = 1;

Property item As list Of %String(MAXLEN = "", XMLNAME = "item", XMLPROJECTION = "ELEMENT");

}
