Class dbo.BDRecordOPLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_RecordOPLog, StorageStrategy = Default ]
{

/// Foreign Key FKBDRPrintLUser created via DDL
ForeignKey FKBDRecordLUser(OPUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_RecordL_User ];

Index IndexMaster On (RecordType, RecordNo, OPDate, OPTime) [ SqlName = Index_Master, Type = index ];

Index IndexUser On (OPUserDR, OPDate, RecordType) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKBDRECORDOPLOG On RowID [ PrimaryKey, SqlName = PK_BD_RECORDOPLOG, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 单据类型  
Property RecordType As %Library.SmallInt [ Required, SqlColumnNumber = 3 ];

/// 单据单号  
Property RecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 操作类型  
Property OPType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 操作日期  
Property OPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 操作时间  
Property OPTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 操作人  
Property OPUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 操作IP地址  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 操作IP地址  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BDRecordOPLogDefaultData">
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
<Value>OPType</Value>
</Value>
<Value name="5">
<Value>OPDate</Value>
</Value>
<Value name="6">
<Value>OPTime</Value>
</Value>
<Value name="7">
<Value>OPUserDR</Value>
</Value>
<Value name="8">
<Value>IPAddress</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDRecordOPLogD</DataLocation>
<DefaultData>BDRecordOPLogDefaultData</DefaultData>
<IdLocation>^dbo.BDRecordOPLogD</IdLocation>
<IndexLocation>^dbo.BDRecordOPLogI</IndexLocation>
<StreamLocation>^dbo.BDRecordOPLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
