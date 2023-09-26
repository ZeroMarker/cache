/// Created from: d:/aaa/xmlfile3.xsd
Class web.DHCEntity.PCA.ResultInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "ResultInfo";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(MAXLEN = "", XMLNAME = "ResultCode");

Property ResultMsg As %String(MAXLEN = "", XMLNAME = "ResultMsg");

Property BTradeNo As %String(MAXLEN = "", XMLNAME = "BTradeNo");

Property TradeTime As %String(MAXLEN = "", XMLNAME = "TradeTime");

Property CardNo As %String(MAXLEN = "", XMLNAME = "CardNo");

Property PatientID As %String(MAXLEN = "", XMLNAME = "PatientID");

Property BankCardNo As %String(MAXLEN = "", XMLNAME = "BankCardNo");

Property OrgAmount As %String(MAXLEN = "", XMLNAME = "OrgAmount");

Property OrgBTradeNo As %String(MAXLEN = "", XMLNAME = "OrgBTradeNo");

Property OrgTrace As %String(MAXLEN = "", XMLNAME = "OrgTrace");

Property OrgPosID As %String(MAXLEN = "", XMLNAME = "OrgPosID");

}
