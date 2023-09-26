/// 
/// 
/// 外派进修总结
Class DHCNMG.HR.MgNurTrainingSub Extends %Persistent
{

Relationship Parref As DHCNMG.HR.MgNurTraining [ Cardinality = parent, Inverse = ChildSub ];

/// 进修收获
Property TrainHarvest As %String(MAXLEN = 2000) [ SqlColumnNumber = 2, SqlFieldName = Train_Harvest ];

/// 开展项目或新工作
Property TrainWork As %String(MAXLEN = 2000) [ SqlColumnNumber = 3, SqlFieldName = Train_Work ];

/// 效果评价
Property TrainEvaluate As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Train_Evaluate ];

/// 评价日期
Property TrainEvaDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Train_EvaDate ];

/// 评价人
Property EvaluateUser As %String [ SqlColumnNumber = 6, SqlFieldName = Evaluate_User ];

Storage Default
{
<Data name="MgNurTrainingSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrainHarvest</Value>
</Value>
<Value name="3">
<Value>TrainWork</Value>
</Value>
<Value name="4">
<Value>TrainEvaluate</Value>
</Value>
<Value name="5">
<Value>TrainEvaDate</Value>
</Value>
<Value name="6">
<Value>EvaluateUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurTrainingSubD</DataLocation>
<DefaultData>MgNurTrainingSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurTrainingSubI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurTrainingSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
