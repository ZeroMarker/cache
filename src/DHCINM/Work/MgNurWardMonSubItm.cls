/// creator: 
/// Description：月报项目数量明细
/// Date:
Class DHCINM.Work.MgNurWardMonSubItm Extends %Persistent
{

Relationship WorkRpWardParref As DHCINM.Work.MgNurWardMonSub [ Cardinality = parent, Inverse = ChildItmData, Required ];

Property SubItm As %String(TRUNCATE = 1);

Property SubItmNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MgNurWardMonSubItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubItm</Value>
</Value>
<Value name="3">
<Value>SubItmNum</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildItmData")</DataLocation>
<DefaultData>MgNurWardMonSubItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildItmData")</IdLocation>
<IndexLocation>^DHCINM.Work.MgNurWardMon533I</IndexLocation>
<StreamLocation>^DHCINM.Work.MgNurWardMon533S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
