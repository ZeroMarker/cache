Class User.DHCRBCLINICCHECKRPTINFO Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCRI_RowID, SqlTableName = DHCRB_CLINICCHECKRPTINFO, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCRI_StudyType
Property DCRIStudyType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCRI_StudyType ];

/// DCRI_StudyNo
Property DCRIStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCRI_StudyNo ];

/// DCRI_PatientID
Property DCRIPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DCRI_PatientID ];

/// DCRI_PatientName
Property DCRIPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 64, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DCRI_PatientName ];

/// DCRI_Sex
Property DCRISex As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DCRI_Sex ];

/// DCRI_BirthDay
Property DCRIBirthDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DCRI_BirthDay ];

/// DCRI_AttendingDocCode
Property DCRIAttendingDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DCRI_AttendingDocCode ];

/// DCRI_AtDocChecked
Property DCRIAtDocChecked As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DCRI_AtDocChecked ];

/// DCRI_AtDocCheckedDate
Property DCRIAtDocCheckedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DCRI_AtDocCheckedDate ];

/// DCRI_AtDocCheckedTime
Property DCRIAtDocCheckedTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DCRI_AtDocCheckedTime ];

/// DCRI_AppDocCode
Property DCRIAppDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DCRI_AppDocCode ];

/// DCRI_AppDocChecked
Property DCRIAppDocChecked As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DCRI_AppDocChecked ];

/// DCRI_AppDocCheckedDate
Property DCRIAppDocCheckedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DCRI_AppDocCheckedDate ];

/// DCRI_AppDocCheckedTime
Property DCRIAppDocCheckedTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DCRI_AppDocCheckedTime ];

/// DCRI_StudyItem
Property DCRIStudyItem As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DCRI_StudyItem ];

/// DCRI_AppDate
Property DCRIAppDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DCRI_AppDate ];

/// DCRI_AppTime
Property DCRIAppTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DCRI_AppTime ];

/// DCRI_ReportDate
Property DCRIReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = DCRI_ReportDate ];

/// DCRI_ReportTime
Property DCRIReportTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = DCRI_ReportTime ];

/// DCRI_ReportDocCode
Property DCRIReportDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DCRI_ReportDocCode ];

/// DCRI_ReportUrl
Property DCRIReportUrl As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DCRI_ReportUrl ];

/// DCRI_OrdRowid
Property DCRIOrdRowid As User.OEOrdItem [ SqlColumnNumber = 23, SqlFieldName = DCRI_OrdRowid ];

/// DCRI_AtIsRptModify
Property DCRIAtIsRptModify As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DCRI_AtIsRptModify ];

/// DCRI_ApIsRptModify
Property DCRIApIsRptModify As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DCRI_ApIsRptModify ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLINICCHECKRPTINFO)</SqlIdExpression>
<SQLMap name="IndexAPPCODE">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APP-CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_AppDocCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAPPDOC">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APPDOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_StudyType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_AppDocCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexATTENDING">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ATTENDING"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_StudyType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_AttendingDocCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexATTENDINGCODE">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ATTENDING-CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_AttendingDocCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEItemStudyNo">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DCRI_OrdRowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegNO">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PATIENTID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_StudyType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_PatientID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBCLINICCHECKRPTINFOi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STUDYNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRI_StudyType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRI_StudyNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DCRI_ApIsRptModify">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DCRI_AppDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCRI_AppDocChecked">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCRI_AppDocCheckedDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCRI_AppDocCheckedTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCRI_AppDocCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCRI_AppTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DCRI_AtDocChecked">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCRI_AtDocCheckedDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCRI_AtDocCheckedTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCRI_AtIsRptModify">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DCRI_AttendingDocCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCRI_BirthDay">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCRI_OrdRowid">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DCRI_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCRI_PatientName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCRI_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DCRI_ReportDocCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DCRI_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DCRI_ReportUrl">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DCRI_Sex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCRI_StudyItem">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCRI_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCRI_StudyType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCLINICCHECKRPTINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DCRI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLINICCHECKRPTINFOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
