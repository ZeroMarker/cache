Class User.DHCMGNurTrain Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property TrainNur As User.DHCMGPersons;

Property TrainDep As %String(TRUNCATE = 1);

Property TrainContent As %String(TRUNCATE = 1);

//主办单位

Property TrainUnit As %String(TRUNCATE = 1);

//学习地点

Property TrainPlace As %String(TRUNCATE = 1);

//学分类型

Property TrainSign As %String(TRUNCATE = 1);

//学分

Property TrainPoint As %String(TRUNCATE = 1);

Property TrainStDate As %Library.Date(FORMAT = 1);

//

Property TrainEnDate As %Library.Date(FORMAT = 1);

Index DateDep On (TrainStDate, TrainDep);

Index Nur On TrainNur;

Storage Default
{
<Data name="DHCMGNurTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrainDep</Value>
</Value>
<Value name="3">
<Value>TrainEnDate</Value>
</Value>
<Value name="4">
<Value>TrainNur</Value>
</Value>
<Value name="5">
<Value>TrainStDate</Value>
</Value>
<Value name="6">
<Value>TrainContent</Value>
</Value>
<Value name="7">
<Value>TrainPlace</Value>
</Value>
<Value name="8">
<Value>TrainPoint</Value>
</Value>
<Value name="9">
<Value>TrainSign</Value>
</Value>
<Value name="10">
<Value>TrainUnit</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurTrainD</DataLocation>
<DefaultData>DHCMGNurTrainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurTrainD</IdLocation>
<IndexLocation>^User.DHCMGNurTrainI</IndexLocation>
<StreamLocation>^User.DHCMGNurTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
