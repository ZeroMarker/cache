Class User.DHCEQAccountPeriod Extends %Persistent [ SqlRowIdName = AP_RowID, SqlTableName = DHC_EQAccountPeriod, StorageStrategy = SQLStorage ]
{

/// AP_Year
Property APYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AP_Year ];

/// AP_Month
Property APMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AP_Month ];

/// AP_StartDate
Property APStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = AP_StartDate ];

/// AP_StartTime
Property APStartTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AP_StartTime ];

/// AP_EndDate
Property APEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = AP_EndDate ];

/// AP_EndTime
Property APEndTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = AP_EndTime ];

/// AP_HospitalDR
Property APHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AP_HospitalDR ];

/// AP_SnapID
Property APSnapID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AP_SnapID ];

/// AP_EquipTypeIDs
Property APEquipTypeIDs As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AP_EquipTypeIDs ];

/// AP_UserDR
Property RUserDR As DHCEQCDepartment [ SqlColumnNumber = 11, SqlFieldName = AP_UserDR ];

/// AP_Date
Property APDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = AP_Date ];

/// AP_Time
Property APTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AP_Time ];

/// AP_ReportStat	///0,正常；1.数据检查正常；2.任务或执行异常；3.数据检测异常
Property APReportStat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AP_ReportStat ];

/// AP_DepreStat
Property APDepreStat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AP_DepreStat ];

/// AP_Remark
Property APRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AP_Remark ];

/// AP_InvalidFlag
Property APInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AP_InvalidFlag ];

/// AP_Hold1
Property APHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AP_Hold1 ];

/// AP_Hold2
Property APHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AP_Hold2 ];

/// AP_Hold3
Property APHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AP_Hold3 ];

/// AP_Hold4
Property APHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AP_Hold4 ];

/// AP_Hold5
Property APHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AP_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAccountPeriod("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_DepreStat">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_EquipTypeIDs">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AP_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AP_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_ReportStat">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_SnapID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AP_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_Year">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQAccountPeriod</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{AP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQAccountPeriod</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{AP_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{AP_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQAccountPeriodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
