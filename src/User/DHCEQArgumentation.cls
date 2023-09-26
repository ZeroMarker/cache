Class User.DHCEQArgumentation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_EQArgumentation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AR_BuyRequestListDR
Property ARBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 2, SqlFieldName = AR_BuyRequestListDR ];

/// AR_ProductIntroduce
Property ARProductIntroduce As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AR_ProductIntroduce ];

/// AR_Actuality
Property ARActuality As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AR_Actuality ];

/// AR_BuyReason
Property ARBuyReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AR_BuyReason ];

/// AR_AffectAnalyse
Property ARAffectAnalyse As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AR_AffectAnalyse ];

/// AR_Condition
Property ARCondition As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AR_Condition ];

/// AR_Service
Property ARService As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AR_Service ];

/// AR_RejectReason
Property ARRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AR_RejectReason ];

/// AR_RejectUserDR
Property ARRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AR_RejectUserDR ];

/// AR_RejectDate
Property ARRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AR_RejectDate ];

/// AR_RejectTime
Property ARRejectTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = AR_RejectTime ];

/// AR_Remark
Property ARRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AR_Remark ];

/// AR_Status
Property ARStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 14, SqlFieldName = AR_Status ];

/// AR_AddUserDR
Property ARAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AR_AddUserDR ];

/// AR_AddDate
Property ARAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = AR_AddDate ];

/// AR_AddTime
Property ARAddTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = AR_AddTime ];

/// AR_SubmitUserDR
Property ARSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AR_SubmitUserDR ];

/// AR_SubmitDate
Property ARSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = AR_SubmitDate ];

/// AR_SubmitTime
Property ARSubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = AR_SubmitTime ];

/// AR_AuditUserDR
Property ARAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AR_AuditUserDR ];

/// AR_AuditDate
Property ARAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = AR_AuditDate ];

/// AR_AuditTime
Property ARAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = AR_AuditTime ];

/// AR_ClinicEffect
Property ARClinicEffect As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AR_ClinicEffect ];

/// AR_SettleState
Property ARSettleState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AR_SettleState ];

/// AR_ResourceState
Property ARResourceState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AR_ResourceState ];

/// AR_PolluteState
Property ARPolluteState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AR_PolluteState ];

/// AR_OtherState
Property AROtherState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AR_OtherState ];

/// AR_PersonnelState
Property ARPersonnelState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AR_PersonnelState ];

/// AR_Income
Property ARIncome As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = AR_Income ];

/// AR_Effect
Property AREffect As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = AR_Effect ];

/// AR_PassAuditFlag
Property ARPassAuditFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AR_PassAuditFlag ];

/// AR_Place
Property ARPlace As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = AR_Place ];

/// AR_FloorSpace
Property ARFloorSpace As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AR_FloorSpace ];

/// AR_VoltageType
Property ARVoltageType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = AR_VoltageType ];

/// AR_VoltageTypeOther
Property ARVoltageTypeOther As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = AR_VoltageTypeOther ];

/// AR_PlaceConditionFlag
Property ARPlaceConditionFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = AR_PlaceConditionFlag ];

/// AR_PlaceCondition
Property ARPlaceCondition As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = AR_PlaceCondition ];

/// AR_PlaceReformFlag
Property ARPlaceReformFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = AR_PlaceReformFlag ];

/// AR_PlaceReform
Property ARPlaceReform As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = AR_PlaceReform ];

/// AR_Hold1
Property ARHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = AR_Hold1 ];

/// AR_Hold2
Property ARHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = AR_Hold2 ];

/// AR_Hold3
Property ARHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = AR_Hold3 ];

/// AR_Hold4
Property ARHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = AR_Hold4 ];

/// AR_Hold5
Property ARHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = AR_Hold5 ];

/// AR_Hold6
Property ARHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = AR_Hold6 ];

/// AR_Hold7
Property ARHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = AR_Hold7 ];

/// AR_Hold8
Property ARHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = AR_Hold8 ];

/// AR_Hold9
Property ARHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = AR_Hold9 ];

/// AR_Hold10
Property ARHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = AR_Hold10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQArgumentation("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_Actuality">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_AffectAnalyse">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AR_BuyReason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_ClinicEffect">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AR_Condition">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_Effect">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AR_FloorSpace">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="AR_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="AR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="AR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="AR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="AR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="AR_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="AR_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="AR_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="AR_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="AR_Income">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AR_OtherState">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AR_PassAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AR_PersonnelState">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AR_Place">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AR_PlaceCondition">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="AR_PlaceConditionFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="AR_PlaceReform">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="AR_PlaceReformFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="AR_PolluteState">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AR_ProductIntroduce">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_ResourceState">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AR_Service">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_SettleState">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AR_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AR_VoltageType">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="AR_VoltageTypeOther">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Global>^DHCEQArgumentation</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyRequestList">
<Global>^DHCEQArgumentation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyRequestList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_BuyRequestListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQArgumentation</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQArgumentationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
