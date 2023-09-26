Class User.DHCMedInfPyObj Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRPO_Rowid, SqlTableName = DHC_MedInfPyObj, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRPOChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCMedInfPyObjDrug As User.DHCMedInfPyObjDrug [ Cardinality = children, Inverse = MIRPODParRef ];

/// DHC_MedInfPathogeny Parent Reference
Relationship MIRPOParRef As User.DHCMedInfPathogeny [ Cardinality = parent, Inverse = ChildDHCMedInfPyObj, Required, SqlFieldName = MIRPO_ParRef ];

/// Child subscript
Property MIRPOChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),"||"),"PY",$p(%d(0),"||",2),"O",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRPO_ChildSub ];

/// MIRPO_Object
Property MIRPOObject As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIRPO_Object ];

/// MIRPO_Flag
Property MIRPOFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MIRPO_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRPO_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIRPO_Object">
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
<Field>DHC_MedInfPathogeny.MIRPY_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MIRPO_ChildSub</Field>
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
<Expression>{MIRPO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPyObjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
