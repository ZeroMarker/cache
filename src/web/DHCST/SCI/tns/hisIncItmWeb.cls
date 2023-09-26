/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisIncItmWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisIncItmWeb";

Parameter XMLSEQUENCE = 1;

Property barCode As %String(MAXLEN = "", XMLNAME = "barCode");

Property form As %String(MAXLEN = "", XMLNAME = "form");

Property venCode As %String(MAXLEN = "", XMLNAME = "venCode");

Property venIncCat As %String(MAXLEN = "", XMLNAME = "venIncCat");

Property venIncCode As %String(MAXLEN = "", XMLNAME = "venIncCode");

Property venIncManf As %String(MAXLEN = "", XMLNAME = "venIncManf");

Property venIncName As %String(MAXLEN = "", XMLNAME = "venIncName");

Property venIncPrice As %xsd.float(XMLNAME = "venIncPrice");

Property venIncSp As %xsd.float(XMLNAME = "venIncSp");

Property venIncSpec As %String(MAXLEN = "", XMLNAME = "venIncSpec");

Property venIncUom As %String(MAXLEN = "", XMLNAME = "venIncUom");

}
