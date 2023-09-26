Class CHSS.PersonDeformityTraining Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = TrainRowId, SqlTableName = PersonDeformityTraining ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 肢体康复类别
Property RecoverType As CHSS.DictRecoverType;

/// 是否伴有其他疾病
Property bOtherDisease As %String(MAXLEN = 60, TRUNCATE = 1);

/// 患病日期
Property DateOfDisease As %Date;

/// 患病原因
Property ReasonOfDisease As %String(MAXLEN = 60, TRUNCATE = 1);

/// 既往康复情况
Property RecoverHistory As %String(MAXLEN = 60, TRUNCATE = 1);

/// 既往康复效果
Property RecoverEffect As CHSS.DictRecoverEffect;

/// 诊断机构
Property DiagnoseHospital As %String(MAXLEN = 60, TRUNCATE = 1);

/// 诊断效果
Property DiagnoseEffect As %String(MAXLEN = 60, TRUNCATE = 1);

/// 主要障碍及困难
Property MainHandicap As %String(MAXLEN = 60, TRUNCATE = 1);

/// 其他主要障碍及困难
Property MainHandicapOther As %String(MAXLEN = 60, TRUNCATE = 1);

/// 填表人
Property Operator As %String(MAXLEN = 60, TRUNCATE = 1);

/// 填表日期
Property DateOfRegister As %Date;

/// 训练监护人
Property Guardian As %String(MAXLEN = 60, TRUNCATE = 1);

/// 与康复者关系
Property GuardianKin As CHSS.DictKin;

Storage Default
{
<Data name="PersonDeformityTrainingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfDisease</Value>
</Value>
<Value name="3">
<Value>DateOfRegister</Value>
</Value>
<Value name="4">
<Value>DiagnoseEffect</Value>
</Value>
<Value name="5">
<Value>DiagnoseHospital</Value>
</Value>
<Value name="6">
<Value>Guardian</Value>
</Value>
<Value name="7">
<Value>GuardianKin</Value>
</Value>
<Value name="8">
<Value>MainHandicap</Value>
</Value>
<Value name="9">
<Value>MainHandicapOther</Value>
</Value>
<Value name="10">
<Value>Operator</Value>
</Value>
<Value name="11">
<Value>PersonRowId</Value>
</Value>
<Value name="12">
<Value>ReasonOfDisease</Value>
</Value>
<Value name="13">
<Value>RecoverEffect</Value>
</Value>
<Value name="14">
<Value>RecoverHistory</Value>
</Value>
<Value name="15">
<Value>RecoverType</Value>
</Value>
<Value name="16">
<Value>bOtherDisease</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonDeformityTrainingD</DataLocation>
<DefaultData>PersonDeformityTrainingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonDeformityTrainingD</IdLocation>
<IndexLocation>^CHSS.PersonDeformityTrainingI</IndexLocation>
<StreamLocation>^CHSS.PersonDeformityTrainingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
