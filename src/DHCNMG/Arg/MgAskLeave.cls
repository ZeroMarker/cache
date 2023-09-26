/// creator:xbl
/// createdate:20170828
/// description: 护士请假信息
Class DHCNMG.Arg.MgAskLeave Extends %Persistent
{

/// 护士信息 DHCNMG.HR.MgPersons->ID
Property LeavePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Leave_PerDR ];

/// 当前科室
Property LeaveWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Leave_WardDR ];

/// 假期类型
Property LeaveHolidayDR As DHCNMG.DB.MgArgWardPost [ SqlColumnNumber = 4, SqlFieldName = Leave_HolidayDR ];

/// 开始日期
Property LeaveStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Leave_StDate ];

/// 开始时间
Property LeaveStTime As %Time [ SqlColumnNumber = 7, SqlFieldName = Leave_StTime ];

/// 结束日期
Property LeaveEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Leave_EndDate ];

/// 结束时间
Property LeaveEndTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Leave_EndTime ];

/// 休假天数
Property LeaveDays As %String [ SqlColumnNumber = 10, SqlFieldName = Leave_Days ];

/// 休假原因
Property LeaveReason As %String(MAXLEN = 10000) [ SqlColumnNumber = 11, SqlFieldName = Leave_Reason ];

/// 状态 DHCNMG.Set.MgSysParamSub 状态设置
Property LeaveStatus As %String [ SqlColumnNumber = 12, SqlFieldName = Leave_Status ];

/// 退回原因
Property BackReason As %String(MAXLEN = 10000) [ SqlColumnNumber = 13, SqlFieldName = Back_Reason ];

/// 替班护士信息 DHCNMG.HR.MgPersons->ID
Property ReplacePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 14, SqlFieldName = Replace_PerDR ];

/// 最后操作时间
Property HandleDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Handle_Date ];

/// 操作人
Property HandleDR As %String [ SqlColumnNumber = 16, SqlFieldName = Handle_DR ];

Index PerDR On LeavePerDR;

Index Ward On LeaveWardDR;

Index Holiday On LeaveHolidayDR;

Storage Default
{
<Data name="MgAskLeaveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LeavePerDR</Value>
</Value>
<Value name="3">
<Value>LeaveWardDR</Value>
</Value>
<Value name="4">
<Value>LeaveHolidayDR</Value>
</Value>
<Value name="5">
<Value>LeaveHolidaySubDR</Value>
</Value>
<Value name="6">
<Value>LeaveStDate</Value>
</Value>
<Value name="7">
<Value>LeaveStTime</Value>
</Value>
<Value name="8">
<Value>LeaveEndDate</Value>
</Value>
<Value name="9">
<Value>LeaveEndTime</Value>
</Value>
<Value name="10">
<Value>LeaveDays</Value>
</Value>
<Value name="11">
<Value>LeaveReason</Value>
</Value>
<Value name="12">
<Value>LeaveStatus</Value>
</Value>
<Value name="13">
<Value>BackReason</Value>
</Value>
<Value name="14">
<Value>ReplacePerDR</Value>
</Value>
<Value name="15">
<Value>HandleDate</Value>
</Value>
<Value name="16">
<Value>HandleDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgAskLeaveD</DataLocation>
<DefaultData>MgAskLeaveDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgAskLeaveD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgAskLeaveI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgAskLeaveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
