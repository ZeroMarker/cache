Class User.DHCMedInfAntiContrast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIAC_Rowid, SqlTableName = DHC_MedInfAntiContrast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2500;

/// MIAC_ItmMastDR
Property MIACItmMastDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MIAC_ItmMastDR ];

/// MIAC_InfAntiDR
Property MIACInfAntiDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MIAC_InfAntiDR ];

/// MIAC_IsActive
Property MIACIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MIAC_IsActive ];

/// MIAC_DateFrom
Property MIACDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MIAC_DateFrom ];

/// MIAC_DateTo
Property MIACDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MIAC_DateTo ];

/// MIAC_Resume
Property MIACResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MIAC_Resume ];

Storage SQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCMInfAC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MIAC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIAC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIAC_InfAntiDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIAC_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIAC_ItmMastDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIAC_Resume">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMInfAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIAC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIAC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcItmMast">
<Global>^DHCMInfAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIAC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIAC_ItmMastDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInfAnti">
<Global>^DHCMInfAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIAC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InfAnti"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIAC_InfAntiDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIAC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfAntiContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
