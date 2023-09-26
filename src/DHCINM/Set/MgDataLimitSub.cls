/// Creator:
/// Descriptions:数据权限子表
/// Date:
Class DHCINM.Set.MgDataLimitSub Extends %Persistent
{

Relationship Parref As DHCINM.Set.MgDataLimit [ Cardinality = parent, Inverse = ChildSub ];

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
<DataLocation>^DHCINM.Set.MgDataLimitSubD</DataLocation>
<DefaultData>MgDataLimitSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Set.MgDataLimitSubI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgDataLimitSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
