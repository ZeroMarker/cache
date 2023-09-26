Class User.DHCPEPreIEndanger Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOED_RowId, SqlTableName = DHC_PE_PreIEndanger, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIEndanger";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOEDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_PreIADM Parent Reference
Relationship PIOEDParRef As User.DHCPEPreIADM [ Cardinality = parent, Inverse = ChildDHCPEPreIEndanger, Required, SqlFieldName = PIOED_ParRef ];

/// PIOED_ChildSub
Property PIOEDChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM($p(%d(0),$c(1),1),"Endanger",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOED_ChildSub ];

/// 高危因素
Property PIOEDEndangerDR As User.DHCPEEndanger [ Required, SqlFieldName = PIOED_Endanger_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIOED_Endanger_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIOED_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Endanger"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOED_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="EndangerIndex">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Endanger"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIOED_Endanger_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIOED_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
