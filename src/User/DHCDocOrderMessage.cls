/// 页面消息提示
Class User.DHCDocOrderMessage Extends %Persistent [ ClassType = persistent, SqlRowIdName = DOM_RowID, SqlTableName = DHC_DocOrderMessage, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DOMChildSub [ IdKey, PrimaryKey, Unique ];

/// 父表 DHCDocOrderPage
Relationship DOMDOPParRef As User.DHCDocOrderPage [ Cardinality = parent, Inverse = ChildDHCDocOrderMessage, Required, SqlFieldName = DOM_DOP_ParRef ];

/// DOM_ChildSub
Property DOMChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocOM(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = DOM_ChildSub ];

/// 代码
Property DOMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOM_Code ];

/// 描述
Property DOMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOM_Desc ];

/// 外文描述
Property DOMOtherDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOM_OtherDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DOM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOM_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocOM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DOM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DOM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOM_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DOM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DOM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOM_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DOM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOtherDesc">
<Global>^DHCDocOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DOM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"OtherDesc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DOM_OtherDesc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DOM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
