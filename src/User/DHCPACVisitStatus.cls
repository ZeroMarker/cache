/// DHC_PACVisitStatus
Class User.DHCPACVisitStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PVS_RowId, SqlTableName = DHC_PACVisitStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHC VisitStatus Code
Property PVSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PVS_Code ];

/// DHC VisitStatus Description 
Property PVSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PVS_Desc ];

/// Admission Type of VisitStatue
Property PVSEpisodeType As %Library.String(DISPLAYLIST = ",Inpatient,Outpatient,Emergency,Physical", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,P") [ SqlColumnNumber = 4, SqlFieldName = PVS_EpisodeType ];

/// Episode Visitor Status
Property PVSEpisodeStatus As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PVS_EpisodeStatus ];

/// PVS_DateFrom
Property PVSDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PVS_DateFrom ];

/// PVS_DateTo
Property PVSDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PVS_DateTo ];

/// PVS_DoctorAccess
Property PVSDoctorAccess As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PVS_DoctorAccess ];

/// PVS_NurseAccess
Property PVSNurseAccess As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PVS_NurseAccess ];

/// PVS_PreVisitStat_Dr
Property PVSPreVisitStatDr As User.DHCPACVisitStatus [ SqlColumnNumber = 10, SqlFieldName = PVS_PreVisitStat_Dr ];

/// PVS_AutoDischarge
Property PVSAutoDischarge As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PVS_AutoDischarge ];

/// PVS_Active 是否可用
Property PVSActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PVS_Active ];

Index PVSCodeUnqIdx1 On PVSCode [ Unique ];

Index PVSDescUnqIdx2 On PVSDesc [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACVisitStatus(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PVS_Active">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PVS_AutoDischarge">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PVS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PVS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PVS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PVS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PVS_DoctorAccess">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PVS_EpisodeStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PVS_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PVS_NurseAccess">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PVS_PreVisitStat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPACVisitStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PVS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXCode">
<Global>^DHCPACVisitStatus</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PVS_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PVS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDescription">
<Global>^DHCPACVisitStatus</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PVS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PVS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPACVisitStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
