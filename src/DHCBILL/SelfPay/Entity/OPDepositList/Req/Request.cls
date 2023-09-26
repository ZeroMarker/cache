Class DHCBILL.SelfPay.Entity.OPDepositList.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID	院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// CardType	卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo	校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PassWord 密码
Property PassWord As %String(TRUNCATE = 1);

/// PatientID	患者ID(HIS登记号)
Property PatientID As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property TerminalID As %String(TRUNCATE = 1);

/// AccountID 院内账户号
Property AccountID As %String(TRUNCATE = 1);

Property PayMode As %String(TRUNCATE = 1);

/// DepCanRefAmount 退款金额
Property DepCanRefAmount As %String(TRUNCATE = 1);

/// ExpStr	扩展信息
Property ExpStr As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TradeCode</Value>
</Value>
<Value name="3">
<Value>HospitalID</Value>
</Value>
<Value name="4">
<Value>CardNo</Value>
</Value>
<Value name="5">
<Value>CardType</Value>
</Value>
<Value name="6">
<Value>SecrityNo</Value>
</Value>
<Value name="7">
<Value>PassWord</Value>
</Value>
<Value name="8">
<Value>PatientID</Value>
</Value>
<Value name="9">
<Value>UserCode</Value>
</Value>
<Value name="10">
<Value>TerminalID</Value>
</Value>
<Value name="11">
<Value>TradeChannel</Value>
</Value>
<Value name="12">
<Value>AccountID</Value>
</Value>
<Value name="13">
<Value>RefundAmt</Value>
</Value>
<Value name="14">
<Value>RefundDepositDr</Value>
</Value>
<Value name="15">
<Value>RefDepRowid</Value>
</Value>
<Value name="16">
<Value>HisTradeNo</Value>
</Value>
<Value name="17">
<Value>CommitFlag</Value>
</Value>
<Value name="18">
<Value>PayDetails</Value>
</Value>
<Value name="19">
<Value>ExpStr</Value>
</Value>
</Data>
<DataLocation>^DHCBILL.SelfPay.En1829.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^DHCBILL.SelfPay.En1829.RequestD</IdLocation>
<IndexLocation>^DHCBILL.SelfPay.En1829.RequestI</IndexLocation>
<StreamLocation>^DHCBILL.SelfPay.En1829.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
