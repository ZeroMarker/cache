Class dhc.pa.data.SurveyScoreTotal Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SurveyScoreTotal_Rowid, SqlTableName = SurveyScoreTotal, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SurveyScoreTotal_AcceptUnitDr
Property SurveyScoreTotalAcceptUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = SurveyScoreTotal_AcceptUnitDr ];

/// SurveyScoreTotal_unitType
Property SurveyScoreTotalunitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SurveyScoreTotal_unitType ];

/// SurveyScoreTotal_ScoreDr
Property SurveyScoreTotalScoreDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 4, SqlFieldName = SurveyScoreTotal_ScoreDr ];

/// SurveyScoreTotal_TotalScore
Property SurveyScoreTotalTotalScore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SurveyScoreTotal_TotalScore ];

/// SurveyScoreTotal_Active
Property SurveyScoreTotalActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SurveyScoreTotal_Active ];

/// SurveyScoreTotal
Property SurveyScoreTotalhandFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SurveyScoreTotal_handFlag ];

/// SurveyScoreTotal_period
Property SurveyScoreTotalperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SurveyScoreTotal_period ];

/// SurveyScoreTotal_periodType
Property SurveyScoreTotalperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SurveyScoreTotal_periodType ];

/// SurveyScoreTotal_SchemDr
Property SurveyScoreTotalSchemDr As dhc.pa.data.Schem [ SqlColumnNumber = 10, SqlFieldName = SurveyScoreTotal_SchemDr ];

/// SurveyScoreTotal_userDr
Property SurveyScoreTotaluserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = SurveyScoreTotal_userDr ];

/// SurveyScoreTotal_patDr
Property SurveyScoreTotalpatDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SurveyScoreTotal_patDr ];

/// SurveyScoreTotal_patName
Property SurveyScoreTotalpatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SurveyScoreTotal_patName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASURVEYSCORETOTAL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="SurveyScoreTotal_AcceptUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SurveyScoreTotal_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SurveyScoreTotal_SchemDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SurveyScoreTotal_ScoreDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SurveyScoreTotal_TotalScore">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SurveyScoreTotal_handFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SurveyScoreTotal_patDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SurveyScoreTotal_patName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SurveyScoreTotal_period">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SurveyScoreTotal_periodType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SurveyScoreTotal_unitType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SurveyScoreTotal_userDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCCJXPASURVEYSCORETOTAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SurveyScoreTotal_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SurveyScoreTotal_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPPAS">
<Global>^DHCCJXPASURVEYSCORETOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SurveyScoreTotal_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScoreTotal_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScoreTotal_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScoreTotal_SchemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScoreTotal_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScoreTotal_userDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SurveyScoreTotal_patDr}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SurveyScoreTotal_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPTTypeLoc">
<Global>^DHCCJXPASURVEYSCORETOTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SurveyScoreTotal_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPTTypeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScoreTotal_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScoreTotal_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScoreTotal_SchemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScoreTotal_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScoreTotal_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SurveyScoreTotalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
