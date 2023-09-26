/// 手术麻醉表单提交数据
Class CIS.AN.ArchiveData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ArchiveData ]
{

/// 手术麻醉表单提交归档记录
Property ArchiveRecord As CIS.AN.ArchiveRecord [ Required, SqlColumnNumber = 2 ];

/// 数据项
Property DataItem As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 数据项描述
Property DataItemDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 数据值
Property DataValue As %String(MAXLEN = 2000) [ SqlColumnNumber = 5 ];

/// 数据更新用户
Property UpdateUserID As %String [ SqlColumnNumber = 6 ];

/// 数据更新日期
Property UpdateDate As %Date [ InitialExpression = {$piece($h,",",1)}, SqlColumnNumber = 7 ];

/// 数据更新时间
Property UpdateTime As %Time [ InitialExpression = {$piece($h,",",2)}, SqlColumnNumber = 8 ];

/// 数据说明
Property DataNote As %String [ SqlColumnNumber = 9 ];

/// 数据分数
Property DataScore As %String [ SqlColumnNumber = 10 ];

Index IArchive On ArchiveRecord;

ForeignKey FKArchiveRecord(ArchiveRecord) References CIS.AN.ArchiveRecord() [ OnDelete = cascade ];

Storage Default
{
<Data name="ArchiveDataDefaultData">
<Value name="1">
<Value>ArchiveRecord</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>DataItemDesc</Value>
</Value>
<Value name="4">
<Value>DataValue</Value>
</Value>
<Value name="5">
<Value>UpdateUserID</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>DataNote</Value>
</Value>
<Value name="9">
<Value>DataScore</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ArchiveDataD</DataLocation>
<DefaultData>ArchiveDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.ArchiveDataD</IdLocation>
<IndexLocation>^CIS.AN.ArchiveDataI</IndexLocation>
<StreamLocation>^CIS.AN.ArchiveDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
