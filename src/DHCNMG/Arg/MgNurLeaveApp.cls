/// Descriptions:护士请假申请【安贞医院】
/// Date:2018-03-09
/// Creator:guozj
Class DHCNMG.Arg.MgNurLeaveApp Extends %Persistent
{

/// 填单日期
Property FillDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Fill_Date ];

/// 护士信息
Property NurseName As DHCNMG.HR.MgPersons [ SqlColumnNumber = 3, SqlFieldName = Nurse_Name ];

/// 当前科室
Property LeaveWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Leave_WardDR ];

/// 身份证号
Property NurseCardID As %String [ SqlColumnNumber = 5, SqlFieldName = Nurse_CardID ];

/// 假期类型【根据排班岗位维护数据为准  病假;事假;婚假；探亲假；丧假；其他】
Property LeaveType As %String [ SqlColumnNumber = 6, SqlFieldName = Leave_Type ];

/// 事由
Property LeaveCause As %String [ SqlColumnNumber = 7, SqlFieldName = Leave_Cause ];

/// 请假开始日期
Property LeaveStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Leave_StDate ];

/// 请假截止日期
Property LeaveEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Leave_EndDate ];

/// 请假天数
Property LeaveDays As %Integer [ SqlColumnNumber = 10, SqlFieldName = Leave_Days ];

/// 联系方式
Property NursePhone As %String [ SqlColumnNumber = 11, SqlFieldName = Nurse_Phone ];

/// 委托人及联系方式
Property LeaveTrustee As %String [ SqlColumnNumber = 12, SqlFieldName = Leave_Trustee ];

/// 护士长签字[DHCNMG.HR.MgPersons=>ID]
Property NurHeadSign As %String [ SqlColumnNumber = 13, SqlFieldName = Nur_HeadSign ];

/// 护士长签字日期
Property NurHeadSignDate As %Date [ SqlColumnNumber = 14, SqlFieldName = Nur_HeadSignDate ];

/// 科主任签字【暂时略】
Property LocHeadSign As %String [ SqlColumnNumber = 15, SqlFieldName = Loc_HeadSign ];

/// 科主任签字日期
Property LocHeadSignDate As %Date [ SqlColumnNumber = 16, SqlFieldName = Loc_HeadSignDate ];

/// 护理部签字
Property NurseDepartSign As %String [ SqlColumnNumber = 17, SqlFieldName = Nurse_DepartSign ];

/// 护理部签字日期
Property NurseDepartSignDate As %Date [ SqlColumnNumber = 18, SqlFieldName = Nurse_DepartSignDate ];

/// 状态 【N：新增 Y：提交 NH：护士长审核 HH：护理部审核】
Property LeaveStatus As %String [ SqlColumnNumber = 19, SqlFieldName = Leave_Status ];

/// 承诺人
Property Accepter As %String [ SqlColumnNumber = 20, SqlFieldName = Accepter ];

/// 病假条图片
Property SickLeaveImg As %String [ SqlColumnNumber = 21, SqlFieldName = SickLeaveImg ];

Index SSID On (FillDate, NurseName);

Index SSDEP On (FillDate, LeaveWard, NurseName);

Index Nurse On NurseName;

Index date On (NurseName, LeaveStDate, LeaveEndDate);

Storage Default
{
<Data name="MgNurLeaveAppDefaultData">
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
<Value>FillDate</Value>
</Value>
<Value name="6">
<Value>NurseName</Value>
</Value>
<Value name="7">
<Value>LeaveWard</Value>
</Value>
<Value name="8">
<Value>NurseCardID</Value>
</Value>
<Value name="9">
<Value>LeaveType</Value>
</Value>
<Value name="10">
<Value>LeaveCause</Value>
</Value>
<Value name="11">
<Value>LeaveStDate</Value>
</Value>
<Value name="12">
<Value>LeaveEndDate</Value>
</Value>
<Value name="13">
<Value>LeaveDays</Value>
</Value>
<Value name="14">
<Value>NursePhone</Value>
</Value>
<Value name="15">
<Value>LeaveTrustee</Value>
</Value>
<Value name="16">
<Value>NurHeadSign</Value>
</Value>
<Value name="17">
<Value>NurHeadSignDate</Value>
</Value>
<Value name="18">
<Value>LocHeadSign</Value>
</Value>
<Value name="19">
<Value>LocHeadSignDate</Value>
</Value>
<Value name="20">
<Value>NurseDepartSign</Value>
</Value>
<Value name="21">
<Value>NurseDepartSignDate</Value>
</Value>
<Value name="22">
<Value>LeaveStatus</Value>
</Value>
<Value name="23">
<Value>Accepter</Value>
</Value>
<Value name="24">
<Value>SickLeaveImg</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurLeaveAppD</DataLocation>
<DefaultData>MgNurLeaveAppDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgNurLeaveAppD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurLeaveAppI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurLeaveAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
