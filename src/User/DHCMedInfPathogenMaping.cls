Class User.DHCMedInfPathogenMaping Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIPM_Rowid, SqlTableName = DHC_MedInfPathogenMaping, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MIPM_PatID
Property MIPMPatID As User.DHCMedInfPathogenDic [ SqlColumnNumber = 2, SqlFieldName = MIPM_PatID ];

/// MIPM_Code
Property MIPMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIPM_Code ];

/// MIPM_Desc
Property MIPMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIPM_Desc ];

/// MIAM_DateFrom
Property MIAMDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MIAM_DateFrom ];

/// MIAM_DateTo
Property MIAMDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MIAM_DateTo ];

/// MIPM_IsActive
Property MIPMIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MIPM_IsActive ];

/// MIPM_Resume
Property MIPMResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MIPM_Resume ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMInfPM)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCMInfPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIPM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIPM_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIPM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCMInfPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIPM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIPM_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIPM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="MIAM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIAM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIPM_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIPM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIPM_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIPM_PatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIPM_Resume">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCMInfPM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIPM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIPM_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfPathogenMapingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
