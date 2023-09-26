/// Creator:
/// Descriptions:数据权限
/// Date:
Class DHCINM.Set.MgDataLimit Extends %Persistent
{

Relationship ChildSub As DHCINM.Set.MgDataLimitSub [ Cardinality = children, Inverse = Parref ];

/// 角色
Property LimitRole As %String [ SqlColumnNumber = 2, SqlFieldName = Limit_Role ];

/// 人员ID
Property LimitNurse As %String [ SqlColumnNumber = 3, SqlFieldName = Limit_Nurse ];

/// 备注
Property LimitRemark As %String [ SqlColumnNumber = 4, SqlFieldName = Limit_Remark ];

Index Role On (LimitRole, LimitNurse);

Storage Default
{
<Data name="MgDataLimitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LimitRole</Value>
</Value>
<Value name="3">
<Value>LimitNurse</Value>
</Value>
<Value name="4">
<Value>LimitRemark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Set.MgDataLimitD</DataLocation>
<DefaultData>MgDataLimitDefaultData</DefaultData>
<IdLocation>^DHCINM.Set.MgDataLimitD</IdLocation>
<IndexLocation>^DHCINM.Set.MgDataLimitI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgDataLimitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
