Class User.DHCEQMove Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = M_RowID, SqlTableName = DHC_EQMove, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// M_No
Property MNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = M_No ];

/// M_ObjType
Property MObjType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = M_ObjType ];

/// M_ObjID
Property MObjID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = M_ObjID ];

/// M_SourceType
Property MSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = M_SourceType ];

/// M_SourceID
Property MSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = M_SourceID ];

/// M_EventType
Property MEventType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = M_EventType ];

/// M_MoveReason
Property MMoveReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = M_MoveReason ];

/// M_FromDeptType
Property MFromDeptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = M_FromDeptType ];

/// M_FromDeptID
Property MFromDeptID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = M_FromDeptID ];

/// M_FromLocationDR
Property MFromLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 11, SqlFieldName = M_FromLocationDR ];

/// M_StartDate
Property MStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = M_StartDate ];

/// M_StartTime
Property MStartTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = M_StartTime ];

/// M_ToLocationDR
Property MToLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 14, SqlFieldName = M_ToLocationDR ];

/// M_ToDeptType
Property MToDeptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = M_ToDeptType ];

/// M_ToDeptID
Property MToDeptID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = M_ToDeptID ];

/// M_EndDate
Property MEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = M_EndDate ];

/// M_EndTime
Property MEndTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = M_EndTime ];

/// M_SendUserDR
Property MSendUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = M_SendUserDR ];

/// M_AcceptUserDR
Property MAcceptUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = M_AcceptUserDR ];

/// M_CreateUserDR
Property MCreateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = M_CreateUserDR ];

/// M_CreateDate
Property MCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = M_CreateDate ];

/// M_CreateTime
Property MCreateTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = M_CreateTime ];

/// M_SubmitUserDR
Property MSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = M_SubmitUserDR ];

/// M_SubmitDate
Property MSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = M_SubmitDate ];

/// M_SubmitTime
Property MSubmitTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = M_SubmitTime ];

/// M_AuditUserDR
Property MAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = M_AuditUserDR ];

/// M_AuditDate
Property MAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = M_AuditDate ];

/// M_AuditTime
Property MAuditTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = M_AuditTime ];

/// M_Remark
Property MRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = M_Remark ];

/// M_Status
Property MStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 31, SqlFieldName = M_Status ];

/// M_InvalidFlag
Property MInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = M_InvalidFlag ];

/// M_InvalidReason
Property MInvalidReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = M_InvalidReason ];

/// M_InvalidUserDR
Property MInvalidUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = M_InvalidUserDR ];

/// M_InvalidDate
Property MInvalidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = M_InvalidDate ];

/// M_InvalidTime
Property MInvalidTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = M_InvalidTime ];

/// M_Hold1
Property MHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = M_Hold1 ];

/// M_Hold2
Property MHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = M_Hold2 ];

/// M_Hold3
Property MHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = M_Hold3 ];

/// M_Hold4
Property MHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = M_Hold4 ];

/// M_Hold5
Property MHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = M_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMove("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="M_AcceptUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="M_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="M_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="M_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="M_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="M_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="M_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="M_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="M_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="M_EventType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="M_FromDeptID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="M_FromDeptType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="M_FromLocationDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="M_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="M_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="M_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="M_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="M_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="M_InvalidDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="M_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="M_InvalidReason">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="M_InvalidTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="M_InvalidUserDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="M_MoveReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="M_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="M_ObjID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="M_ObjType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="M_Remark">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="M_SendUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="M_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="M_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="M_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="M_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="M_Status">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="M_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="M_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="M_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="M_ToDeptID">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="M_ToDeptType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="M_ToLocationDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQMove</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{M_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexSourceID">
<Global>^DHCEQMove</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{M_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{M_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{M_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMoveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
