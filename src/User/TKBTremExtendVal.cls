/// 知识点扩展属性值表： TKB_TremExtendVal(子)
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-21
Class User.TKBTremExtendVal Extends %Persistent [ SqlRowIdName = TKBTEV_RowId, SqlTableName = TKB_TremExtendVal, StorageStrategy = SQLStorage ]
{

//^TKBTREEXTVAL,^TKBTREEXTVALi

Property TKBTEVParDr As User.TKBTremExtendDetail [ SqlColumnNumber = 2, SqlFieldName = TKBTEV_Par_Dr ];

Property TKBTEVExtendDr As User.TKBTremExtendCat [ SqlColumnNumber = 3, SqlFieldName = TKBTEV_Extend_Dr ];

Property TKBTEVValue As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TKBTEV_Value ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTREEXTVAL(0))</SqlIdExpression>
<SQLMap name="CatIndex">
<Global>^TKBTREEXTVALi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTEV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTEV_Extend_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTEV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DetailIndex">
<Global>^TKBTREEXTVALi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTEV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTEV_Par_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTEV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTEV_Extend_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTEV_Par_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTEV_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^TKBTREEXTVAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTEV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTEV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ValIdex">
<Global>^TKBTREEXTVALi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTEV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Val"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTEV_Par_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTEV_Extend_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTEV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremExtendValS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
