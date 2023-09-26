Class User.DHCMedLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MLG_Rowid, SqlTableName = DHC_MedLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MLG_Loc
Property MLGLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MLG_Loc ];

/// MLG_User
Property MLGUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MLG_User ];

/// MLG_ET_DR
Property MLGETDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MLG_ET_DR ];

/// MLG_LogDate
Property MLGLogDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MLG_LogDate ];

/// MLG_LogTime
Property MLGLogTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = MLG_LogTime ];

/// MLG_OutDate
Property MLGOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MLG_OutDate ];

/// MLG_OutTime
Property MLGOutTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MLG_OutTime ];

/// MLG_Hours
Property MLGHours As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MLG_Hours ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMLG)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MLG_ET_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MLG_Hours">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MLG_Loc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MLG_LogDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MLG_LogTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MLG_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MLG_OutTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MLG_User">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMLG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MLG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MLG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateETLoc">
<Global>^DHCMLG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MLG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateETLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MLG_LogDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MLG_ET_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MLG_Loc}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLocET">
<Global>^DHCMLG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MLG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLocET"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MLG_LogDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MLG_Loc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MLG_ET_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
