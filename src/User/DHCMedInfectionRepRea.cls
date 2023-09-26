Class User.DHCMedInfectionRepRea Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRR_Rowid, SqlTableName = DHC_MedInfectionRepRea, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIRRParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfectionRepRea, Required, SqlFieldName = MIRR_ParRef ];

/// Child subscript
Property MIRRChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"R",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRR_ChildSub ];

/// MIRR_InfReason
Property MIRRInfReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIRR_InfReason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRR_InfReason">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIRR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIRR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepReaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
