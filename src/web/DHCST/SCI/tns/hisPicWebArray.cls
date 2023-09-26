/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisPicWebArray Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisPicWebArray";

Parameter XMLSEQUENCE = 1;

Property item As list Of web.DHCST.SCI.tns.hisPicWeb(XMLNAME = "item", XMLPROJECTION = "ELEMENT");

}
