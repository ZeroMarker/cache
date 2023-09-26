Class User.DHCPADiagnoseDuration Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDD_Rowid, SqlTableName = DHCPADiagnoseDuration, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PDD_PatientType_DR
Property PDDPatientTypeDR As User.CTSocialStatus [ SqlColumnNumber = 2, SqlFieldName = PDD_PatientType_DR ];

/// PDD_Diagnose_DR
Property PDDDiagnoseDR As User.MRDiagnos [ SqlColumnNumber = 3, SqlFieldName = PDD_Diagnose_DR ];

/// PDD_Duration_DR
Property PDDDurationDR As User.PHCDuration [ SqlColumnNumber = 4, SqlFieldName = PDD_Duration_DR ];

/// PDD_Remark
Property PDDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDD_Remark ];

/// PDDHospDR
Property PDDHospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = PDD_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPADIADuration)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDD_Diagnose_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDD_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDD_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDD_PatientType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPADIADuration</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PDD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnose">
<Global>^DHCPADIADuration</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Diagnose"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDD_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDD_Diagnose_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDuration">
<Global>^DHCPADIADuration</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Duration"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDD_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDD_Duration_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientType">
<Global>^DHCPADIADuration</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatientType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDD_Hosp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDD_PatientType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPADiagnoseDurationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
