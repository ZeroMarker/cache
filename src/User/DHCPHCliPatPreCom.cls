Class User.DHCPHCliPatPreCom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCPC_RowID, SqlTableName = DHC_PHCliPatPreCom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCPCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHCliPathography Parent Reference PHCPC_PHCP_Parref
Relationship PHCPCPHCPParref As User.DHCPHCliPathography [ Cardinality = parent, Inverse = ChildDHCPHCLIPATPRECOM, Required, SqlFieldName = PHCPC_PHCP_Parref ];

/// PHCPC_ChildSub
Property PHCPCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHCPC_ChildSub ];

/// PHCPC_Desc  主诉描述
Property PHCPCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCPC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHCPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCliPathography.PHCP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCPC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHCliPathography.PHCP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCPC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCliPatPreComS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
