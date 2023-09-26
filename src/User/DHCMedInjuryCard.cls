/// MedInjuryCard
Class User.DHCMedInjuryCard Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MINJ_Rowid, SqlTableName = DHC_MedInjuryCard, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MINJ_PaAdm_DR
Property MINJPaAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MINJ_PaAdm_DR ];

/// MINJ_CardNo
Property MINJCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MINJ_CardNo ];

/// Card Status
Property MINJCardStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MINJ_CardStatus ];

/// InjDate
Property MINJInjDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MINJ_InjDate ];

/// InjTime
Property MINJInjTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = MINJ_InjTime ];

/// Diagnose_Dr
Property MINJDiagnoseDr As User.MRCICDDx [ SqlColumnNumber = 7, SqlFieldName = MINJ_Diagnose_Dr ];

/// RepUsr_DR
Property MINJRepUsrDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = MINJ_RepUsr_DR ];

/// RepDate
Property MINJRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MINJ_RepDate ];

/// RepTime
Property MINJRepTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MINJ_RepTime ];

/// CheckUsr_DR
Property MINJCheckUsrDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = MINJ_CheckUsr_DR ];

/// CheckDate
Property MINJCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = MINJ_CheckDate ];

/// CheckTime
Property MINJCheckTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = MINJ_CheckTime ];

/// IsActive
Property MINJIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = MINJ_IsActive ];

/// ResumeText
Property MINJResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MINJ_ResumeText ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMINJ)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MINJ_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MINJ_CardStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MINJ_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MINJ_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MINJ_CheckUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MINJ_Diagnose_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MINJ_InjDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MINJ_InjTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MINJ_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MINJ_PaAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MINJ_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MINJ_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MINJ_RepUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MINJ_ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCMINJ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDiagnose">
<Global>^DHCMINJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Diagnose"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MINJ_Diagnose_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInjDate">
<Global>^DHCMINJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InjDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MINJ_InjDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaAdm">
<Global>^DHCMINJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PaAdm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MINJ_PaAdm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDate">
<Global>^DHCMINJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MINJ_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCMINJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MINJ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MINJ_CardStatus}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MINJ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInjuryCardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
