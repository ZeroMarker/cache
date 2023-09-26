/// Creator:guozj
/// Descriptions:护理信息（护士角色）
/// Date:2017-08-30
/// 
Class DHCNMG.HR.MgNurRole Extends %Persistent
{

/// 人员档案id
Property RolePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Role_PerDR ];

/// 角色id
Property RoleID As %String [ SqlColumnNumber = 3, SqlFieldName = Role_ID ];

/// 开始日期
Property RoleStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Role_StDate ];

/// 截止日期
Property RoleEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Role_EndDate ];

Index ssid On RolePerDR;

Index date On (RolePerDR, RoleStDate, RoleID);

Index role On (RolePerDR, RoleID);

Index role2 On (RoleID, RolePerDR);

Storage Default
{
<Data name="MgNurRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RolePerDR</Value>
</Value>
<Value name="3">
<Value>RoleID</Value>
</Value>
<Value name="4">
<Value>RoleStDate</Value>
</Value>
<Value name="5">
<Value>RoleEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurRoleD</DataLocation>
<DefaultData>MgNurRoleDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurRoleD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurRoleI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
