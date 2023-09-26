/// Creator:guozj
/// Descriptions:数据权限 
/// Date:2017-11-20
/// 
Class DHCNMG.DB.MgDataLimit Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgDataLimitSub [ Cardinality = children, Inverse = Parref ];

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
<DataLocation>^DHCNMG.DB.MgDataLimitD</DataLocation>
<DefaultData>MgDataLimitDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgDataLimitD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgDataLimitI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgDataLimitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
