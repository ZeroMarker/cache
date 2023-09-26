/// 医用知识库icd北京码与His ICD诊断对照：TKB_ICDContrast
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-8-22
Class User.TKBICDContrast Extends %Persistent [ SqlRowIdName = TKBICT_RowId, SqlTableName = TKB_ICDContrast, StorageStrategy = SQLStorage ]
{

/// ^TKBICDCON
Property TKBICTTremDr As User.TKBTrem [ SqlColumnNumber = 2, SqlFieldName = TKBICT_Trem_Dr ];

Property TKBICTICDDxDr As User.MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = TKBICT_ICDDx_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBICDCON(0))</SqlIdExpression>
<SQLMap name="IndexContrast">
<Global>^TKBICDCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBICT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Contrast"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBICT_Trem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBICT_ICDDx_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICDDx">
<Global>^TKBICDCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBICT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICDDx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBICT_ICDDx_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTrem">
<Global>^TKBICDCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBICT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Trem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBICT_Trem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBICT_ICDDx_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBICT_Trem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TKBICDCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBICT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBICT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.TKBICDContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
