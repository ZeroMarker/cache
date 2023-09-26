Class EMRmeta.Auth.AuthPrivRuleKey Extends (%Persistent, User.Abstract)
{

Property KeyCode As %String;

Property KeyName As %String;

Property Seq As %String;

Property IsActive As %String;

Index IdxActiveSeq On (IsActive, Seq);

Index IdKeyCode On (KeyCode, KeyName);

Storage Default
{
<Data name="AuthPrivRuleKeyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyCode</Value>
</Value>
<Value name="3">
<Value>KeyName</Value>
</Value>
<Value name="4">
<Value>Seq</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.AuthPrivRuleKeyD</DataLocation>
<DefaultData>AuthPrivRuleKeyDefaultData</DefaultData>
<IdLocation>^DHCEMRM.AuthPrivRuleKeyD</IdLocation>
<IndexLocation>^DHCEMRM.AuthPrivRuleKeyI</IndexLocation>
<StreamLocation>^DHCEMRM.AuthPrivRuleKeyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
