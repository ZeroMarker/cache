Class User.DHCPlanAuditItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPAI_RowId, SqlTableName = DHC_PlanAuditItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCPAIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PlanAudit Parent Reference
Relationship DHCPAIDHCPAParRef As User.DHCPlanAudit [ Cardinality = parent, Inverse = ChildDHCPlanAuditItm, Required, SqlFieldName = DHCPAI_DHCPA_ParRef ];

/// DHCPAI Childsub
Property DHCPAIChildSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DHCPAI_ChildSub ];

/// DHCPAI_INPPI_DR
Property DHCPAINPPIDR As User.INPurPlanItm [ SqlColumnNumber = 4, SqlFieldName = DHCPAI_INPPI_DR ];

/// DHCPAI_PriorQty
Property DHCPAIPriorQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHCPAI_PriorQty ];

/// DHCPAI_ResultQty
Property DHCPAIResultQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DHCPAI_ResultQty ];

/// DHCPAI_PriorAPCVMDR
Property DHCPAIPriorAPCVMDR As User.APCVendor [ SqlColumnNumber = 7, SqlFieldName = DHCPAI_PriorAPCVM_DR ];

/// DHCPAI_ResultAPCVMDR
Property DHCPAIResultAPCVMDR As User.APCVendor [ SqlColumnNumber = 8, SqlFieldName = DHCPAI_ResultAPCVM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCPAI_INPPI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPAI_PriorAPCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPAI_PriorQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPAI_ResultAPCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPAI_ResultQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PlanAudit.DHCPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCPAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PlanAudit.DHCPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PAI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPAI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINPPI">
<Global>^DHCPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PlanAudit.DHCPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCPAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPPI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPAI_INPPI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PlanAudit.DHCPA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCPAI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPlanAuditItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
