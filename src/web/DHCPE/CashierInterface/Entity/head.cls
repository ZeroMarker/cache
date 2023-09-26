Class web.DHCPE.CashierInterface.Entity.head Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Property InvName As %String(XMLNAME = "缴款人");

Property InvLSH As %String(XMLNAME = "业务流水号");

Property InvType As %String(XMLNAME = "医疗机构类型");

Property InvSex As %String(XMLNAME = "性别");

Property InvInsuType As %String(XMLNAME = "医保类型");

Property InvInsuCardNo As %String(XMLNAME = "社会保障卡号");

Property InvInsuPay As %String(XMLNAME = "基金支付");

Property InvSelfCardPay As %String(XMLNAME = "个人账户支付");

Property InvSelfPay As %String(XMLNAME = "个人支付金额");

Storage Default
{
<Data name="headDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CashierInteEBBF.headD</DataLocation>
<DefaultData>headDefaultData</DefaultData>
<IdLocation>^web.DHCPE.CashierInteEBBF.headD</IdLocation>
<IndexLocation>^web.DHCPE.CashierInteEBBF.headI</IndexLocation>
<StreamLocation>^web.DHCPE.CashierInteEBBF.headS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
