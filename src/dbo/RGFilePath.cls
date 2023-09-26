Class dbo.RGFilePath Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_FilePath, StorageStrategy = Default ]
{

Index IndexMaster On (Code, DataID, FilePath) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index PKRGFILEPATH On RowID [ PrimaryKey, SqlName = PK_RG_FILEPATH, Type = index, Unique ];

ForeignKey FKRGTransportCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Transport_Creator ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property DataID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FilePath As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 5 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RGFilePathDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>DataID</Value>
</Value>
<Value name="4">
<Value>FilePath</Value>
</Value>
<Value name="5">
<Value>CreatorDR</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGFilePathD</DataLocation>
<DefaultData>RGFilePathDefaultData</DefaultData>
<IdLocation>^dbo.RGFilePathD</IdLocation>
<IndexLocation>^dbo.RGFilePathI</IndexLocation>
<StreamLocation>^dbo.RGFilePathS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
