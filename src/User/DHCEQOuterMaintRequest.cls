Class User.DHCEQOuterMaintRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OMR_RowID, SqlTableName = DHC_EQOuterMaintRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index OMRRequestNoUnqIdx1 On OMRRequestNo [ Unique ];

/// OMR_ApproveRoleDR
Property OMRApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 20, SqlFieldName = OMR_ApproveRoleDR ];

/// OMR_ApproveSetDR
Property OMRApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 16, SqlFieldName = OMR_ApproveSetDR ];

/// OMR_ApproveStatu
Property OMRApproveStatu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OMR_ApproveStatu ];

/// OMR_AuditDate
Property OMRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = OMR_AuditDate ];

/// OMR_AuditTime
Property OMRAuditTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = OMR_AuditTime ];

/// OMR_AuditUserDR
Property OMRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OMR_AuditUserDR ];

/// OMR_Condition
Property OMRCondition As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = OMR_Condition ];

/// OMR_EquipDR
Property OMREquipDR As User.DHCEQEquip [ SqlColumnNumber = 5, SqlFieldName = OMR_EquipDR ];

/// OMR_EquipTypeDR
Property OMREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 21, SqlFieldName = OMR_EquipTypeDR ];

/// OMR_Hold1
Property OMRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OMR_Hold1 ];

/// OMR_Hold2
Property OMRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OMR_Hold2 ];

/// OMR_Hold3
Property OMRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = OMR_Hold3 ];

/// OMR_Hold4
Property OMRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = OMR_Hold4 ];

/// OMR_Hold5
Property OMRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = OMR_Hold5 ];

/// OMR_MaintFee
Property OMRMaintFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = OMR_MaintFee ];

/// OMR_NextFlowStep
Property OMRNextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = OMR_NextFlowStep ];

/// OMR_NextRoleDR
Property OMRNextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 17, SqlFieldName = OMR_NextRoleDR ];

/// OMR_RejectDate
Property OMRRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = OMR_RejectDate ];

/// OMR_RejectReason
Property OMRRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = OMR_RejectReason ];

/// OMR_RejectTime
Property OMRRejectTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = OMR_RejectTime ];

/// OMR_RejectUserDR
Property OMRRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OMR_RejectUserDR ];

/// OMR_Remark
Property OMRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = OMR_Remark ];

/// OMR_RequestDate
Property OMRRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = OMR_RequestDate ];

/// OMR_RequestNo
Property OMRRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OMR_RequestNo ];

/// OMR_RequestReason
Property OMRRequestReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OMR_RequestReason ];

/// OMR_SourceID
Property OMRSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OMR_SourceID ];

/// OMR_SourceType
Property OMRSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OMR_SourceType ];

/// OMR_Status
Property OMRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 15, SqlFieldName = OMR_Status ];

/// OMR_SubmitDate
Property OMRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = OMR_SubmitDate ];

/// OMR_SubmitTime
Property OMRSubmitTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = OMR_SubmitTime ];

/// OMR_SubmitUserDR
Property OMRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OMR_SubmitUserDR ];

/// OMR_UseLocDR
Property OMRUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OMR_UseLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOuterMaintRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OMR_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OMR_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OMR_ApproveStatu">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OMR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OMR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OMR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OMR_Condition">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OMR_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OMR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OMR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OMR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OMR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OMR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OMR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OMR_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OMR_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OMR_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OMR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OMR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OMR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OMR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OMR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OMR_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OMR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OMR_RequestReason">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OMR_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OMR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OMR_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OMR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OMR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OMR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OMR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQOuterMaintRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_NextRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_NextFlowStep}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RequestNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQOuterMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OMR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOuterMaintRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
