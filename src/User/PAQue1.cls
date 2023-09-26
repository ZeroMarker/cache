/// PA Que1(QUE1,1385)
Class User.PAQue1 Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Que1, StorageStrategy = SQLStorage ]
{

Relationship ChildPAPS As PAQue1PrtSerial [ Cardinality = children, Inverse = PAPSPAParRef ];

/// Des Ref PAADM
Property QUE1PAADMDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = QUE1_PAADM_DR ];

/// Des Ref CTLOC
Property QUE1DepartmentLocDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = QUE1_DepartmentLoc_DR ];

/// Queue 1 No
Property QUE1No As %Float [ SqlColumnNumber = 4, SqlFieldName = QUE1_No ];

/// Pharmacy Status
Property QUE1PharmStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = QUE1_PharmStatus ];

/// Prescription No
Property QUE1PrescNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = QUE1_PrescNo ];

/// Date Accepted
Property QUE1DateAccepted As %Date [ SqlColumnNumber = 7, SqlFieldName = QUE1_DateAccepted ];

/// Time Accepted
Property QUE1TimeAccepted As %Time [ SqlColumnNumber = 8, SqlFieldName = QUE1_TimeAccepted ];

/// Date Packed
Property QUE1DatePacked As %Date [ SqlColumnNumber = 9, SqlFieldName = QUE1_DatePacked ];

/// Time Packed
Property QUE1TimePacked As %Time [ SqlColumnNumber = 10, SqlFieldName = QUE1_TimePacked ];

/// Date Collected
Property QUE1DateCollected As %Date [ SqlColumnNumber = 11, SqlFieldName = QUE1_DateCollected ];

/// Time Collected
Property QUE1TimeCollected As %Time [ SqlColumnNumber = 12, SqlFieldName = QUE1_TimeCollected ];

/// Transaction Date
Property QUE1TransDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = QUE1_TransDate ];

/// Transaction Time
Property QUE1TransTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = QUE1_TransTime ];

/// Des Ref CTCP
Property QUE1CareProviderDR As CTCareProv [ SqlColumnNumber = 16, SqlFieldName = QUE1_CareProviderDR ];

/// Des Ref User
Property QUE1UserAcceptedDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = QUE1_UserAccepted_DR ];

/// Des Ref OrderDep
Property QUE1OrderDepDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = QUE1_OrderDep_DR ];

/// Priority
Property QUE1Priority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = QUE1_Priority ];

/// UserAccepted
Property QUE1UserAccepted As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = QUE1_UserAccepted ];

/// Des Ref LastUpdateUser
Property QUE1LastUpdateUserDR As SSUser [ SqlColumnNumber = 21, SqlFieldName = QUE1_LastUpdateUser_DR ];

/// LastUpdateDate
Property QUE1LastUpdateDate As %Date [ SqlColumnNumber = 22, SqlFieldName = QUE1_LastUpdateDate ];

/// LastUpdateTime
Property QUE1LastUpdateTime As %Time [ SqlColumnNumber = 23, SqlFieldName = QUE1_LastUpdateTime ];

/// StartDate
Property QUE1StartDate As %Date [ SqlColumnNumber = 24, SqlFieldName = QUE1_StartDate ];

/// EndDate
Property QUE1EndDate As %Date [ SqlColumnNumber = 25, SqlFieldName = QUE1_EndDate ];

/// DateUnCollect
Property QUE1DateUnCollect As %Date [ SqlColumnNumber = 26, SqlFieldName = QUE1_DateUnCollect ];

/// TimeUnCollect
Property QUE1TimeUnCollect As %Time [ SqlColumnNumber = 27, SqlFieldName = QUE1_TimeUnCollect ];

/// 代办人证件类型
Property QUE1AgencyCredTypeDR As PACCardType [ SqlColumnNumber = 28, SqlFieldName = QUE1_AgencyCredType_DR ];

/// 代办人证件号码
Property QUE1AgencyCredNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = QUE1_AgencyCredNo ];

/// 代办人姓名
Property QUE1AgencyName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = QUE1_AgencyName ];

/// 代办人电话
Property QUE1AgencyTel As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = QUE1_AgencyTel ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAQue1).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAQue1).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAQue1).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAQue1).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAQue1).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAQue1","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>660</ExtentSize>
<Property name="QUE1CareProviderDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="QUE1DateAccepted">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1DateCollected">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1DatePacked">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="QUE1DateUnCollect">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1DepartmentLocDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="QUE1EndDate">
<Selectivity>0.4425%</Selectivity>
</Property>
<Property name="QUE1LastUpdateDate">
<Selectivity>2.3256%</Selectivity>
</Property>
<Property name="QUE1LastUpdateTime">
<Selectivity>0.5435%</Selectivity>
</Property>
<Property name="QUE1LastUpdateUserDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="QUE1No">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1OrderDepDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1PAADMDR">
<Selectivity>0.7042%</Selectivity>
</Property>
<Property name="QUE1PharmStatus">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="QUE1PrescNo">
<Selectivity>0.1515%</Selectivity>
</Property>
<Property name="QUE1Priority">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1StartDate">
<Selectivity>0.5319%</Selectivity>
</Property>
<Property name="QUE1TimeAccepted">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1TimeCollected">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1TimePacked">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="QUE1TimeUnCollect">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1TransDate">
<Selectivity>0.5435%</Selectivity>
</Property>
<Property name="QUE1TransTime">
<Selectivity>0.1664%</Selectivity>
</Property>
<Property name="QUE1UserAccepted">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUE1UserAcceptedDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAQUE1(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QUE1_AgencyCredNo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="QUE1_AgencyCredType_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="QUE1_AgencyName">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="QUE1_AgencyTel">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="QUE1_CareProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QUE1_DateAccepted">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="QUE1_DateCollected">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="QUE1_DatePacked">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="QUE1_DateUnCollect">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="QUE1_DepartmentLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUE1_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="QUE1_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="QUE1_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="QUE1_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="QUE1_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QUE1_OrderDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="QUE1_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUE1_PharmStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QUE1_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="QUE1_Priority">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="QUE1_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="QUE1_TimeAccepted">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="QUE1_TimeCollected">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="QUE1_TimePacked">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="QUE1_TimeUnCollect">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="QUE1_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QUE1_TransTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QUE1_UserAccepted">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="QUE1_UserAccepted_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^PAQUE1</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{QUE1_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateAccepted">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepDateAccept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_DepartmentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_DateAccepted}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepDateCollected">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepDateCollect"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_DepartmentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_DateCollected}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepPhStatDatePresc">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepPhStatDatePresc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_DepartmentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_PharmStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUE1_TransDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QUE1_PrescNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepPharmStPresc">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepPharmStPresc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_DepartmentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_PharmStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUE1_PrescNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUE1_PAADM_DR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartEndDate">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>QUE1_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepPharmStStDtFnDtPresc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE1_DepartmentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUE1_PharmStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUE1_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QUE1_EndDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QUE1_PrescNo}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{QUE1_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QUE1_RowID</SqlRowIdName>
<StreamLocation>^User.PAQue1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
