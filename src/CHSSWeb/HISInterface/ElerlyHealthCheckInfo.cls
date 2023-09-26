Class CHSSWeb.HISInterface.ElerlyHealthCheckInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property CheckRowId As %String;

Property PersonRowId As %String(TRUNCATE = 1);

Property DateCheck As %Date;

Property CheckAdd As %String(TRUNCATE = 1);

Property CheckDoctor As %String(TRUNCATE = 1);

Property StaffInput As %Integer;

Property StaffInputName As %String;

Property DateOfInput As %Date;

Property DateOfUpdate As %Date;

Property TargetOfNextCheck As %String(TRUNCATE = 1);

Property BookingDate As %Date;

Property bBooking As %String(TRUNCATE = 1);

Property Symptom As %Integer;

Property SymptomName As %String;

Property NewSymptom As %String(TRUNCATE = 1);

Property NewSymptomName As %String;

Property OlsSymptom As %String(TRUNCATE = 1);

Property OlsSymptomName As %String;

Property MentalStatus As %String(TRUNCATE = 1);

Property PsychologyStatus As %Integer;

Property PsychologyStatusName As %String;

Property HighPressure As %Numeric;

Property LowPressure As %Numeric;

Property HeartRate As %Numeric;

Property Weight As %Float;

Property Height As %Float;

Property BMI As %Float;

Property Food As %Integer;

Property FoodName As %String;

Property MentalityAdjust As %String(TRUNCATE = 1);

Property EduKnowledge As %String(TRUNCATE = 1);

Property EduKnowledgeValue As %String;

Property EduKnowledgeAim As %String(TRUNCATE = 1);

Property bSmoke As %String(TRUNCATE = 1);

Property Smoke As %String;

Property SmokeNum As %Integer;

Property DateOfStopSmoke As %Date;

Property bDrink As %String(TRUNCATE = 1);

Property Drink As %String;

Property DrinkQuentity As %Float;

Property DateOfStopDrink As %Date;

Property Exercise As %String(TRUNCATE = 1);

Property DrugRegularity As %Integer;

Property DrugRegularityName As %String;

Property EatDrug As %String(TRUNCATE = 1);

Property ExerciseNum As %Numeric;

Property ExerciseMin As %Numeric;

Property BloodAfterDining As %String(TRUNCATE = 1);

Property BloodAfterDiningOfTwo As %String(TRUNCATE = 1);

Property BloodSurgeLimosis As %String(TRUNCATE = 1);

Property NeedTransfer As %String(TRUNCATE = 1);

Property PsychologyOfCoaching As %String(TRUNCATE = 1);

Property Drepress As %String(TRUNCATE = 1);

Property ComplyDoctor As %Integer;

Property ComplyDoctorName As %String;

Property GiveVaccination As %String(TRUNCATE = 1);

Property DefendOfCoronary As %String(TRUNCATE = 1);

Property DefendOfOsteoporosis As %String(TRUNCATE = 1);

Property CaseType As %Integer;

Property CaseTypeName As %String;

Property EyegroundCheck As %Integer;

Property EyegroundCheckName As %String;

Property TransferEachOther As %String(TRUNCATE = 1);

Property TransferReason As %String(TRUNCATE = 1);

