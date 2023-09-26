Class EMRmeta.ChildUsers Extends %Persistent
{

Property UserID As %String;

Property SSGroupID As %String;

Relationship ParRef As EMRmeta.PowerUser [ Cardinality = parent, Inverse = ChildUser ];

Index IdxParRef On (ParRef, UserID) [ Unique ];

Storage Default
{
<Data name="ChildUsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildUsers")</DataLocation>
<DefaultData>ChildUsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PowerUserC("ChildUsers")</IdLocation>
<IndexLocation>^DHCEMRM.ChildUsersI</IndexLocation>
<StreamLocation>^DHCEMRM.ChildUsersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
