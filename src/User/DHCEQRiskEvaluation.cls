Class User.DHCEQRiskEvaluation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RE_RowID, SqlTableName = DHC_EQRiskEvaluation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RE_Type
Property REType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RE_Type ];

/// RE_SourceType
Property RESourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RE_SourceType ];

/// RE_SourceID
Property RESourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RE_SourceID ];

/// RE_Weight
Property REWeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RE_Weight ];

/// RE_RiskGradeDR
Property RERiskGradeDR As User.DHCEQCRiskGrade [ SqlColumnNumber = 6, SqlFieldName = RE_RiskGradeDR ];

/// RE_EvaluateUser
Property REEvaluateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RE_EvaluateUser ];

/// RE_EvaluateDate
Property REEvaluateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RE_EvaluateDate ];

/// RE_EvaluateTime
Property REEvaluateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = RE_EvaluateTime ];

/// RE_Remark
Property RERemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RE_Remark ];

/// RE_Hold1
Property REHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RE_Hold1 ];

/// RE_Hold2
Property REHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RE_Hold2 ];

/// RE_Hold3
Property REHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RE_Hold3 ];

/// RE_Hold4
Property REHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RE_Hold4 ];

/// RE_Hold5
Property REHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = RE_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRiskEvaluation("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RE_EvaluateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RE_EvaluateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RE_EvaluateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RE_RiskGradeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RE_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RE_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RE_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RE_Weight">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQRiskEvaluation</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQRiskEvaluation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RE_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RE_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRiskEvaluationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
