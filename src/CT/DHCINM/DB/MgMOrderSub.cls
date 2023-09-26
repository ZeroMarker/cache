/// Creater:zhengzhong
/// Descriptions:医嘱配置子类
/// Date:2021-06-15
Class CT.DHCINM.DB.MgMOrderSub Extends %Persistent
{

Relationship Parref As CT.DHCINM.DB.MgMOrder [ Cardinality = parent, Inverse = ChildSub ];

/// 关联医嘱项
Property WorkRelArcim As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WorkRelArcim ];

Index ItmArcimInstr On WorkRelArcim;

Storage Default
{
<Data name="MgMOrderSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkRelArcim</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.DB.MgMOrderSubD</DataLocation>
<DefaultData>MgMOrderSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgMOrderSubI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgMOrderSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
