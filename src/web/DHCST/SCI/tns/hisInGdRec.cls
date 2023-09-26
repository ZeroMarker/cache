/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisInGdRec Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisInGdRec";

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property inGdRecItms As list Of web.DHCST.SCI.tns.hisInGdRecItm(XMLNAME = "inGdRecItms", XMLPROJECTION = "ELEMENT");

Property picWebs As list Of web.DHCST.SCI.tns.hisPicWeb(XMLNAME = "picWebs", XMLPROJECTION = "ELEMENT");

Property resultCode As %String(MAXLEN = "", XMLNAME = "resultCode");

Property resultContent As %String(MAXLEN = "", XMLNAME = "resultContent");

}
