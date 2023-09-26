/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisCmpRecWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisCmpRecWeb";

Parameter XMLSEQUENCE = 1;

Property hopname As %String(MAXLEN = "", XMLNAME = "hopname");

Property invs As list Of %String(MAXLEN = "", XMLNAME = "invs", XMLPROJECTION = "ELEMENT");

Property venname As %String(MAXLEN = "", XMLNAME = "venname");

}
