Class User.DHCPHGLOC Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHGL_ROWID, SqlTableName = DHC_PHGLOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHGL_CTLOC_DR
Property PHGLCTLOCDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHGL_CTLOC_DR ];

/// phctloc open
Property PHGLDOFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHGL_DOFLAG ];

/// pharmacy sufferance
Property PHGLOKFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHGL_OKFLAG ];

/// PHGL_PHG_DR
Property PHGLPHGDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHGL_PHG_DR ];

/// PHGL_PHL_DR
Property PHGLPHLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHGL_PHL_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHGL)</SqlIdExpression>
<SQLMap name="PHGLCTLOC">
<Global>^DHCPHGLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHGL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHGL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHGL_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHGLMASTER">
<Data name="PHGL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHGL_DOFLAG">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHGL_OKFLAG">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHGL_PHG_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHGL_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHGL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHGL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHGL_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PHGLPHG">
<Global>^DHCPHGLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHGL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHGL_PHG_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHGL_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHGLOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
