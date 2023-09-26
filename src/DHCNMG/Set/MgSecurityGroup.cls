/// Creator:gzj
/// Date:2018-07-12
/// Decription:安全小组
Class DHCNMG.Set.MgSecurityGroup Extends %Persistent
{

Relationship ChildSub As DHCNMG.Set.MgSecurityGroupSub [ Cardinality = children, Inverse = Parref ];

/// 描述
Property SecurityDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Security_Desc ];

/// 不良事件类型
Property SecurityType As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Security_Type ];

Index Desc On SecurityDesc;

Storage Default
{
<Data name="MgSecurityGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SecurityDesc</Value>
</Value>
<Value name="3">
<Value>SecurityCode</Value>
</Value>
<Value name="4">
<Value>SecurityType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgSecurityGroupD</DataLocation>
<DefaultData>MgSecurityGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgSecurityGroupD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgSecurityGroupI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgSecurityGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
