Class User.DHCEQDisuseRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DR_RowID, SqlTableName = DHC_EQDisuseRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index DRRequestNoUnqIdx1 On DRRequestNo [ Unique ];

/// DR_AddDate
Property DRAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DR_AddDate ];

/// DR_AddTime
Property DRAddTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DR_AddTime ];

/// DR_AddUserDR
Property DRAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DR_AddUserDR ];

/// DR_ApproveRoleDR
Property DRApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 32, SqlFieldName = DR_ApproveRoleDR ];

/// DR_ApproveSetDR
Property DRApproveSetDR As User.DHCEQCApproveSet [ SqlColumnNumber = 28, SqlFieldName = DR_ApproveSetDR ];

/// DR_ApproveStatu
Property DRApproveStatu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DR_ApproveStatu ];

/// DR_AuditDate
Property DRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = DR_AuditDate ];

/// DR_AuditTime
Property DRAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = DR_AuditTime ];

/// DR_AuditUserDR
Property DRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DR_AuditUserDR ];

/// DR_CancelDate
Property DRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = DR_CancelDate ];

/// DR_CancelTime
Property DRCancelTime As %Library.Time [ SqlColumnNumber = 53, SqlFieldName = DR_CancelTime ];

/// DR_CancelUser
Property DRCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = DR_CancelUser ];

/// DR_ChangeReason
Property DRChangeReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DR_ChangeReason ];

/// DR_CheckResult
Property DRCheckResult As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DR_CheckResult ];

/// DR_DisureDate
Property DRDisureDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DR_DisureDate ];

/// DR_DisuseTypeDR
Property DRDisuseTypeDR As User.DHCEQCDisuseType [ SqlColumnNumber = 7, SqlFieldName = DR_DisuseTypeDR ];

/// DR_EquipDR
Property DREquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = DR_EquipDR ];

/// DR_EquipTypeDR
Property DREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 44, SqlFieldName = DR_EquipTypeDR ];

/// DR_GroupDR
Property DRGroupDR As User.DHCEQGroup [ SqlColumnNumber = 3, SqlFieldName = DR_GroupDR ];

/// DR_Hold1
Property DRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = DR_Hold1 ];

/// DR_Hold3
Property DRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = DR_Hold2 ];

/// DR_Hold4
Property DRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = DR_Hold3 ];

/// DR_Hold5
Property DRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = DR_Hold4 ];

/// DR_Hold5
Property DRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = DR_Hold5 ];

/// DR_InStockListDR
Property DRInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 50, SqlFieldName = DR_InStockListDR ];

/// DR_Income
Property DRIncome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = DR_Income ];

/// DR_InvalidFlag
Property DRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = DR_InvalidFlag ];

/// DR_KindFlag
Property DRKindFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = DR_KindFlag ];

/// DR_LimitYears
Property DRLimitYears As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = DR_LimitYears ];

/// DR_NextFlowStep
Property DRNextFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DR_NextFlowStep ];

/// DR_NextRoleDR
Property DRNextRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 29, SqlFieldName = DR_NextRoleDR ];

/// DR_RejectDate
Property DRRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = DR_RejectDate ];

/// DR_RejectReason
Property DRRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DR_RejectReason ];

/// DR_RejectTime
Property DRRejectTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = DR_RejectTime ];

/// DR_RejectUserDR
Property DRRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DR_RejectUserDR ];

/// DR_Remark
Property DRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DR_Remark ];

/// DR_RepairFee
Property DRRepairFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DR_RepairFee ];

/// DR_RepairHours
Property DRRepairHours As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = DR_RepairHours ];

/// DR_RepairTimes
Property DRRepairTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = DR_RepairTimes ];

/// DR_RequestDate
Property DRRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DR_RequestDate ];

/// DR_RequestLocDR
Property DRRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DR_RequestLocDR ];

/// DR_RequestNo
Property DRRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DR_RequestNo ];

/// DR_Status
Property DRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 11, SqlFieldName = DR_Status ];

/// DR_SubmitDate
Property DRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = DR_SubmitDate ];

/// DR_SubmitTime
Property DRSubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = DR_SubmitTime ];

/// DR_SubmitUserDR
Property DRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DR_SubmitUserDR ];

/// DR_TechnicEvaluate
Property DRTechnicEvaluate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = DR_TechnicEvaluate ];

/// DR_TotleTime
Property DRTotleTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DR_TotleTime ];

/// DR_UpdateDate
Property DRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = DR_UpdateDate ];

/// DR_UpdateTime
Property DRUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = DR_UpdateTime ];

/// DR_UpdateUserDR
Property DRUpdateUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = DR_UpdateUserDR ];

/// DR_UseLocDR
Property DRUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DR_UseLocDR ];

/// DR_UseState
Property DRUseState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DR_UseState ];

// add by lmm 2017-08-25 用于报废汇总标记

/// DR_MergeOrderFlag
Property DRMergeOrderFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = DR_MergeOrderFlag ];

/// DR_DisposalWay 处置方式
Property DRDisposalWay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = DR_DisposalWay ];

/// DR_DisposalFee 处置费用
Property DRDisposalFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = DR_DisposalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDisuseRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DR_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DR_ApproveSetDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DR_ApproveStatu">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="DR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="DR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="DR_ChangeReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DR_CheckResult">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DR_DisposalFee">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="DR_DisposalWay">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="DR_DisureDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DR_DisuseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DR_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DR_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="DR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="DR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="DR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="DR_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="DR_Income">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="DR_KindFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="DR_LimitYears">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DR_MergeOrderFlag">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="DR_NextFlowStep">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DR_NextRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DR_RepairFee">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DR_RepairHours">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DR_RepairTimes">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DR_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DR_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DR_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DR_TechnicEvaluate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DR_TotleTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DR_UseState">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQDisuseRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_NextRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApproveSet">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApproveSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_ApproveSetDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DR_NextFlowStep}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditDateStatus">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDateStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestLocDate">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RequestLocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_RequestLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DR_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DR_RowID</Field>
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
<Expression>" "_{DR_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQDisuseRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDisuseRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
