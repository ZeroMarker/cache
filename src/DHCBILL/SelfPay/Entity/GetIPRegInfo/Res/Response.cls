Class DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode	
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg
Property ResultMsg As %String(TRUNCATE = 1);

/// IPBook
Property IPBook As %String(TRUNCATE = 1);

/// AdmID
Property AdmID As %String(TRUNCATE = 1);

/// InsuFlag
Property InsuFlag As %String(TRUNCATE = 1);

/// AdmReasonID
Property AdmReasonID As %String(TRUNCATE = 1);

/// AdmReaNationCode
Property AdmReaNationCode As %String(TRUNCATE = 1);

/// UserCode
Property UserCode As %String(TRUNCATE = 1);

/// InsuExpString
Property InsuExpString As %String(TRUNCATE = 1);

Property PatInfo As DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.IPRegPatInfo;

Property AdmInfo As DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.IPRegAdmInfo;

}
