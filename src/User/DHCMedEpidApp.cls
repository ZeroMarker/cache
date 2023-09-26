Class User.DHCMedEpidApp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEA_Rowid, SqlTableName = DHC_MedEpidApp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedEpidAppSub As User.DHCMedEpidAppSub [ Cardinality = children, Inverse = MEASParRef ];

/// MEA_Papmi_DR
Property MEAPapmiDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MEA_Papmi_DR ];

/// MEA_MIC_DR
Property MEAMICDR As User.DHCMedInfection [ SqlColumnNumber = 3, SqlFieldName = MEA_MIC_DR ];

/// MEA_Place
Property MEAPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEA_Place ];

/// MEA_Ctloc_DR
Property MEACtlocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MEA_Ctloc_DR ];

/// MEA_DutyUser_DR
Property MEADutyUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MEA_DutyUser_DR ];

/// MEA_Diagnose
Property MEADiagnose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MEA_Diagnose ];

/// MEA_Report
Property MEAReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MEA_Report ];

/// MEA_Nature
Property MEANature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MEA_Nature ];

/// MEA_User_DR
Property MEAUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MEA_User_DR ];

/// MEA_Date
Property MEADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = MEA_Date ];

/// MEA_Time
Property MEATime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = MEA_Time ];

/// MEA_Demo
Property MEADemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MEA_Demo ];

/// MEA_OccDate
Property MEAOccDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MEA_OccDate ];

/// MEA_AppStatus
Property MEAAppStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MEA_AppStatus ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMEPA)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MEA_AppStatus">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEA_Ctloc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEA_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEA_Demo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEA_Diagnose">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEA_DutyUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEA_MIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEA_Nature">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEA_OccDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEA_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEA_Place">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEA_Report">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEA_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEA_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCMEPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MEA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCMEPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEA_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEA_Ctloc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIMIC">
<Global>^DHCMEPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMIMIC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEA_Papmi_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEA_MIC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedEpidAppS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
