Class dhc.pa.data.SurveyTotalScore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SurveyTotalScore_rowid, SqlTableName = SurveyTotalScore, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SurveyTotalScore_period
Property SurveyTotalScoreperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SurveyTotalScore_period ];

/// SurveyTotalScore_periodType
Property SurveyTotalScoreperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SurveyTotalScore_periodType ];

/// SurveyTotalScore_schemDr
Property SurveyTotalScoreschemDr As dhc.pa.data.Schem [ SqlColumnNumber = 4, SqlFieldName = SurveyTotalScore_schemDr ];

/// SurveyTotalScore_AcceptUnitDr
Property SurveyTotalScoreAcceptUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 5, SqlFieldName = SurveyTotalScore_AcceptUnitDr ];

/// SurveyTotalScore_score
Property SurveyTotalScorescore As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SurveyTotalScore_score ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASURVEYTOTALSCORE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="SurveyTotalScore_AcceptUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SurveyTotalScore_period">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SurveyTotalScore_periodType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SurveyTotalScore_schemDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SurveyTotalScore_score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCJXPASURVEYTOTALSCORE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SurveyTotalScore_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SurveyTotalScore_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPPSA">
<Global>^DHCCJXPASURVEYTOTALSCORE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SurveyTotalScore_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPSA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyTotalScore_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyTotalScore_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyTotalScore_schemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyTotalScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyTotalScore_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SurveyTotalScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
