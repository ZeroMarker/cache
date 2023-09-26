Class User.PAZYZTESTLOG Extends %Persistent [ SqlTableName = PAZYZ_TestLog, StorageStrategy = NewStorage1 ]
{

/// 病人RowID
Property LogPersonDr As User.PAZYZTEST [ Required, SqlColumnNumber = 2, SqlFieldName = Log_Person_Dr ];

/// 值变化字段名
Property LogFiled As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Filed ];

/// 旧值
Property LogOldValue As %String [ SqlColumnNumber = 4, SqlFieldName = Log_Old_Value ];

/// 新值
Property LogNewValue As %String [ SqlColumnNumber = 5, SqlFieldName = Log_New_Value ];

Storage NewStorage1
{
<SqlIdExpression>$i(^PAZYZTestLog(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="Log_Filed">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Log_New_Value">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Log_Old_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Log_Person_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAZYZTestLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Log_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPersonDr">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^PAZYZTestLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Log_Person_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Log_RowId</SqlRowIdName>
<StreamLocation>^User.PAZYZTESTLOGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
