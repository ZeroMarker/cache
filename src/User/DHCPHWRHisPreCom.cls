Class User.DHCPHWRHisPreCom Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHHPC_RowID, SqlTableName = DHC_PHWRHisPreCom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHHPCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHWardRound Parent Reference PHHPC_PHWR_Parref
Relationship PHHPCPHWRParref As User.DHCPHWardRound [ Cardinality = parent, Inverse = ChildDHCPHWRHISPRECOM, Required, SqlFieldName = PHHPC_PHWR_Parref ];

/// PHHPC_ChildSub
Property PHHPCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHHPC_ChildSub ];

/// PHHPC_Desc  现病史
Property PHHPCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHHPC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHHPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHWardRound.PHWR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHHPC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHWardRound.PHWR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HPC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHHPC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWRHisPreComS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
