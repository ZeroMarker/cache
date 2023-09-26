Class dhc.pa.data.SurveyScore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SurveyScore_Rowid, SqlTableName = SurveyScore, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SurveyScore_ScoreUserDr
Property SurveyScoreScoreUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = SurveyScore_ScoreUserDr ];

/// SurveyScore_ScoreUnitDr
Property SurveyScoreScoreUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = SurveyScore_ScoreUnitDr ];

/// SurveyScore_unitType
Property SurveyScoreunitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SurveyScore_unitType ];

/// SurveyScore_AcceptUnitDr
Property SurveyScoreAcceptUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 6, SqlFieldName = SurveyScore_AcceptUnitDr ];

/// SurveyScore_AcceptUnitType
Property SurveyScoreAcceptUnitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SurveyScore_AcceptUnitType ];

/// SurveyScore_KpiDr
Property SurveyScoreKpiDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 8, SqlFieldName = SurveyScore_KpiDr ];

/// SurveyScore_ScoreLevelDr
Property SurveyScoreScoreLevelDr As dhc.pa.data.ScoreLevel [ SqlColumnNumber = 9, SqlFieldName = SurveyScore_ScoreLevelDr ];

/// SurveyScore_DirectScore
Property SurveyScoreDirectScore As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SurveyScore_DirectScore ];

/// SurveyScore_period
Property SurveyScoreperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SurveyScore_period ];

/// SurveyScore_periodType
Property SurveyScoreperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SurveyScore_periodType ];

/// SurveyScore_SchemDr
Property SurveyScoreSchemDr As dhc.pa.data.Schem [ SqlColumnNumber = 13, SqlFieldName = SurveyScore_SchemDr ];

/// SurveyScore_Active
Property SurveyScoreActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SurveyScore_Active ];

/// SurveyScore_desc
Property SurveyScoredesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SurveyScore_desc ];

/// SurveyScore_submit
Property SurveyScoresubmit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = SurveyScore_submit ];

/// 受访人编号
Property SurveyScorepatDr As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SurveyScore_patDr ];

/// 受访人姓名
Property SurveyScorepatName As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = SurveyScore_patName ];

/// 时间
Property SurveyScoreDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = SurveyScore_patDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASURVEYSCORE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="SurveyScore_AcceptUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SurveyScore_AcceptUnitType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SurveyScore_Active">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SurveyScore_DirectScore">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SurveyScore_KpiDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SurveyScore_SchemDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SurveyScore_ScoreLevelDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SurveyScore_ScoreUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SurveyScore_ScoreUserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SurveyScore_desc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SurveyScore_patDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SurveyScore_patDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SurveyScore_patName">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SurveyScore_period">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SurveyScore_periodType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SurveyScore_submit">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SurveyScore_unitType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPASURVEYSCORE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SurveyScore_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPPTU">
<Global>^DHCCJXPASURVEYSCORE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SurveyScore_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPTU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScore_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScore_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScore_AcceptUnitType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRep">
<Global>^DHCCJXPASURVEYSCORE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L9}</Expression>
<Field>SurveyScore_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepRecord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScore_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScore_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScore_ScoreUserDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScore_patDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SurveyScore_SchemDr}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SurveyScore_KpiDr}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepcord">
<Global>^DHCCJXPASURVEYSCORE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Repcord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScore_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScore_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScore_SchemDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScore_ScoreUserDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SurveyScore_patDr}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemKpi">
<Global>^DHCCJXPASURVEYSCORE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SurveyScore_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemKpi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScore_SchemDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScore_AcceptUnitType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScore_KpiDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRepRecord">
<Global>^DHCCJXPASURVEYSCORE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemPat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SurveyScore_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SurveyScore_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SurveyScore_AcceptUnitDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SurveyScore_ScoreUserDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SurveyScore_SchemDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SurveyScore_patDr}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SurveyScore_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SurveyScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
