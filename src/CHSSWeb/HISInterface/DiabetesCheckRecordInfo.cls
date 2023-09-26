Class CHSSWeb.HISInterface.DiabetesCheckRecordInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowIdParref As %Integer;

Property DateCheck As %Date;

Property CheckAdd As %String(TRUNCATE = 1);

Property CheckType As %String(TRUNCATE = 1);

Property Symptom As %String(TRUNCATE = 1);

Property OtherSymptom As %String(TRUNCATE = 1);

Property CheckDoctor As %String(TRUNCATE = 1);

Property nHighPressure As %Numeric;

Property nLowPressure As %Numeric;

Property HeartRate As %Numeric;

Property OtherCheck As %String(TRUNCATE = 1);

Property Weight As %Float;

Property Height As %Float;

Property BMI As %Float;

Property FootArteryThrob As %String(TRUNCATE = 1);

Property Food As %Integer;

Property DateOfStopSmoke As %Date;

Property bSmoke As %String(TRUNCATE = 1);

Property Smoke As %String(TRUNCATE = 1);

Property SmokeNum As %Numeric;

Property DateOfStopDrink As %Date;

Property bDrink As %String(TRUNCATE = 1);

Property Drink As %String(TRUNCATE = 1);

Property DrinkQuentity As %Float;

Property Exercise As %String(TRUNCATE = 1);

Property Other As %String(TRUNCATE = 1);

Property WaistlineStern As %Float;

Property BookingDate As %Date;

Property bBooking As %String(TRUNCATE = 1);

Property ExerciseNum As %Numeric;

Property ExerciseMin As %Numeric;

Property DrugSideEffect As %String(TRUNCATE = 1);

Property DoseComplier As %String(TRUNCATE = 1);

Property BloodAfterDining As %String(TRUNCATE = 1);

Property BloodAfterDiningOfTwo As %String(TRUNCATE = 1);

Property BloodSurgeLimosis As %String(TRUNCATE = 1);

Property Cholesterin As %String(TRUNCATE = 1);

Property HbAlC As %String(TRUNCATE = 1);

Property OtherOfBlood As %String(TRUNCATE = 1);

Property Hb As %String(TRUNCATE = 1);

Property NAlbumen As %String(TRUNCATE = 1);

Property NOther As %String(TRUNCATE = 1);

Property SugarInDay As %String(TRUNCATE = 1);

Property UniteIll As %String(TRUNCATE = 1);

Property ComplyDoctor As %Integer;

Property MentalityAdjust As %Integer;

Property bAdverseEffects As %String(TRUNCATE = 1);

Property DrugOfAdverseEffects As %String(TRUNCATE = 1);

Property CheckResult As %Integer;

Property EatDrug As %String(TRUNCATE = 1);

Property Direction As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

Property bTranfer As %String(TRUNCATE = 1);

Property TransferDept As %Integer;

Property TransferReason As %String(TRUNCATE = 1);

Property DrugRegularityRate As %Integer;

Property Deal As %String(TRUNCATE = 1);

Property StaffInput As %Integer;

Property DateOfInput As %Date;

Property DateOfUpdate As %Date;

Property CaseType As %String(TRUNCATE = 1);

Property bCaseTrans As %String(TRUNCATE = 1);

Property BloodSurgeRate As %Integer;

Property Eyeground As %Integer;

Property MentalStatus As %String(TRUNCATE = 1);

Property Waistline As %Float;

Property Stern As %Float;

