Class User.DHCMedDeathBDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDBD_Rowid, SqlTableName = DHC_MedDeathBDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedDBDSub As User.DHCMedDBDSub [ Cardinality = children, Inverse = MDBDSParRef ];

/// MDBD_NO
Property MDBDNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MDBD_NO ];

/// MDBD_Type_DR
Property MDBDTypeDR As User.DHCMedDictory [ SqlColumnNumber = 3, SqlFieldName = MDBD_Type_DR ];

/// MDBD_Flag
Property MDBDFlag As %Library.String(MAXLEN = 1, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A||Active,B||Bill") [ SqlColumnNumber = 4, SqlFieldName = MDBD_Flag ];

/// MDBD_Loc_DR
Property MDBDLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MDBD_Loc_DR ];

/// MDBD_DBSub_DR
Property MDBDDBDR As User.DHCMedDeathRep [ SqlColumnNumber = 6, SqlFieldName = MDBD_DB_DR ];

/// MDBD_UseDate
Property MDBDUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MDBD_UseDate ];

/// MDBD_UseTime
Property MDBDUseTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MDBD_UseTime ];

/// MDBD_Usr_DR
Property MDBDUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MDBD_Usr_DR ];

/// MDBD_SetUsr_DR
Property MDBDSetUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MDBD_SetUsr_DR ];

/// MDBD_GetUsr_DR
Property MDBDGetUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = MDBD_GetUsr_DR ];

/// MDBD_Date
Property MDBDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = MDBD_Date ];

/// MDBD_Time
Property MDBDTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = MDBD_Time ];

/// MDBD_InDate
Property MDBDInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MDBD_InDate ];

/// MDBD_InTime
Property MDBDInTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = MDBD_InTime ];

/// MDBD_InUser
Property MDBDInUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MDBD_InUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDBD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MDBD_DB_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDBD_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MDBD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDBD_GetUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MDBD_InDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MDBD_InTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MDBD_InUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MDBD_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDBD_NO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDBD_SetUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MDBD_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MDBD_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDBD_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDBD_UseTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDBD_Usr_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMDBD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeathBook">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DeathBook"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_DB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInDate">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QInDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_InDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeFlag">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocTypeFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Type_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDBD_Flag}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDateLoc">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TDL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDBD_Loc_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeFlag">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Flag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeNO">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_NO}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDate">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MDBD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QUseDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBD_UseDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDeathBDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
