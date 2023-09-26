Class User.DHCRBCApplicationShapeFie Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DASF_Rowid, SqlTableName = DHCRBC_ApplicationShape_Field, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DASFChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRBC_ApplicationShape Parent Reference
Relationship DASFParRef As User.DHCRBCApplicationShape [ Cardinality = parent, Inverse = ChildDHCRBCApplicationShapeFie, Required, SqlFieldName = DASF_ParRef ];

/// Child subscript
Property DASFChildSub As %Library.Float [ InitialExpression = {$i(^mdata("DHCRBCAPPLICATIONSHAPEFIELD"))}, Required, SqlColumnNumber = 2, SqlFieldName = DASF_ChildSub ];

/// DASF_ApplicationField_DR
Property DASFApplicationFieldDR As User.DHCRBCApplicationField [ SqlColumnNumber = 3, SqlFieldName = DASF_ApplicationField_DR ];

/// DASF_ItemMast_DR
Property DASFItemMastDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DASF_ItemMast_DR ];

/// DASF_ItemCat_DR
Property DASFItemCatDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DASF_ItemCat_DR ];

/// DASF_OrCat_DR
Property DASFOrCatDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DASF_OrCat_DR ];

/// DSAF_Index
Property DASFIndex As %Library.Float(MINVAL = 1) [ SqlColumnNumber = 7, SqlFieldName = DASF_Index ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DASF_ApplicationField_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DASF_Index">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DASF_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DASF_ItemMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DASF_OrCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCAppSF</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRBC_ApplicationShape.DAS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DASF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ShapeField"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRBC_ApplicationShape.DAS_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DASF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIndex">
<Global>^DHCRBCAppSFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCRBC_ApplicationShape.DAS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DASF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FieldIndex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCRBC_ApplicationShape.DAS_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DASF_Index}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DASF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCApplic91FS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