Property NoComplaints As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ElerlyHealthCheckInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>BloodAfterDining</Value>
</Value>
<Value name="4">
<Value>BloodAfterDiningOfTwo</Value>
</Value>
<Value name="5">
<Value>BloodSurgeLimosis</Value>
</Value>
<Value name="6">
<Value>BookingDate</Value>
</Value>
<Value name="7">
<Value>CaseType</Value>
</Value>
<Value name="8">
<Value>CheckAdd</Value>
</Value>
<Value name="9">
<Value>CheckDoctor</Value>
</Value>
<Value name="10">
<Value>ComplyDoctor</Value>
</Value>
<Value name="11">
<Value>DateCheck</Value>
</Value>
<Value name="12">
<Value>DateOfInput</Value>
</Value>
<Value name="13">
<Value>DateOfStopDrink</Value>
</Value>
<Value name="14">
<Value>DateOfStopSmoke</Value>
</Value>
<Value name="15">
<Value>DateOfUpdate</Value>
</Value>
<Value name="16">
<Value>DefendOfCoronary</Value>
</Value>
<Value name="17">
<Value>DefendOfOsteoporosis</Value>
</Value>
<Value name="18">
<Value>Drepress</Value>
</Value>
<Value name="19">
<Value>DrinkQuentity</Value>
</Value>
<Value name="20">
<Value>DrugRegularity</Value>
</Value>
<Value name="21">
<Value>EatDrug</Value>
</Value>
<Value name="22">
<Value>EduKnowledge</Value>
</Value>
<Value name="23">
<Value>EduKnowledgeAim</Value>
</Value>
<Value name="24">
<Value>Exercise</Value>
</Value>
<Value name="25">
<Value>ExerciseMin</Value>
</Value>
<Value name="26">
<Value>ExerciseNum</Value>
</Value>
<Value name="27">
<Value>EyegroundCheck</Value>
</Value>
<Value name="28">
<Value>Food</Value>
</Value>
<Value name="29">
<Value>GiveVaccination</Value>
</Value>
<Value name="30">
<Value>HeartRate</Value>
</Value>
<Value name="31">
<Value>Height</Value>
</Value>
<Value name="32">
<Value>HighPressure</Value>
</Value>
<Value name="33">
<Value>LowPressure</Value>
</Value>
<Value name="34">
<Value>MentalStatus</Value>
</Value>
<Value name="35">
<Value>MentalityAdjust</Value>
</Value>
<Value name="36">
<Value>NeedTransfer</Value>
</Value>
<Value name="37">
<Value>NewSymptom</Value>
</Value>
<Value name="38">
<Value>OlsSymptom</Value>
</Value>
<Value name="39">
<Value>PersonRowId</Value>
</Value>
<Value name="40">
<Value>PsychologyOfCoaching</Value>
</Value>
<Value name="41">
<Value>PsychologyStatus</Value>
</Value>
<Value name="42">
<Value>SmokeNum</Value>
</Value>
<Value name="43">
<Value>StaffInput</Value>
</Value>
<Value name="44">
<Value>Symptom</Value>
</Value>
<Value name="45">
<Value>TargetOfNextCheck</Value>
</Value>
<Value name="46">
<Value>TransferEachOther</Value>
</Value>
<Value name="47">
<Value>TransferReason</Value>
</Value>
<Value name="48">
<Value>Weight</Value>
</Value>
<Value name="49">
<Value>bBooking</Value>
</Value>
<Value name="50">
<Value>bDrink</Value>
</Value>
<Value name="51">
<Value>bSmoke</Value>
</Value>
<Value name="52">
<Value>StaffInputName</Value>
</Value>
<Value name="53">
<Value>SymptomName</Value>
</Value>
<Value name="54">
<Value>PsychologyStatusName</Value>
</Value>
<Value name="55">
<Value>FoodName</Value>
</Value>
<Value name="56">
<Value>Smoke</Value>
</Value>
<Value name="57">
<Value>Drink</Value>
</Value>
<Value name="58">
<Value>DrugRegularityName</Value>
</Value>
<Value name="59">
<Value>NoComplaints</Value>
</Value>
<Value name="60">
<Value>ComplyDoctorName</Value>
</Value>
<Value name="61">
<Value>CaseTypeName</Value>
</Value>
<Value name="62">
<Value>EyegroundCheckName</Value>
</Value>
<Value name="63">
<Value>CheckRowId</Value>
</Value>
<Value name="64">
<Value>NewSymptomName</Value>
</Value>
<Value name="65">
<Value>OlsSymptomName</Value>
</Value>
<Value name="66">
<Value>EduKnowledgeValue</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.ElerlyHealth82DD</DataLocation>
<DefaultData>ElerlyHealthCheckInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.ElerlyHealth82DD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.ElerlyHealth82DI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.ElerlyHealth82DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
