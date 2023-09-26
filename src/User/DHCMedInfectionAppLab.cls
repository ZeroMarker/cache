Class User.DHCMedInfectionAppLab Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFAL_Rowid, SqlTableName = DHC_MedInfectionAppLab, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIFALChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfectionApp Parent Reference
Relationship MIFALParRef As User.DHCMedInfectionApp [ Cardinality = parent, Inverse = ChildDHCMedInfectionAppLab, Required, SqlFieldName = MIFAL_ParRef ];

/// Child subscript
Property MIFALChildSub As %Library.Float [ InitialExpression = {$i(^DHCMedIA($p(%d(0),$c(1),1),"L",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIFAL_ChildSub ];

/// MIFAL_LabNo
Property MIFALLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIFAL_LabNo ];

/// MIFAL_MIFC_Dr
Property MIFALMIFCDr As User.DHCMedInfLabItm [ SqlColumnNumber = 4, SqlFieldName = MIFAL_MIFC_Dr ];

/// MIFAL_LabResult
Property MIFALLabResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIFAL_LabResult ];

/// MIFAL_LabDate
Property MIFALLabDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MIFAL_LabDate ];

/// MIFAL_LabTime
Property MIFALLabTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MIFAL_LabTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIFAL_LabDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIFAL_LabNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIFAL_LabResult">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIFAL_LabTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIFAL_MIFC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMedIA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfectionApp.MIFA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIFAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfectionApp.MIFA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFAL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionAppLabS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
