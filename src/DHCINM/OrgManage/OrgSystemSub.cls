/// Creater:dhh
/// Descriptions:制度维护子表
/// Date:2020-07-27
Class DHCINM.OrgManage.OrgSystemSub Extends %Persistent
{

Relationship Parref As DHCINM.OrgManage.OrgSystem [ Cardinality = parent, Inverse = ChildSub ];

/// 制度
Property SystemLoad As %String [ SqlColumnNumber = 3, SqlFieldName = SystemItem_Load ];

Storage Default
{
<Data name="OrgSystemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemLoad</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>OrgSystemSubDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.OrgSystemC("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.OrgManage.OrgSystemSubI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.OrgSystemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
