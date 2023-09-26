Class CHSS.PersonTrainingEvaluation Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = EvaluateRowId, SqlTableName = PersonTrainingEvaluation ]
{

/// 训练编号
Property TrainRowId As CHSS.PersonDeformityTraining;

/// 评估分数
Property EvaluateScore As %Float;

/// 训练效果
Property TrainEffect As CHSS.DictTrainEffect;

/// 执行训练计划的情况
Property ExecuteInfo As %String(MAXLEN = 500);

/// 存在哪些问题
Property Problem As %String(MAXLEN = 500);

/// 进一步的康复意见
Property HealingSuggestion As %String(MAXLEN = 500);

/// 其它
Property Other As %String(MAXLEN = 100);

/// 评估人
Property EvaluateMan As %String(MAXLEN = 50);

/// 评估日期
Property DateOfEvaluate As %Date;

Storage Default
{
<Data name="PersonTrainingEvaluationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfEvaluate</Value>
</Value>
<Value name="3">
<Value>EvaluateMan</Value>
</Value>
<Value name="4">
<Value>EvaluateScore</Value>
</Value>
<Value name="5">
<Value>ExecuteInfo</Value>
</Value>
<Value name="6">
<Value>HealingSuggestion</Value>
</Value>
<Value name="7">
<Value>Other</Value>
</Value>
<Value name="8">
<Value>Problem</Value>
</Value>
<Value name="9">
<Value>TrainEffect</Value>
</Value>
<Value name="10">
<Value>TrainRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonTrainingEvaluationD</DataLocation>
<DefaultData>PersonTrainingEvaluationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonTrainingEvaluationD</IdLocation>
<IndexLocation>^CHSS.PersonTrainingEvaluationI</IndexLocation>
<StreamLocation>^CHSS.PersonTrainingEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
