/// 麻醉排班表
Class CIS.AN.AnaArrange Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaArrange ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 麻醉指导
Property AnaExpert As %String [ SqlColumnNumber = 3 ];

/// 麻醉医生
Property Anesthesiologist As %String [ SqlColumnNumber = 4 ];

/// 麻醉助手
Property AnaAssistant As %String [ SqlColumnNumber = 5 ];

/// 实习进修
Property AnaAddtionalStaff As %String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 7 ];

/// 发布用户
Property ReleaseUser As %String [ SqlColumnNumber = 8 ];

/// 发布日期
Property ReleaseDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9 ];

/// 发布时间
Property ReleaseTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10 ];

/// 排班说明
Property Note As %String [ SqlColumnNumber = 12 ];

/// 麻醉护士
Property AnaNurse As %String [ SqlColumnNumber = 13 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键索引
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
<Data name="AnaArrangeDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>AnaExpert</Value>
</Value>
<Value name="3">
<Value>Anesthesiologist</Value>
</Value>
<Value name="4">
<Value>AnaAssistant</Value>
</Value>
<Value name="5">
<Value>AnaAddtionalStaff</Value>
</Value>
<Value name="6">
<Value>AnaMethod</Value>
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
<Value>Note</Value>
</Value>
<Value name="11">
<Value>AnaNurse</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaArrangeD</DataLocation>
<DefaultData>AnaArrangeDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaArrangeD</IdLocation>
<IndexLocation>^CIS.AN.AnaArrangeI</IndexLocation>
<StreamLocation>^CIS.AN.AnaArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
