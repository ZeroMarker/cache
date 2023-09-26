Class DHCBILL.SelfPay.Entity.OPDepositList.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode	交易代码
Property ResultCode As %String(TRUNCATE = 1);

/// HospitalID	院区ID
Property ResultMsg As %String(TRUNCATE = 1);

/// CardNo	卡号
Property PatientID As %String(TRUNCATE = 1);

/// CardType	卡类型
Property PatientName As %String(TRUNCATE = 1);

/// SecrityNo	校验码
Property Sex As %String(TRUNCATE = 1);

/// PassWord 密码
Property DOB As %String(TRUNCATE = 1);

/// PatientID	患者ID(HIS登记号)
Property CredType As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property CredNo As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property BalanceAmt As %String(TRUNCATE = 1);

Property PayDetails As list Of DHCBILL.SelfPay.Entity.OPDepositList.Res.ResPayDetails(XMLITEMNAME = "AccDetailInfo", XMLNAME = "AccDetailS", XMLPROJECTION = "COLLECTION");

Storage Default
{
<Data name="ResponseDefaultData">
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
<Value>ExpStr</Value>
</Value>
<Value name="19">
<Value>PayDetails</Value>
</Value>
</Data>
<DataLocation>^DHCBILL.SelfPay.ED9A8.ResponseD</DataLocation>
<DefaultData>ResponseDefaultData</DefaultData>
<IdLocation>^DHCBILL.SelfPay.ED9A8.ResponseD</IdLocation>
<IndexLocation>^DHCBILL.SelfPay.ED9A8.ResponseI</IndexLocation>
<StreamLocation>^DHCBILL.SelfPay.ED9A8.ResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
