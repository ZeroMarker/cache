/// Coding Errors(2098)
Class User.PACodingErrors Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CodingErrors, StorageStrategy = SQLStorage ]
{

/// Des Ref AdmCoding
Property CODERRAdmCodingDR As PAAdmCoding [ SqlColumnNumber = 6, SqlFieldName = CODERR_AdmCoding_DR ];

/// Code
Property CODERRCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CODERR_Code ];

/// ID
Property CODERRID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CODERR_ID ];

/// National Code
Property CODERRNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CODERR_NationalCode ];

/// Parameters
Property CODERRParameters As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CODERR_Parameters ];

/// Des Ref SMRError
Property CODERRSMRErrorDR As PACSMRError [ SqlColumnNumber = 2, SqlFieldName = CODERR_SMRError_DR ];

Parameter EXTENTSIZE = 1470;

Storage SQLStorage
{
<ExtentSize>1470</ExtentSize>
<Property name="CODERRAdmCodingDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CODERRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CODERRID">
<Selectivity>1</Selectivity>
</Property>
<Property name="CODERRNationalCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CODERRParameters">
<Selectivity>1</Selectivity>
</Property>
<Property name="CODERRSMRErrorDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PACE(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CODERR_AdmCoding_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CODERR_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CODERR_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CODERR_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CODERR_Parameters">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CODERR_SMRError_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PACE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CODERR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CODERR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmCoding">
<Global>^PACEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CODERR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AdmCoding"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CODERR_AdmCoding_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CODERR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CODERR_RowId</SqlRowIdName>
<StreamLocation>^User.PACodingErrorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
