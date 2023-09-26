Class User.DHCPHPCMonScope Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMS_RowID, SqlTableName = DHC_PHPCMonScope, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHPharCare Parent Reference PHMS_PHPC_Parref
Relationship PHMSPHPCParref As User.DHCPHPharCare [ Cardinality = parent, Inverse = ChildDHCPHPCMONSCOPE, Required, SqlFieldName = PHMS_PHPC_Parref ];

/// PHMS_ChildSub
Property PHMSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMS_ChildSub ];

/// PHMS_MonScope_Dr  监控范围
Property PHMSMonScopeDr As User.DHCPHMonScope [ SqlColumnNumber = 3, SqlFieldName = PHMS_MonScope_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHMS_MonScope_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHPharCare.PHPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHPharCare.PHPC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPCMonScopeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
