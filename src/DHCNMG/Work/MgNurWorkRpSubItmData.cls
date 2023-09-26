/// creator: zhangjz
/// Description：日报项目数量统计
/// Date:2018-08-20
Class DHCNMG.Work.MgNurWorkRpSubItmData Extends %Persistent
{

Relationship WorkRpWardParref As DHCNMG.Work.MgNurWorkRpWard [ Cardinality = parent, Inverse = ChildItmData, Required ];

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
<IndexLocation>^DHCNMG.Work.MgNurWRpSDataI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWRpSDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
