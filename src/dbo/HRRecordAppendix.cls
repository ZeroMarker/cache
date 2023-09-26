Class dbo.HRRecordAppendix Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_RecordAppendix, StorageStrategy = Default ]
{

Index IndexRecord On (RecordType, RecordDR) [ SqlName = Index_Record, Type = index ];

/// DDL Primary Key Specification
Index PKHRRECORDAPPENDIX On RowID [ PrimaryKey, SqlName = PK_HR_RECORDAPPENDIX, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RecordType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3 ];

Property RecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="HRRecordAppendixDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordType</Value>
</Value>
<Value name="3">
<Value>RecordDR</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>FilePath</Value>
</Value>
</Data>
<DataLocation>^dbo.HRRecordAppendixD</DataLocation>
<DefaultData>HRRecordAppendixDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.HRRecordAppendixD</IdLocation>
<IndexLocation>^dbo.HRRecordAppendixI</IndexLocation>
<StreamLocation>^dbo.HRRecordAppendixS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
