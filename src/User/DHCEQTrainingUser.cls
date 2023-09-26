Class User.DHCEQTrainingUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TU_RowID, SqlTableName = DHC_EQTrainingUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TU_Absence
Property TUAbsence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TU_Absence ];

/// TU_AverageScore
Property TUAverageScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TU_AverageScore ];

/// TU_Frequency
Property TUFrequency As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TU_Frequency ];

/// TU_Hold1
Property TUHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TU_Hold1 ];

/// TU_Hold2
Property TUHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = TU_Hold2 ];

/// TU_Hold3
Property TUHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TU_Hold3 ];

/// TU_Hold4
Property TUHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = TU_Hold4 ];

/// TU_Hold5
Property TUHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TU_Hold5 ];

/// TU_InvalidFlag
Property TUInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = TU_InvalidFlag ];

/// TU_Leave
Property TULeave As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TU_Leave ];

/// TU_PassFlag
Property TUPassFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TU_PassFlag ];

/// TU_Remark
Property TURemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TU_Remark ];

/// TU_Stage
Property TUStage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TU_Stage ];

/// TU_Times
Property TUTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TU_Times ];

/// TU_TrainingDR
Property TUTrainingDR As User.DHCEQCourse [ SqlColumnNumber = 3, SqlFieldName = TU_TrainingDR ];

/// TU_TrainUserDR
Property TUTrainUserDR As User.DHCEQCUser [ SqlColumnNumber = 2, SqlFieldName = TU_TrainUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTrainingUser("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TU_Absence">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TU_AverageScore">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TU_Frequency">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TU_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TU_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TU_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TU_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TU_Leave">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TU_PassFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TU_Stage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TU_Times">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TU_TrainUserDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TU_TrainingDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQTrainingUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{TU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTraining">
<Global>^DHCEQTrainingUser</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Training"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TU_TrainingDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTrainingUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
