/// 表格
Class User.DHCDocOrderGrid Extends %Persistent [ ClassType = persistent, SqlRowIdName = DOG_RowID, SqlTableName = DHC_DocOrderGrid, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DOGChildSub [ IdKey, PrimaryKey, Unique ];

/// 父表 DHCDocOrderPage
Relationship DOGDOPParRef As User.DHCDocOrderPage [ Cardinality = parent, Inverse = ChildDHCDocOrderGrid, Required, SqlFieldName = DOG_DOP_ParRef ];

/// 子表
Relationship ChildDHCDocOrderListSet As User.DHCDocOrderListSet [ Cardinality = children, Inverse = OLSDOGParRef ];

/// PPR_ChildSub
Property DOGChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocOG(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = DOG_ChildSub ];

/// 代码
Property DOGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOG_Code ];

/// 描述
Property DOGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOG_Desc ];

/// 类型
Property DOGType As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOG_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DOG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocOG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DOG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DOG_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DOG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DOG_Code}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DOG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DOG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOG_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCDocOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Field>DOG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderGridS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
