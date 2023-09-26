Class User.DHCItmDiagnose Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ItmDia_Rowid, SqlTableName = DHC_ItmDiagnose, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ItmDia_PatientType_DR
Property ItmDiaPatientTypeDR As User.CTSocialStatus [ SqlColumnNumber = 2, SqlFieldName = ItmDia_PatientType_DR ];

/// ItmDia_ItmMast_DR
Property ItmDiaItmMastDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ItmDia_ItmMast_DR ];

/// ItmDia_Diagnose_DR
Property ItmDiaDiagnoseDR As User.MRDiagnos [ SqlColumnNumber = 4, SqlFieldName = ItmDia_Diagnose_DR ];

/// ItmDia_Remark
Property ItmDiaRemark As %Library.String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ItmDia_Remark ];

/// ItmDia_Hosp_DR
Property ItmDiaHospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = ItmDia_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITMDIA)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ItmDia_Diagnose_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ItmDia_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ItmDia_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItmDia_PatientType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ItmDia_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCITMDIA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ItmDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ItmDia_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnose">
<Global>^DHCITMDIAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ItmDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Diagnose"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ItmDia_Hosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ItmDia_Diagnose_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ItmDia_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItm">
<Global>^DHCITMDIAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ItmDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Itm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ItmDia_Hosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ItmDia_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ItmDia_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientType">
<Global>^DHCITMDIAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ItmDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PatientType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ItmDia_Hosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ItmDia_PatientType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ItmDia_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientTypeItm">
<Global>^DHCITMDIAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ItmDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PatientTypeItm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ItmDia_Hosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ItmDia_PatientType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ItmDia_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ItmDia_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmDiagnoseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
