Class User.DHCTEMPPRINT Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TEMPPRINT_ROWID, SqlTableName = DHC_TEMPPRINT, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TEMPPRINT_ADM_DR
Property TEMPPRINTADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = TEMPPRINT_ADM_DR ];

/// TEMPPRINT_DATE
Property TEMPPRINTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = TEMPPRINT_DATE ];

/// TEMPPRINT_TIME
Property TEMPPRINTTIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = TEMPPRINT_TIME ];

/// TEMPPRINT_PAGE
Property TEMPPRINTPAGE As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TEMPPRINT_PAGE ];

/// TEMPPRINT_USER_DR
Property TEMPPRINTUSERDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = TEMPPRINT_USER_DR ];

/// TEMPPRINT_FLAG
Property TEMPPRINTFLAG As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TEMPPRINT_FLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTEMPPRINT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="TEMPPRINT_ADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TEMPPRINT_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TEMPPRINT_FLAG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TEMPPRINT_PAGE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TEMPPRINT_TIME">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TEMPPRINT_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCTEMPPRINT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TEMPPRINT_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{TEMPPRINT_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAdm">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^DHCTEMPPRINT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TEMPPRINT_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"adm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TEMPPRINT_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TEMPPRINT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTEMPPRINTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
