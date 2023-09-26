/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisPicWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisPicWeb";

Parameter XMLSEQUENCE = 1;

Property picName As %String(MAXLEN = "", XMLNAME = "picName");

Property picType As %String(MAXLEN = "", XMLNAME = "picType");

}
