Class CHSS.MalignancyHeadPage Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = MaligRowId, SqlTableName = MalignancyHeadPage ]
{

//生存期

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property Intime As %Date;

Property Doctor As %String(MAXLEN = 60, TRUNCATE = 1);

Property Nurse As %String(MAXLEN = 60, TRUNCATE = 1);

Property StaffInput As User.SSUser;

Property DateOfInput As %Date;

Property DateOfUpdate As %Date;

Property DiagnoseUnit As %String(MAXLEN = 100, TRUNCATE = 1);

Property SmokeInfo As %String(MAXLEN = 20, TRUNCATE = 1);

Property DrinkInfo As %String(MAXLEN = 20, TRUNCATE = 1);

Property GymInfo As %String(MAXLEN = 20, TRUNCATE = 1);

Property DiseaseHistory As %String(MAXLEN = 100, TRUNCATE = 1);

Property Weight As %Float;

Property High As %Float;

Property BMI As %Float;

Property Checker As %String(MAXLEN = 50, TRUNCATE = 1);

Property DateOfCheck As %Date;

Property CheckOutWay As %String(MAXLEN = 60, TRUNCATE = 1);

Property TellPatient As CHSS.DictTellPatient;

Property DateOfFirstFound As %Date;

Property DateOfDiagnose As %Date;

Property FirstDiagnoseInfo As %String(MAXLEN = 100, TRUNCATE = 1);

Property FirstOPSHospital As %String(MAXLEN = 60, TRUNCATE = 1);

Property InHosCode As %String(MAXLEN = 50, TRUNCATE = 1);

Property PathologyCode As %String(MAXLEN = 50, TRUNCATE = 1);

Property DateOfFirstOPS As %Date;

Property FirstOPSProperty As CHSS.DictMalignancyOPSProperty;

Property OPSHos As %String(MAXLEN = 60, TRUNCATE = 1);

Property ChemotherapyHos As %String(MAXLEN = 60, TRUNCATE = 1);

Property RadiotherapyHos As %String(MAXLEN = 60, TRUNCATE = 1);

Property bTransfer As %String(MAXLEN = 5, TRUNCATE = 1);

Property TransferPart As %String(MAXLEN = 60, TRUNCATE = 1);

Property MalignancyFMH As %String(MAXLEN = 5, TRUNCATE = 1);

Property Relation As %String(MAXLEN = 60, TRUNCATE = 1);

Property MalignancyType As %String(MAXLEN = 60, TRUNCATE = 1);

Property CurrentSituation As CHSS.DictCurrentSituation;

Property Guide As CHSS.DictGuide;

Property KPS As CHSS.DictKPS;

Property FirstDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

Property FirstDate As %Date;

Property UndoManageDate As %Date;

Property UndoManageReason As %String(MAXLEN = 60, TRUNCATE = 1);

Property DeathDate As %Date;

Property DeathReason As %String(MAXLEN = 60, TRUNCATE = 1);

Property DeathPlace As %String(MAXLEN = 60, TRUNCATE = 1);

Property TTL As %Date;

Index PersonRowIdParrefIndex On PersonRowId;

Storage Default
{
<Data name="MalignancyHeadPageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>CheckOutWay</Value>
</Value>
<Value name="4">
<Value>Checker</Value>
</Value>
<Value name="5">
<Value>ChemotherapyHos</Value>
</Value>
<Value name="6">
<Value>CurrentSituation</Value>
</Value>
<Value name="7">
<Value>DateOfCheck</Value>
</Value>
<Value name="8">
<Value>DateOfDiagnose</Value>
</Value>
<Value name="9">
<Value>DateOfFirstFound</Value>
</Value>
<Value name="10">
<Value>DateOfFirstOPS</Value>
</Value>
<Value name="11">
<Value>DateOfInput</Value>
</Value>
<Value name="12">
<Value>DateOfUpdate</Value>
</Value>
<Value name="13">
<Value>DeathDate</Value>
</Value>
<Value name="14">
<Value>DeathPlace</Value>
</Value>
<Value name="15">
<Value>DeathReason</Value>
</Value>
<Value name="16">
<Value>DiagnoseUnit</Value>
</Value>
<Value name="17">
<Value>DiseaseHistory</Value>
</Value>
<Value name="18">
<Value>Doctor</Value>
</Value>
<Value name="19">
<Value>DrinkInfo</Value>
</Value>
<Value name="20">
<Value>FirstDate</Value>
</Value>
<Value name="21">
<Value>FirstDiagnoseInfo</Value>
</Value>
<Value name="22">
<Value>FirstDoctor</Value>
</Value>
<Value name="23">
<Value>FirstOPSHospital</Value>
</Value>
<Value name="24">
<Value>FirstOPSProperty</Value>
</Value>
<Value name="25">
<Value>Guide</Value>
</Value>
<Value name="26">
<Value>GymInfo</Value>
</Value>
<Value name="27">
<Value>High</Value>
</Value>
<Value name="28">
<Value>InHosCode</Value>
</Value>
<Value name="29">
<Value>Intime</Value>
</Value>
<Value name="30">
<Value>KPS</Value>
</Value>
<Value name="31">
<Value>MalignancyFMH</Value>
</Value>
<Value name="32">
<Value>MalignancyType</Value>
</Value>
<Value name="33">
<Value>Nurse</Value>
</Value>
<Value name="34">
<Value>OPSHos</Value>
</Value>
<Value name="35">
<Value>PathologyCode</Value>
</Value>
<Value name="36">
<Value>PersonRowId</Value>
</Value>
<Value name="37">
<Value>RadiotherapyHos</Value>
</Value>
<Value name="38">
<Value>Relation</Value>
</Value>
<Value name="39">
<Value>SmokeInfo</Value>
</Value>
<Value name="40">
<Value>StaffInput</Value>
</Value>
<Value name="41">
<Value>TTL</Value>
</Value>
<Value name="42">
<Value>TellPatient</Value>
</Value>
<Value name="43">
<Value>TransferPart</Value>
</Value>
<Value name="44">
<Value>UndoManageDate</Value>
</Value>
<Value name="45">
<Value>UndoManageReason</Value>
</Value>
<Value name="46">
<Value>Weight</Value>
</Value>
<Value name="47">
<Value>bTransfer</Value>
</Value>
</Data>
<DataLocation>^CHSS.MalignancyHeadPageD</DataLocation>
<DefaultData>MalignancyHeadPageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.MalignancyHeadPageD</IdLocation>
<IndexLocation>^CHSS.MalignancyHeadPageI</IndexLocation>
<StreamLocation>^CHSS.MalignancyHeadPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
