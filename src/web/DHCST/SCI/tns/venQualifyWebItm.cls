/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.venQualifyWebItm Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "venQualifyWebItm";

Parameter XMLSEQUENCE = 1;

Property exp As %TimeStamp(XMLNAME = "exp");

Property pics As list Of web.DHCST.SCI.tns.hisPicWeb(XMLNAME = "pics", XMLPROJECTION = "ELEMENT");

Property text As %String(MAXLEN = "", XMLNAME = "text");

Property type As %String(MAXLEN = "", XMLNAME = "type");

Property venCode As %String(MAXLEN = "", XMLNAME = "venCode");

}
