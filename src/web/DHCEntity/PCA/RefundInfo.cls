/// Creator:Lid
/// CreatDate:2013-05-31
/// Description:住院收费结算明细列表
Class web.DHCEntity.PCA.RefundInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", CompileAfter = , Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "RefundInfo";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property CardNo As %String(MAXLEN = "", XMLNAME = "CardNo");

Property PatientID As %String(MAXLEN = "", XMLNAME = "PatientID");

Property BankCardNo As %String(MAXLEN = "", XMLNAME = "BankCardNo");

Property Amount As %String(MAXLEN = "", XMLNAME = "Amount");

Property OrgBTradeNo As %String(MAXLEN = "", XMLNAME = "OrgBTradeNo");

Property PosID As %String(MAXLEN = "", XMLNAME = "PosID") [ Required ];

Property OrgTradeTime As %String(MAXLEN = "", XMLNAME = "OrgTradeTime");

Property OrgHTradeNo As %String(MAXLEN = "", XMLNAME = "OrgHTradeNo");

Property RefundBalance As %String(MAXLEN = "", XMLNAME = "RefundBalance");

}
