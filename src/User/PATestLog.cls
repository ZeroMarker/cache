Class User.PATestLog Extends %Persistent [ SqlRowIdName = Log_RowId, SqlTableName = PA_TestLog, StorageStrategy = NewStorage1 ]
{

/// 病人RowId
Property LogPersonDr As User.PATest [ SqlColumnNumber = 2, SqlFieldName = Log_Person_Dr ];

/// 值变化字段名
Property LogField As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Field ];

/// 旧值
Property LogOldValue As %String [ SqlFieldName = Log_OldValue ];

/// 新值
Property LogNewValue As %String [ SqlFieldName = Log_NewValue ];

Storage NewStorage1
{
<SqlIdExpression>$i(^PATESTLOGi)</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="Log_Field">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Log_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Log_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Log_Person_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PATESTLOGi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Log_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Log_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPersonDr">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^PATESTLOGi</Global>
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
<StreamLocation>^User.PATestLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
