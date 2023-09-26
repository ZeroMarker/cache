Class User.DHCRBRegInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RAR_Rowid, SqlTableName = DHCRB_RegInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBRegInfoBodyParts As User.DHCRBRegInfoBodyParts [ Cardinality = children, Inverse = RRBParRef ];

/// RAR_Appointment_DR
Property RARAppointmentDR As User.RBAppointment [ SqlColumnNumber = 2, SqlFieldName = RAR_Appointment_DR ];

/// RAR_StudyNo
Property RARStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RAR_StudyNo ];

/// RAR_No
Property RARNoDR As User.DHCRBNO [ SqlColumnNumber = 4, SqlFieldName = RAR_No_DR ];

/// RAR_Resource_DR
Property RARResourceDR As User.RBResource [ SqlColumnNumber = 5, SqlFieldName = RAR_Resource_DR ];

/// RAR_MainDoctor_DR
Property RARMainDoctorDR As User.CTCareProv [ SqlColumnNumber = 6, SqlFieldName = RAR_MainDoctor_DR ];

/// RAR_AssistantDoctor_DR
Property RARAssistantDoctorDR As User.CTCareProv [ SqlColumnNumber = 7, SqlFieldName = RAR_AssistantDoctor_DR ];

/// RAR_SSUSER_DR
Property RARSSUSERDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = RAR_SSUSER_DR ];

/// RAR_RegDate
Property RARRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = RAR_RegDate ];

/// RAR_RegTime
Property RARRegTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = RAR_RegTime ];

/// RAR_PAADM_DR
Property RARPAADMDR As User.PAAdm [ SqlColumnNumber = 11, SqlFieldName = RAR_PAADM_DR ];

/// RAR_OEORI_DR
Property RAROEORIDR As User.OEOrdItem [ SqlColumnNumber = 12, SqlFieldName = RAR_OEORI_DR ];

/// RAR_ARCIM_DR
Property RARARCIMDR As User.ARCItmMast [ SqlColumnNumber = 13, SqlFieldName = RAR_ARCIM_DR ];

/// RAR_RegLoc_DR
Property RARRegLocDR As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = RAR_RegLoc_DR ];

/// RAR_RegEQ_DR
Property RARRegEQDR As User.RBCEquipment [ SqlColumnNumber = 15, SqlFieldName = RAR_RegEQ_DR ];

/// RAR_RegEQ_Index
Property RARRegEQIndex As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = RAR_RegEQ_Index ];

/// RAR_Room_DR
Property RARRoomDR As User.DHCRBCRoom [ SqlColumnNumber = 18, SqlFieldName = RAR_Room_DR ];

/// RAR_EQGroup_DR
Property RAREQGroupDR As User.RBCEquipmentGroup [ SqlColumnNumber = 19, SqlFieldName = RAR_EQGroup_DR ];

/// RAR_TotalFee
Property RARTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = RAR_TotalFee ];

/// RAR_Memo
Property RARMemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = RAR_Memo ];

/// RAR_ReportInfo
Property RARReportInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = RAR_ReportInfo ];

/// RAR_Note1
Property RARNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = RAR_Note1 ];

/// RAR_Note2
Property RARNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = RAR_Note2 ];

/// RAR_Note3
Property RARNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = RAR_Note3 ];

/// RAR_RoomIndex
Property RARRoomIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = RAR_RoomIndex ];

/// RAR_Note4
Property RARNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = RAR_Note4 ];

/// RAR_Note5
Property RARNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = RAR_Note5 ];

/// RAR_Note6
Property RARNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = RAR_Note6 ];

/// RAR_CheckGroupIndex
Property RARCheckGroupIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = RAR_CheckGroupIndex ];

/// RAR_PregnantWeeks
Property RARPregnantWeeks As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = RAR_PregnantWeeks ];

/// RAR_IndexType_DR
Property RARIndexTypeDR As User.DHCRBCIndexType [ SqlColumnNumber = 32, SqlFieldName = RAR_IndexType_DR ];

/// RAR_CallRoom
Property RARCallRoom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = RAR_CallRoom ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACRegInfo)</SqlIdExpression>
<SQLMap name="DHCRegInfo">
<Data name="RAR_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RAR_Appointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RAR_AssistantDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RAR_CallRoom">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="RAR_CheckGroupIndex">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RAR_EQGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RAR_IndexType_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="RAR_MainDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RAR_Memo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RAR_No_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RAR_Note1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RAR_Note2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RAR_Note3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RAR_Note4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RAR_Note5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RAR_Note6">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RAR_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RAR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RAR_PregnantWeeks">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="RAR_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RAR_RegEQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RAR_RegEQ_Index">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RAR_RegLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RAR_RegTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RAR_ReportInfo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RAR_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RAR_RoomIndex">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RAR_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RAR_SSUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RAR_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RAR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPACRegInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCheckRoom">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Check-Room"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_Room_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_RegDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEQGroup">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EQGRoupDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_RegLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAR_EQGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExecuteLocDR">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocdate">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc-date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_RegDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainDoc">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MainDoctor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_MainDoctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_No_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORID">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_OEORI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegEQ">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegEQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegEQ_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegIndex">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Index"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_RegLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAR_RegEQ_Index}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoom">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Room"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_RegLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Room_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RAR_RegEQ_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUsser">
<Global>^DHCPACRegInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Usser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RAR_SSUSER_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RAR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRegInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
