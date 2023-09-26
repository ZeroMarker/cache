Class User.DHCEmShiftLinkItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmShiftLinkItem, StorageStrategy = SQLStorage ]
{

/// 关联表ID  EM_ParRef_Dr
Property EMParRefDr As User.DHCEmBedSideShift [ SqlColumnNumber = 2, SqlFieldName = EM_ParRef_Dr ];

/// 项目ID  EM_Item_Dr
Property EMItemDr As User.DHCEmDicItem [ SqlColumnNumber = 3, SqlFieldName = EM_Item_Dr ];

/// 项目值  EM_ItemVal
Property EMItemVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EM_ItemVal ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMSLI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_ItemVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMSLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParref">
<Global>^DHCEMSLI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parref"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmShiftLinkItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
