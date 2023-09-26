Class dbo.OTNotice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_Notice, StorageStrategy = Default ]
{

Index IndexCreateDate On (CreateDate, CreateDate) [ SqlName = Index_CreateDate, Type = index ];

Index IndexReleaseDate On (ReleaseDate, ReleaseTime) [ SqlName = Index_ReleaseDate, Type = index ];

Index IndexEndDate On (EndDate, EndTime) [ SqlName = Index_EndDate, Type = index ];

/// DDL Primary Key Specification
Index PKOTNOTICE On RowID [ PrimaryKey, SqlName = PK_OT_NOTICE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 5000) [ SqlColumnNumber = 7 ];

Property WorkGroupList As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

Property UserList As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 9 ];

Property ReleaseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ReleaseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property NoticeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 17 ];

Property NoticeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="OTNoticeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>CreateUserDR</Value>
</Value>
<Value name="5">
<Value>Title</Value>
</Value>
<Value name="6">
<Value>Content</Value>
</Value>
<Value name="7">
<Value>WorkGroupList</Value>
</Value>
<Value name="8">
<Value>UserList</Value>
</Value>
<Value name="9">
<Value>ReleaseDate</Value>
</Value>
<Value name="10">
<Value>ReleaseTime</Value>
</Value>
<Value name="11">
<Value>EndDate</Value>
</Value>
<Value name="12">
<Value>EndTime</Value>
</Value>
<Value name="13">
<Value>CheckDate</Value>
</Value>
<Value name="14">
<Value>CheckTime</Value>
</Value>
<Value name="15">
<Value>CheckUserDR</Value>
</Value>
<Value name="16">
<Value>NoticeNo</Value>
</Value>
<Value name="17">
<Value>NoticeTypeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.OTNoticeD</DataLocation>
<DefaultData>OTNoticeDefaultData</DefaultData>
<IdLocation>^dbo.OTNoticeD</IdLocation>
<IndexLocation>^dbo.OTNoticeI</IndexLocation>
<StreamLocation>^dbo.OTNoticeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
