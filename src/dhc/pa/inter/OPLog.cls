/// 操作记录：主要记录删除和修改数据记录
Class dhc.pa.inter.OPLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPLOG_RowID, SqlTableName = OPLog, StorageStrategy = SqlStorage ]
{

/// 被操作模块的名称
Property OPLOGModuleName As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OPLOG_ModuleName ];

/// 操作方式
Property OPLOGMode As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OPLOG_Mode ];

/// 操作数据
Property OPLOGData As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OPLOG_Data ];

/// 操作人
Property OPLOGUser As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OPLOG_User ];

/// 操作时间
Property OPLOGTime As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OPLOG_Time ];

/// 操作表和记录的rowid值
Property OPLOGTableSub As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OPLOG_TableSub ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCCJXPAINTEROPLOG(0))</SqlIdExpression>
<SQLMap name="Index">
<Data name="OPLOG_Data">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPLOG_Mode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPLOG_ModuleName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPLOG_TableSub">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPLOG_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPLOG_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCJXPAINTEROPLOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPLOG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OPLOG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.OPLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
