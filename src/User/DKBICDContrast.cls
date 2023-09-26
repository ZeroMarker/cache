/// Function: 国际编码 对照 北京编码 
/// CreateDate: 2016-12-20
/// Creator:  sunfengchao
Class User.DKBICDContrast Extends %Persistent [ SqlRowIdName = DKBCT_RowId, SqlTableName = DKB_ICDContrast, StorageStrategy = NewStorage1 ]
{

Property DKBCTIntCode As %String [ SqlColumnNumber = 2, SqlFieldName = DKBCT_IntCode ];

Property DKBCTIntDesc As list Of %String [ SqlColumnNumber = 3, SqlFieldName = DKBCT_IntDesc ];

Property DKBCTIntLongDescription As list Of %String [ SqlColumnNumber = 4, SqlFieldName = DBKCT_IntLongDesc ];

Property DKBCTPekCode As %String [ SqlColumnNumber = 5, SqlFieldName = DBKCT_PekCode ];

Property DKBCTPekDesc As %String [ SqlColumnNumber = 6, SqlFieldName = DBKCT_PekDesc ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DBKICDCONSTRAST(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DBKICDCONSTRAST</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCT_IntCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DBKCT_PekCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DBKICDCONSTRAST</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PekCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DBKCT_PekCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DBKCT_IntLongDesc">
<Node>"IntLongDesc"</Node>
</Data>
<Data name="DBKCT_PekCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DBKCT_PekDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBCT_IntCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBCT_IntDesc">
<Node>"IntDesc"</Node>
</Data>
<Global>^DBKICDCONSTRAST</Global>
<Subscript name="1">
<Expression>{DKBCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBICDContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
