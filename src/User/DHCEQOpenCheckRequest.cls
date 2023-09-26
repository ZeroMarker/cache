Class User.DHCEQOpenCheckRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OCR_RowID, SqlTableName = DHC_EQOpenCheckRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index OCRHold1UnqIdx1 On OCRHold1 [ Unique ];

/// OCR_AffixState
Property OCRAffixState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OCR_AffixState ];

/// OCR_ApproveRoleDR
Property OCRApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 37, SqlFieldName = OCR_ApproveRoleDR ];

/// OCR_ApproveSetDR
Property OCRApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 33, SqlFieldName = OCR_ApproveSetDR ];

/// OCR_ApproveStatu
Property OCRApproveStatu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = OCR_ApproveStatu ];

/// OCR_AuditDate
Property OCRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = OCR_AuditDate ];

/// OCR_AuditTime
Property OCRAuditTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = OCR_AuditTime ];

/// OCR_AuditUserDR
Property OCRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OCR_AuditUserDR ];

/// OCR_CancelDate
Property OCRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = OCR_CancelDate ];

/// OCR_CancelTime
Property OCRCancelTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = OCR_CancelTime ];

/// OCR_CancelUser
Property OCRCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = OCR_CancelUser ];

/// OCR_CheckDate
Property OCRCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = OCR_CheckDate ];

/// OCR_CheckResult
Property OCRCheckResult As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OCR_CheckResult ];

/// OCR_CheckType
Property OCRCheckType As %Library.String(DISPLAYLIST = ",新设备验收,维修验收,改造验收", MAXLEN = 5, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 2, SqlFieldName = OCR_CheckType ];

/// OCR_CheckUser
Property OCRCheckUser As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = OCR_CheckUser ];

/// OCR_ConfigState
Property OCRConfigState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = OCR_ConfigState ];

/// OCR_EquipTypeDR
Property OCREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 3, SqlFieldName = OCR_EquipTypeDR ];

/// OCR_FileState
Property OCRFileState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = OCR_FileState ];

/// OCR_FromDeptDR
Property OCRFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 10, SqlFieldName = OCR_FromDeptDR ];

/// OCR_Hold1
Property OCRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = OCR_Hold1 ];

/// OCR_Hold2
Property OCRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = OCR_Hold2 ];

/// OCR_UpdateUserDR 制单人
Property OCRUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = OCR_UpdateUserDR ];

/// OCR_UpdateDate 制单日期
Property OCRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 41, SqlFieldName = OCR_UpdateDate ];

/// OCR_UpdateTime 制单时间
Property OCRUpdateTime As %Library.Time [ SqlColumnNumber = 42, SqlFieldName = OCR_UpdateTime ];

/// OCR_InvalidFlag
Property OCRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = OCR_InvalidFlag ];

/// OCR_NextFlowStep
Property OCRNextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = OCR_NextFlowStep ];

/// OCR_NextRoleDR
Property OCRNextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 34, SqlFieldName = OCR_NextRoleDR ];

/// OCR_OpenCheckDate
Property OCROpenCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = OCR_OpenCheckDate ];

/// OCR_OpenState
Property OCROpenState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = OCR_OpenState ];

/// OCR_OriginDR
Property OCROriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 9, SqlFieldName = OCR_OriginDR ];

/// OCR_PackageState
Property OCRPackageState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OCR_PackageState ];

/// OCR_ProviderDR
Property OCRProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 6, SqlFieldName = OCR_ProviderDR ];

/// OCR_ProviderHandler
Property OCRProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OCR_ProviderHandler ];

/// OCR_ProviderTel
Property OCRProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OCR_ProviderTel ];

/// OCR_PurchaseTypeDR
Property OCRPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 4, SqlFieldName = OCR_PurchaseTypeDR ];

/// OCR_RejectDate
Property OCRRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = OCR_RejectDate ];

/// OCR_RejectReason
Property OCRRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OCR_RejectReason ];

/// OCR_RejectTime
Property OCRRejectTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = OCR_RejectTime ];

/// OCR_RejectUserDR
Property OCRRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OCR_RejectUserDR ];

/// OCR_Remark
Property OCRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = OCR_Remark ];

/// OCR_RunningState
Property OCRRunningState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = OCR_RunningState ];

/// OCR_StatCatDR
Property OCRStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 5, SqlFieldName = OCR_StatCatDR ];

/// OCR_Status
Property OCRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 21, SqlFieldName = OCR_Status ];

/// OCR_SubmitDate
Property OCRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = OCR_SubmitDate ];

/// OCR_SubmitTime
Property OCRSubmitTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = OCR_SubmitTime ];

/// OCR_SubmitUserDR
Property OCRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OCR_SubmitUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOpenCheckRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OCR_AffixState">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OCR_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OCR_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OCR_ApproveStatu">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OCR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OCR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OCR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OCR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OCR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OCR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OCR_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OCR_CheckResult">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OCR_CheckType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OCR_CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OCR_ConfigState">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OCR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCR_FileState">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OCR_FromDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OCR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OCR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OCR_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OCR_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OCR_OpenCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OCR_OpenState">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OCR_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OCR_PackageState">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OCR_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OCR_ProviderHandler">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCR_ProviderTel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OCR_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OCR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OCR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OCR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OCR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OCR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OCR_RunningState">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OCR_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OCR_Status">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OCR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OCR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OCR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OCR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OCR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OCR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Global>^DHCEQOpenCheckRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OCR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQOpenCheckRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>OCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCR_CheckType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCR_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCR_NextRoleDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQOpenCheckRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>OCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCR_CheckType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCR_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCR_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OCR_NextFlowStep}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{OCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCheckType">
<Global>^DHCEQOpenCheckRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CheckType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCR_CheckType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQOpenCheckRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCR_RowID</Field>
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
<Expression>" "_{OCR_Hold1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQOpenCheckRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCR_CheckType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OCR_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOpenCheckRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
