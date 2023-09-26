Class CHSS.DictTrainingItemVsDegree Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictTrainingItemVsDegree ]
{

/// 流水号
Property ItemRowId As CHSS.DictTrainingItem;

/// 流水号2
Property RowIdParref As CHSS.DictTrainDegree;

/// 分数
Property Score As %Float;

Storage Default
{
<Data name="DictTrainingItemVsDegreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemRowId</Value>
</Value>
<Value name="3">
<Value>RowIdParref</Value>
</Value>
<Value name="4">
<Value>Score</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictTrainingItemVsDegreeD</DataLocation>
<DefaultData>DictTrainingItemVsDegreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictTrainingItemVsDegreeD</IdLocation>
<IndexLocation>^CHSS.DictTrainingItemVsDegreeI</IndexLocation>
<StreamLocation>^CHSS.DictTrainingItemVsDegreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
