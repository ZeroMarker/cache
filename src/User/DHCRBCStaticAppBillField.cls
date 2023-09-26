Class User.DHCRBCStaticAppBillField Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSBF_RowID, SqlTableName = DHCRBC_StaticAppBillField, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 252;

/// DSBF_Name
Property DSBFName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSBF_Name ];

/// DSBF_Description
Property DSBFDescription As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSBF_Description ];

/// DSBF_Type
Property DSBFType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DSBF_Type ];

/// DSBF_Len
Property DSBFLen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSBF_Len ];

/// DSBF_Note
Property DSBFNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DSBF_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("AppField"))</SqlIdExpression>
<SQLMap name="IndexName">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSBF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FieldName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSBF_Name}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSBF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapData">
<Data name="DSBF_Description">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSBF_Len">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSBF_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSBF_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSBF_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSBF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AppField"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSBF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCStaticAppBillFieldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
