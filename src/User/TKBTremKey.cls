/// 术语拼音码字典表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-18
Class User.TKBTremKey Extends %Persistent [ SqlRowIdName = TKBTRK_RowId, SqlTableName = TKB_TremKey, StorageStrategy = SQLStorage ]
{

//^TKBTREKEY ^TKBTREKEYi

Property TKBTRKTreDr As User.TKBTremCom [ SqlColumnNumber = 2, SqlFieldName = TKBTRK_Tre_Dr ];

Property TKBTRKCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTRK_Code ];

Property TKBTRKDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TKBTRK_Desc ];

Property TKBTRKType As %String(DISPLAYLIST = ",常用名,别名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A") [ SqlColumnNumber = 5, SqlFieldName = TKBTRK_Type ];

Property TKBTRKActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TKBTRK_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBDGSKEY(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^TKBTREKEYi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TKBTRK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRK_Tre_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({TKBTRK_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTRK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^TKBTREKEYi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TKBTRK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRK_Tre_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({TKBTRK_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTRK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTRK_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBTRK_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTRK_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTRK_Tre_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTRK_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^TKBTREKEY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTRK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTRK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TreIndex">
<Global>^TKBTREKEYi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Tre"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRK_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRK_Tre_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
