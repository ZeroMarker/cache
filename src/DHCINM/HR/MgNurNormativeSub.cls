Class DHCINM.HR.MgNurNormativeSub Extends %Persistent
{

Relationship Parref As DHCINM.HR.MgNurNormative [ Cardinality = parent, Inverse = ChildSub ];

Storage Default
{
<Data name="MgNurNormativeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>MgNurNormativeSubDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurNormativeC("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurNormativeSubI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurNormativeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
