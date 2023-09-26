Class User.DHCAppTestSpecRelArc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, StorageStrategy = DHCAppTestSpecRelArc ]
{

Property AppTestSpec As User.DHCAppTestSpec [ SqlColumnNumber = 2, SqlFieldName = App_TestSpec ];

Property AppTestSpecArc As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = App_TestSpecArc ];

Storage DHCAppTestSpecRelArc
{
<SqlIdExpression>$i(^DHCAppTestSpecRelArc)</SqlIdExpression>
<SQLMap name="IndexSpecArc">
<Global>^DHCAppTestSpecRelArc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AppTest"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{App_TestSpec}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{App_TestSpecArc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="App_TestSpec">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="App_TestSpecArc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAppTestSpecRelArc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppTestSpecRelArcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
