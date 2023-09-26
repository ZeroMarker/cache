/// 每日人员考勤
Class CIS.AN.Attendance Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Attendance ]
{

/// 考勤日期
Property AttendDate As %Date [ Required, SqlColumnNumber = 2 ];

/// 科室
Property Dept As %String [ Required, SqlColumnNumber = 3 ];

/// 科室人员
Property Member As %String [ Required, SqlColumnNumber = 4 ];

/// 班次
Property Shift As CF.AN.CrewShift [ Required, SqlColumnNumber = 5 ];

/// 创建者
Property CreateUser As %String [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8 ];

/// 更新人
Property UpdateUser As %String [ SqlColumnNumber = 9 ];

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11 ];

/// 提交人
Property AuditUser As %String [ SqlColumnNumber = 12 ];

/// 提交日期
Property AuditDate As %Date [ SqlColumnNumber = 13 ];

/// 提交时间
Property AuditTime As %Time [ SqlColumnNumber = 14 ];

Index IDate On AttendDate;

Index IDept On (AttendDate, Dept);

Index IMember On (AttendDate, Dept, Member);

Storage Default
{
<Data name="AttendanceDefaultData">
<Value name="1">
<Value>AttendDate</Value>
</Value>
<Value name="2">
<Value>Dept</Value>
</Value>
<Value name="3">
<Value>Member</Value>
</Value>
<Value name="4">
<Value>Shift</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
<Value name="11">
<Value>AuditUser</Value>
</Value>
<Value name="12">
<Value>AuditDate</Value>
</Value>
<Value name="13">
<Value>AuditTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AttendanceD</DataLocation>
<DefaultData>AttendanceDefaultData</DefaultData>
<IdLocation>^CIS.AN.AttendanceD</IdLocation>
<IndexLocation>^CIS.AN.AttendanceI</IndexLocation>
<StreamLocation>^CIS.AN.AttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
