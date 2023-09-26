/// 归档日志
Class CIS.AN.ArchiveLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ArchiveLog ]
{

/// 手术麻醉表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 归档用户
Property ArchiveUser As %String [ Required, SqlColumnNumber = 3 ];

/// 归档日期
Property ArchiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 归档时间
Property ArchiveTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 5 ];

/// 文件归档地址
Property Url As %String(MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 手术麻醉表单索引
Index IRecordSheet On RecordSheet;

/// 归档日期索引
Index IArchiveDate On ArchiveDate;

/// 手术麻醉表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="ArchiveLogDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>ArchiveUser</Value>
</Value>
<Value name="3">
<Value>ArchiveDate</Value>
</Value>
<Value name="4">
<Value>ArchiveTime</Value>
</Value>
<Value name="5">
<Value>Url</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ArchiveLogD</DataLocation>
<DefaultData>ArchiveLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.ArchiveLogD</IdLocation>
<IndexLocation>^CIS.AN.ArchiveLogI</IndexLocation>
<StreamLocation>^CIS.AN.ArchiveLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
