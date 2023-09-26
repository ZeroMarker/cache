Class User.DHCRBCGroupUseFuntion Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DGPF_RowID, SqlTableName = DHCRBC_GroupUseFuntion, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DGPFChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRBC_Group Parent Reference
Relationship DGPFParRef As User.DHCRBCGroup [ Cardinality = parent, Inverse = ChildDHCRBCGroupUseFuntion, Required, SqlFieldName = DGPF_ParRef ];

/// Child subscript
Property DGPFChildSub As %Library.Float [ InitialExpression = {$i(^DHCRBC("DHCRBCGROUPUSEFUNTION"))}, Required, SqlColumnNumber = 2, SqlFieldName = DGPF_ChildSub ];

/// DRPF_Function_DR
Property DGPFFunctionDR As User.DHCRBCSystemFunction [ SqlColumnNumber = 3, SqlFieldName = DGPF_Function_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DGPF_Function_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRBC_Group.DGP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DGPF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupUseFunction"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRBC_Group.DGP_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DGPF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCGroupUseFuntionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
