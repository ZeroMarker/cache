/// 治疗分类-医嘱子类
Class User.DHCDocCureArcCatLinkItemCat Extends %Persistent [ SqlRowIdName = DCACLIC_RowID, SqlTableName = DHC_DocCureArcCatLinkItemCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCACLICChildSub [ IdKey, PrimaryKey, Unique ];

/// DCACLIC_CatParRef
Relationship DCACLICParRef As User.DHCDocCureArcCat [ Cardinality = parent, Inverse = ChildDHCDocCureArcCatLinkItemCat, Required, SqlFieldName = DCACLIC_ParRef ];

Relationship ChildDHCDocCureArcCatLinkItemCatLoc As User.DHCDocCureArcCatLinkItemCatLoc [ Cardinality = children, Inverse = DCACLICLOCParRef ];

/// DCACLIC_ChildSub
Property DCACLICChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureArcCat($p(%d(0),$c(1)),"LIC",0))}, SqlColumnNumber = 2, SqlFieldName = DCACLIC_ChildSub ];

/// 医嘱子类id DCACLIC_ItemCat_Dr
Property DCACLICItemCatDr As User.ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = DCACLIC_ItemCat_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMap">
<Data name="DCACLIC_ItemCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocCureArcCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCACLIC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCACLIC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DCACLIC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LICCAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCACLIC_ItemCat_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemCat1">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LICCAT1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCACLIC_ItemCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCACLIC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureA45CDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
