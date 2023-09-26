Class User.DHCEQSCShareItemList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SIL_RowID, SqlTableName = DHC_EQSCShareItemList, StorageStrategy = SQLStorage ]
{

/// 资源项目
Property SILShareItemDR As DHCEQSCShareItem [ SqlColumnNumber = 2, SqlFieldName = SIL_ShareItemDR ];

/// 设备项
Property SILItemDR As DHCEQCMasterItem [ SqlColumnNumber = 3, SqlFieldName = SIL_ItemDR ];

/// 描述
Property SILName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SIL_Name ];

/// 规格型号
Property SILModelDR As DHCEQCModel [ SqlColumnNumber = 5, SqlFieldName = SIL_ModelDR ];

/// 无效标志
Property SILInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SIL_InvalidFlag ];

/// hold1
Property SILHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SIL_Hold1 ];

/// hold2
Property SILHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SIL_Hold2 ];

/// hold3
Property SILHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SIL_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSCShareItemList("0"))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="SIL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SIL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SIL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SIL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SIL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SIL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SIL_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SIL_ShareItemDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQSCShareItemList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SIL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQSCShareItemList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShareItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SIL_ShareItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemModel">
<Global>^DHCEQSCShareItemList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemModel"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SIL_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SIL_ModelDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModel">
<Global>^DHCEQSCShareItemList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SIL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Model"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SIL_ShareItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SIL_ModelDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSCShareItemListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
