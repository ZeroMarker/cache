Class User.DHCEQTrainingRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TRR_RowID, SqlTableName = DHC_EQTrainingRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index TRRNoUnqIdx1 On TRRNo [ Unique ];

/// TRR_ClassHours
Property TRRClassHours As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TRR_ClassHours ];

/// TRR_Hold1
Property TRRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = TRR_Hold1 ];

/// TRR_Hold2
Property TRRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = TRR_Hold2 ];

/// TRR_Hold3
Property TRRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = TRR_Hold3 ];

/// TRR_Hold4
Property TRRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = TRR_Hold4 ];

/// TRR_Hold5
Property TRRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = TRR_Hold5 ];

/// TRR_InvalidFlag
Property TRRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = TRR_InvalidFlag ];

/// TRR_LocDR
Property TRRLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TRR_LocDR ];

/// TRR_Name
Property TRRName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TRR_Name ];

/// TRR_No
Property TRRNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TRR_No ];

/// TRR_Remark
Property TRRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = TRR_Remark ];

/// TRR_Stage
Property TRRStage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TRR_Stage ];

/// TRR_Status
Property TRRStatus As %Library.String(DISPLAYLIST = ",新增,审核,作废", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,2,3") [ SqlColumnNumber = 17, SqlFieldName = TRR_Status ];

/// TRR_TrainContent
Property TRRTrainContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TRR_TrainContent ];

/// TRR_TrainEndDate
Property TRRTrainEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = TRR_TrainEndDate ];

/// TRR_TrainEndTime
Property TRRTrainEndTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = TRR_TrainEndTime ];

/// TRR_TrainingDR
Property TRRTrainingDR As User.DHCEQCourse [ SqlColumnNumber = 3, SqlFieldName = TRR_TrainingDR ];

/// TRR_TrainingUser
Property TRRTrainingUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TRR_TrainingUser ];

/// TRR_TrainPlace
Property TRRTrainPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TRR_TrainPlace ];

/// TRR_TrainStartDate
Property TRRTrainStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = TRR_TrainStartDate ];

/// TRR_TrainStartTime
Property TRRTrainStartTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = TRR_TrainStartTime ];

/// TRR_TrainType
Property TRRTrainType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TRR_TrainType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTrainingRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRR_ClassHours">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TRR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TRR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TRR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TRR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TRR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TRR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TRR_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRR_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TRR_Stage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRR_Status">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TRR_TrainContent">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRR_TrainEndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TRR_TrainEndTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TRR_TrainPlace">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRR_TrainStartDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TRR_TrainStartTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TRR_TrainType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRR_TrainingDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRR_TrainingUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQTrainingRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TRR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQTrainingRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TRR_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TRR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTraining">
<Global>^DHCEQTrainingRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRR_RowID</Field>
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
<Expression>{TRR_TrainingDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TRR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTrainingRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
