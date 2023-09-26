Class User.DHCRBPositionMapDesc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPMD_RowID, SqlTableName = DHCRB_PositionMap_Desc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DPMDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_PositionMap Parent Reference
Relationship DPMDParRef As User.DHCRBPositionMap [ Cardinality = parent, Inverse = ChildDHCRBPositionMapDesc, Required, SqlFieldName = DPMD_ParRef ];

/// Child subscript
Property DPMDChildSub As %Library.Float [ InitialExpression = {$i(^DHCRBMap("DHCRBPOSITONMAPDESC"))}, Required, SqlColumnNumber = 2, SqlFieldName = DPMD_ChildSub ];

/// DPMD_Desc
Property DPMDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DPMD_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DPMD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBMap</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_PositionMap.DPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DPMD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PostionMap"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_PositionMap.DPM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DPMD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBPositionMapDescS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
