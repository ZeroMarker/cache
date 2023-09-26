Class User.TestA Extends %Persistent [ SqlRowIdName = TestA_RowId, SqlTableName = TestA, StorageStrategy = NewStorage1 ]
{

Property NewProperty1 As %String;

Property NewProperty2 As %String;

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^TestA(0))</SqlIdExpression>
<SQLMap name="Map1">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="NewProperty1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NewProperty2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^TestA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TestA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TestA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TestA_RowId</SqlRowIdName>
<StreamLocation>^User.TestAS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
