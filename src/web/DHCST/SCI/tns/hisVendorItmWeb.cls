/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisVendorItmWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisVendorItmWeb";

Parameter XMLSEQUENCE = 1;

Property businessRegNo As %String(MAXLEN = "", XMLNAME = "businessRegNo");

Property code As %String(MAXLEN = "", XMLNAME = "code");

Property name As %String(MAXLEN = "", XMLNAME = "name");

}
