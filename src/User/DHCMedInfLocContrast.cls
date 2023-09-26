Class User.DHCMedInfLocContrast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MILC_Rowid, SqlTableName = DHC_MedInfLocContrast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2500;

/// MILC_CtlocDR
Property MILCCtlocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MILC_CtlocDR ];

/// MILC_InflocDR
Property MILCInflocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MILC_InflocDR ];

/// MILC_IsActive
Property MILCIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MILC_IsActive ];

/// MILC_DateFrom
Property MILCDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MILC_DateFrom ];

/// MILC_DateTo
Property MILCDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MILC_DateTo ];

/// MILC_Resume
Property MILCResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MILC_Resume ];

Storage SQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCMInfLC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MILC_CtlocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MILC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MILC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MILC_InflocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MILC_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MILC_Resume">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMInfLC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MILC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MILC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCtloc">
<Global>^DHCMInfLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MILC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Ctloc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MILC_CtlocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MILC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInfloc">
<Global>^DHCMInfLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MILC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Infloc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MILC_InflocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MILC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfLocContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
