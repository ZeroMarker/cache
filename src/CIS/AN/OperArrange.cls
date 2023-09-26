/// 手术排班
Class CIS.AN.OperArrange Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperArrange ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 手术间
Property OperRoom As CF.AN.Location [ SqlColumnNumber = 3 ];

/// 台次
Property OperSeq As %String [ SqlColumnNumber = 4 ];

/// 器械护士
Property ScrubNurse As %String [ SqlColumnNumber = 5 ];

/// 巡回护士
Property CircualNurse As %String [ SqlColumnNumber = 6 ];

/// 排班说明
Property Note As %String [ SqlColumnNumber = 7 ];

/// 发布用户
Property ReleaseUser As %String [ SqlColumnNumber = 8 ];

/// 发布日期
Property ReleaseDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9 ];

/// 发布时间
Property ReleaseTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10 ];

/// 手术状态
Property OperStatus As CT.AN.OperStatus [ SqlColumnNumber = 11 ];

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
<Data name="OperArrangeDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>OperRoom</Value>
</Value>
<Value name="3">
<Value>OperSeq</Value>
</Value>
<Value name="4">
<Value>ScrubNurse</Value>
</Value>
<Value name="5">
<Value>CircualNurse</Value>
</Value>
<Value name="6">
<Value>Note</Value>
</Value>
<Value name="7">
<Value>ReleaseUser</Value>
</Value>
<Value name="8">
<Value>ReleaseDate</Value>
</Value>
<Value name="9">
<Value>ReleaseTime</Value>
</Value>
<Value name="10">
<Value>OperStatus</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperArrangeD</DataLocation>
<DefaultData>OperArrangeDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperArrangeD</IdLocation>
<IndexLocation>^CIS.AN.OperArrangeI</IndexLocation>
<StreamLocation>^CIS.AN.OperArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
