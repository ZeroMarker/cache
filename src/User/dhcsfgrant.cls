Class User.dhcsfgrant Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = grant_rowid, SqlTableName = dhc_sfgrant, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// grant_currentno
Property grantcurrentno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = grant_currentno ];

/// grant_date
Property grantdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = grant_date ];

/// grant_endno
Property grantendno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = grant_endno ];

/// grant_loc
Property grantloc As %Library.String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Registration,Login,Medicare", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,E,R,L.M") [ SqlColumnNumber = 7, SqlFieldName = grant_loc ];

/// grant_lquser
Property grantlquser As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = grant_lquser ];

/// grant_startno
Property grantstartno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = grant_startno ];

/// grant_time
Property granttime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = grant_time ];

/// grant_title
Property granttitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = grant_title ];

/// grant_useflag
Property grantuseflag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = grant_useflag ];

/// grant_user
Property grantuser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = grant_user ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSFGRANT)</SqlIdExpression>
<SQLMap name="Indexgranglquser">
<Global>^DHCSFGRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>grant_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"gglquser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{grant_lquser}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{grant_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexgrantdate">
<Global>^DHCSFGRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>grant_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"grantdate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{grant_date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{grant_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexgranttime">
<Global>^DHCSFGRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>grant_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"granttime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{grant_date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{grant_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexgrantuseflag">
<Global>^DHCSFGRANT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>grant_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"grantuseflag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{grant_useflag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{grant_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="sfgrant">
<Data name="grant_currentno">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="grant_date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="grant_endno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="grant_loc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="grant_lquser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="grant_startno">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="grant_time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="grant_title">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="grant_useflag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="grant_user">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCSFGRANT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>grant_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{grant_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.dhcsfgrantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
