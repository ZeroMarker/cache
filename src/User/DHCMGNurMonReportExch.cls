Class User.DHCMGNurMonReportExch Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//借入借出人员记录

Relationship ExchParref As User.DHCMGNurMonReport [ Cardinality = parent, Inverse = ChildSubExch ];

Property ExchTyp As %String(TRUNCATE = 1);

Property ExchNur As %String(TRUNCATE = 1);

Property ExchDate As %Library.Date(FORMAT = 1);

Property ExchDep As %String(TRUNCATE = 1);

Property ExchDays As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGNurMonReportExchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExchDate</Value>
</Value>
<Value name="3">
<Value>ExchDays</Value>
</Value>
<Value name="4">
<Value>ExchDep</Value>
</Value>
<Value name="5">
<Value>ExchNur</Value>
</Value>
<Value name="6">
<Value>ExchTyp</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSubExch")</DataLocation>
<DefaultData>DHCMGNurMonReportExchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurMonReportC("ChildSubExch")</IdLocation>
<IndexLocation>^User.DHCMGNurMonReportExchI</IndexLocation>
<StreamLocation>^User.DHCMGNurMonReportExchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
