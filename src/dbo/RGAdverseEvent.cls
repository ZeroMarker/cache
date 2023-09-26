Class dbo.RGAdverseEvent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_AdverseEvent, StorageStrategy = Default ]
{

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexEventNo On EventNo [ SqlName = Index_EventNo, Type = index, Unique ];

Index PKRGADVERSEEVENT On RowID [ PrimaryKey, SqlName = PK_RG_ADVERSEEVENT, Type = index, Unique ];

ForeignKey FKRGEventFilePath(FilePathDR) References dbo.RGFilePath(PKRGFILEPATH) [ SqlName = FK_RG_Event_FilePath ];

ForeignKey FKRGEventCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Event_Creator ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property EventNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

Property Event As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property Content As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Property FilePathDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RGAdverseEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventNo</Value>
</Value>
<Value name="3">
<Value>Event</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
<Value name="5">
<Value>FilePathDR</Value>
</Value>
<Value name="6">
<Value>CreatorDR</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RGAdverseEventD</DataLocation>
<DefaultData>RGAdverseEventDefaultData</DefaultData>
<IdLocation>^dbo.RGAdverseEventD</IdLocation>
<IndexLocation>^dbo.RGAdverseEventI</IndexLocation>
<StreamLocation>^dbo.RGAdverseEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
