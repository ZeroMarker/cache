Class CHSS.PersonTrainingItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ItemRowId, SqlTableName = PersonTrainingItem ]
{

/// 评估记录
Property EvaluateRowId As CHSS.PersonTrainingEvaluation;

/// 训练项目
Property RowIdDR As CHSS.DictTrainingItem;

/// 分数
Property Score As %Float;

/// 程度
Property DegreeDR As CHSS.DictTrainingItemVsDegree;

Storage Default
{
<Data name="PersonTrainingItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DegreeDR</Value>
</Value>
<Value name="3">
<Value>EvaluateRowId</Value>
</Value>
<Value name="4">
<Value>RowIdDR</Value>
</Value>
<Value name="5">
<Value>Score</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonTrainingItemD</DataLocation>
<DefaultData>PersonTrainingItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonTrainingItemD</IdLocation>
<IndexLocation>^CHSS.PersonTrainingItemI</IndexLocation>
<StreamLocation>^CHSS.PersonTrainingItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
