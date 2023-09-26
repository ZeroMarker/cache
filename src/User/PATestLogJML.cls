Class User.PATestLogJML Extends %Persistent [ SqlTableName = PA_TestLogJML, StorageStrategy = NewStorage1 ]
{

Property LogPersonDr As User.PATestJML [ SqlColumnNumber = 2, SqlFieldName = Log_Person_Dr ];

Property LogFiled As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Filed ];

Property LogOldValue As %String [ SqlColumnNumber = 4, SqlFieldName = Log_OldValue ];

Property LogNewValue As %String [ SqlColumnNumber = 5, SqlFieldName = Log_NewValue ];

Storage NewStorage1
{
<SqlIdExpression>$i(^PATESTLOGi)</SqlIdExpression>
<SQLMap name="DateMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="Log_Filed">
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
<SQLMap name="IndexLogPersonDr">
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
<StreamLocation>^User.PATestLogJMLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
