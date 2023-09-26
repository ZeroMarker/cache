Class User.DHCMedDictory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDIC_Rowid, SqlTableName = DHC_MedDictory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MDIC_Code
Property MDICCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MDIC_Code ];

/// MDIC_Desc
Property MDICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MDIC_Desc ];

/// MDIC_Type
Property MDICType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MDIC_Type ];

/// MDIC_Active
Property MDICActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MDIC_Active ];

/// MDIC_DateFrom
Property MDICDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MDIC_DateFrom ];

/// MDIC_DateTo
Property MDICDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MDIC_DateTo ];

/// MDIC_StrA
Property MDICStrA As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MDIC_StrA ];

/// MDIC_StrB
Property MDICStrB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MDIC_StrB ];

/// MDIC_StrC
Property MDICStrC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MDIC_StrC ];

/// MDIC_StrD
Property MDICStrD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MDIC_StrD ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDIC)</SqlIdExpression>
<SQLMap name="DataMastermap">
<Data name="MDIC_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDIC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDIC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDIC_StrA">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MDIC_StrB">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MDIC_StrC">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MDIC_StrD">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MDIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMDIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MDIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MDIC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTYPE">
<Global>^DHCMDIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDIC_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDIC_Active}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCMDIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MDIC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDIC_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDIC_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MDIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDictoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
