///     
Class dbo.BDRecordPrintLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_RecordPrintLog, StorageStrategy = Default ]
{

/// Foreign Key FKBDRPrintLUser created via DDL
ForeignKey FKBDRPrintLUser(PrintUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RPrintL_User ];

Index IndexPrintDate On PrintDate [ SqlName = Index_PrintDate, Type = index ];

Index IndexPrintUser On PrintUserDR [ SqlName = Index_PrintUser, Type = index ];

Index IndexRecordNo On RecordNo [ SqlName = Index_RecordNo, Type = index ];

Index IndexRecordType On RecordType [ SqlName = Index_RecordType, Type = index ];

/// DDL Primary Key Specification
Index PKBDRECORDPRINTLOG On RowID [ PrimaryKey, SqlName = PK_BD_RECORDPRINTLOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property RecordType As %Library.SmallInt [ Required, SqlColumnNumber = 3 ];

Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property PrintDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property PrintTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property PrintUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BDRecordPrintLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecordType</Value>
</Value>
<Value name="3">
<Value>RecordNo</Value>
</Value>
<Value name="4">
<Value>PrintDate</Value>
</Value>
<Value name="5">
<Value>PrintTime</Value>
</Value>
<Value name="6">
<Value>PrintUserDR</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
</Data>
<DataLocation>^dbo.BDRecordPrintLogD</DataLocation>
<DefaultData>BDRecordPrintLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDRecordPrintLogD</IdLocation>
<IndexLocation>^dbo.BDRecordPrintLogI</IndexLocation>
<StreamLocation>^dbo.BDRecordPrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
