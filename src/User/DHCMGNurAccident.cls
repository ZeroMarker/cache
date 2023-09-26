Class User.DHCMGNurAccident Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//事故

Property AccidentDep As %String(TRUNCATE = 1);

Property AccidentNur As User.DHCMGPersons;

Property Accidentdate As %Library.Date(FORMAT = 1);

//事故内容

Property Accidentcontent As %String(TRUNCATE = 1);

//事故性质

Property Accidentsort As %String(TRUNCATE = 1);

//处理结果

Property AccidentDealresult As %String(TRUNCATE = 1);

Index depnur On (AccidentDep, AccidentNur);

Index DateDep On (Accidentdate, AccidentDep);

Storage Default
{
<Data name="DHCMGNurAccidentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccidentDep</Value>
</Value>
<Value name="3">
<Value>AccidentNur</Value>
</Value>
<Value name="4">
<Value>Accidentcontent</Value>
</Value>
<Value name="5">
<Value>Accidentdate</Value>
</Value>
<Value name="6">
<Value>Accidentsort</Value>
</Value>
<Value name="7">
<Value>AccidentDealresult</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurAccidentD</DataLocation>
<DefaultData>DHCMGNurAccidentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurAccidentD</IdLocation>
<IndexLocation>^User.DHCMGNurAccidentI</IndexLocation>
<StreamLocation>^User.DHCMGNurAccidentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
