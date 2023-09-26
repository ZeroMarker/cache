/// ScoreLevel
Class dhc.pa.data.ScoreLevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ScoreLevel_Rowid, SqlTableName = ScoreLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ScoreLevel_Score
Property ScoreLevelScore As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ScoreLevel_Score ];

/// ScoreLevel_Code
Property ScoreLevelCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ScoreLevel_Code ];

/// ScoreLevel_Name
Property ScoreLevelName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ScoreLevel_Name ];

/// ScoreLevel_ShortCut
Property ScoreLevelShortCut As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ScoreLevel_ShortCut ];

/// ScoreLevel_Py
Property ScoreLevelPy As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ScoreLevel_Py ];

/// ScoreLevel_Active
Property ScoreLevelActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ScoreLevel_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPASCORELEVEL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="ScoreLevel_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ScoreLevel_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ScoreLevel_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ScoreLevel_Py">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ScoreLevel_Score">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ScoreLevel_ShortCut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCJXPASCORELEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ScoreLevel_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ScoreLevel_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPASCORELEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ScoreLevel_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ScoreLevel_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ScoreLevel_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPASCORELEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ScoreLevel_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ScoreLevel_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ScoreLevel_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.ScoreLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
