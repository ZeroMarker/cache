/// Descriptions:护士长、科护士长请假备案【安贞医院】
/// Date:2018-03-15
/// Creator:guozj
Class DHCNMG.Arg.MgNurNurHeadApp Extends %Persistent
{

/// 填单日期
Property FillDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Fill_Date ];

/// 护士长、科护士长信息
Property NurseName As DHCNMG.HR.MgPersons [ SqlColumnNumber = 3, SqlFieldName = Nurse_Name ];

/// 当前科室
Property LeaveWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Leave_WardDR ];

/// 科室电话
Property WardTelphone As %String [ SqlColumnNumber = 5, SqlFieldName = Ward_Telphone ];

/// 假期类型【1 病假;2 事假;3 婚假；4 探亲假；5 丧假；6 其他】
Property LeaveType As %String [ SqlColumnNumber = 6, SqlFieldName = Leave_Type ];

/// 请假开始日期
Property LeaveStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Leave_StDate ];

/// 请假截止日期
Property LeaveEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Leave_EndDate ];

/// 请假天数
Property LeaveDays As %Integer [ SqlColumnNumber = 9, SqlFieldName = Leave_Days ];

/// 事由
Property LeaveCause As %String [ SqlColumnNumber = 10, SqlFieldName = Leave_Cause ];

/// 临时负责人
Property TmpResponse As %String [ SqlColumnNumber = 11, SqlFieldName = TmpResponse ];

/// 临时负责人电话
Property ResponsePhone As %String [ SqlColumnNumber = 12, SqlFieldName = Response_Phone ];

/// 请假期间所在地
Property LeavePlace As %String [ SqlColumnNumber = 13, SqlFieldName = LeavePlace ];

/// 备注
Property LeaveRemark As %String [ SqlColumnNumber = 14, SqlFieldName = Leave_Remark ];

/// 科护士长签字
Property NurHeadSign As %String [ SqlColumnNumber = 15, SqlFieldName = NurHead_Sign ];

/// 科护士长签字日期
Property NurHeadSignDate As %Date [ SqlColumnNumber = 16, SqlFieldName = NurHead_SignDate ];

/// 科主任签字【暂时略】
Property LocHeadSign As %String [ SqlColumnNumber = 17, SqlFieldName = Loc_HeadSign ];

/// 科主任签字日期
Property LocHeadSignDate As %Date [ SqlColumnNumber = 18, SqlFieldName = Loc_HeadSignDate ];

/// 护理部签字
Property NurseDepartSign As %String [ SqlColumnNumber = 19, SqlFieldName = Nurse_DepartSign ];

/// 护理部签字日期
Property NurseDepartSignDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Nurse_DepartSignDate ];

/// 状态 【N：新增 Y：提交 HC：科护士长申请  HH：护理部审核】
Property LeaveStatus As %String [ SqlColumnNumber = 21, SqlFieldName = Leave_Status ];

/// 类别 【H：护士长 C：科护士长】
Property LeaveCategory As %String [ SqlColumnNumber = 22, SqlFieldName = Leave_Category ];

Index SSID On (FillDate, NurseName);

Index SSDEP On (FillDate, LeaveWard, NurseName);

Index Nurse On NurseName;

Index date On (NurseName, LeaveStDate, LeaveEndDate);

Storage Default
{
<Data name="MgNurNurHeadAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FillDate</Value>
</Value>
<Value name="3">
<Value>NurseName</Value>
</Value>
<Value name="4">
<Value>LeaveWard</Value>
</Value>
<Value name="5">
<Value>WardTelphone</Value>
</Value>
<Value name="6">
<Value>LeaveType</Value>
</Value>
<Value name="7">
<Value>LeaveStDate</Value>
</Value>
<Value name="8">
<Value>LeaveEndDate</Value>
</Value>
<Value name="9">
<Value>LeaveDays</Value>
</Value>
<Value name="10">
<Value>TmpResponse</Value>
</Value>
<Value name="11">
<Value>ResponsePhone</Value>
</Value>
<Value name="12">
<Value>LeavePlace</Value>
</Value>
<Value name="13">
<Value>NurHeadSign</Value>
</Value>
<Value name="14">
<Value>NurHeadSignDate</Value>
</Value>
<Value name="15">
<Value>LocHeadSign</Value>
</Value>
<Value name="16">
<Value>LocHeadSignDate</Value>
</Value>
<Value name="17">
<Value>NurseDepartSign</Value>
</Value>
<Value name="18">
<Value>NurseDepartSignDate</Value>
</Value>
<Value name="19">
<Value>LeaveStatus</Value>
</Value>
<Value name="20">
<Value>LeaveRemark</Value>
</Value>
<Value name="21">
<Value>LeaveCause</Value>
</Value>
<Value name="22">
<Value>LeaveCategory</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgNurNurHeadAppD</DataLocation>
<DefaultData>MgNurNurHeadAppDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgNurNurHeadAppD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgNurNurHeadAppI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgNurNurHeadAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
