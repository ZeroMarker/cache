/// 名称: 术语明细表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2017-4-18
Class User.TKBTremItm Extends %Persistent [ SqlRowIdName = TKBTRI_RowId, SqlTableName = TKB_TremItm, StorageStrategy = NewStorage1 ]
{

/// ^TKBTREMITM ^TKBTREMITMi
Property TKBTRITremDR As User.TKBTrem [ SqlColumnNumber = 2, SqlFieldName = TKBTRI_Trem_DR ];

Property TKBTRIFieldDr As User.TKBTremBaseField [ SqlColumnNumber = 3, SqlFieldName = TKBTRI_Field_Dr ];

Property TKBTRISource As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TKBTRI_Source ];

Storage NewStorage1
{
<SqlIdExpression>$i(^TKBTREMITM(0))</SqlIdExpression>
<SQLMap name="FieldIndex">
<Global>^TKBTREMITMi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Field"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRI_Field_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LinkIndex">
<Global>^TKBTREMITMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRI_Trem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRI_Field_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTRI_Field_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTRI_Source">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTRI_Trem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TKBTREMITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTRI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TremIndex">
<Global>^TKBTREMITMi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTRI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Trem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRI_Trem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
