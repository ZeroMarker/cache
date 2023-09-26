Class User.DHCRBCResSchduleDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRPD_RowID, SqlTableName = DHCRBC_ResSchduleDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRPD_ResSchdule_ID
Property DRPDResSchduleID As User.DHCRBCResSchdule [ SqlColumnNumber = 2, SqlFieldName = DRPD_ResSchdule_ID ];

/// DRPD_OrderItem_ID
Property DRPDOrderItemID As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DRPD_OrderItem_ID ];

/// DRPD_AppointMethod
Property DRPDAppointMethod As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRPD_AppointMethod ];

/// DRPD_EpsoideID
Property DRPDEpsoideID As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = DRPD_EpsoideID ];

/// DRPD_PrintFlag
Property DRPDPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRPD_PrintFlag ];

/// DRPD_StudyNo
Property DRPDStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRPD_StudyNo ];

/// DRPD_CAFlag
Property DRPDCAFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DRPD_CAFlag ];

/// DRPD_EQ_Index
Property DRPDEQIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRPD_EQ_Index ];

/// DRPD_CheckGroupIndex
Property DRPDCheckGroupIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DRPD_CheckGroupIndex ];

/// DRPD_RoomIndex
Property DRPDRoomIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DRPD_RoomIndex ];

/// DRPD_EQ_DR
Property DRPDEQDR As User.RBCEquipment [ SqlColumnNumber = 12, SqlFieldName = DRPD_EQ_DR ];

/// DRPD_EQGroup_DR
Property DRPDEQGroupDR As User.RBCEquipmentGroup [ SqlColumnNumber = 13, SqlFieldName = DRPD_EQGroup_DR ];

/// DRPD_Room_DR
Property DRPDRoomDR As User.DHCRBCRoom [ SqlColumnNumber = 14, SqlFieldName = DRPD_Room_DR ];

/// DRPD_IndexType_DR
Property DRPDIndexTypeDR As User.DHCRBCIndexType [ SqlColumnNumber = 15, SqlFieldName = DRPD_IndexType_DR ];

/// DRPD_AppointUser_DR
Property DRPDAppointUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = DRPD_AppointUser_DR ];

/// DRPD_Operate_Date
Property DRPDOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DRPD_Operate_Date ];

/// DRPD_Operate_Time
Property DRPDOperateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DRPD_Operate_Time ];

/// DRPD_StartTime
Property DRPDStartTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = DRPD_StartTime ];

/// DRPD_EndTime
Property DRPDEndTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = DRPD_EndTime ];

/// DRPD_EqBooked_Index
Property DRPDEqBookedIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DRPD_EqBooked_Index ];

/// DRPD_QueueNumber
Property DRPDQueueNumber As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DRPD_QueueNumber ];

/// DRPD_OccupyResNumber
Property DRPDOccupyResNumber As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DRPD_OccupyResNumber ];

/// DRPD_BookDate
Property DRPDBookDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = DRPD_BookDate ];

/// DRPD_BookResourceId
Property DRPDBookResourceId As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DRPD_BookResourceId ];

/// DRPD_ExamDoc
Property DRPDExamDoc As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DRPD_ExamDoc ];

/// DRPD_Remark
Property DRPDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DRPD_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCResSchduleDetail("Detail"))</SqlIdExpression>
<SQLMap name="IndexBKStartTime">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BKSTARTTIME"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_ResSchdule_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_StartTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpsodeID">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EpsodeID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_EpsoideID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_OrderItem_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpeDate">
<Global>^DHCRBCResSchduleDetaili</Global>
<Subscript name="1">
<Expression>"OpeDateTime"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_Operate_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_Operate_Time}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrditem">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_OrderItem_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResScduleID">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SchudleId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_ResSchdule_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchudleID">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SchudleId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_ResSchdule_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBCResSchduleDetaili</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRPD_AppointMethod">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRPD_AppointUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRPD_BookDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DRPD_BookResourceId">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DRPD_CAFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRPD_CheckGroupIndex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRPD_EQGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRPD_EQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRPD_EQ_Index">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRPD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DRPD_EpsoideID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRPD_EqBooked_Index">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DRPD_ExamDoc">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DRPD_IndexType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRPD_OccupyResNumber">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DRPD_Operate_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRPD_Operate_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRPD_OrderItem_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRPD_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRPD_QueueNumber">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DRPD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DRPD_ResSchdule_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRPD_RoomIndex">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRPD_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRPD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DRPD_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCRBCResSchduleDetail</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRPD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCResSchduleDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
