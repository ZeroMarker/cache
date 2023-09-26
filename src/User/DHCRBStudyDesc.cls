Class User.DHCRBStudyDesc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRSD_RowID, SqlTableName = DHCRB_StudyDesc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRSD_StudyNo
Property DRSDStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRSD_StudyNo ];

/// DRSD_HocusWay
Property DRSDHocusWay As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRSD_HocusWay ];

/// DRSD_SpileWay
Property DRSDSpileWay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRSD_SpileWay ];

/// DRSD_ExpoureNum
Property DRSDExpoureNum As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRSD_ExpoureNum ];

/// DRSD_FilmNum
Property DRSDFilmNum As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRSD_FilmNum ];

/// DRSD_FilmSpec
Property DRSDFilmSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRSD_FilmSpec ];

/// DRSD_CheckWay
Property DRSDCheckWay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DRSD_CheckWay ];

/// DRSD_Equiment_DR
Property DRSDEquimentDR As User.RBCEquipment [ SqlColumnNumber = 9, SqlFieldName = DRSD_Equiment_DR ];

/// DRSD_Note
Property DRSDNote As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DRSD_Note ];

/// DRSD_SendUnit
Property DRSDSendUnit As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DRSD_SendUnit ];

/// DRSD_SendDate
Property DRSDSendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DRSD_SendDate ];

/// DRSD_SendDoc
Property DRSDSendDoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DRSD_SendDoc ];

/// DRSD_FilmSent
Property DRSDFilmSent As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DRSD_FilmSent ];

/// DRSD_ReportPrint
Property DRSDReportPrint As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DRSD_ReportPrint ];

/// DRSD_Memo
Property DRSDMemo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DRSD_Memo ];

/// DRSD_Memo1
Property DRSDMemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DRSD_Memo1 ];

/// DRSD_Memo2
Property DRSDMemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DRSD_Memo2 ];

/// DRSD_Images
Property DRSDImageNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DRSD_ImageNum ];

/// DRSD_SendFilmDate
Property DRSDSendFilmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DRSD_SendFilmDate ];

/// DRSD_SendFilmTime
Property DRSDSendFilmTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DRSD_SendFilmTime ];

/// DRSD_SendFilmDocID
Property DRSDSendFilmDocID As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = DRSD_SendFilmDocID ];

/// DRSD_StudyDate
Property DRSDStudyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = DRSD_StudyDate ];

/// DRSD_StudyTime
Property DRSDStudyTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = DRSD_StudyTime ];

/// DRSD_StudyStartDate
Property DRSDStudyStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = DRSD_StudyStartDate ];

/// DRSD_StudyStartTime
Property DRSDStudyStartTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = DRSD_StudyStartTime ];

/// DRSD_StudyEndDate
Property DRSDStudyEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = DRSD_StudyEndDate ];

/// DRSD_StudyEndTime
Property DRSDStudyEndTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = DRSD_StudyEndTime ];

/// DRSD_NurseID
Property DRSDNurseID As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = DRSD_NurseID ];

/// DRSD_PatientStatusID
Property DRSDPatientStatusID As User.DHCRBCPatientStatus [ SqlColumnNumber = 30, SqlFieldName = DRSD_PatientStatusID ];

/// DRSD_MainDoctorCode
Property DRSDMainDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DRSD_MainDoctorCode ];

/// DRSD_AssistantDoctorCode
Property DRSDAssistantDoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DRSD_AssistantDoctorCode ];

/// DRSD_MainDoctor
Property DRSDMainDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DRSD_MainDoctor ];

/// DRSD_AssistantDoctor
Property DRSDAssistantDoctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DRSD_AssistantDoctor ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBStudy("StudyDesc"))</SqlIdExpression>
<SQLMap name="IndexMainDoctor">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MainDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSD_MainDoctor}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyEndDate">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyEndDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRSD_StudyEndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRSD_StudyNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterdata">
<Data name="DRSD_AssistantDoctor">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DRSD_AssistantDoctorCode">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DRSD_CheckWay">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRSD_Equiment_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRSD_ExpoureNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRSD_FilmNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRSD_FilmSent">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRSD_FilmSpec">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRSD_HocusWay">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRSD_ImageNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DRSD_MainDoctor">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DRSD_MainDoctorCode">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DRSD_Memo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRSD_Memo1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRSD_Memo2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRSD_Note">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRSD_NurseID">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DRSD_PatientStatusID">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DRSD_ReportPrint">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRSD_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRSD_SendDoc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRSD_SendFilmDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DRSD_SendFilmDocID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DRSD_SendFilmTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DRSD_SendUnit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRSD_SpileWay">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRSD_StudyDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DRSD_StudyEndDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DRSD_StudyEndTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DRSD_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRSD_StudyStartDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DRSD_StudyStartTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DRSD_StudyTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCRBStudy</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRSD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBStudyDescS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
