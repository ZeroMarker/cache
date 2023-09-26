/// 手术麻醉通用数据表
Class CIS.AN.OperData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperData ]
{

/// 手术麻醉表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 数据项
Property DataItem As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 数据值
Property DataValue As %String(MAXLEN = 99999) [ SqlColumnNumber = 4 ];

/// 数据的执行日期
Property ExecDate As %Date [ SqlColumnNumber = 5 ];

/// 数据执行时间
Property ExecTime As %Time [ SqlColumnNumber = 6 ];

/// 数据更新用户ID
Property UpdateUserID As %String [ SqlColumnNumber = 7 ];

/// 数据更新日期
Property UpdateDate As %Date [ InitialExpression = {$piece($h,",",1)}, SqlColumnNumber = 8 ];

/// 数据更新时间
Property UpdateTime As %Time [ InitialExpression = {$piece($h,",",2)}, SqlColumnNumber = 9 ];

/// 分数值
Property DataScore As %String [ SqlColumnNumber = 10 ];

/// 数据说明
Property DataNote As %String [ SqlColumnNumber = 11 ];

/// 数据项描述
Property DataItemDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

Index ISheet On RecordSheet;

Index ICode On (RecordSheet, DataItem) [ Unique ];

ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

ClassMethod GetOpsId(recordSheetId)
{
	set obj=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set id=obj.OperSchedule.%Id()
	do obj.%Close()
	quit id
}

Trigger AfterInsert [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
    set recordSheetId = {RecordSheet}
    set id=..GetOpsId(recordSheetId)
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterUpdate [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
    set recordSheetId = {RecordSheet}
    set id=..GetOpsId(recordSheetId)
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterDelete [ Event = DELETE, Foreach = row/object, Time = AFTER ]
{
    set recordSheetId = {RecordSheet}
    set id=..GetOpsId(recordSheetId)
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Storage Default
{
<Data name="OperDataDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>DataValue</Value>
</Value>
<Value name="4">
<Value>ExecDate</Value>
</Value>
<Value name="5">
<Value>ExecTime</Value>
</Value>
<Value name="6">
<Value>UpdateUserID</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>DataScore</Value>
</Value>
<Value name="10">
<Value>DataNote</Value>
</Value>
<Value name="11">
<Value>DataItemDesc</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperDataD</DataLocation>
<DefaultData>OperDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperDataD</IdLocation>
<IndexLocation>^CIS.AN.OperDataI</IndexLocation>
<StreamLocation>^CIS.AN.OperDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
