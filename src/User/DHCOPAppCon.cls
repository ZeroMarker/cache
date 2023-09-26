Class User.DHCOPAppCon Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPAC_RowID, SqlTableName = DHC_OPAppCon, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCOPAppConCate As User.DHCOPAppConCate [ Cardinality = children, Inverse = OPACCOPACParRef ];

/// OPAC_DateFrom
Property OPACDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = OPAC_DateFrom ];

/// OPAC_DateTo
Property OPACDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = OPAC_DateTo ];

/// OPAC_MinAmount
Property OPACMinAmount As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = OPAC_MinAmount ];

/// OPAC_Name
Property OPACName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OPAC_Name ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPAppCon)</SqlIdExpression>
<SQLMap name="dataDHCOPAppCon">
<Data name="OPAC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPAC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPAC_MinAmount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPAC_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPAppCon</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPAC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OPAC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexName">
<Global>^DHCOPAppCon</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPAC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPAC_Name}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPAppConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
