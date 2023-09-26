Class CHSS.PersonTrainingRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RecordRowId, SqlTableName = PersonTrainingRecord ]
{

/// 训练编号
Property TrainRowId As CHSS.PersonDeformityTraining;

/// 训练日期
Property DateOfTrain As %Date;

/// 下次训练日期
Property DateOfNextTrain As %Date;

/// 执行医生
Property Doctor As %String(MAXLEN = 60, TRUNCATE = 1);

/// 训练记录
Property TrainContent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 训练情况
Property TrainInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PersonTrainingRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfNextTrain</Value>
</Value>
<Value name="3">
<Value>DateOfTrain</Value>
</Value>
<Value name="4">
<Value>Doctor</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>TrainContent</Value>
</Value>
<Value name="7">
<Value>TrainInfo</Value>
</Value>
<Value name="8">
<Value>TrainRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonTrainingRecordD</DataLocation>
<DefaultData>PersonTrainingRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonTrainingRecordD</IdLocation>
<IndexLocation>^CHSS.PersonTrainingRecordI</IndexLocation>
<StreamLocation>^CHSS.PersonTrainingRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
