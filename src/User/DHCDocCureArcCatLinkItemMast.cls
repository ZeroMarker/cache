/// 治疗分类-医嘱项
Class User.DHCDocCureArcCatLinkItemMast Extends %Persistent [ SqlTableName = DHC_DocCureArcCatLinkItemMast, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCACLIMChildSub [ IdKey, PrimaryKey, Unique ];

/// DCACLIMParRef
Relationship DCACLIMParRef As User.DHCDocCureArcCat [ Cardinality = parent, Inverse = ChildDHCDocCureArcCatLinkItemMast, Required, SqlFieldName = DCACLIM_ParRef ];

Relationship ChildDHCDocCureArcCatLinkItemMastLoc As User.DHCDocCureArcCatLinkItemMastLoc [ Cardinality = children, Inverse = DCACLIMLOCParRef ];

/// DCACLIM_ChildSub
Property DCACLIMChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureArcCat($p(%d(0),$c(1)),"LIM",0))}, SqlColumnNumber = 2, SqlFieldName = DCACLIM_ChildSub ];

/// 医嘱项id  DCACLIM_ArcItm_Dr
Property DCACLIMArcItmDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DCACLIM_ArcItm_Dr ];

/// 医嘱套id  DCACLIM_ArcOrdSet_Dr
Property DCACLIMArcOrdSetDr As User.ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = DCACLIM_ArcOrdSet_Dr ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="DCACLIM_ArcItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCACLIM_ArcOrdSet_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocCureArcCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCACLIM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCACLIM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemMast">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocCureArcCat.DCAC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DCACLIM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIMMAST"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCACLIM_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemMast1">
<Global>^DHCDocCureArcCat</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIMMAST1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCACLIM_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureArcCat.DCAC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DCACLIM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCACLIM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureA6A84S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
