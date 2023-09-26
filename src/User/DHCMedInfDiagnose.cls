Class User.DHCMedInfDiagnose Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIDIA_Rowid, SqlTableName = DHC_MedInfDiagnose, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MIDIA_ICD
Property MIDIAICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MIDIA_ICD ];

/// MIDIA_DiseaseName
Property MIDIADiseaseName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIDIA_DiseaseName ];

/// MIDIA_Type
Property MIDIAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIDIA_Type ];

/// MIDIA_Active
Property MIDIAActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MIDIA_Active ];

/// MIDIA_Demo
Property MIDIADemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIDIA_Demo ];

/// MIDIA_Alias
Property MIDIAAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MIDIA_Alias ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMIDIA)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIDIA_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIDIA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIDIA_Demo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIDIA_DiseaseName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIDIA_ICD">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIDIA_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMIDIA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIDIA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIDIA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCMIDIA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIDIA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MIDIA_Alias})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIDIA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfDiagnoseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
