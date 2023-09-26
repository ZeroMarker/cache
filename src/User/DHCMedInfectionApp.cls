Class User.DHCMedInfectionApp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFA_Rowid, SqlTableName = DHC_MedInfectionApp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedInfectionAppLab As User.DHCMedInfectionAppLab [ Cardinality = children, Inverse = MIFALParRef ];

/// MIFA_Paadm_Dr
Property MIFAPaadmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MIFA_Paadm_Dr ];

/// MIFA_Points
Property MIFAPoints As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = MIFA_Points ];

/// MIFA_InfDesc1_Dr
Property MIFAInfDesc1Dr As User.DHCMedInfDiagnose [ SqlColumnNumber = 4, SqlFieldName = MIFA_InfDesc1_Dr ];

/// MIFA_Diagnose
Property MIFADiagnose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIFA_Diagnose ];

/// MIFA_Report
Property MIFAReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIFA_Report ];

/// MIFA_Nature
Property MIFANature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MIFA_Nature ];

/// MIFA_User1_DR
Property MIFAUser1DR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = MIFA_User1_DR ];

/// MIFA_Date1
Property MIFADate1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MIFA_Date1 ];

/// MIFA_Time1
Property MIFATime1 As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MIFA_Time1 ];

/// MIFA_InfDesc2_Dr
Property MIFAInfDesc2Dr As User.DHCMedInfDiagnose [ SqlColumnNumber = 11, SqlFieldName = MIFA_InfDesc2_Dr ];

/// MIFA_User2_DR
Property MIFAUser2DR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = MIFA_User2_DR ];

/// MIFA_Date2
Property MIFADate2 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = MIFA_Date2 ];

/// MIFA_Time2
Property MIFATime2 As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = MIFA_Time2 ];

/// MIFA_Demo
Property MIFADemo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MIFA_Demo ];

/// MIFA_AppStatus
Property MIFAAppStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MIFA_AppStatus ];

/// MIFA_Width
Property MIFAWidth As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = MIFA_Width ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMedIA)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIFA_AppStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MIFA_Date1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MIFA_Date2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MIFA_Demo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MIFA_Diagnose">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIFA_InfDesc1_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIFA_InfDesc2_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MIFA_Nature">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIFA_Paadm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIFA_Points">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIFA_Report">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIFA_Time1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIFA_Time2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MIFA_User1_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIFA_User2_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MIFA_Width">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCMedIA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIFA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIFA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate1">
<Global>^DHCMedIA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIFA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFA_Date1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIFA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCMedIA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIFA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFA_Paadm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIFA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionAppS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
