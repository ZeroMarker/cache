/// 麻醉记录时间轴
Class CIS.AN.TimeLine Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = TimeLine ]
{

/// 麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 每列表示的分钟数
Property ColumnMinutes As %Integer(MAXVAL = 10, MINVAL = 1) [ InitialExpression = 10, Required, SqlColumnNumber = 3 ];

/// 开始日期
Property StartDate As %Date [ Required, SqlColumnNumber = 4 ];

/// 开始时间
Property StartTime As %Time [ Required, SqlColumnNumber = 5 ];

/// 结束日期
Property EndDate As %Date [ Required, SqlColumnNumber = 6 ];

/// 结束时间
Property EndTime As %Time [ Required, SqlColumnNumber = 7 ];

/// 麻醉记录表单索引
Index ISheet On RecordSheet;

/// 麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="TimeLineDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>ColumnMinutes</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>StartTime</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.TimeLineD</DataLocation>
<DefaultData>TimeLineDefaultData</DefaultData>
<IdLocation>^CIS.AN.TimeLineD</IdLocation>
<IndexLocation>^CIS.AN.TimeLineI</IndexLocation>
<StreamLocation>^CIS.AN.TimeLineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
