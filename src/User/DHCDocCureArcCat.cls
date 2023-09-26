Class User.DHCDocCureArcCat Extends (%Persistent, User.Abstract) [ SqlRowIdName = DCAC_RowID, SqlTableName = DHC_DocCureArcCat, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCDocCureArcCatLinkItemCat As User.DHCDocCureArcCatLinkItemCat [ Cardinality = children, Inverse = DCACLICParRef ];

Relationship ChildDHCDocCureArcCatLinkItemMast As User.DHCDocCureArcCatLinkItemMast [ Cardinality = children, Inverse = DCACLIMParRef ];

/// 分类代码 AC_CatCode
Property DCACCatCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = DCAC_CatCode ];

/// 分类描述 AC_CatDesc
Property DCACCatDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = DCAC_CatDesc ];

/// 集团化医院 AC_Hosp_Dr
Property DCACHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = DCAC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocCureArcCat(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DCAC_CatCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAC_CatDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureArcCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DCAC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCAC_CatCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCAC_CatDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCAC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureArcCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
