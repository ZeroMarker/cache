Class User.DHCWLPatDepInfor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDI_Rowid, SqlTableName = DHCWLPatDepInfor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PDI_AdmDr
Property PDIAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDI_AdmDr ];

/// PDI_DepDr
Property PDIDepDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDI_DepDr ];

/// PDI_Code
Property PDICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDI_Code ];

/// PDI_Desc
Property PDIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDI_Desc ];

/// PDI_DataValue
Property PDIDataValue As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PDI_DataValue ];

/// PDI_StandardValue
Property PDIStandardValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDI_StandardValue ];

/// PDI_DateFlag
Property PDIDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PDI_DateFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLPDI(0))</SqlIdExpression>
<SQLMap name="DataMasterDHCWLPDI">
<Data name="PDI_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDI_DataValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDI_DateFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDI_DepDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDI_StandardValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCWLPDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADMCODE">
<Global>^DHCWLPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexADMDEP">
<Global>^DHCWLPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_DepDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexADMDEPCODE">
<Global>^DHCWLPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDEPCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_DepDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDI_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexADMDR">
<Global>^DHCWLPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmCodeDateFlag">
<Global>^DHCWLPDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmCodeDateFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDI_DateFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLPatDepInforS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
