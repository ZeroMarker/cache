/// creator: xbl
/// createdate: 20180108
/// description: 开展新业务新技术
Class DHCNMG.Arg.MgNurTrainSub Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgNurTrain [ Cardinality = parent, Inverse = ChildSub ];

/// 参见培训人员
Property TrainPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Train_PerDR ];

/// 成绩
Property TrainScore As %Float [ SqlColumnNumber = 5, SqlFieldName = Train_Score ];

Index Person On TrainPerDR;

Storage Default
{
<Data name="MgNurTrainSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrainPerDR</Value>
</Value>
<Value name="3">
<Value>TrainScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurTrainSubD</DataLocation>
<DefaultData>MgNurTrainSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurTrainSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurTrainSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
