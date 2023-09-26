Class User.DHCVISNote Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Note_RowId, SqlTableName = DHC_VIS_Note, StorageStrategy = NewStorage1 ]
{

/// NoteDesc
Property NoteDesc As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Note_Desc ];

/// User
Property NoteUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = Note_User ];

/// CreateDate
Property CreateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = Note_CreateDate ];

/// CreateTime
Property CreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = Note_CreateTime ];

/// UpdateDate
Property UpdateDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = Note_UpdateDate ];

/// CreateTime
Property UpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = Note_UpdateTime ];

/// PeriodNote Active
Property NoteActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = Note_Active ];

/// PeriodNote
Property NotePeriodNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Note_PeriodNote ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCVISNoteD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Note_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Note_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Note_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Note_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Note_PeriodNote">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Note_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Note_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Note_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISNoteD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Note_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Note_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCreateDate">
<Global>^DHCVISNotei</Global>
<RowIdSpec name="1">
<Expression>{l4}</Expression>
<Field>Note_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Note_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Note_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDesc">
<Global>^DHCVISNotei</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Note_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NoteDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Note_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Note_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUserId">
<Global>^DHCVISNotei</Global>
<RowIdSpec name="1">
<Expression>{l4}</Expression>
<Field>Note_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NoteUserId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Note_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Note_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Note_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVISNoteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
