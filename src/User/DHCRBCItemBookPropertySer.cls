Class User.DHCRBCItemBookPropertySer Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIPS_Rowid, SqlTableName = DHCRBC_ItemBookProperty_ServiceG, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DIPSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRBC_ItemBookProperty Parent Reference
Relationship DIPSParentRef As User.DHCRBCItemBookProperty [ Cardinality = parent, Inverse = ChildDHCRBCItemBookPropertySer, Required, SqlFieldName = DIPS_ParentRef ];

/// Child subscript
Property DIPSChildSub As %Library.Float [ InitialExpression = {$i(^mdata("DHCRBCITEMBOOKPROPERTYSERVICEG"))}, Required, SqlColumnNumber = 2, SqlFieldName = DIPS_ChildSub ];

/// DIPS_ArcItem_DR
Property DIPSArcItemDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DIPS_ArcItem_DR ];

/// DIPS_ServiceGroup_DR
Property DIPSServiceGroupDR As User.RBCServiceGroup [ SqlColumnNumber = 4, SqlFieldName = DIPS_ServiceGroup_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DIPS_ArcItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIPS_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIPS_ParentRef">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIPS_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCItemBookPropertySG</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCRBC_ItemBookProperty.DIBP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DIPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ServiceGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCRBC_ItemBookProperty.DIBP_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIPS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemBo94FS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
