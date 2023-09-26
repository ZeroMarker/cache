Class CHSSWeb.HISInterface.PersonSchizoCheckRecordInfo Extends %Persistent
{

Property RowId As %Integer;

Property CheckType As %Integer;

Property CheckTypeName As %String;

Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

Property DateCheck As %Date(FORMAT = 1);

Property Symptom As %String(MAXLEN = 100, TRUNCATE = 1);

Property SymptomName As %String;

Property OtherSymptom As %String(MAXLEN = 60, TRUNCATE = 1);

Property HeartRate As %Numeric;

Property nLowPressure As %Numeric;

Property nHighPressure As %Numeric;

Property InsightInfo As %Integer;

Property InsightInfoName As %String;

Property SleepInfo As %Integer;

Property SleepInfoName As %String;

Property DeitInfo As %Integer;

Property DeitInfoName As %String;

Property SelfCare As %Integer;

Property SelfCareName As %String;

Property Housework As %Integer;

Property HouseworkName As %String;

Property ProductiveLabour As %Integer;

Property ProductiveLabourName As %String;

Property StudyAbility As %Integer;

Property StudyAbilityName As %String;

Property HumanCommunication As %Integer;

Property HumanCommunicationName As %String;

Property PhysicalDisease As %String(MAXLEN = 100, TRUNCATE = 1);

Property LaboratoryExamination As %String(MAXLEN = 100, TRUNCATE = 1);

Property ComplyDoctor As %Integer;

Property ComplyDoctorName As %String;

Property DoseComplier As %Integer;

Property DoseComplierName As %String;

Property bAdverseEffects As %String(MAXLEN = 5, TRUNCATE = 1);

Property DrugOfAdverseEffects As %String(MAXLEN = 50, TRUNCATE = 1);

Property EvaluationCategory As %Integer;

Property EvaluationCategoryName As %String;

Property RehabilitationMeasure As %String(MAXLEN = 100, TRUNCATE = 1);

Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

Property TransferHospital As %String(MAXLEN = 80, TRUNCATE = 1);

Property AdvisoryOpinion As %String(MAXLEN = 100, TRUNCATE = 1);

Property StaffInput As %Integer;

Property StaffInputName As %String;

Property DateOfInput As %Date(FORMAT = 1);

Property DateOfUpdate As %Date(FORMAT = 1);

Property bBooking As %String(MAXLEN = 5, TRUNCATE = 1);

Property DateOfNextCheck As %Date(FORMAT = 1);

Property TransferReason As %String(MAXLEN = 100, TRUNCATE = 1);

Property CureEffect As %Integer;

Property CureEffectName As %String;

Storage Default
{
<Data name="PersonSchizoCheckRecordInfoDefaultData">
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
<Value>ComplyDoctor</Value>
</Value>
<Value name="7">
<Value>CureEffect</Value>
</Value>
<Value name="8">
<Value>DateCheck</Value>
</Value>
<Value name="9">
<Value>DateOfInput</Value>
</Value>
<Value name="10">
<Value>DateOfNextCheck</Value>
</Value>
<Value name="11">
<Value>DateOfUpdate</Value>
</Value>
<Value name="12">
<Value>DeitInfo</Value>
</Value>
<Value name="13">
<Value>DoseComplier</Value>
</Value>
<Value name="14">
<Value>DrugOfAdverseEffects</Value>
</Value>
<Value name="15">
<Value>EvaluationCategory</Value>
</Value>
<Value name="16">
<Value>HeartRate</Value>
</Value>
<Value name="17">
<Value>Housework</Value>
</Value>
<Value name="18">
<Value>HumanCommunication</Value>
</Value>
<Value name="19">
<Value>InsightInfo</Value>
</Value>
<Value name="20">
<Value>LaboratoryExamination</Value>
</Value>
<Value name="21">
<Value>OtherSymptom</Value>
</Value>
<Value name="22">
<Value>PhysicalDisease</Value>
</Value>
<Value name="23">
<Value>ProductiveLabour</Value>
</Value>
<Value name="24">
<Value>RehabilitationMeasure</Value>
</Value>
<Value name="25">
<Value>SelfCare</Value>
</Value>
<Value name="26">
<Value>SleepInfo</Value>
</Value>
<Value name="27">
<Value>StaffInput</Value>
</Value>
<Value name="28">
<Value>StudyAbility</Value>
</Value>
<Value name="29">
<Value>Symptom</Value>
</Value>
<Value name="30">
<Value>TransferHospital</Value>
</Value>
<Value name="31">
<Value>TransferReason</Value>
</Value>
<Value name="32">
<Value>bAdverseEffects</Value>
</Value>
<Value name="33">
<Value>bBooking</Value>
</Value>
<Value name="34">
<Value>bTransfer</Value>
</Value>
<Value name="35">
<Value>nHighPressure</Value>
</Value>
<Value name="36">
<Value>nLowPressure</Value>
</Value>
<Value name="37">
<Value>CheckTypeName</Value>
</Value>
<Value name="38">
<Value>ComplyDoctorName</Value>
</Value>
<Value name="39">
<Value>CureEffectName</Value>
</Value>
<Value name="40">
<Value>DeitInfoName</Value>
</Value>
<Value name="41">
<Value>DoseComplierName</Value>
</Value>
<Value name="42">
<Value>EvaluationCategoryName</Value>
</Value>
<Value name="43">
<Value>HouseworkName</Value>
</Value>
<Value name="44">
<Value>HumanCommunicationName</Value>
</Value>
<Value name="45">
<Value>InsightInfoName</Value>
</Value>
<Value name="46">
<Value>ProductiveLabourName</Value>
</Value>
<Value name="47">
<Value>SelfCareName</Value>
</Value>
<Value name="48">
<Value>SleepInfoName</Value>
</Value>
<Value name="49">
<Value>StaffInputName</Value>
</Value>
<Value name="50">
<Value>StudyAbilityName</Value>
</Value>
<Value name="51">
<Value>SymptomName</Value>
</Value>
<Value name="52">
<Value>RowId</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonSchizoAB0D</DataLocation>
<DefaultData>PersonSchizoCheckRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonSchizoAB0D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonSchizoAB0I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonSchizoAB0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
