/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisIncLocQtyItmWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisIncLocQtyItmWeb";

Parameter XMLSEQUENCE = 1;

Property locCode As %String(MAXLEN = "", XMLNAME = "locCode");

Property locIncCode As %String(MAXLEN = "", XMLNAME = "locIncCode");

Property locIncMaxQty As %xsd.float(XMLNAME = "locIncMaxQty");

Property locIncMinQty As %xsd.float(XMLNAME = "locIncMinQty");

Property locIncQty As %xsd.float(XMLNAME = "locIncQty");

Property locIncStandQty As %xsd.float(XMLNAME = "locIncStandQty");

}
