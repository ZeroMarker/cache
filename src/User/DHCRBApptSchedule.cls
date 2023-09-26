Class User.DHCRBApptSchedule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = AS_Rowid, SqlTableName = DHC_RBApptSchedule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (ASRESParRef, ASChildsub) [ IdKey, PrimaryKey, Unique ];

Property ASASDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AS_AS_DR ];

/// AS_AppLoad
Property ASAppLoad As %Float(MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 16, SqlFieldName = AS_AppLoad ];

/// AS_Childsub
Property ASChildsub As %Library.Float(MINVAL = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = AS_Childsub ];

/// AS_ClinicGroup_DR
Property ASClinicGroupDR As User.RBCClinicGroup [ SqlColumnNumber = 8, SqlFieldName = AS_ClinicGroup_DR ];

/// AS_Date
Property ASDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AS_Date ];

/// AS_DateCreate
Property ASDateCreate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AS_DateCreate ];

/// AS_LockFlag
Property ASLockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AS_LockFlag ];

/// AS_NoOverbookAllow
Property ASNoOverbookAllowed As %Float(MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = AS_NoOverbookAllow ];

/// AS_QueueNo
Property ASQueueNo As %Library.String(COLLATION = "Exact", MAXLEN = 30000000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AS_QueueNo ];

/// AS_RES_ParRef
Property ASRESParRef As User.RBResource [ SqlColumnNumber = 2, SqlFieldName = AS_RES_ParRef ];

/// AS_ReasonNotAvail_DR
Property ASReasonNotAvailDR As User.RBCReasonNotAvail [ SqlColumnNumber = 12, SqlFieldName = AS_ReasonNotAvail_DR ];

/// AS_Room_DR
Property ASRoomDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = AS_Room_DR ];

/// AS_SessionType_DR
Property ASSessionTypeDR As User.RBCSessionType [ SqlColumnNumber = 7, SqlFieldName = AS_SessionType_DR ];

///  AS_Status_DR
Property ASStatusDR As User.DHCRBCASStatus [ Required, SqlColumnNumber = 11, SqlFieldName = AS_Status_DR ];

/// AS_TimeCreate
Property ASTimeCreate As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AS_TimeCreate ];

/// AS_TimeRange_DR
Property ASTimeRangeDR As User.DHCTimeRange [ SqlColumnNumber = 18, SqlFieldName = AS_TimeRange_DR ];

/// AS_UserAuthorise_DR
Property ASUserAuthoriseDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = AS_UserAuthorise_DR ];

/// AS_AppQueueNo
Property ASAppQueueNo As %Library.String(COLLATION = "Exact", MAXLEN = 30000000, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AS_AppQueueNo ];

/// ASTimeRangeFlag
Property ASTimeRangeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = AS_TimeRangeFlag ];

/// ASTRStartTime
Property ASTRStartTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = AS_TRStartTime ];

/// ASTREndTime
Property ASTREndTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = AS_TREndTime ];

/// ASTRLength
Property ASTRLength As %Integer [ SqlColumnNumber = 23, SqlFieldName = AS_TRLength ];

/// ASTRRegNum
Property ASTRRegNum As %Integer [ SqlColumnNumber = 24, SqlFieldName = AS_TRRegNum ];

/// ASTRRegNumStr
Property ASTRRegNumStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000000, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AS_TRRegNumStr ];

/// ASTRRegInfoStr
Property ASTRRegInfoStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AS_TRRegInfoStr ];

/// ASAddRegNum
Property ASAddRegNum As %Integer [ SqlColumnNumber = 27, SqlFieldName = AS_AddRegNum ];

/// ASStopRegNoFlag
Property ASStopRegNoFlag As %Library.String [ SqlColumnNumber = 28, SqlFieldName = AS_StopRegNoFlag ];

/// ASAuditFlag 待审核标记，Y：待审核 N/空：已审核或无需审核
Property ASAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = AS_AuditFlag ];

/// AS_ClinicGroup_DRStr 专业组多选保存串
Property ASClinicGroupDRStr As %Library.String [ SqlColumnNumber = 30, SqlFieldName = AS_ClinicGroupDR_Str ];

/// ASAuditFlag 停止挂号标记，Y：停止 N/空：没有停止
Property ASStopRegFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = AS_StopRegFlag ];

/// ASNoLimitLoadFlag 无限号源标识
Property ASNoLimitLoadFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = AS_NoLimitLoadFlag ];

Relationship ChildDHCRBApptScheduleAppQty As User.DHCRBApptScheduleAppQty [ Cardinality = children, Inverse = ASQASParRef ];

Relationship ChildDHCRBApptScheduleExtendConfig As User.DHCRBApptScheduleExtendConfig [ Cardinality = children, Inverse = ASQECASParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AS_AS_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="AS_AddRegNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="AS_AppLoad">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="AS_AppQueueNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="AS_AuditFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="AS_Childsub">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="AS_ClinicGroupDR_Str">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="AS_ClinicGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="AS_Date">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="AS_DateCreate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="AS_LockFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="AS_NoLimitLoadFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="AS_NoOverbookAllow">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="AS_QueueNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="AS_RES_ParRef">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="AS_ReasonNotAvail_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="AS_Room_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="AS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="AS_Status_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="AS_StopRegFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="AS_StopRegNoFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="AS_TREndTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="AS_TRLength">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="AS_TRRegInfoStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="AS_TRRegNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="AS_TRRegNumStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="AS_TRStartTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="AS_TimeCreate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="AS_TimeRangeFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="AS_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="AS_UserAuthorise_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AS_RES_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>AS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AS_RES_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateRoom">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AS_RES_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateRoom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_Room_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_RES_ParRef}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTR">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AS_RES_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AS_RES_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_TimeRange_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBApptScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
