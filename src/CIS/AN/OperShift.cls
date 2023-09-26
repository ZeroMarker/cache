/// 手术麻醉交接班
Class CIS.AN.OperShift Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperShift ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 交班医护人员ID
Property ShiftCareProvID As %String [ Required, SqlColumnNumber = 3 ];

/// 接班医护人员ID
Property ReliefCareProvID As %String [ Required, SqlColumnNumber = 4 ];

/// 交接班类型
Property ShiftType As %String(DISPLAYLIST = ",麻醉医生交接班,手术护士交接班,麻醉护士交接班,麻醉助手交接班,巡回护士交接班,器械护士交接班,PACU医生交接班,PACU护士交接班", VALUELIST = ",A,ON,AN,AA,SN,CN,PD,PN") [ SqlColumnNumber = 5 ];

/// 交接班说明
Property ShiftNote As %String(MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 交接班日期
Property ShiftDate As %Date [ SqlColumnNumber = 7 ];

/// 交接班时间
Property ShiftTime As %Time [ SqlColumnNumber = 8 ];

/// 交接班医护人员科室
Property CareProvDept As %String [ SqlColumnNumber = 9 ];

/// 更新人
Property UpdateUser As %String [ SqlColumnNumber = 10 ];

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11 ];

/// 更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Trigger AfterInsert [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterUpdate [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterDelete [ Event = DELETE, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Storage Default
{
<Data name="OperShiftDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>ShiftCareProvID</Value>
</Value>
<Value name="3">
<Value>ReliefCareProvID</Value>
</Value>
<Value name="4">
<Value>ShiftType</Value>
</Value>
<Value name="5">
<Value>ShiftNote</Value>
</Value>
<Value name="6">
<Value>ShiftDate</Value>
</Value>
<Value name="7">
<Value>ShiftTime</Value>
</Value>
<Value name="8">
<Value>CareProvDept</Value>
</Value>
<Value name="9">
<Value>UpdateUser</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperShiftD</DataLocation>
<DefaultData>OperShiftDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperShiftD</IdLocation>
<IndexLocation>^CIS.AN.OperShiftI</IndexLocation>
<StreamLocation>^CIS.AN.OperShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
