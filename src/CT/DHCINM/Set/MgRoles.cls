/// Creator:
/// Descriptions:系统角色表
/// Date:
Class CT.DHCINM.Set.MgRoles Extends %Persistent
{

/// 角色代码
Property RoleCode As %String [ SqlColumnNumber = 2, SqlFieldName = RoleCode ];

/// 角色描述
Property RoleDesc As %String [ SqlColumnNumber = 3, SqlFieldName = RoleDesc ];

/// 角色说明
Property RoleRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 4, SqlFieldName = Role_Remark ];

/// 启用状态
Property RoleStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = Role_Status ];

/// 级别
Property RoleLevel As %Integer [ SqlColumnNumber = 6, SqlFieldName = Role_Level ];

/// 序号
Property RoleSort As %Integer [ SqlColumnNumber = 7, SqlFieldName = Role_Sort ];

Index code On (RoleStatus, RoleCode);

Index desc On (RoleStatus, RoleDesc) [ Unique ];

Index Sort On RoleSort;

Storage Default
{
<Data name="MgRolesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleCode</Value>
</Value>
<Value name="3">
<Value>RoleDesc</Value>
</Value>
<Value name="4">
<Value>RoleRemark</Value>
</Value>
<Value name="5">
<Value>RoleStatus</Value>
</Value>
<Value name="6">
<Value>RoleLevel</Value>
</Value>
<Value name="7">
<Value>RoleSort</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgRolesD</DataLocation>
<DefaultData>MgRolesDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgRolesD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgRolesI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgRolesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
