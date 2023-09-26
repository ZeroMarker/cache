Class dbo.OTFileVersion Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_FileVersion ]
{

Index IndexPrevious On (NewOTFileInfoDR, OldOTFileInfoDR) [ SqlName = Index_Previous, Type = index, Unique ];

Index IndexNext On (OldOTFileInfoDR, NewOTFileInfoDR) [ SqlName = Index_Next, Type = index, Unique ];

Index PKOTFILEVERSION On RowID [ PrimaryKey, SqlName = PK_OT_FILEVERSION, Type = index, Unique ];

ForeignKey FKNEWOTFileInfoDR(NewOTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_NEWOTFileInfoDR ];

ForeignKey FKOLDOTFileInfoDR(OldOTFileInfoDR) References dbo.OTFileInfo(PKOTFileInfo) [ SqlName = FK_OLDOTFileInfoDR ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 新文件  
Property NewOTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 旧文件  
Property OldOTFileInfoDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 新版本号  
Property NewVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 5 ];

/// 旧版本号  
Property OldVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="OTFileVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NewOTFileInfoDR</Value>
</Value>
<Value name="3">
<Value>OldOTFileInfoDR</Value>
</Value>
<Value name="4">
<Value>NewVersion</Value>
</Value>
<Value name="5">
<Value>OldVersion</Value>
</Value>
</Data>
<DataLocation>^dbo.OTFileVersionD</DataLocation>
<DefaultData>OTFileVersionDefaultData</DefaultData>
<IdLocation>^dbo.OTFileVersionD</IdLocation>
<IndexLocation>^dbo.OTFileVersionI</IndexLocation>
<StreamLocation>^dbo.OTFileVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
