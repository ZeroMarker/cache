Class User.DHCEQAMoveStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AMS_RowID, SqlTableName = DHC_EQAMoveStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AMS_MoveNo
Property AMSMoveNo As %Library.String(COLLATION = "Exact", MAXLEN = 45, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AMS_MoveNo ];

/// AMS_AccessoryTypeDR
Property AMSAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 3, SqlFieldName = AMS_AccessoryTypeDR ];

/// AMS_Type
Property AMSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AMS_Type ];

/// AMS_FromLocDR
Property AMSFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AMS_FromLocDR ];

/// AMS_ToLocDR
Property AMSToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AMS_ToLocDR ];

/// AMS_MakerDR
Property AMSMakerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AMS_MakerDR ];

/// AMS_MakeDate
Property AMSMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = AMS_MakeDate ];

/// AMS_MakeTime
Property AMSMakeTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = AMS_MakeTime ];

/// AMS_ToType
Property AMSToType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AMS_ToType ];

/// AMS_ToSourceID
Property AMSToSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AMS_ToSourceID ];

/// AMS_SubmitUserDR
Property AMSSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AMS_SubmitUserDR ];

/// AMS_SubmitDate
Property AMSSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = AMS_SubmitDate ];

/// AMS_SubmitTime
Property AMSSubmitTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = AMS_SubmitTime ];

/// AMS_MoveType
Property AMSMoveType As %Library.String(DISPLAYLIST = ",出库,库房调配,退库", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 15, SqlFieldName = AMS_MoveType ];

/// AMS_ReciverDR
Property AMSReciverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AMS_ReciverDR ];

/// AMS_AuditUserDR
Property AMSAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AMS_AuditUserDR ];

/// AMS_AuditDate
Property AMSAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AMS_AuditDate ];

/// AMS_AuditTime
Property AMSAuditTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = AMS_AuditTime ];

/// AMS_Hold6
Property AMSHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AMS_Hold6 ];

/// AMS_Hold7
Property AMSHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AMS_Hold7 ];

/// AMS_Hold8
Property AMSHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AMS_Hold8 ];

/// AMS_Hold9
Property AMSHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AMS_Hold9 ];

/// AMS_Hold10
Property AMSHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AMS_Hold10 ];

/// AMS_RejectReason
Property AMSRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AMS_RejectReason ];

/// AMS_RejectUserDR
Property AMSRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AMS_RejectUserDR ];

/// AMS_RejectDate
Property AMSRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = AMS_RejectDate ];

/// AMS_RejectTime
Property AMSRejectTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = AMS_RejectTime ];

/// AMS_Status
Property AMSStatus As %Library.String(DISPLAYLIST = ",新增,提交,记账,报废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 29, SqlFieldName = AMS_Status ];

/// AMS_Remark
Property AMSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = AMS_Remark ];

/// AMS_Hold2
Property AMSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = AMS_Hold1 ];

/// AMS_Hold2
Property AMSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = AMS_Hold2 ];

/// AMS_Hold3
Property AMSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AMS_Hold3 ];

/// AMS_Hold4
Property AMSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = AMS_Hold4 ];

/// AMS_Hold5
Property AMSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AMS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAMoveStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AMS_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AMS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AMS_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AMS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AMS_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AMS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AMS_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AMS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AMS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AMS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AMS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="AMS_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AMS_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AMS_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AMS_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AMS_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AMS_MakeTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AMS_MakerDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AMS_MoveNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AMS_MoveType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AMS_ReciverDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AMS_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AMS_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AMS_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AMS_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AMS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AMS_Status">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AMS_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AMS_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AMS_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AMS_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AMS_ToSourceID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AMS_ToType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AMS_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQAMoveStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AMS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFromLoc">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFromLocSubmitDate">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLocSubmitDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_SubmitDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AMS_MoveType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AMS_Status}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMoveStockNo">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MoveStockNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_MoveNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusMoveType">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusMoveType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_SubmitDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AMS_MoveType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusTypeDate">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_MoveType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AMS_AccessoryTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AMS_AuditDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLoc">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLocSubmitDate">
<Global>^DHCEQAMoveStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLocSubmitDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AMS_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AMS_SubmitDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AMS_MoveType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AMS_Status}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAMoveStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
