Class User.DHCPHBasManStudent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHBMS_RowID, SqlTableName = DHC_PHBasManStudent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHBMS_Name
Property PHBMSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHBMS_Name ];

/// PHBMS_Sex_Dr
Property PHBMSSexDr As User.CTSex [ SqlColumnNumber = 3, SqlFieldName = PHBMS_Sex_Dr ];

/// PHBMS_Age
Property PHBMSAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHBMS_Age ];

/// PHBMS_Education
Property PHBMSEducation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHBMS_Education ];

/// PHBMS_CarPrvTp
Property PHBMSCarPrvTp As User.CTCareProv [ SqlColumnNumber = 6, SqlFieldName = PHBMS_CarPrvTp ];

/// PHBMS_Career
Property PHBMSCareer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHBMS_Career ];

/// PHBMS_WorkUnit
Property PHBMSWorkUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHBMS_WorkUnit ];

/// PHBMS_BegEduDate
Property PHBMSBegEduDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PHBMS_BegEduDate ];

/// PHBMS_EndEduDate
Property PHBMSEndEduDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PHBMS_EndEduDate ];

/// PHBMS_OutProFlag
Property PHBMSOutProFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHBMS_OutProFlag ];

/// PHBMS_Date
Property PHBMSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PHBMS_Date ];

/// PHBMS_Time
Property PHBMSTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PHBMS_Time ];

/// PHBMS_Remark
Property PHBMSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHBMS_Remark ];

/// PHBMS_JobNo  增加学员工号
Property PHBMSJobNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHBMS_JobNo ];

/// PHBMS_HighestEducation
Property PHBMSHighestEducation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PHBMS_HighestEducation ];

/// PHBMS_Professional
Property PHBMSProfessional As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHBMS_Professional ];

/// PHBMS_TopProfessional
Property PHBMSTopProfessional As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHBMS_TopProfessional ];

/// PHBMS_Teacher
Property PHBMSTeacher As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHBMS_Teacher ];

/// PHBMS_TrainDate
Property PHBMSTrainDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = PHBMS_TrainDate ];

/// PHBMS_IsAssessment
Property PHBMSIsAssessment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PHBMS_IsAssessment ];

/// PHBMS_Flag
Property PHBMSFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PHBMS_Flag ];

/// PHBMS_Telephone
Property PHBMSTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHBMS_Telephone ];

/// PHBMS_Address
Property PHBMSAddress As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PHBMS_Address ];

/// PHBMS_Path
Property PHBMSPath As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PHBMS_Path ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHBMS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHBMS_Address">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHBMS_Age">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHBMS_BegEduDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHBMS_CarPrvTp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHBMS_Career">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHBMS_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHBMS_Education">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHBMS_EndEduDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHBMS_Flag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHBMS_HighestEducation">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHBMS_IsAssessment">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHBMS_JobNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHBMS_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHBMS_OutProFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHBMS_Path">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHBMS_Professional">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHBMS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHBMS_Sex_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHBMS_Teacher">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHBMS_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHBMS_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHBMS_TopProfessional">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHBMS_TrainDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHBMS_WorkUnit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHBMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHBMS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHBMS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexJobNo">
<Global>^DHCPHBMS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHBMS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JobNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHBMS_JobNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHBMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTeacher">
<Global>^DHCPHBMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHBMS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Teacher"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHBMS_Teacher}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHBMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHBasManStudentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHBMS)
	s oldI = +$g(^mdata("DHCPHBASMANSTUDENT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHBMS = maxI
	s ^mdata("DHCPHBASMANSTUDENT") = maxI
}

}
