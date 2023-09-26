Class User.DHCMedInfPyObjDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRPOD_Rowid, SqlTableName = DHC_MedInfPyObjDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRPODChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfPyObj Parent Reference
Relationship MIRPODParRef As User.DHCMedInfPyObj [ Cardinality = parent, Inverse = ChildDHCMedInfPyObjDrug, Required, SqlFieldName = MIRPOD_ParRef ];

/// Child subscript
Property MIRPODChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),"||"),"PY",$p(%d(0),"||",2),"O",$p(%d(0),"||",3),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRPOD_ChildSub ];

/// MIRPOD_Drug_DR
Property MIRPODDrugDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MIRPOD_Drug_DR ];

/// MIRPOD_Flag
Property MIRPODFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MIRPOD_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRPOD_Drug_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIRPOD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionRep.MIR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_MedInfPathogeny.MIRPY_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_MedInfPyObj.MIRPO_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>MIRPOD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionRep.MIR_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PY"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfPathogeny.MIRPY_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfPyObj.MIRPO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MIRPOD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPyObjDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
