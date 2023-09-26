/// Admission Point(2416)
Class User.PACAdmissionPoint Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmissionPoint, StorageStrategy = SQLStorage ]
{

Relationship ChildPACAdmissionPointHosp As PACAdmissionPointHosp [ Cardinality = children, Inverse = HOSParRef ];

/// Code
Property ADMPOINTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADMPOINT_Code ];

/// Description
Property ADMPOINTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADMPOINT_Desc ];

/// Date From
Property ADMPOINTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ADMPOINT_DateFrom ];

/// Date To
Property ADMPOINTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ADMPOINT_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("ADMPOINT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADMPOINT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMPOINT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADMPOINT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADMPOINT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADMPOINT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMPOINT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADMPOINT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMPOINT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMPOINT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMPOINT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMPOINT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMPOINT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMPOINT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMPOINT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMPOINT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADMPOINT_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmissionPointS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
