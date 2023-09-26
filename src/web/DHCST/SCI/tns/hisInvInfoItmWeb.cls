/// 创建自: http://hospscm.jiankangle.com/sci/ws/hisInfoService?wsdl
Class web.DHCST.SCI.tns.hisInvInfoItmWeb Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLNAME = "hisInvInfoItmWeb";

Parameter XMLSEQUENCE = 1;

Property batno As %String(MAXLEN = "", XMLNAME = "batno");

Property deliveritmid As %Integer(XMLNAME = "deliveritmid");

Property expdate As %TimeStamp(XMLNAME = "expdate");

Property hopinccode As %String(MAXLEN = "", XMLNAME = "hopinccode");

Property invdate As %TimeStamp(XMLNAME = "invdate");

Property invno As %String(MAXLEN = "", XMLNAME = "invno");

Property orderno As %String(MAXLEN = "", XMLNAME = "orderno");

Property qty As %xsd.float(XMLNAME = "qty") [ Required ];

Property rp As %xsd.float(XMLNAME = "rp") [ Required ];

Property rpamt As %xsd.float(XMLNAME = "rpamt") [ Required ];

}
