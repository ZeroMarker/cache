Class dbo.OTNoticeFile Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_NoticeFile, StorageStrategy = Default ]
{

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

Index IndexNotice On NoticeDR [ SqlName = Index_Notice, Type = index ];

/// Foreign Key FKAGAssessTypeHospital created via DDL
ForeignKey FKOTNoticeFileNotice(NoticeDR) References dbo.OTNotice(PKOTNOTICE) [ SqlName = FK_OTNoticeFile_Notice ];

/// DDL Primary Key Specification
Index PKOTNOTICEFILE On RowID [ PrimaryKey, SqlName = PK_OT_NOTICEFILE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property NoticeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="OTNoticeFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoticeDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>FilePath</Value>
</Value>
</Data>
<DataLocation>^dbo.OTNoticeFileD</DataLocation>
<DefaultData>OTNoticeFileDefaultData</DefaultData>
<IdLocation>^dbo.OTNoticeFileD</IdLocation>
<IndexLocation>^dbo.OTNoticeFileI</IndexLocation>
<StreamLocation>^dbo.OTNoticeFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
