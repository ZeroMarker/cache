Class User.DHCEQBuyPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BP_RowID, SqlTableName = DHC_EQBuyPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index BPPlanNoUnqIdx1 On BPPlanNo [ Unique ];

/// BP_AddDate
Property BPAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = BP_AddDate ];

/// BP_AddTime
Property BPAddTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = BP_AddTime ];

/// BP_AddUserDR
Property BPAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BP_AddUserDR ];

/// BP_AuditDate
Property BPAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = BP_AuditDate ];

/// BP_AuditTime
Property BPAuditTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = BP_AuditTime ];

/// BP_AuditUserDR
Property BPAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BP_AuditUserDR ];

/// BP_BuyAuditDate
Property BPBuyAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = BP_BuyAuditDate ];

/// BP_BuyAuditTime
Property BPBuyAuditTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = BP_BuyAuditTime ];

/// BP_BuyAuditUserDR
Property BPBuyAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = BP_BuyAuditUserDR ];

/// BP_BuyRemark
Property BPBuyRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = BP_BuyRemark ];

/// BP_BuyStatus
Property BPBuyStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,部分执行,全部执行", MAXLEN = 4, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 39, SqlFieldName = BP_BuyStatus ];

/// BP_CancelDate
Property BPCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = BP_CancelDate ];

/// BP_CancelTime
Property BPCancelTime As %Library.Time [ SqlColumnNumber = 46, SqlFieldName = BP_CancelTime ];

/// BP_CancelUser
Property BPCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = BP_CancelUser ];

/// BP_EquipTypeDR
Property BPEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 13, SqlFieldName = BP_EquipTypeDR ];

/// BP_Hold1
Property BPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BP_Hold1 ];

/// BP_Hold2
Property BPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BP_Hold2 ];

/// BP_Hold3
Property BPHold3 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = BP_Hold3 ];

/// BP_Hold4
Property BPHold4 As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = BP_Hold4 ];

/// BP_Hold5
Property BPHold5 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = BP_Hold5 ];

/// BP_Hold6-->BP_ManageLocDR
Property BPManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = BP_ManageLocDR ];

/// BP_Hold7
Property BPHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = BP_Hold7 ];

/// BP_Hold8
Property BPHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = BP_Hold8 ];

/// BP_InvalidFlag
Property BPInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = BP_InvalidFlag ];

/// BP_PlanDate
Property BPPlanDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = BP_PlanDate ];

/// BP_PlanName
Property BPPlanName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BP_PlanName ];

/// BP_PlanNo
Property BPPlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BP_PlanNo ];

/// BP_PlanType
Property BPPlanType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BP_PlanType ];

/// BP_PlanYear
Property BPPlanYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BP_PlanYear ];

/// BP_PurchaseTypeDR
Property BPPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 29, SqlFieldName = BP_PurchaseTypeDR ];

/// BP_PurposeTypeDR
Property BPPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 43, SqlFieldName = BP_PurposeTypeDR ];

/// BP_QuantityNum
Property BPQuantityNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = BP_QuantityNum ];

/// BP_RejectDate
Property BPRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = BP_RejectDate ];

/// BP_RejectReason
Property BPRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BP_RejectReason ];

/// BP_RejectTime
Property BPRejectTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = BP_RejectTime ];

/// BP_RejectUserDR
Property BPRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = BP_RejectUserDR ];

/// BP_Remark
Property BPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BP_Remark ];

/// BP_Status
Property BPStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 7, SqlFieldName = BP_Status ];

/// BP_SubmitDate
Property BPSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = BP_SubmitDate ];

/// BP_SubmitTime
Property BPSubmitTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = BP_SubmitTime ];

/// BP_SubmitUserDR
Property BPSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BP_SubmitUserDR ];

/// BP_TotalFee
Property BPTotalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BP_TotalFee ];

/// BP_UpdateDate
Property BPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = BP_UpdateDate ];

/// BP_UpdateTime
Property BPUpdateTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = BP_UpdateTime ];

/// BP_UpdateUserDR
Property BPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BP_UpdateUserDR ];

/// BP_UrgencyFlag
Property BPUrgencyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = BP_UrgencyFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BP_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BP_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BP_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BP_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BP_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BP_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BP_BuyAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BP_BuyAuditTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BP_BuyAuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BP_BuyRemark">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BP_BuyStatus">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BP_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="BP_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="BP_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="BP_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BP_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BP_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="BP_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BP_PlanDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BP_PlanName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BP_PlanNo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BP_PlanType">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BP_PlanYear">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BP_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BP_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BP_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BP_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BP_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BP_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BP_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BP_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BP_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BP_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BP_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BP_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BP_UrgencyFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCEQBuyPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_Hold2}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_Hold1}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BP_Hold3}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuyApproveRole">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_BuyStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_Hold2}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuyApproveSet">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_BuyStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_Hold8}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BP_Hold3}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuyStatus">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_BuyStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlanNo">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PlanNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>" "_{BP_PlanNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlanYear">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlanYear"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_PlanYear}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQBuyPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
