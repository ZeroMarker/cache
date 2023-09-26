/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.venQualifyWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "venQualifyWeb";

Parameter XMLSEQUENCE = 1;

Property operateResult As web.DHCST.SCI.tns.operateResult(XMLNAME = "operateResult");

Property venQualifyWebItms As list Of web.DHCST.SCI.tns.venQualifyWebItm(XMLNAME = "venQualifyWebItms", XMLPROJECTION = "ELEMENT");

}
