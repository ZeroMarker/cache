/// Creator:gzj
/// Date:2018-11-09
/// Description:规培生管理子表
Class DHCNMG.HR.MgNurNormativeSub Extends %Persistent
{

Relationship Parref As DHCNMG.HR.MgNurNormative [ Cardinality = parent, Inverse = ChildSub ];

Storage Default
{
<Data name="MgNurNormativeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNormativeSubD</DataLocation>
<DefaultData>MgNurNormativeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNormativeSubI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNormativeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
