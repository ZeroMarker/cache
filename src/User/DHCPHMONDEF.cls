Class User.DHCPHMONDEF Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMD_ROWID, SqlTableName = DHC_PHMONDEF, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMD_DATE
Property PHMDDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHMD_DATE ];

/// PHMD_ENDDATE
Property PHMDENDDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHMD_ENDDATE ];

/// PHMD_MONTH
Property PHMDMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHMD_MONTH ];

/// PHMD_PHP_DR
Property PHMDPHPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHMD_PHP_DR ];

/// PHMD_STDATE
Property PHMDSTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHMD_STDATE ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMONDEF)</SqlIdExpression>
<SQLMap name="PHMONDEFMASTER">
<Data name="PHMD_DATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMD_ENDDATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMD_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMD_PHP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMD_STDATE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHMONDEF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMD_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMONDEFS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
