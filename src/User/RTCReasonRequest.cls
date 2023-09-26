/// Reason for Request(1132)
Class User.RTCReasonRequest Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RTC_Reason_Request, StorageStrategy = SQLStorage ]
{

Relationship ChildRTCReasonRequestHosp As RTCReasonRequestHosp [ Cardinality = children, Inverse = HOSParRef ];

/// Description
Property READesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = REA_Desc ];

/// Priority No
Property REAPriorityNo As %Float(MAXVAL = 99, MINVAL = 0) [ SqlColumnNumber = 3, SqlFieldName = REA_Priority_No ];

/// Expected Time to Keep Record
Property REAExpTimeKeepRecord As %Float(MAXVAL = 9999, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = REA_ExpTimeKeepRecord ];

/// AdmissionType
Property REAAdmissionType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Health Promotion,All", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,H,A") [ SqlColumnNumber = 5, SqlFieldName = REA_AdmissionType ];

/// Return To Office
Property REAReturnToOffice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = REA_ReturnToOffice ];

/// Code
Property REACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = REA_Code ];

/// Date From
Property READateFrom As %Date [ SqlColumnNumber = 8, SqlFieldName = REA_DateFrom ];

/// Date To
Property READateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = REA_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RTC("REA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REA_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REA_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REA_ExpTimeKeepRecord">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REA_Priority_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REA_ReturnToOffice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^RTC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RTC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REA_RowId</SqlRowIdName>
<StreamLocation>^User.RTCReasonRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
