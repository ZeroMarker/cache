Class User.DHCEQBuyRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BR_RowID, SqlTableName = DHC_EQBuyRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index BRRequestNoUnqIdx1 On BRRequestNo [ Unique ];

/// BR_AddDate
Property BRAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = BR_AddDate ];

/// BR_AddTime
Property BRAddTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = BR_AddTime ];

/// BR_AddUserDR
Property BRAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BR_AddUserDR ];

/// BR_AuditDate
Property BRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = BR_AuditDate ];

/// BR_AuditTime
Property BRAuditTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = BR_AuditTime ];

/// BR_AuditUserDR
Property BRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BR_AuditUserDR ];

/// BR_CancelDate
Property BRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = BR_CancelDate ];

/// BR_CancelTime
Property BRCancelTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = BR_CancelTime ];

/// BR_CancelUser
Property BRCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = BR_CancelUser ];

/// BR_EquipTypeDR
Property BREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 26, SqlFieldName = BR_EquipTypeDR ];

/// BR_GatherFlag
Property BRGatherFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BR_GatherFlag ];

/// BR_Hold1
Property BRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BR_Hold1 ];

/// BR_Hold2-->BR_ManageLocDR
Property BRManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BR_ManageLocDR ];

/// BR_Hold3
Property BRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BR_Hold3 ];

/// BR_Hold4
Property BRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BR_Hold4 ];

/// BR_Hold5
Property BRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BR_Hold5 ];

/// BR_Hold6
Property BRHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BR_Hold6 ];

/// BR_Hold7
Property BRHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BR_Hold7 ];

/// BR_Hold8
Property BRHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BR_Hold8 ];

/// BR_InvalidFlag
Property BRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = BR_InvalidFlag ];

/// BR_LocOpinion
Property BRLocOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = BR_LocOpinion ];

/// BR_PrjName
Property BRPrjName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BR_PrjName ];

/// BR_PurchaseTypeDR
Property BRPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 27, SqlFieldName = BR_PurchaseTypeDR ];

/// BR_PurposeTypeDR
Property BRPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 42, SqlFieldName = BR_PurposeTypeDR ];

/// BR_QuantityNum
Property BRQuantityNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BR_QuantityNum ];

/// BR_RejectDate
Property BRRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 40, SqlFieldName = BR_RejectDate ];

/// BR_RejectReason
Property BRRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = BR_RejectReason ];

/// BR_RejectTime
Property BRRejectTime As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = BR_RejectTime ];

/// BR_RejectUserDR
Property BRRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = BR_RejectUserDR ];

/// BR_Remark
Property BRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BR_Remark ];

/// BR_RequestDate
Property BRRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = BR_RequestDate ];

/// BR_RequestLocDR
Property BRRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BR_RequestLocDR ];

/// BR_RequestNo
Property BRRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = BR_RequestNo ];

/// BR_Status
Property BRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 17, SqlFieldName = BR_Status ];

/// BR_SubmitDate
Property BRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = BR_SubmitDate ];

/// BR_SubmitTime
Property BRSubmitTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = BR_SubmitTime ];

/// BR_SubmitUserDR
Property BRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BR_SubmitUserDR ];

/// BR_TotalFee
Property BRTotalFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = BR_TotalFee ];

/// BR_UpdateDate
Property BRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = BR_UpdateDate ];

/// BR_UpdateTime
Property BRUpdateTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = BR_UpdateTime ];

/// BR_UpdateUserDR
Property BRUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = BR_UpdateUserDR ];

/// BR_UrgencyFlag
Property BRUrgencyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = BR_UrgencyFlag ];

/// BR_UseLocDR
Property BRUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BR_UseLocDR ];

/// BR_Year
Property BRYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BR_Year ];

/// BR_YearFlag
Property BRYearFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BR_YearFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="BR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="BR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BR_GatherFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BR_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BR_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BR_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="BR_LocOpinion">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BR_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BR_PrjName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BR_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BR_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BR_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BR_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BR_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BR_Status">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BR_UrgencyFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BR_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BR_Year">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BR_YearFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQBuyRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQBuyRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestLoc">
<Global>^DHCEQBuyRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RequestLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BR_RequestLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQBuyRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BR_RowID</Field>
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
<Expression>" "_{BR_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQBuyRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BR_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexYear">
<Global>^DHCEQBuyRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Year"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BR_Year}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
