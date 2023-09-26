Class User.DHCMGNurMonReportHol Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理人员出勤

Relationship HolParref As User.DHCMGNurMonReport [ Cardinality = parent, Inverse = ChildSubHol ];

Property HolNur As %String(TRUNCATE = 1);

Property HolHolDr As %String(TRUNCATE = 1);

Property HolHolNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGNurMonReportHolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolHolDr</Value>
</Value>
<Value name="3">
<Value>HolHolNum</Value>
</Value>
<Value name="4">
<Value>HolNur</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSubHol")</DataLocation>
<DefaultData>DHCMGNurMonReportHolDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurMonReportC("ChildSubHol")</IdLocation>
<IndexLocation>^User.DHCMGNurMonReportHolI</IndexLocation>
<StreamLocation>^User.DHCMGNurMonReportHolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
