Class User.DHCWLPatBaseInfor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBI_Rowid, SqlTableName = DHCWLPatBaseInfor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PBI_AdmDr
Property PBIAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PBI_AdmDr ];

/// PBI_Code
Property PBICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PBI_Code ];

/// PBI_Desc
Property PBIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PBI_Desc ];

/// PBI_DataValue
Property PBIDataValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PBI_DataValue ];

/// PBI_StandardValue
Property PBIStandardValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PBI_StandardValue ];

/// PBI_DateFlag
Property PBIDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PBI_DateFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLPBI(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PBI_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBI_DataValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBI_DateFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PBI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBI_StandardValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCWLPBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PBI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PBI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmCodeDateFlag">
<Global>^DHCWLPBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PBI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmCodeDateFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBI_DateFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMCode">
<Global>^DHCWLPBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PBI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAadm">
<Global>^DHCWLPBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PBI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBI_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLPatBaseInforS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
