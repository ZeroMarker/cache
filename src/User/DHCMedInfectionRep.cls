Class User.DHCMedInfectionRep Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIR_Rowid, SqlTableName = DHC_MedInfectionRep, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedInfPathogeny As User.DHCMedInfPathogeny [ Cardinality = children, Inverse = MIRPYParRef ];

Relationship ChildDHCMedInfectionRepDia As User.DHCMedInfectionRepDia [ Cardinality = children, Inverse = MIRMRParRef ];

Relationship ChildDHCMedInfectionRepDrug As User.DHCMedInfectionRepDrug [ Cardinality = children, Inverse = MIRDParRef ];

Relationship ChildDHCMedInfectionRepOPR As User.DHCMedInfectionRepOPR [ Cardinality = children, Inverse = MIROParRef ];

Relationship ChildDHCMedInfectionRepPos As User.DHCMedInfectionRepPos [ Cardinality = children, Inverse = MIRPParRef ];

Relationship ChildDHCMedInfectionRepRea As User.DHCMedInfectionRepRea [ Cardinality = children, Inverse = MIRRParRef ];

/// MIR_Paadm_DR
Property MIRPaadmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = MIR_Paadm_DR ];

/// MIR_LapseTo
Property MIRLapseTo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIR_LapseTo ];

/// MIR_DeathConnection
Property MIRDeathConnection As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIR_DeathConnection ];

/// MIR_ICUFlag
Property MIRICUFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIR_ICUFlag ];

/// MIR_DrugEffect
Property MIRDrugEffect As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = MIR_DrugEffect ];

/// MIR_DblInfFlag
Property MIRDblInfFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MIR_DblInfFlag ];

/// MIR_BeModify_DR
Property MIRBeModifyDR As User.DHCMedInfectionRep [ SqlColumnNumber = 8, SqlFieldName = MIR_BeModify_DR ];

/// MIR_Date
Property MIRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MIR_Date ];

/// MIR_Time
Property MIRTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MIR_Time ];

/// MIR_User_DR
Property MIRUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = MIR_User_DR ];

/// MIR_Status
Property MIRStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MIR_Status ];

/// MIR_CheckUsr_DR
Property MIRCheckUsrDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = MIR_CheckUsr_DR ];

/// MIR_CheckDate
Property MIRCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MIR_CheckDate ];

/// MIR_CheckTime
Property MIRCheckTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = MIR_CheckTime ];

/// MIR_Demo
Property MIRDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MIR_Demo ];

/// MIR_InfPlace
Property MIRInfPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MIR_InfPlace ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMedIR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIR_BeModify_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIR_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MIR_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MIR_CheckUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MIR_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MIR_DblInfFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIR_DeathConnection">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIR_Demo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MIR_DrugEffect">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIR_ICUFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIR_InfPlace">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MIR_LapseTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIR_Paadm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIR_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MIR_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCMedIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMedIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInfPlaceDate">
<Global>^DHCMedIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MIR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InfPlaceDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIR_InfPlace}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MIR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^DHCMedIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIR_Rowid</Field>
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
<Expression>{MIR_Paadm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionRepS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
