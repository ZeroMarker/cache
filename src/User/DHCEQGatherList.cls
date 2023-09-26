Class User.DHCEQGatherList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GL_RowID, SqlTableName = DHC_EQGatherList, StorageStrategy = SQLStorage ]
{

/// GL_GatherDR
Property GLGatherDR As User.DHCEQGather [ SqlColumnNumber = 2, SqlFieldName = GL_GatherDR ];

/// GL_UseDate
Property GLUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = GL_UseDate ];

/// GL_ExType
Property GLExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GL_ExType ];

/// GL_BeginTime
Property GLBeginTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = GL_BeginTime ];

/// GL_EndTime
Property GLEndTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = GL_EndTime ];

/// GL_Status
Property GLStatus As %Library.String(DISPLAYLIST = ",失败,成功", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 7, SqlFieldName = GL_Status ];

/// GL_Version
Property GLVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = GL_Version ];

/// GL_Hold1
Property GLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = GL_Hold1 ];

/// GL_Hold2
Property GLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GL_Hold2 ];

/// GL_Hold3
Property GLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GL_Hold3 ];

/// GL_Hold4
Property GLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GL_Hold4 ];

/// GL_Hold5
Property GLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = GL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQGatherList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GL_BeginTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GL_ExType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GL_GatherDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GL_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GL_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GL_Version">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQGatherList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGather">
<Global>^DHCEQGatherList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gather"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GL_GatherDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^DHCEQGatherList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>{GL_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Version"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GL_GatherDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GL_ExType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GL_UseDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GL_Version}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{GL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQGatherListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
