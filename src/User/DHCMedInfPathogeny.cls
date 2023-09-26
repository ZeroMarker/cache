Class User.DHCMedInfPathogeny Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIRPY_Rowid, SqlTableName = DHC_MedInfPathogeny, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIRPYChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCMedInfPyObj As User.DHCMedInfPyObj [ Cardinality = children, Inverse = MIRPOParRef ];

/// DHC_MedInfectionRep Parent Reference
Relationship MIRPYParRef As User.DHCMedInfectionRep [ Cardinality = parent, Inverse = ChildDHCMedInfPathogeny, Required, SqlFieldName = MIRPY_ParRef ];

/// Child subscript
Property MIRPYChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIR($p(%d(0),$c(1),1),"PY",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIRPY_ChildSub ];

/// MIRPY_Sample
Property MIRPYSample As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIRPY_Sample ];

/// MIRPY_InfPos_DR
Property MIRPYInfPosDR As User.DHCMedInfPosition [ SqlColumnNumber = 4, SqlFieldName = MIRPY_InfPos_DR ];

/// MIRPY_Date
Property MIRPYDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MIRPY_Date ];

/// MIRPY_Method
Property MIRPYMethod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIRPY_Method ];

/// MIRPY_DrugFlag
Property MIRPYDrugFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MIRPY_DrugFlag ];

/// MIRPY_OEORI_DR
Property MIRPYOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MIRPY_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIRPY_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIRPY_DrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIRPY_InfPos_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIRPY_Method">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIRPY_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIRPY_Sample">
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
<Field>MIRPY_ChildSub</Field>
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
<Expression>{MIRPY_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPathogenyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
