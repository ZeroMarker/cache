Class User.DHCEQCheck Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CH_RowID, SqlTableName = DHC_EQCheck, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CH_EquipDR
Property CHEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CH_EquipDR ];

/// CH_InstallLocDR
Property CHInstallLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CH_InstallLocDR ];

/// CH_InstallDate
Property CHInstallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = CH_InstallDate ];

/// CH_InstallUser
Property CHInstallUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CH_InstallUser ];

/// CH_StartDate
Property CHStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = CH_StartDate ];

/// CH_EndDate
Property CHEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = CH_EndDate ];

/// CH_CheckContent
Property CHCheckContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CH_CheckContent ];

/// CH_CheckResultDR
Property CHCheckResultDR As User.DHCEQCCheckResult [ SqlColumnNumber = 9, SqlFieldName = CH_CheckResultDR ];

/// CH_CheckResultRemark
Property CHCheckResultRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CH_CheckResultRemark ];

/// CH_CheckTypeDR
Property CHCheckTypeDR As User.DHCEQCCheckType [ SqlColumnNumber = 11, SqlFieldName = CH_CheckTypeDR ];

/// CH_Status
Property CHStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 12, SqlFieldName = CH_Status ];

/// CH_Remark
Property CHRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CH_Remark ];

/// CH_RejectReason
Property CHRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CH_RejectReason ];

/// CH_RejectUserDR
Property CHRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CH_RejectUserDR ];

/// CH_RejectDate
Property CHRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = CH_RejectDate ];

/// CH_RejectTime
Property CHRejectTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = CH_RejectTime ];

/// CH_ApproveSetDR
Property CHApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 18, SqlFieldName = CH_ApproveSetDR ];

/// CH_NextRoleDR
Property CHNextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 19, SqlFieldName = CH_NextRoleDR ];

/// CH_NextFlowStep
Property CHNextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CH_NextFlowStep ];

/// CH_ApproveStatu
Property CHApproveStatu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CH_ApproveStatu ];

/// CH_ApproveRoleDR
Property CHApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 22, SqlFieldName = CH_ApproveRoleDR ];

/// CH_Hold1
Property CHHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CH_Hold1 ];

/// CH_InvalidFlag
Property CHInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = CH_InvalidFlag ];

/// CH_AddUserDR
Property CHAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CH_AddUserDR ];

/// CH_AddDate
Property CHAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = CH_AddDate ];

/// CH_AddTime
Property CHAddTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = CH_AddTime ];

/// CH_UpdateUserDR
Property CHUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = CH_UpdateUserDR ];

/// CH_UpdateDate
Property CHUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = CH_UpdateDate ];

/// CH_UpdateTime
Property CHUpdateTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = CH_UpdateTime ];

/// CH_AuditUserDR
Property CHAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = CH_AuditUserDR ];

/// CH_AuditDate
Property CHAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = CH_AuditDate ];

/// CH_AuditTime
Property CHAuditTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = CH_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheck("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CH_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CH_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CH_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CH_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CH_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CH_ApproveStatu">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CH_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CH_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CH_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CH_CheckContent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CH_CheckResultDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CH_CheckResultRemark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CH_CheckTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CH_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CH_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CH_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CH_InstallDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CH_InstallLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CH_InstallUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CH_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CH_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CH_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CH_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CH_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CH_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CH_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CH_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CH_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CH_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CH_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CH_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CH_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCEQCheck</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CH_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CH_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CH_NextRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CH_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CH_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CH_NextFlowStep}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CH_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CH_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
