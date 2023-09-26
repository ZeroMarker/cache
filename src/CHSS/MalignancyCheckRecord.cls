Class CHSS.MalignancyCheckRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CheckRowId, SqlTableName = MalignancyCheckRecord ]
{

//备注	

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property DateCheck As %Date(FORMAT = 1);

Property CheckType As CHSS.DictCheckType;

Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property OtherSymptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

Property nHighPressure As %Numeric;

Property nLowPressure As %Numeric;

Property HeartRate As %Numeric;

Property OtherCheck As %String(MAXLEN = 100, TRUNCATE = 1);

Property Weight As %Float;

Property Height As %Float;

Property BMI As %Float;

Property CureSituation As CHSS.DictCureSituation;

Property bRelapse As %String(MAXLEN = 5, TRUNCATE = 1);

Property RelapseNum As %Numeric;

Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

Property TransferPart As %String(MAXLEN = 60, TRUNCATE = 1);

Property CurrentSymptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property bSmoke As %String(MAXLEN = 5, TRUNCATE = 1);

Property KPS As CHSS.DictKPS;

Property Guide As CHSS.DictGuide;

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

Index PersonRowIdParrefIndex On PersonRowId;

Storage Default
{
<Data name="MalignancyCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
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
<Value>CureSituation</Value>
</Value>
<Value name="7">
<Value>CurrentSymptom</Value>
</Value>
<Value name="8">
<Value>DateCheck</Value>
</Value>
<Value name="9">
<Value>Guide</Value>
</Value>
<Value name="10">
<Value>HeartRate</Value>
</Value>
<Value name="11">
<Value>Height</Value>
</Value>
<Value name="12">
<Value>KPS</Value>
</Value>
<Value name="13">
<Value>OtherCheck</Value>
</Value>
<Value name="14">
<Value>OtherSymptom</Value>
</Value>
<Value name="15">
<Value>PersonRowId</Value>
</Value>
<Value name="16">
<Value>RelapseNum</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
<Value name="18">
<Value>Symptom</Value>
</Value>
<Value name="19">
<Value>TransferPart</Value>
</Value>
<Value name="20">
<Value>Weight</Value>
</Value>
<Value name="21">
<Value>bRelapse</Value>
</Value>
<Value name="22">
<Value>bSmoke</Value>
</Value>
<Value name="23">
<Value>bTransfer</Value>
</Value>
<Value name="24">
<Value>nHighPressure</Value>
</Value>
<Value name="25">
<Value>nLowPressure</Value>
</Value>
</Data>
<DataLocation>^CHSS.MalignancyCheckRecordD</DataLocation>
<DefaultData>MalignancyCheckRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.MalignancyCheckRecordD</IdLocation>
<IndexLocation>^CHSS.MalignancyCheckRecordI</IndexLocation>
<StreamLocation>^CHSS.MalignancyCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
