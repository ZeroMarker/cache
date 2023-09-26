Class User.DHCEQTrainingScoreList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TSL_RowID, SqlTableName = DHC_EQTrainingScoreList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TSL_Forms
Property TSLForms As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TSL_Forms ];

/// TSL_Hold1
Property TSLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TSL_Hold1 ];

/// TSL_Hold2
Property TSLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TSL_Hold2 ];

/// TSL_Hold3
Property TSLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TSL_Hold3 ];

/// TSL_Hold4
Property TSLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TSL_Hold4 ];

/// TSL_Hold5
Property TSLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TSL_Hold5 ];

/// TSL_InvalidFlag
Property TSLInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = TSL_InvalidFlag ];

/// TSL_PassFlag
Property TSLPassFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TSL_PassFlag ];

/// TSL_Remark
Property TSLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TSL_Remark ];

/// TSL_Score
Property TSLScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TSL_Score ];

/// TSL_TrainingScoreDR
Property TSLTrainingScoreDR As User.DHCEQTrainingScore [ SqlColumnNumber = 2, SqlFieldName = TSL_TrainingScoreDR ];

/// TSL_TrainUserDR
Property TSLTrainUserDR As User.DHCEQTrainingUser [ SqlColumnNumber = 3, SqlFieldName = TSL_TrainUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTrainingScoreList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TSL_Forms">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TSL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TSL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TSL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TSL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TSL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TSL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TSL_PassFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TSL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TSL_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TSL_TrainUserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TSL_TrainingScoreDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQTrainingScoreList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TSL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTrainingScore">
<Global>^DHCEQTrainingScoreList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TrainingScore"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TSL_TrainingScoreDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TSL_TrainUserDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTrainingScoreListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
