Class User.DHCPHMANCODE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMC_ROWID, SqlTableName = DHC_PHMANCODE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHMC_PHL_DR
Property PHMCCTLOCDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHMC_CTLOC_DR ];

/// PHMC_INCIDESC
Property PHMCINCIDESC As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMC_INCIDESC ];

/// PHMC_INCI_DR
Property PHMCINCIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHMC_INCI_DR ];

/// PHMC_LMGRP_DR
Property PHMCLMGRPDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHMC_LMGRP_DR ];

/// PHMC_USEFLAG
Property PHMCUSEFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHMC_USEFLAG ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PHMC)</SqlIdExpression>
<SQLMap name="INDEXLocManGrp">
<Global>^PHMCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHMC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MANGRP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHMC_LMGRP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHMC_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHMC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHMCINDEX">
<Global>^PHMCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHMC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHMC_INCI_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHMC_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHMCMASTER">
<Data name="PHMC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMC_INCIDESC">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMC_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMC_LMGRP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMC_USEFLAG">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PHMC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMC_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMC_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMANCODES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
