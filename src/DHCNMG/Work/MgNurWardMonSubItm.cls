/// creator: zhangjz
/// Description：月报项目数量明细
/// Date:2018-08-20
Class DHCNMG.Work.MgNurWardMonSubItm Extends %Persistent
{

Relationship WorkRpWardParref As DHCNMG.Work.MgNurWardMonSub [ Cardinality = parent, Inverse = ChildItmData, Required ];

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
<IdLocation>^DHCNMG.Work.MgNurWardMonSubC("ChildItmData")</IdLocation>
<IndexLocation>^DHCNMG.Work.MgNurWardMonSubItmI</IndexLocation>
<StreamLocation>^DHCNMG.Work.MgNurWardMonSubItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
