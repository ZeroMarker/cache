Class User.DHCEQSRent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = R_RowID, SqlTableName = DHC_EQSRent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RRequestNoUnqIdx1 On RRequestNo [ Unique ];

/// R_ApproveStatus
Property RApproveStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 42, SqlFieldName = R_ApproveStatus ];

/// R_ShareResourceDR
Property RShareResourceDR As User.DHCEQSShareResource [ SqlColumnNumber = 10, SqlFieldName = R_ShareResourceDR ];

/// R_EquipType
Property REquipType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = R_EquipType ];

/// R_FromLocDR
Property RFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = R_FromLocDR ];

/// R_ItemDR
Property RItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 8, SqlFieldName = R_ItemDR ];

/// R_LocReceiverDR
Property RLocReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = R_LocReceiverDR ];

/// R_LocReturnDR
Property RLocReturnDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = R_LocReturnDR ];

/// R_FromHospitalDR
Property RFromHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = R_FromHospitalDR ];

/// R_ResourcePriceDR
Property RResourcePriceDR As User.DHCEQSResourceHistoryPrice [ SqlColumnNumber = 34, SqlFieldName = R_ResourcePriceDR ];

/// R_ModelDR
Property RModelDR As User.DHCEQCModel [ SqlColumnNumber = 9, SqlFieldName = R_ModelDR ];

/// R_PlanBeginDate
Property RPlanBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = R_PlanBeginDate ];

/// R_PlanBeginTime
Property RPlanBeginTime As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = R_PlanBeginTime ];

/// R_PlanEndDate
Property RPlanEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = R_PlanEndDate ];

/// R_PlanEndTime
Property RPlanEndTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = R_PlanEndTime ];

/// R_Quantity
Property RQuantity As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = R_Quantity ];

/// R_ShareItemDR
Property RShareItemDR As User.DHCEQSCShareItem [ SqlColumnNumber = 33, SqlFieldName = R_ShareItemDR ];

/// R_RentManagerDR
Property RRentManagerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = R_RentManagerDR ];

/// R_RentOperatorDate
Property RRentOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = R_RentOperateDate ];

/// R_RentOperatorTime
Property RRentOperateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = R_RentOperateTime ];

/// R_RentOperatorDR
Property RRentOperatorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = R_RentOperatorDR ];

/// R_RentStatus
Property RRentStatus As %Library.String(DISPLAYLIST = ",完好,有缺陷", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 17, SqlFieldName = R_RentStatus ];

/// R_StatusRemark
Property RRentStatusRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = R_RentStatusRemark ];

/// R_RequestDate
Property RRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = R_RequestDate ];

/// R_RequestLocDR
Property RRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = R_RequestLocDR ];

/// R_RequestNo
Property RRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = R_RequestNo ];

/// R_RequestTime
Property RRequestTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = R_RequestTime ];

/// R_RequestUserDR
Property RRequestUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = R_RequestUserDR ];

/// R_ReturnDate
Property RReturnDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = R_ReturnDate ];

/// R_ReturnManagerDR
Property RReturnManagerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = R_ReturnManagerDR ];

/// R_ReturnOperateDate
Property RReturnOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = R_ReturnOperateDate ];

/// R_ReturnOperateTime
Property RReturnOperateTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = R_ReturnOperateTime ];

/// R_ReturnOperatorDR
Property RReturnOperatorDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = R_ReturnOperatorDR ];

/// R_ReturnStatus
Property RReturnStatus As %Library.String(DISPLAYLIST = ",完好,有缺陷,故障", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 26, SqlFieldName = R_ReturnStatus ];

/// R_ReturnStatusRemark
Property RReturnStatusRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = R_ReturnStatusRemark ];

/// R_ReturnTime
Property RReturnTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = R_ReturnTime ];

/// R_StartDate
Property RStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = R_StartDate ];

/// R_StartTime
Property RStartTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = R_StartTime ];

/// R_Status
Property RStatus As %Library.String(DISPLAYLIST = ",新增,申请,借出,归还", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 37, SqlFieldName = R_Status ];

/// R_TotalFee
Property RTotalFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = R_TotalFee ];

/// R_WorkLoad
Property RWorkLoad As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = R_WorkLoad ];

/// R_WorkLoadUOMDR
Property RWorkLoadUOMDR As User.DHCEQCUOM [ SqlColumnNumber = 32, SqlFieldName = R_WorkLoadUOMDR ];

/// R_RenewalTimes
Property RenewalTimes As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = R_RenewalTimes ];

/// R_RenewalToDate
Property RenewalToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = R_RenewalToDate ];

/// R_RenewalToTime
Property RenewalToTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = R_RenewalToTime ];

/// R_ToHospitalDR
Property RToHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = R_ToHospitalDR ];

/// R_Hold2
Property RHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = R_Hold2 ];

/// R_Hold3
Property RHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = R_Hold3 ];

/// R_Hold4
Property RHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = R_Hold4 ];

/// R_Hold5
Property RHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = R_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSRent("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="R_ApproveStatus">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="R_EquipType">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="R_FromHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="R_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="R_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="R_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="R_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="R_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="R_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="R_LocReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="R_LocReturnDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="R_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="R_PlanBeginDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="R_PlanBeginTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="R_PlanEndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="R_PlanEndTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="R_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="R_RenewalTimes">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="R_RenewalToDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="R_RenewalToTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="R_RentManagerDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="R_RentOperateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="R_RentOperateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="R_RentOperatorDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="R_RentStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="R_RentStatusRemark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="R_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="R_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="R_RequestTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="R_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_ResourcePriceDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="R_ReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="R_ReturnManagerDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="R_ReturnOperateDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="R_ReturnOperateTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="R_ReturnOperatorDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="R_ReturnStatus">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="R_ReturnStatusRemark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="R_ReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="R_ShareItemDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="R_ShareResourceDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="R_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="R_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="R_Status">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="R_ToHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="R_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="R_WorkLoad">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="R_WorkLoadUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Global>^DHCEQSRent</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQSRent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShareResource"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_ShareResourceDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestLoc">
<Global>^DHCEQSRent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RequestLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_RequestLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQSRent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
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
<Expression>" "_{R_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQSRent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{R_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSRentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
