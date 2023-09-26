Class EMRmeta.PrivRuleLog Extends %Persistent
{

Property UserID As %String(TRUNCATE = 1);

Property UserName As %String(TRUNCATE = 1);

Property IP As %String(TRUNCATE = 1);

Property ModifyDate As %String(TRUNCATE = 1);

Property LogType As %String(TRUNCATE = 1);

Property PrivRuleID As %String(TRUNCATE = 1);

Property PrivRuleName As %String(TRUNCATE = 1);

Property PrivRuleValid As %String(TRUNCATE = 1);

Property PrivRuleTypeDR As %String(TRUNCATE = 1);

Property PrivRuleCode As %String(MAXLEN = 20000, TRUNCATE = 1);

Storage Default
{
<Data name="PrivRuleLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserName</Value>
</Value>
<Value name="4">
<Value>ModifyDate</Value>
</Value>
<Value name="5">
<Value>PrivRuleID</Value>
</Value>
<Value name="6">
<Value>PrivRuleName</Value>
</Value>
<Value name="7">
<Value>PrivRuleValid</Value>
</Value>
<Value name="8">
<Value>PrivRuleCode</Value>
</Value>
<Value name="9">
<Value>ID</Value>
</Value>
<Value name="10">
<Value>LogType</Value>
</Value>
<Value name="11">
<Value>PrivRuleTypeDR</Value>
</Value>
<Value name="12">
<Value>IP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleLogD</DataLocation>
<DefaultData>PrivRuleLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PrivRuleLogD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleLogI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
