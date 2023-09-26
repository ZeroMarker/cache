/// Creator:gzj
/// Date:2019-04-29
/// Description:出勤记录
Class DHCNMG.Arg.MgAttendance Extends %Persistent
{

Relationship ChildSub As DHCNMG.Arg.MgAttendanceSub [ Cardinality = children, Inverse = Parref ];

/// 出勤月
Property AttendMonth As %Integer [ SqlColumnNumber = 2, SqlFieldName = Attend_Month ];

/// 出勤病区
Property AttendWard As %Integer [ SqlColumnNumber = 3, SqlFieldName = Attend_Ward ];

/// 生成日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = Create_Date ];

/// 生成时间
Property CreateTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 5, SqlFieldName = Create_Time ];

/// 创建人
Property CreateUser As %Integer [ SqlColumnNumber = 6, SqlFieldName = Create_User ];

Index ward On (AttendWard, AttendMonth);

Storage Default
{
<Data name="MgAttendanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AttendMonth</Value>
</Value>
<Value name="3">
<Value>AttendWard</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgAttendanceD</DataLocation>
<DefaultData>MgAttendanceDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgAttendanceD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgAttendanceI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgAttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
