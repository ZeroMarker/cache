Class User.DHCMGNurMonReport Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//月报

Relationship ChildSubHol As User.DHCMGNurMonReportHol [ Cardinality = children, Inverse = HolParref ];

Relationship ChildSubExch As User.DHCMGNurMonReportExch [ Cardinality = children, Inverse = ExchParref ];

Property MonHosp As %String(TRUNCATE = 1);

Property MonDep As %String(TRUNCATE = 1);

Property MonUser As User.DHCMGPersons;

Property MonMonth As %String(TRUNCATE = 1);

Property MonDate As %Library.Date(FORMAT = 1);

Property MonNote As %String(TRUNCATE = 1);

Property AuditDr As User.DHCMGNurMonAudit;

Property PerHoliday As %String(TRUNCATE = 1);

Property SickLeave As %String(TRUNCATE = 1);

Property PersonalLeave As %String(TRUNCATE = 1);

Property OutAcademic As %String(TRUNCATE = 1);

Property OutMeeting As %String(TRUNCATE = 1);

Property PerSchooling As %String(TRUNCATE = 1);

Property PerDuty As %String(TRUNCATE = 1);

Property AdmissionNum As %String(TRUNCATE = 1);

Property OperationNum As %String(TRUNCATE = 1);

Property CriticalCare As %String(TRUNCATE = 1);

Property FirstCare As %String(TRUNCATE = 1);

Property DeathNum As %String(TRUNCATE = 1);

Property PraiseNum As %String(TRUNCATE = 1);

Property PraisePerson As %String(TRUNCATE = 1);

Property CriticizeNum As %String(TRUNCATE = 1);

Property CriticizePerson As %String(TRUNCATE = 1);

Property ComplainNum As %String(TRUNCATE = 1);

Property ComplainPerson As %String(TRUNCATE = 1);

Property InfusionReaction As %String(TRUNCATE = 1);

Property ComplicationNum As %String(TRUNCATE = 1);

Property ComplicationPerson As %String(TRUNCATE = 1);

Property NightShift As %String(TRUNCATE = 1);

Property OverTime As %String(TRUNCATE = 1);

Property OverHours As %String(TRUNCATE = 1);

//专科业务培训

Property MonTrain As %String(TRUNCATE = 1);

//护理查房

Property MonCare As %String(TRUNCATE = 1);

//护理技术操作培训考评

Property MonExam As %String(TRUNCATE = 1);

//护理质控

Property MonQual As %String(TRUNCATE = 1);

//科护士长

Property MonManager As %String(TRUNCATE = 1);

Index DateMon On (MonDep, MonMonth);

Index DepDate On (MonDep, MonDate);

Index Audit On AuditDr;

Storage Default
{
<Data name="DHCMGNurMonReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmissionNum</Value>
</Value>
<Value name="3">
<Value>MonDep</Value>
</Value>
<Value name="4">
<Value>MonMonth</Value>
</Value>
<Value name="5">
<Value>MonUser</Value>
</Value>
<Value name="6">
<Value>OutAcademic</Value>
</Value>
<Value name="7">
<Value>OutMeeting</Value>
</Value>
<Value name="8">
<Value>PerDuty</Value>
</Value>
<Value name="9">
<Value>PerHoliday</Value>
</Value>
<Value name="10">
<Value>PerSchooling</Value>
</Value>
<Value name="11">
<Value>PersonalLeave</Value>
</Value>
<Value name="12">
<Value>SickLeave</Value>
</Value>
<Value name="13">
<Value>ComplainNum</Value>
</Value>
<Value name="14">
<Value>ComplainPerson</Value>
</Value>
<Value name="15">
<Value>ComplicationNum</Value>
</Value>
<Value name="16">
<Value>ComplicationPerson</Value>
</Value>
<Value name="17">
<Value>CriticalCare</Value>
</Value>
<Value name="18">
<Value>CriticizeNum</Value>
</Value>
<Value name="19">
<Value>CriticizePerson</Value>
</Value>
<Value name="20">
<Value>DeathNum</Value>
</Value>
<Value name="21">
<Value>FirstCare</Value>
</Value>
<Value name="22">
<Value>InfusionReaction</Value>
</Value>
<Value name="23">
<Value>MonDate</Value>
</Value>
<Value name="24">
<Value>MonNote</Value>
</Value>
<Value name="25">
<Value>NightShift</Value>
</Value>
<Value name="26">
<Value>OperationNum</Value>
</Value>
<Value name="27">
<Value>OverHours</Value>
</Value>
<Value name="28">
<Value>OverTime</Value>
</Value>
<Value name="29">
<Value>PraiseNum</Value>
</Value>
<Value name="30">
<Value>PraisePerson</Value>
</Value>
<Value name="31">
<Value>AuditDr</Value>
</Value>
<Value name="32">
<Value>MonHosp</Value>
</Value>
<Value name="33">
<Value>MonCare</Value>
</Value>
<Value name="34">
<Value>MonExam</Value>
</Value>
<Value name="35">
<Value>MonQual</Value>
</Value>
<Value name="36">
<Value>MonTrain</Value>
</Value>
<Value name="37">
<Value>MonManager</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurMonReportD</DataLocation>
<DefaultData>DHCMGNurMonReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurMonReportD</IdLocation>
<IndexLocation>^User.DHCMGNurMonReportI</IndexLocation>
<StreamLocation>^User.DHCMGNurMonReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
