/// Creator:guozj
/// Descriptions:数据权限：人员所辖护理单元
/// Date:2017-11-20
/// 
Class DHCNMG.DB.MgDataLimitSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgDataLimit [ Cardinality = parent, Inverse = ChildSub ];

/// 护理单元
Property SubWard As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_Ward ];

Storage Default
{
<Data name="MgDataLimitSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubWard</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgDataLimitSubD</DataLocation>
<DefaultData>MgDataLimitSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgDataLimitSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgDataLimitSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
