Class User.TestB Extends %Persistent [ StorageStrategy = NewStorage1 ]
{

Property NewProperty1 As User.TestA [ SqlColumnNumber = 3 ];

Property NewProperty2 As %String [ SqlColumnNumber = 2 ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^TestB(0))</SqlIdExpression>
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
<Data name="NewProperty3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NewProperty4">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NewProperty5">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^TestB</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TestB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TestB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TestB_RowId</SqlRowIdName>
<SqlTableNumber>TestB</SqlTableNumber>
<StreamLocation>^User.TestBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Property NewProperty3 As %Date;

Property NewProperty4 As %Boolean;

Property NewProperty5 As %Time;

}
