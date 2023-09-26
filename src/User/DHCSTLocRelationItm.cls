Class User.DHCSTLocRelationItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LRELI_RowID, SqlTableName = DHCST_LocRelationItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LRELIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCST_LocRelation Parent Reference
Relationship LRELILRELParRef As User.DHCSTLocRelation [ Cardinality = parent, Inverse = ChildDHCSTLocRelationItm, Required, SqlFieldName = LRELI_LocRel_ParRef ];

/// DHCLRELI Childsub
Property LRELIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LRELI_ChildSub ];

/// DHCLRELI_INCI_DR
Property LRELIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = LRELI_INCI_DR ];

/// DHCLRELI_LIMITQTY
Property DHCLRELILIMITQTY As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = LRELI_LIMITQTY ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LRELI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRELI_LIMITQTY">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLOCREL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCST_LocRelation.DHCLocRel_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LRELI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCST_LocRelation.DHCLocRel_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LRELI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRELI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCLOCREL</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCST_LocRelation.DHCLocRel_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LRELI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCST_LocRelation.DHCLocRel_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LRELI_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRELI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTLocRelationItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
