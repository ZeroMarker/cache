Class User.DHCEQTrainingRecordList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TRRL_RowID, SqlTableName = DHC_EQTrainingRecordList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TRRL_CheckinTime
Property TRRLCheckinTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = TRRL_CheckinTime ];

/// TRRL_Hold1
Property TRRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TRRL_Hold1 ];

/// TRRL_Hold2
Property TRRLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TRRL_Hold2 ];

/// TRRL_Hold3
Property TRRLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TRRL_Hold3 ];

/// TRRL_Hold4
Property TRRLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TRRL_Hold4 ];

/// TRRL_Hold5
Property TRRLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TRRL_Hold5 ];

/// TRRL_InvalidFlag
Property TRRLInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TRRL_InvalidFlag ];

/// TRRL_Remark
Property TRRLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TRRL_Remark ];

/// TRRL_Status
Property TRRLStatus As %Library.String(DISPLAYLIST = ",正常,请假,缺席", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 4, SqlFieldName = TRRL_Status ];

/// TRRL_TrainingRecordDR
Property TRRLTrainingRecordDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TRRL_TrainingRecordDR ];

/// TRRL_TrainUserDR
Property TRRLTrainUserDR As User.DHCEQTrainingUser [ SqlColumnNumber = 3, SqlFieldName = TRRL_TrainUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTrainingRecordList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRRL_CheckinTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRRL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRRL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRRL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRRL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TRRL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TRRL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRRL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRRL_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRRL_TrainUserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRRL_TrainingRecordDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQTrainingRecordList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TRRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TRRL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTrainingRecord">
<Global>^DHCEQTrainingRecordList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TrainingRecord"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TRRL_TrainingRecordDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TRRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTrainingRecordListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
