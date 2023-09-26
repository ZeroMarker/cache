Class web.DHCPE.CashierInterface.Entity.param Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Property param1 As list Of bill;

Property param2 As %String(TRUNCATE = 1);

Property param3 As %String(TRUNCATE = 1);

Property param4 As %String(TRUNCATE = 1);

Property param5 As %String(TRUNCATE = 1);

Property param6 As %String(TRUNCATE = 1);

Property param7 As %String(TRUNCATE = 1);

Property param8 As %String(TRUNCATE = 1);

Property param9 As %String(TRUNCATE = 1);

Property param10 As %String(TRUNCATE = 1, XMLNAME = "param1");

Storage Default
{
<Data name="paramDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CashierIntEBBF.paramD</DataLocation>
<DefaultData>paramDefaultData</DefaultData>
<IdLocation>^web.DHCPE.CashierIntEBBF.paramD</IdLocation>
<IndexLocation>^web.DHCPE.CashierIntEBBF.paramI</IndexLocation>
<StreamLocation>^web.DHCPE.CashierIntEBBF.paramS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
