Class DHCBILL.SelfPay.Entity.TransferQuery.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg
Property ResultMsg As %String(TRUNCATE = 1);

/// AdmID
Property AdmID As %String(TRUNCATE = 1);

/// Invoice	
Property Invoice As %String(TRUNCATE = 1);

/// PaidFlag
Property PaidFlag As %String(TRUNCATE = 1);

/// PayModeCode
Property PayModeCode As %String(TRUNCATE = 1);

/// Amount
Property Amount As %String(TRUNCATE = 1);

/// TransTradeNo
Property TransTradeNo As %String(TRUNCATE = 1);

/// PayeeAmt
Property PayeeAmt As %String(TRUNCATE = 1);

/// PayeeName
Property PayeeName As %String(TRUNCATE = 1);

/// PayeeNo
Property PayeeNo As %String(TRUNCATE = 1);

}
