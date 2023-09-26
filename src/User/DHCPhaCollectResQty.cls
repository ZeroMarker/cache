Class User.DHCPhaCollectResQty Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RES_Rowid, SqlTableName = DHC_PhaCollectResQty, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RESChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHACollectItm Parent Reference
Relationship RESPHACIParref As User.DHCPHACollectItm [ Cardinality = parent, Inverse = ChildDHCPhaCollectResQty, Required, SqlFieldName = RES_PHACI_Parref ];

/// RES_Childsub
Property RESChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = RES_Childsub ];

/// RES_PREDET_DR
Property RESPREDETDR As User.DHCPhaReserveDetail [ SqlColumnNumber = 3, SqlFieldName = RES_PREDET_DR ];

/// RES_UseQty
Property RESUseQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RES_UseQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPhaciResqty">
<Data name="RES_PREDET_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RES_UseQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHACollectItm.PHACI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollectItm.PHACI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPhaResDet">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHACollected.DHC_PHACollect_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PHACollectItm.PHACI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RESDET"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RES_PREDET_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollected.DHC_PHACollect_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollectItm.PHACI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCollectResQtyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
