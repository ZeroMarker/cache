Class User.DHCPhaPriorDisType Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPDP_RowId, SqlTableName = DHC_PhaPriorDisType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPDPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaPriority Parent Reference
Relationship PPDPParRef As User.DHCPhaPriority [ Cardinality = parent, Inverse = ChildDHCPhaPriorDisType, Required, SqlFieldName = PPDP_ParRef ];

/// PPDP_ChildSub
Property PPDPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PPDP_ChildSub ];

/// PPDP_OrderPrior_DR
Property PPDPOrderPriorDR As User.OECPriority [ SqlColumnNumber = 3, SqlFieldName = PPDP_OrderPrior_DR ];

/// PPDP_DispCat_DR
Property PPDPDispCatDr As User.DHCStkDrugGroup [ SqlColumnNumber = 4, SqlFieldName = PPDP_DispCat_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPriorDisType">
<Data name="PPDP_DispCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPDP_OrderPrior_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPPRIOR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaPriority.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PPDP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaPriority.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PRIOR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PPDP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdPrior">
<Global>^DHCPPRIOR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_PhaPriority.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPDP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaPriority.PP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PP"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PPDP_OrderPrior_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PPDP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaPriorDisTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
