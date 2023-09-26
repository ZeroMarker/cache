Class BILL.CES.PO.DHCImportLog Extends (%Persistent, User.Abstract) [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = DHC_ImportLog ]
{

Property IRRowId As %Library.Integer(MAXVAL = 2147483647, MINVAL = 1) [ Identity, SqlColumnNumber = 2, SqlFieldName = IR_RowId ];

Property IRSeqNo As %Library.Integer [ Required, SqlColumnNumber = 3, SqlFieldName = IR_SeqNo ];

Property IRTableName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 4, SqlFieldName = IR_TableName ];

Property IRDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = IR_Date ];

Property IRTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = IR_Time ];

Property IRHisId As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 7, SqlFieldName = IR_HisId ];

Property IRCESId As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 8, SqlFieldName = IR_CESId ];

/// 客户端编号
Property IRCESTerminalNo As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 9, SqlFieldName = IR_CESTerminalNo ];

/// 应急系统唯一
Property IRCESGlobalNo As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 10, SqlFieldName = IR_CESGlobalNo ];

/// 应急收费系统导回的原始json串
Property IRCESOrigString As %Library.String(COLLATION = "EXACT", MAXLEN = 2000) [ SqlColumnNumber = 11, SqlFieldName = IR_CESOrigString ];

/// 上传人员姓名
Property IRCESUserName As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 12, SqlFieldName = IR_CESUserName ];

Index IDXDate On (IRDate, IRRowId) [ SqlName = IDXDate, Type = index ];

Index IDXTabGlobalNo On (IRTableName, IRCESGlobalNo, IRRowId) [ SqlName = IDXTabGlobalNo, Type = index ];

Index IDXTabCESId On (IRTableName, IRCESTerminalNo, IRCESId, IRRowId) [ SqlName = IDXTabCESId, Type = index ];

Index IDXTabHisId On (IRTableName, IRHisId, IRRowId) [ SqlName = IDXTabHisId, Type = index ];

Index IDXIRSeqNo On (IRSeqNo, IRRowId) [ SqlName = IRSeqNo, Type = index ];

/// DDL Primary Key Specification
Index RowIDFieldAsPKey On IRRowId [ IdKey, PrimaryKey, SqlName = RowIDField_As_PKey, Unique ];

Storage Default
{
<Data name="DHCImportLogDefaultData">
<Value name="1">
<Value>IRTableName</Value>
</Value>
<Value name="2">
<Value>IRDate</Value>
</Value>
<Value name="3">
<Value>IRTime</Value>
</Value>
<Value name="4">
<Value>IRHisId</Value>
</Value>
<Value name="5">
<Value>IRCESId</Value>
</Value>
<Value name="6">
<Value>IRText1</Value>
</Value>
<Value name="7">
<Value>IRText2</Value>
</Value>
<Value name="8">
<Value>IRMAC</Value>
</Value>
<Value name="9">
<Value>IRCESGlobalNo</Value>
</Value>
<Value name="10">
<Value>IRCESTerminalNo</Value>
</Value>
<Value name="11">
<Value>IRCESOutString</Value>
</Value>
<Value name="12">
<Value>IRCESOrigString</Value>
</Value>
<Value name="13">
<Value>IRSeqNo</Value>
</Value>
<Value name="14">
<Value>IRCESUserName</Value>
</Value>
</Data>
<DataLocation>^BILL.CES.PO.DHCImportLogD</DataLocation>
<DefaultData>DHCImportLogDefaultData</DefaultData>
<IdFunction>sequence</IdFunction>
<IdLocation>^BILL.CES.PO.DHCImportLogD</IdLocation>
<IndexLocation>^BILL.CES.PO.DHCImportLogI</IndexLocation>
<StreamLocation>^BILL.CES.PO.DHCImportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
