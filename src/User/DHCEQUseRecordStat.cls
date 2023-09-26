Class User.DHCEQUseRecordStat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URS_RowID, SqlTableName = DHC_EQUseRecordStat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// URS_CheckNum
Property URSCheckNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = URS_CheckNum ];

/// URS_CheckNumPerItem
Property URSCheckNumPerItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = URS_CheckNumPerItem ];

/// URS_CheckPerson
Property URSCheckPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = URS_CheckPerson ];

/// URS_CheckPersonPerItem
Property URSCheckPersonPerItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = URS_CheckPersonPerItem ];

/// URS_ExposureNum
Property URSExposureNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = URS_ExposureNum ];

/// URS_ExposureNumPerItem
Property URSExposureNumPerItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = URS_ExposureNumPerItem ];

/// URS_AdmissionType
Property URSAdmissionType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = URS_AdmissionType ];

/// URS_WaitTImeTotal
Property URSWaitTImeTotal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = URS_WaitTImeTotal ];

/// URS_CheckPart
Property URSCheckPart As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = URS_CheckPart ];

/// URS_DoctorID
Property URSDoctorID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = URS_DoctorID ];

/// URS_RequestDeptDR
Property URSRequestDeptDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = URS_RequestDeptDR ];

/// URS_PositiveFlag
Property URSPositiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = URS_PositiveFlag ];

/// URS_Operator
Property URSOperator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = URS_Operator ];

/// URS_ReportDoctorDR
Property URSReportDoctorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = URS_ReportDoctorDR ];

/// URS_TWorkLoadNum
Property URSTWorkLoadNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = URS_TWorkLoadNum ];

/// URS_InCome
Property URSInCome As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = URS_InCome ];

/// URS_Month
Property URSMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = URS_Month ];

/// URS_Price
Property URSPrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = URS_Price ];

/// URS_Remark
Property URSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = URS_Remark ];

/// URS_ServiceItemDR
Property URSServiceItemDR As User.DHCEQCServiceItem [ SqlColumnNumber = 7, SqlFieldName = URS_ServiceItemDR ];

/// URS_SourceID
Property URSSourceID As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = URS_SourceID ];

/// URS_SourceType
Property URSSourceType As %Library.String(DISPLAYLIST = ",设备,设备项", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 2, SqlFieldName = URS_SourceType ];

/// URS_UseLocDR
Property URSUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = URS_UseLocDR ];

/// URS_WorkLoadNum
Property URSWorkLoadNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = URS_WorkLoadNum ];

/// URS_WorkLoadUnitDR
Property URSWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = URS_WorkLoadUnitDR ];

/// URS_Year
Property URSYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = URS_Year ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseRecordStat("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="URS_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="URS_CheckNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="URS_CheckNumPerItem">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="URS_CheckPart">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="URS_CheckPerson">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="URS_CheckPersonPerItem">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="URS_DoctorID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="URS_ExposureNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="URS_ExposureNumPerItem">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="URS_InCome">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="URS_Month">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URS_Operator">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="URS_PositiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="URS_Price">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="URS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="URS_ReportDoctorDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="URS_RequestDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="URS_ServiceItemDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="URS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URS_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="URS_TWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="URS_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URS_WaitTImeTotal">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="URS_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="URS_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="URS_Year">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQUseRecordStat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>URS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{URS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQUseRecordStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>URS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URS_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URS_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceMonth">
<Global>^DHCEQUseRecordStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>URS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SourceMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URS_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URS_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URS_Year}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{URS_Month}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{URS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceService">
<Global>^DHCEQUseRecordStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>URS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceService"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{URS_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URS_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{URS_Year}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{URS_Month}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{URS_ServiceItemDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{URS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseRecordStatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
