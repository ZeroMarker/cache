/// Creator:gzj
/// Date:2018-07-12
/// Decription:安全小组子表
Class DHCNMG.Set.MgSecurityGroupSub Extends %Persistent
{

Relationship Parref As DHCNMG.Set.MgSecurityGroup [ Cardinality = parent, Inverse = ChildSub ];

/// 成员
Property GroupMember As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Member ];

/// 组长
Property GroupHeader As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Header ];

/// 病区
Property GroupWards As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Group_Wards ];

Storage Default
{
<Data name="MgSecurityGroupSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupMember</Value>
</Value>
<Value name="3">
<Value>GroupHeader</Value>
</Value>
<Value name="4">
<Value>GroupWards</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgSecurityGroupSubD</DataLocation>
<DefaultData>MgSecurityGroupSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgSecurityGroupSubI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgSecurityGroupSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
