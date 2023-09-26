/// 列表子术语库：DKB_ListBase
Class User.DKBListBase Extends %Persistent [ SqlRowIdName = DKBLB_RowId, SqlTableName = DKB_ListBase, StorageStrategy = SQLStorage ]
{

//^DKBLISBAS

Property DKBLBCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DKBLB_Code ];

Property DKBLBDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBLB_Desc ];

Property DKBLBBCDR As User.DKBBaseCat [ SqlColumnNumber = 4, SqlFieldName = DKBLB_BCDR ];

Property DKBLBRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DKBLB_Remark ];

Property DKBLBActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DKBLB_ActiveFlag ];

Property DKBLBExtend As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBLB_Extend ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBLISBAS(0))</SqlIdExpression>
<SQLMap name="CatIndex">
<Global>^DKBLISBAS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBLB_BCDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CodeIndex">
<Global>^DKBLISBAS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBLB_BCDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({DKBLB_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBLISBAS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBLB_BCDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({DKBLB_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBLB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBLB_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBLB_BCDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBLB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBLB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBLB_Extend">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBLB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DKBLISBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBLB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBListBaseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
