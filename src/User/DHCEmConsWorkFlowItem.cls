Class User.DHCEmConsWorkFlowItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsWorkFlowItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ECChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmConsWorkFlow Parent Reference EC_ParRef_Dr
Relationship ECParRefDr As User.DHCEmConsWorkFlow [ Cardinality = parent, Inverse = ChildDHCEMCONSFLOWITM, Required, SqlFieldName = EC_ParRef_Dr ];

/// EC_ChildSub
Property ECChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EC_ChildSub ];

/// 状态  EC_Status_Dr
Property ECStatusDr As User.DHCEmConsStatus [ SqlColumnNumber = 3, SqlFieldName = EC_Status_Dr ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EC_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCONWF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmConsWorkFlow.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmConsWorkFlow.EC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEMCONWF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmConsWorkFlow.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Status_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmConsWorkFlow.EC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsWorkFlowItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
