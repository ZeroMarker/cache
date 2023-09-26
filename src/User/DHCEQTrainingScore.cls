Class User.DHCEQTrainingScore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TS_RowID, SqlTableName = DHC_EQTrainingScore, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TS_Desc
Property TSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TS_Desc ];

/// TS_ExamContent
Property TSExamContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TS_ExamContent ];

/// TS_ExamEndDate
Property TSExamEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = TS_ExamEndDate ];

/// TS_ExamEndTime
Property TSExamEndTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = TS_ExamEndTime ];

/// TS_ExamStartDate
Property TSExamStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = TS_ExamStartDate ];

/// TS_ExamStartTime
Property TSExamStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = TS_ExamStartTime ];

/// TS_Hold1
Property TSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TS_Hold1 ];

/// TS_Hold2
Property TSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = TS_Hold2 ];

/// TS_Hold3
Property TSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = TS_Hold3 ];

/// TS_Hold4
Property TSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = TS_Hold4 ];

/// TS_Hold5
Property TSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = TS_Hold5 ];

/// TS_InvalidFlag
Property TSInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = TS_InvalidFlag ];

/// TS_LocDR
Property TSLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TS_LocDR ];

/// TS_Manager
Property TSManager As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TS_Manager ];

/// TS_No
Property TSNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TS_No ];

/// TS_Num
Property TSNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TS_Num ];

/// TS_Remark
Property TSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = TS_Remark ];

/// TS_Stage
Property TSStage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TS_Stage ];

/// TS_Status
Property TSStatus As %Library.String(DISPLAYLIST = ",新增,审核,作废", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,2,3") [ SqlColumnNumber = 15, SqlFieldName = TS_Status ];

/// TS_TrainingDR
Property TSTrainingDR As User.DHCEQCourse [ SqlColumnNumber = 3, SqlFieldName = TS_TrainingDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTrainingScore("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TS_ExamContent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TS_ExamEndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TS_ExamEndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TS_ExamStartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TS_ExamStartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TS_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TS_Manager">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TS_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TS_Num">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TS_Stage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TS_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TS_TrainingDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQTrainingScore</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTraining">
<Global>^DHCEQTrainingScore</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TS_RowID</Field>
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
<Expression>{TS_TrainingDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTrainingScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
