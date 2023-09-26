Class User.DHCEQBuildingChange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BC_RowID, SqlTableName = DHC_EQBuildingChange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BC_EquipDR
Property BCEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = BC_EquipDR ];

/// BC_ChangeType
Property BCChangeType As %Library.String(DISPLAYLIST = ",改建,扩建", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = BC_ChangeType ];

/// BC_ChangeDate
Property BCChangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = BC_ChangeDate ];

/// BC_ProjectItem
Property BCProjectItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BC_ProjectItem ];

/// BC_StartDate
Property BCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = BC_StartDate ];

/// BC_FinishedDate
Property BCFinishedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = BC_FinishedDate ];

/// BC_Company
Property BCCompany As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BC_Company ];

/// BC_ProjectFee
Property BCProjectFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BC_ProjectFee ];

/// BC_CheckDate
Property BCCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = BC_CheckDate ];

/// BC_CheckUser
Property BCCheckUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BC_CheckUser ];

/// BC_FromStructDR
Property BCFromStructDR As User.DHCEQCBuildingStruct [ SqlColumnNumber = 12, SqlFieldName = BC_FromStructDR ];

/// BC_ToStructDR
Property BCToStructDR As User.DHCEQCBuildingStruct [ SqlColumnNumber = 13, SqlFieldName = BC_ToStructDR ];

/// BC_FromBuildingArea
Property BCFromBuildingArea As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = BC_FromBuildingArea ];

/// BC_ToBuildingArea
Property BCToBuildingArea As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = BC_ToBuildingArea ];

/// BC_FromUtilizationArea
Property BCFromUtilizationArea As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = BC_FromUtilizationArea ];

/// BC_ToUtilizationArea
Property BCToUtilizationArea As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = BC_ToUtilizationArea ];

/// BC_FromSubArea
Property BCFromSubArea As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = BC_FromSubArea ];

/// BC_ToSubArea
Property BCToSubArea As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = BC_ToSubArea ];

/// BC_FromFloorNum
Property BCFromFloorNum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = BC_FromFloorNum ];

/// BC_ToFloorNum
Property BCToFloorNum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = BC_ToFloorNum ];

/// BC_FromUnderFloorNum
Property BCFromUnderFloorNum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = BC_FromUnderFloorNum ];

/// BC_ToUnderFloorNum
Property BCToUnderFloorNum As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = BC_ToUnderFloorNum ];

/// BC_FromLandArea
Property BCFromLandArea As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = BC_FromLandArea ];

/// BC_ToLandArea
Property BCToLandArea As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = BC_ToLandArea ];

/// BC_Hold1
Property BCHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BC_Hold1 ];

/// BC_Hold2
Property BCHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BC_Hold2 ];

/// BC_Hold3
Property BCHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BC_Hold3 ];

/// BC_Hold4
Property BCHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BC_Hold4 ];

/// BC_Hold5
Property BCHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BC_Hold5 ];

/// BC_Status
Property BCStatus As %Library.String(DISPLAYLIST = ",新建,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 31, SqlFieldName = BC_Status ];

/// BC_CreateUserDR
Property BCCreateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = BC_CreateUserDR ];

/// BC_CreateDate
Property BCCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = BC_CreateDate ];

/// BC_CreateTime
Property BCCreateTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = BC_CreateTime ];

/// BC_SubmitUserDR
Property BCSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = BC_SubmitUserDR ];

/// BC_SubmitDate
Property BCSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = BC_SubmitDate ];

/// BC_SubmitTime
Property BCSubmitTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = BC_SubmitTime ];

/// BC_AuditUserDR
Property BCAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = BC_AuditUserDR ];

/// BC_AuditDate
Property BCAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = BC_AuditDate ];

/// BC_AuditTime
Property BCAuditTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = BC_AuditTime ];

/// BC_DropUserDR
Property BCDropUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = BC_DropUserDR ];

/// BC_DropDate
Property BCDropDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = BC_DropDate ];

/// BC_DropTime
Property BCDropTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = BC_DropTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuildingChange("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BC_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BC_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BC_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BC_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BC_ChangeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BC_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BC_CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BC_Company">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BC_CreateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BC_DropDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BC_DropTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BC_DropUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BC_FinishedDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BC_FromBuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BC_FromFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BC_FromLandArea">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BC_FromStructDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BC_FromSubArea">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BC_FromUnderFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BC_FromUtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BC_ProjectFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BC_ProjectItem">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BC_Status">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BC_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BC_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BC_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BC_ToBuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BC_ToFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BC_ToLandArea">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BC_ToStructDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BC_ToSubArea">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BC_ToUnderFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BC_ToUtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQBuildingChange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQBuildingChange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BC_ChangeType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BC_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuildingChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
