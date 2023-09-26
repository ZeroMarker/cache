/// Creator:gzj
/// Date:2018-10-29
/// Descriptions:来院进修人员进修情况
Class DHCNMG.HR.MgNurTrainInfo Extends %Persistent
{

/// 进修护士
Property TrainNurse As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Train_Nurse ];

/// 建议
Property TrainSuggest As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Train_Suggest ];

Storage Default
{
<Data name="MgNurTrainInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrainNurse</Value>
</Value>
<Value name="3">
<Value>TrainSuggest</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurTrainInfoD</DataLocation>
<DefaultData>MgNurTrainInfoDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgNurTrainInfoD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurTrainInfoI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurTrainInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
