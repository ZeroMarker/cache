/// creator：xbl
/// createdate：20170823
/// description：排班参数设置
Class DHCNMG.Set.MgArgParamSet Extends %Persistent
{

/// 排班周期
Property ArgPeriod As %String [ SqlColumnNumber = 2, SqlFieldName = Arg_Periond ];

/// 统计单位
Property ArgCountUnit As %String [ SqlColumnNumber = 3, SqlFieldName = Arg_CountUnit ];

/// 跨天统计
Property ArgCrossDay As %String [ SqlColumnNumber = 4, SqlFieldName = Arg_CrossDay ];

/// 夏令夜班开始时间
Property NightStTime1 As %Time [ SqlColumnNumber = 5, SqlFieldName = Night_StTime1 ];

/// 夏令夜班结束时间
Property NightEndTime1 As %Time [ SqlColumnNumber = 6, SqlFieldName = Night_EndTime1 ];

/// 夏令白班时长
Property DayHour1 As %Float [ SqlColumnNumber = 7, SqlFieldName = Day_Hour1 ];

/// 夏令上午时长
Property AMHour1 As %Float [ SqlColumnNumber = 8, SqlFieldName = AM_Hour1 ];

/// 夏令下午时长
Property PMHour1 As %Float [ SqlColumnNumber = 9, SqlFieldName = PM_Hour1 ];

/// 冬令夜班开始时间
Property NightStTime2 As %Time [ SqlColumnNumber = 10, SqlFieldName = Night_StTime2 ];

/// 冬令夜班结束时间
Property NightEndTime2 As %Time [ SqlColumnNumber = 11, SqlFieldName = Night_EndTime2 ];

/// 冬令白班时长
Property DayHour2 As %Float [ SqlColumnNumber = 12, SqlFieldName = Day_Hour2 ];

/// 冬令上午时长
Property AMHour2 As %Float [ SqlColumnNumber = 13, SqlFieldName = AM_Hour2 ];

/// 冬令下午时长
Property PMHour2 As %Float [ SqlColumnNumber = 14, SqlFieldName = PM_Hour2 ];

/// 排班修改时限
Property ArgUpdateDay As %Integer [ SqlColumnNumber = 15, SqlFieldName = Arg_UpdateDay ];

/// 全院床护比参数
Property BedBR As %String [ SqlColumnNumber = 16, SqlFieldName = Bed_BR ];

/// 标准时长
Property ArgStandardTime As %String [ SqlColumnNumber = 17, SqlFieldName = Arg_StandardTime ];

/// 时段修改标识
Property ArgTimeSlot As %String [ SqlColumnNumber = 18, SqlFieldName = Arg_TimeSlot ];

Storage Default
{
<Data name="MgArgParamSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgPeriod</Value>
</Value>
<Value name="3">
<Value>ArgCountUnit</Value>
</Value>
<Value name="4">
<Value>ArgCrossDay</Value>
</Value>
<Value name="5">
<Value>NightStTime1</Value>
</Value>
<Value name="6">
<Value>NightEndTime1</Value>
</Value>
<Value name="7">
<Value>DayHour1</Value>
</Value>
<Value name="8">
<Value>NightStTime2</Value>
</Value>
<Value name="9">
<Value>NightEndTime2</Value>
</Value>
<Value name="10">
<Value>DayHour2</Value>
</Value>
<Value name="11">
<Value>AMHour1</Value>
</Value>
<Value name="12">
<Value>PMHour1</Value>
</Value>
<Value name="13">
<Value>AMHour2</Value>
</Value>
<Value name="14">
<Value>PMHour2</Value>
</Value>
<Value name="15">
<Value>ArgUpdateDay</Value>
</Value>
<Value name="16">
<Value>BedBR</Value>
</Value>
<Value name="17">
<Value>ArgStandardTime</Value>
</Value>
<Value name="18">
<Value>ArgTimeSlot</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgArgParamSetD</DataLocation>
<DefaultData>MgArgParamSetDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgArgParamSetD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgArgParamSetI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgArgParamSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
