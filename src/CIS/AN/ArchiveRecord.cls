/// 手术麻醉表单提交归档记录
Class CIS.AN.ArchiveRecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ArchiveRecord ]
{

/// 手术麻醉表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 归档绘制数据内容
Property ArchiveDataContent As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchiveRecordS") [ SqlColumnNumber = 3 ];

/// 表单提交人
Property SubmitUser As %String [ Required, SqlColumnNumber = 4 ];

/// 表单提交日期
Property SubmitDate As %Date [ InitialExpression = {+$H}, SqlColumnNumber = 5 ];

/// 表单提交时间
Property SubmitTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 撤销标志
Property SumitState As %String(DISPLAYLIST = ",已提交,撤销提交", VALUELIST = ",S,R") [ SqlColumnNumber = 7 ];

/// 表单撤销提交人
Property RevokeSubmitUser As %String [ SqlColumnNumber = 8 ];

/// 表单撤销提交日期
Property RevokeSubmitDate As %Date [ SqlColumnNumber = 9 ];

/// 表单撤销提交时间
Property RevokeSubmitTime As %Time [ SqlColumnNumber = 10 ];

/// 表单对应的界面模板
Property SheetTemplate As %String [ SqlColumnNumber = 11 ];

/// 表单对应的选择器
Property SheetSelector As %String(MAXLEN = 500) [ SqlColumnNumber = 12 ];

/// 表单提交归档代码
Property ArchiveCode As %String [ Required, SqlColumnNumber = 13 ];

/// 表单归档人
Property FileUser As %String [ SqlColumnNumber = 14 ];

/// 表单归档日期
Property FileDate As %Date [ SqlColumnNumber = 15 ];

/// 表单归档时间
Property FileTime As %Time [ SqlColumnNumber = 16 ];

/// 表单归档位置
Property FilePath As %String(MAXLEN = 1000) [ SqlColumnNumber = 17 ];

/// 表单对应的打印模板
Property PrintTemplate As %String [ SqlColumnNumber = 18 ];

Index ISheet On RecordSheet;

ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="ArchiveRecordDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>ArchiveDataContent</Value>
</Value>
<Value name="3">
<Value>SubmitUser</Value>
</Value>
<Value name="4">
<Value>SubmitDate</Value>
</Value>
<Value name="5">
<Value>SubmitTime</Value>
</Value>
<Value name="6">
<Value>SumitState</Value>
</Value>
<Value name="7">
<Value>RevokeSubmitUser</Value>
</Value>
<Value name="8">
<Value>RevokeSubmitDate</Value>
</Value>
<Value name="9">
<Value>RevokeSubmitTime</Value>
</Value>
<Value name="10">
<Value>SheetTemplate</Value>
</Value>
<Value name="11">
<Value>SheetSelector</Value>
</Value>
<Value name="12">
<Value>ArchiveCode</Value>
</Value>
<Value name="13">
<Value>FileUser</Value>
</Value>
<Value name="14">
<Value>FileDate</Value>
</Value>
<Value name="15">
<Value>FileTime</Value>
</Value>
<Value name="16">
<Value>FilePath</Value>
</Value>
<Value name="17">
<Value>PrintTemplate</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ArchiveRecordD</DataLocation>
<DefaultData>ArchiveRecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.ArchiveRecordD</IdLocation>
<IndexLocation>^CIS.AN.ArchiveRecordI</IndexLocation>
<StreamLocation>^CIS.AN.ArchiveRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
