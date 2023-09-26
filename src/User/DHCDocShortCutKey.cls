Class User.DHCDocShortCutKey Extends %Persistent [ ClassType = persistent, SqlRowIdName = DSK_RowID, SqlTableName = DHC_DocShortCutKey, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On DSKChildSub [ IdKey, PrimaryKey, Unique ];

/// 父表 DHCDocOrderPage
Relationship DSKDOPParRef As User.DHCDocOrderPage [ Cardinality = parent, Inverse = ChildDHCDocShortCutKey, Required, SqlFieldName = DSK_DOP_ParRef ];

/// DOM_ChildSub
Property DSKChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocSCK(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = DSK_ChildSub ];

/// 元素ID
Property DSKItemID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSK_ItemID ];

/// 快捷键
Property DSKShortCutKey As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DSK_ShortCutKey ];

/// 调用函数
Property DSKCallBackFun As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSK_CallBackFun ];

/// 描述
Property DSKItemDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DSK_ItemDesc ];

Storage NewStorage1
{
<SQLMap name="Map1">
<Data name="DSK_CallBackFun">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSK_ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSK_ItemID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSK_ShortCutKey">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocSCK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DSK_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSK_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSK_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocShortCutKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
