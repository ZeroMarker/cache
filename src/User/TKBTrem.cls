/// 术语库字典表：TKB_Trem 
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-18
Class User.TKBTrem Extends %Persistent [ SqlRowIdName = TKBTRB_RowId, SqlTableName = TKB_Trem, StorageStrategy = SQLStorage ]
{

//^TKBTREM ^TKBTREMi

Property TKBTRBCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TKBTRB_Code ];

Property TKBTRBDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TKBTRB_Desc ];

Property TKBTRBBaseDR As User.TKBTremBase [ SqlColumnNumber = 4, SqlFieldName = TKBTRB_Base_DR ];

Property TKBTRBLastLevel As User.TKBTrem [ SqlColumnNumber = 5, SqlFieldName = TKBTRB_LastLevel ];

Property TKBTRBPYCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TKBTRB_PYCode ];

Property TKBTRBNote As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TKBTRB_Note ];

//Property TKBTRBSource As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TKBTRB_Source ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTREM(0))</SqlIdExpression>
<SQLMap name="BaseIndex">
<Global>^TKBTREMi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTRB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Base"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRB_Base_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CodeIndex">
<Global>^TKBTREMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRB_Base_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({TKBTRB_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^TKBTREMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRB_Base_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({TKBTRB_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTRB_Base_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTRB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTRB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTRB_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TKBTRB_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBTRB_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^TKBTREM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTRB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTRB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^TKBTREMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRB_Base_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRB_LastLevel}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
