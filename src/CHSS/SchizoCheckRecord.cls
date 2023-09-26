Class CHSS.SchizoCheckRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = SchizoCheckRecord ]
{

//治疗效果

/// 外键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property CheckType As CHSS.DictCheckType;

Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

Property DateCheck As %Date(FORMAT = 1);

Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property OtherSymptom As %String(MAXLEN = 60, TRUNCATE = 1);

Property HeartRate As %Numeric;

Property nLowPressure As %Numeric;

Property nHighPressure As %Numeric;

Property InsightInfo As CHSS.DictInSight;

Property SleepInfo As CHSS.DictSleepStatus;

Property DeitInfo As CHSS.DictSleepStatus;

Property SelfCare As CHSS.DictSleepStatus;

Property Housework As CHSS.DictSleepStatus;

Property ProductiveLabour As CHSS.DictSleepStatus;

Property StudyAbility As CHSS.DictSleepStatus;

Property HumanCommunication As CHSS.DictSleepStatus;

Property PhysicalDisease As %String(MAXLEN = 100, TRUNCATE = 1);

Property LaboratoryExamination As %String(MAXLEN = 100, TRUNCATE = 1);

Property ComplyDoctor As CHSS.DictComplyDoctor;

Property DoseComplier As CHSS.DictDrugRegularityRate;

Property bAdverseEffects As %String(MAXLEN = 5, TRUNCATE = 1);

Property DrugOfAdverseEffects As %String(MAXLEN = 50, TRUNCATE = 1);

Property EvaluationCategory As CHSS.DictEvaluationCategory;

Property RehabilitationMeasure As %String(MAXLEN = 100, TRUNCATE = 1);

Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

Property TransferHospital As %String(MAXLEN = 80, TRUNCATE = 1);

Property AdvisoryOpinion As %String(MAXLEN = 100, TRUNCATE = 1);

Property StaffInput As User.SSUser;

Property DateOfInput As %Date(FORMAT = 1);

Property DateOfUpdate As %Date(FORMAT = 1);

Property bBooking As %String(MAXLEN = 5, TRUNCATE = 1);

Property DateOfNextCheck As %Date(FORMAT = 1);

Property TransferReason As %String(MAXLEN = 100, TRUNCATE = 1);

Property CureEffect As CHSS.DictCureEffect;

Index PersonRowIdIndex On PersonRowId;

Storage Default
{
<Data name="SchizoCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdvisoryOpinion</Value>
</Value>
<Value name="3">
<Value>CheckAdd</Value>
</Value>
<Value name="4">
<Value>CheckDoctor</Value>
</Value>
<Value name="5">
<Value>CheckType</Value>
</Value>
<Value name="6">
<Value>DateCheck</Value>
</Value>
<Value name="7">
<Value>DateOfInput</Value>
</Value>
<Value name="8">
<Value>DateOfNextCheck</Value>
</Value>
<Value name="9">
<Value>DateOfUpdate</Value>
</Value>
<Value name="10">
<Value>DeitInfo</Value>
</Value>
<Value name="11">
<Value>DoseComplier</Value>
</Value>
<Value name="12">
<Value>DrugOfAdverseEffects</Value>
</Value>
<Value name="13">
<Value>EvaluationCategory</Value>
</Value>
<Value name="14">
<Value>HeartRate</Value>
</Value>
<Value name="15">
<Value>Housework</Value>
</Value>
<Value name="16">
<Value>HumanCommunication</Value>
</Value>
<Value name="17">
<Value>InsightInfo</Value>
</Value>
<Value name="18">
<Value>LaboratoryExamination</Value>
</Value>
<Value name="19">
<Value>OtherSymptom</Value>
</Value>
<Value name="20">
<Value>PersonRowId</Value>
</Value>
<Value name="21">
<Value>PhysicalDisease</Value>
</Value>
<Value name="22">
<Value>ProductiveLabour</Value>
</Value>
<Value name="23">
<Value>RehabilitationMeasure</Value>
</Value>
<Value name="24">
<Value>SelfCare</Value>
</Value>
<Value name="25">
<Value>SleepInfo</Value>
</Value>
<Value name="26">
<Value>StaffInput</Value>
</Value>
<Value name="27">
<Value>StudyAbility</Value>
</Value>
<Value name="28">
<Value>Symptom</Value>
</Value>
<Value name="29">
<Value>TransferHospital</Value>
</Value>
<Value name="30">
<Value>TransferReason</Value>
</Value>
<Value name="31">
<Value>TreatEffection</Value>
</Value>
<Value name="32">
<Value>bAdverseEffects</Value>
</Value>
<Value name="33">
<Value>bTransfer</Value>
</Value>
<Value name="34">
<Value>nHighPressure</Value>
</Value>
<Value name="35">
<Value>nLowPressure</Value>
</Value>
<Value name="36">
<Value>ComplyDoctor</Value>
</Value>
<Value name="37">
<Value>bBooking</Value>
</Value>
<Value name="38">
<Value>CureEffect</Value>
</Value>
<Value name="39">
<Value>EatDrug</Value>
</Value>
</Data>
<DataLocation>^CHSS.SchizoCheckRecordD</DataLocation>
<DefaultData>SchizoCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.SchizoCheckRecordD</IdLocation>
<IndexLocation>^CHSS.SchizoCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.SchizoCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
