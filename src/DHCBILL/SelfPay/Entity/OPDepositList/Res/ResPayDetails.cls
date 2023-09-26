Class DHCBILL.SelfPay.Entity.OPDepositList.Res.ResPayDetails Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 序号
Property Ind As %String(TRUNCATE = 1);

/// 记录ID
Property APPreRowid As %String(TRUNCATE = 1);

/// 支付日期
Property APDate As %String(TRUNCATE = 1);

/// 业务类型
Property APType As %String(TRUNCATE = 1);

/// 支付方式
Property APMode As %String(TRUNCATE = 1);

/// 原充值金额
Property AccSum As %String(TRUNCATE = 1);

/// 工号
Property AccUser As %String(TRUNCATE = 1);

/// 收据号
Property ABillNo As %String(TRUNCATE = 1);

/// 可退金额
Property CanRefAmt As %String(TRUNCATE = 1);

/// 当前余额
Property ALeft As %String(TRUNCATE = 1);

/// 平台流水
Property PlatformNo As %String(TRUNCATE = 1);

/// 第三方流水
Property OutPayNo As %String(TRUNCATE = 1);

/// pos终端号
Property PosTermnial As %String(TRUNCATE = 1);

/// Pos凭证号
Property PosSysNO As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ResPayDetailsDefaultData">
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
<DataLocation>^DHCBILL.SelfD9A8.ResPayDetailsD</DataLocation>
<DefaultData>ResPayDetailsDefaultData</DefaultData>
<IdLocation>^DHCBILL.SelfD9A8.ResPayDetailsD</IdLocation>
<IndexLocation>^DHCBILL.SelfD9A8.ResPayDetailsI</IndexLocation>
<StreamLocation>^DHCBILL.SelfD9A8.ResPayDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
