Class EMRmeta.PrivRuleType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Index IdxName On Name [ Data = Name, Unique ];

Storage Default
{
<Data name="PrivRuleTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleTypeD</DataLocation>
<DefaultData>PrivRuleTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PrivRuleTypeD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
