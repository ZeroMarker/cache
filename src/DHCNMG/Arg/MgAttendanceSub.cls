Class DHCNMG.Arg.MgAttendanceSub Extends %Persistent
{

Relationship Parref As DHCNMG.Arg.MgAttendance [ Cardinality = parent, Inverse = ChildSub ];

/// 护士ID
Property NurseID As %String [ SqlColumnNumber = 2, SqlFieldName = NurseID ];

Property One As %String [ SqlColumnNumber = 3, SqlFieldName = One ];

Property Two As %String [ SqlColumnNumber = 4, SqlFieldName = Two ];

Property Three As %String [ SqlColumnNumber = 5, SqlFieldName = Three ];

Property Four As %String [ SqlColumnNumber = 6, SqlFieldName = Four ];

Property Five As %String [ SqlColumnNumber = 7, SqlFieldName = Five ];

Property Six As %String [ SqlColumnNumber = 8, SqlFieldName = Six ];

Property Seven As %String [ SqlColumnNumber = 9, SqlFieldName = Seven ];

Property Eight As %String [ SqlColumnNumber = 10, SqlFieldName = Eight ];

Property Nine As %String [ SqlColumnNumber = 11, SqlFieldName = Nine ];

Property Ten As %String [ SqlColumnNumber = 12, SqlFieldName = Ten ];

Property Eleven As %String [ SqlColumnNumber = 13, SqlFieldName = Eleven ];

Property Twelve As %String [ SqlColumnNumber = 14, SqlFieldName = twelve ];

Property Thirteen As %String [ SqlColumnNumber = 15, SqlFieldName = Thirteen ];

Property Fourteen As %String [ SqlColumnNumber = 16, SqlFieldName = Fourteen ];

Property Fifteen As %String [ SqlColumnNumber = 17, SqlFieldName = Fifteen ];

Property Sixteen As %String [ SqlColumnNumber = 18, SqlFieldName = Sixteen ];

Property Seventeen As %String [ SqlColumnNumber = 19, SqlFieldName = Seventeen ];

Property Eighteen As %String [ SqlColumnNumber = 20, SqlFieldName = Eighteen ];

Property Nineteen As %String [ SqlColumnNumber = 21, SqlFieldName = Nineteen ];

Property Twenty As %String [ SqlColumnNumber = 22, SqlFieldName = Twenty ];

Property TwentyOne As %String [ SqlColumnNumber = 23, SqlFieldName = TwentyOne ];

Property TwentyTwo As %String [ SqlColumnNumber = 24, SqlFieldName = TwentyTwo ];

Property TwentyThree As %String [ SqlColumnNumber = 25, SqlFieldName = TwentyThree ];

Property TwentyFour As %String [ SqlColumnNumber = 26, SqlFieldName = TwentyFour ];

Property TwentyFive As %String [ SqlColumnNumber = 27, SqlFieldName = TwentyFive ];

Property TwentySix As %String [ SqlColumnNumber = 28, SqlFieldName = TwentySix ];

Property TwentySeven As %String [ SqlColumnNumber = 29, SqlFieldName = TwentySeven ];

Property TwentyEight As %String [ SqlColumnNumber = 30, SqlFieldName = TwentyEight ];

Property TwentyNine As %String [ SqlColumnNumber = 31, SqlFieldName = TwentyNine ];

Property Thirty As %String [ SqlColumnNumber = 32, SqlFieldName = Thirty ];

Property ThirtyOne As %String [ SqlColumnNumber = 33, SqlFieldName = ThirtyOne ];

/// 病假天数
Property SickDays As %Integer [ SqlColumnNumber = 34, SqlFieldName = SickDays ];

/// 事假天数
Property LeaveDays As %Integer [ SqlColumnNumber = 35, SqlFieldName = LeaveDays ];

/// 探亲假天数
Property VisitDays As %Integer [ SqlColumnNumber = 36, SqlFieldName = VisitDays ];

/// 婚丧假天数
Property MarryFuneral As %Integer [ SqlColumnNumber = 37, SqlFieldName = MarryFuneral ];

/// 产假天数
Property Maternity As %Integer [ SqlColumnNumber = 38, SqlFieldName = Maternity ];

/// 年休假天数
Property AnnualDays As %Integer [ SqlColumnNumber = 39, SqlFieldName = AnnualDays ];

/// 外地进修
Property TrainNum As %Integer [ SqlColumnNumber = 40, SqlFieldName = TrainNum ];

/// 进修回科
Property FromTrainNum As %Integer [ SqlColumnNumber = 41, SqlFieldName = FromTrainNum ];

/// 调入
Property TransIn As %Integer [ SqlColumnNumber = 42, SqlFieldName = TransIn ];

/// 调出
Property TransOut As %Integer [ SqlColumnNumber = 43, SqlFieldName = TransOut ];

/// 夜班数
Property NightNum As %Integer [ SqlColumnNumber = 44, SqlFieldName = NightNum ];

/// 加班数
Property OverTime As %Integer [ SqlColumnNumber = 45, SqlFieldName = OverTime ];

/// 其他
Property Others As %Integer [ SqlColumnNumber = 46, SqlFieldName = Others ];

Index per On (Parref, NurseID);

Storage Default
{
<Data name="MgAttendanceSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NurseID</Value>
</Value>
<Value name="3">
<Value>One</Value>
</Value>
<Value name="4">
<Value>Two</Value>
</Value>
<Value name="5">
<Value>Three</Value>
</Value>
<Value name="6">
<Value>Four</Value>
</Value>
<Value name="7">
<Value>Five</Value>
</Value>
<Value name="8">
<Value>Six</Value>
</Value>
<Value name="9">
<Value>Seven</Value>
</Value>
<Value name="10">
<Value>Eight</Value>
</Value>
<Value name="11">
<Value>Nine</Value>
</Value>
<Value name="12">
<Value>Ten</Value>
</Value>
<Value name="13">
<Value>Eleven</Value>
</Value>
<Value name="14">
<Value>Twelve</Value>
</Value>
<Value name="15">
<Value>Thirteen</Value>
</Value>
<Value name="16">
<Value>Fourteen</Value>
</Value>
<Value name="17">
<Value>Fifteen</Value>
</Value>
<Value name="18">
<Value>Sixteen</Value>
</Value>
<Value name="19">
<Value>Seventeen</Value>
</Value>
<Value name="20">
<Value>Eighteen</Value>
</Value>
<Value name="21">
<Value>Nineteen</Value>
</Value>
<Value name="22">
<Value>Twenty</Value>
</Value>
<Value name="23">
<Value>TwentyOne</Value>
</Value>
<Value name="24">
<Value>TwentyTwo</Value>
</Value>
<Value name="25">
<Value>TwentyThree</Value>
</Value>
<Value name="26">
<Value>TwentyFour</Value>
</Value>
<Value name="27">
<Value>TwentyFive</Value>
</Value>
<Value name="28">
<Value>TwentySix</Value>
</Value>
<Value name="29">
<Value>TwentySeven</Value>
</Value>
<Value name="30">
<Value>TwentyEight</Value>
</Value>
<Value name="31">
<Value>TwentyNinth</Value>
</Value>
<Value name="32">
<Value>Thirty</Value>
</Value>
<Value name="33">
<Value>ThirtyOne</Value>
</Value>
<Value name="34">
<Value>SickDays</Value>
</Value>
<Value name="35">
<Value>LeaveDays</Value>
</Value>
<Value name="36">
<Value>VisitDays</Value>
</Value>
<Value name="37">
<Value>MarryFuneral</Value>
</Value>
<Value name="38">
<Value>Maternity</Value>
</Value>
<Value name="39">
<Value>AnnualDays</Value>
</Value>
<Value name="40">
<Value>TrainDays</Value>
</Value>
<Value name="41">
<Value>TrainReturn</Value>
</Value>
<Value name="42">
<Value>TransIn</Value>
</Value>
<Value name="43">
<Value>TransOut</Value>
</Value>
<Value name="44">
<Value>NightNum</Value>
</Value>
<Value name="45">
<Value>OverTime</Value>
</Value>
<Value name="46">
<Value>Others</Value>
</Value>
<Value name="47">
<Value>TwentyNine</Value>
</Value>
<Value name="48">
<Value>TrainNum</Value>
</Value>
<Value name="49">
<Value>FromTrainNum</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgAttendanceSubD</DataLocation>
<DefaultData>MgAttendanceSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgAttendanceSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgAttendanceSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
