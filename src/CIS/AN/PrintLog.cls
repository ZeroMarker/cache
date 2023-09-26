/// 表单打印日志
Class CIS.AN.PrintLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PrintLog ]
{

/// 手术表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 打印类型
Property Type As %String [ Required, SqlColumnNumber = 3 ];

/// 打印用户
Property PrintUser As %String [ Required, SqlColumnNumber = 4 ];

/// 打印日期
Property PrintDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 打印时间
Property PrintTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 手术麻醉记录表单、打印类型索引
Index IType On (RecordSheet, Type);

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="PrintLogDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>PrintUser</Value>
</Value>
<Value name="4">
<Value>PrintDate</Value>
</Value>
<Value name="5">
<Value>PrintTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PrintLogD</DataLocation>
<DefaultData>PrintLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.PrintLogD</IdLocation>
<IndexLocation>^CIS.AN.PrintLogI</IndexLocation>
<StreamLocation>^CIS.AN.PrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
