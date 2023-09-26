/// 
/// 
/// 关联HIS安全组
Class DHCNMG.Set.MgNurSecLinkRole Extends %Persistent
{

/// HIS安全组ID【User.SSGroup 】
Property SecGroup As %String [ SqlColumnNumber = 2, SqlFieldName = Sec_Group ];

/// 护管角色ID
Property SecRole As %String [ SqlColumnNumber = 3, SqlFieldName = Sec_Role ];

Property SecStatus As %String [ SqlColumnNumber = 4, SqlFieldName = Sec_Status ];

Index sec On (SecGroup, SecRole);

Storage Default
{
<Data name="MgNurSecLinkRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SecGroup</Value>
</Value>
<Value name="3">
<Value>SecRole</Value>
</Value>
<Value name="4">
<Value>SecStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgNurSecLinkRoleD</DataLocation>
<DefaultData>MgNurSecLinkRoleDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgNurSecLinkRoleD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgNurSecLinkRoleI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgNurSecLinkRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
