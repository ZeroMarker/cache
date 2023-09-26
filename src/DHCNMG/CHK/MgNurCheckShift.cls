/// Descriptions:护士长夜查房换班
/// Date:2018-10-21
/// Creator:lulin
Class DHCNMG.CHK.MgNurCheckShift Extends %Persistent
{

/// 状态【N:创建,S:提交，NA:交换人护士长审核，HA:护理部审核，B:驳回，C:作废】
Property ShiftStatus As %String [ SqlColumnNumber = 2, SqlFieldName = Shift_Status ];

/// 换班日期
Property ShiftDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Shift_Date ];

/// 交换日期
Property ShiftToDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Shift_ToDate ];

/// 换班人
Property ShiftPer As %String [ SqlColumnNumber = 5, SqlFieldName = Shift_Per ];

/// 交换人
Property ShiftToPer As %String [ SqlColumnNumber = 6, SqlFieldName = Shift_ToPer ];

/// 申请人
Property shiftCreator As %String [ SqlColumnNumber = 7, SqlFieldName = Shift_Creator ];

/// 操作人
Property shiftUpdator As %String [ SqlColumnNumber = 8, SqlFieldName = Shift_Updator ];

/// 状态说明
Property ShiftReason As %String [ SqlColumnNumber = 9, SqlFieldName = Shift_Reason ];

/// 备注
Property ShiftRemark As %String [ SqlColumnNumber = 10, SqlFieldName = Shift_Remark ];

/// 申请日期
Property ShiftCreateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Shift_CreateDate ];

/// 最后操作日期
Property ShiftUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Shift_UpdateDate ];

/// 换班班次
Property ChangePost As %String [ SqlColumnNumber = 13, SqlFieldName = Change_Post ];

/// 交换班次
Property ExChangePost As %String [ SqlColumnNumber = 14, SqlFieldName = ExChange_Post ];

Index date On ShiftDate;

Index todate On ShiftToDate;

Storage Default
{
<Data name="MgNurCheckShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShiftStatus</Value>
</Value>
<Value name="3">
<Value>ShiftDate</Value>
</Value>
<Value name="4">
<Value>ShiftToDate</Value>
</Value>
<Value name="5">
<Value>ShiftPer</Value>
</Value>
<Value name="6">
<Value>ShiftToPer</Value>
</Value>
<Value name="7">
<Value>shiftCreator</Value>
</Value>
<Value name="8">
<Value>shiftUpdator</Value>
</Value>
<Value name="9">
<Value>ShiftReason</Value>
</Value>
<Value name="10">
<Value>ShiftRemark</Value>
</Value>
<Value name="11">
<Value>ShiftCreateDate</Value>
</Value>
<Value name="12">
<Value>ShiftUpdateDate</Value>
</Value>
<Value name="13">
<Value>ChangePost</Value>
</Value>
<Value name="14">
<Value>ExChangePost</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurCheckShiftD</DataLocation>
<DefaultData>MgNurCheckShiftDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurCheckShiftD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurCheckShiftI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurCheckShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