Storage Default
{
<Data name="DiabetesCheckRecordInfoDefaultData">
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
<Value>BloodSurgeRate</Value>
</Value>
<Value name="7">
<Value>BookingDate</Value>
</Value>
<Value name="8">
<Value>CaseType</Value>
</Value>
<Value name="9">
<Value>CheckAdd</Value>
</Value>
<Value name="10">
<Value>CheckDoctor</Value>
</Value>
<Value name="11">
<Value>CheckResult</Value>
</Value>
<Value name="12">
<Value>Cholesterin</Value>
</Value>
<Value name="13">
<Value>ComplyDoctor</Value>
</Value>
<Value name="14">
<Value>DateCheck</Value>
</Value>
<Value name="15">
<Value>DateOfInput</Value>
</Value>
<Value name="16">
<Value>DateOfStopDrink</Value>
</Value>
<Value name="17">
<Value>DateOfStopSmoke</Value>
</Value>
<Value name="18">
<Value>DateOfUpdate</Value>
</Value>
<Value name="19">
<Value>Deal</Value>
</Value>
<Value name="20">
<Value>Direction</Value>
</Value>
<Value name="21">
<Value>DoseComplier</Value>
</Value>
<Value name="22">
<Value>Drink</Value>
</Value>
<Value name="23">
<Value>DrinkQuentity</Value>
</Value>
<Value name="24">
<Value>DrugOfAdverseEffects</Value>
</Value>
<Value name="25">
<Value>DrugRegularityRate</Value>
</Value>
<Value name="26">
<Value>DrugSideEffect</Value>
</Value>
<Value name="27">
<Value>EatDrug</Value>
</Value>
<Value name="28">
<Value>Exercise</Value>
</Value>
<Value name="29">
<Value>ExerciseMin</Value>
</Value>
<Value name="30">
<Value>ExerciseNum</Value>
</Value>
<Value name="31">
<Value>Eyeground</Value>
</Value>
<Value name="32">
<Value>Food</Value>
</Value>
<Value name="33">
<Value>FootArteryThrob</Value>
</Value>
<Value name="34">
<Value>Hb</Value>
</Value>
<Value name="35">
<Value>HbAlC</Value>
</Value>
<Value name="36">
<Value>HeartRate</Value>
</Value>
<Value name="37">
<Value>Height</Value>
</Value>
<Value name="38">
<Value>MentalStatus</Value>
</Value>
<Value name="39">
<Value>MentalityAdjust</Value>
</Value>
<Value name="40">
<Value>NAlbumen</Value>
</Value>
<Value name="41">
<Value>NOther</Value>
</Value>
<Value name="42">
<Value>Other</Value>
</Value>
<Value name="43">
<Value>OtherCheck</Value>
</Value>
<Value name="44">
<Value>OtherOfBlood</Value>
</Value>
<Value name="45">
<Value>OtherSymptom</Value>
</Value>
<Value name="46">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="47">
<Value>Remark</Value>
</Value>
<Value name="48">
<Value>Smoke</Value>
</Value>
<Value name="49">
<Value>SmokeNum</Value>
</Value>
<Value name="50">
<Value>StaffInput</Value>
</Value>
<Value name="51">
<Value>Stern</Value>
</Value>
<Value name="52">
<Value>SugarInDay</Value>
</Value>
<Value name="53">
<Value>Symptom</Value>
</Value>
<Value name="54">
<Value>TransferDept</Value>
</Value>
<Value name="55">
<Value>TransferReason</Value>
</Value>
<Value name="56">
<Value>UniteIll</Value>
</Value>
<Value name="57">
<Value>Waistline</Value>
</Value>
<Value name="58">
<Value>WaistlineStern</Value>
</Value>
<Value name="59">
<Value>Weight</Value>
</Value>
<Value name="60">
<Value>bAdverseEffects</Value>
</Value>
<Value name="61">
<Value>bBooking</Value>
</Value>
<Value name="62">
<Value>bCaseTrans</Value>
</Value>
<Value name="63">
<Value>bDrink</Value>
</Value>
<Value name="64">
<Value>bSmoke</Value>
</Value>
<Value name="65">
<Value>bTranfer</Value>
</Value>
<Value name="66">
<Value>nHighPressure</Value>
</Value>
<Value name="67">
<Value>nLowPressure</Value>
</Value>
<Value name="68">
<Value>CheckType</Value>
</Value>
<Value name="69">
<Value>Count</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.DiabetesChec8EAD</DataLocation>
<DefaultData>DiabetesCheckRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.DiabetesChec8EAD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.DiabetesChec8EAI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.DiabetesChec8EAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
