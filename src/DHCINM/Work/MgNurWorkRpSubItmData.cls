/// creator: 
/// Description：日报项目数量统计
/// Date:
Class DHCINM.Work.MgNurWorkRpSubItmData Extends %Persistent
{

Relationship WorkRpWardParref As DHCINM.Work.MgNurWorkRpWard [ Cardinality = parent, Inverse = ChildItmData, Required ];

Property SubItm As %String(TRUNCATE = 1);

Property SubItmNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MgNurWorkRpSubItmDataDefaultData">
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
<DefaultData>MgNurWorkRpSubItmDataDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildItmData")</IdLocation>
<IndexLocation>^DHCINM.Work.MgNurWorkRpA286I</IndexLocation>
<StreamLocation>^DHCINM.Work.MgNurWorkRpA286S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
