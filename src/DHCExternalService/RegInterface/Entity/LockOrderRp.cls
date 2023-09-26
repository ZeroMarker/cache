Class DHCExternalService.RegInterface.Entity.LockOrderRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "LockOrderRp";

Parameter XMLSEQUENCE = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

Property HospitalID As %String(TRUNCATE = 1, XMLNAME = "HospitalID");

Property HISDate As %String(TRUNCATE = 1, XMLNAME = "HISDate");

Property HISTradeNo As %String(TRUNCATE = 1, XMLNAME = "HISTradeNo");

Property LockQueueNo As %String(TRUNCATE = 1, XMLNAME = "LockQueueNo");

Property ExtOrgCode As %String(TRUNCATE = 1, XMLNAME = "ExtOrgCode");

Storage Default
{
<Data name="LockOrderRpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmitAddress</Value>
</Value>
<Value name="3">
<Value>AdmitDate</Value>
</Value>
<Value name="4">
<Value>AdmitRange</Value>
</Value>
<Value name="5">
<Value>ExtOrgCode</Value>
</Value>
<Value name="6">
<Value>HISDate</Value>
</Value>
<Value name="7">
<Value>HISTradeNo</Value>
</Value>
<Value name="8">
<Value>HospitalID</Value>
</Value>
<Value name="9">
<Value>Items</Value>
</Value>
<Value name="10">
<Value>OrderCode</Value>
</Value>
<Value name="11">
<Value>OrderContent</Value>
</Value>
<Value name="12">
<Value>RegFee</Value>
</Value>
<Value name="13">
<Value>ResultCode</Value>
</Value>
<Value name="14">
<Value>ResultContent</Value>
</Value>
<Value name="15">
<Value>ScheduleItemCode</Value>
</Value>
<Value name="16">
<Value>SeqCode</Value>
</Value>
<Value name="17">
<Value>TradeCode</Value>
</Value>
</Data>
<DataLocation>^RegInter.LockOrderRpD</DataLocation>
<DefaultData>LockOrderRpDefaultData</DefaultData>
<IdLocation>^RegInter.LockOrderRpD</IdLocation>
<IndexLocation>^RegInter.LockOrderRpI</IndexLocation>
<StreamLocation>^RegInter.LockOrderRpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
