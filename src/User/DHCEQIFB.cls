Class User.DHCEQIFB Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFB_RowID, SqlTableName = DHC_EQIFB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index IFBNoUnqIdx1 On IFBNo [ Unique ];

/// IFB_AddDate
Property IFBAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = IFB_AddDate ];

/// IFB_AddTime
Property IFBAddTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = IFB_AddTime ];

/// IFB_AddUserDR
Property IFBAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = IFB_AddUserDR ];

/// IFB_AgencyConPerson
Property IFBAgencyConPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IFB_AgencyConPerson ];

/// IFB_AgencyDR
Property IFBAgencyDR As User.DHCEQCIFBAgency [ SqlColumnNumber = 18, SqlFieldName = IFB_AgencyDR ];

/// IFB_AgencyFax
Property IFBAgencyFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IFB_AgencyFax ];

/// IFB_AgencyTel
Property IFBAgencyTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IFB_AgencyTel ];

/// IFB_AnnouncementDate
Property IFBAnnouncementDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = IFB_AnnouncementDate ];

/// IFB_AnnouncementMedia
Property IFBAnnouncementMedia As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IFB_AnnouncementMedia ];

/// IFB_AuditDate
Property IFBAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 49, SqlFieldName = IFB_AuditDate ];

/// IFB_AuditTime
Property IFBAuditTime As %Library.Time [ SqlColumnNumber = 50, SqlFieldName = IFB_AuditTime ];

/// IFB_AuditUserDR
Property IFBAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = IFB_AuditUserDR ];

/// IFB_BuyFileFromDate
Property IFBBuyFileFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = IFB_BuyFileFromDate ];

/// IFB_BuyFileFromTime
Property IFBBuyFileFromTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = IFB_BuyFileFromTime ];

/// IFB_BuyFilePlace
Property IFBBuyFilePlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IFB_BuyFilePlace ];

/// IFB_BuyFilePrice
Property IFBBuyFilePrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = IFB_BuyFilePrice ];

/// IFB_BuyFileToDate
Property IFBBuyFileToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = IFB_BuyFileToDate ];

/// IFB_BuyFileToTime
Property IFBBuyFileToTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = IFB_BuyFileToTime ];

/// IFB_BuyTypeDR
Property IFBBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 36, SqlFieldName = IFB_BuyTypeDR ];

/// IFB_ConPerson
Property IFBConPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IFB_ConPerson ];

/// IFB_Condition
Property IFBCondition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = IFB_Condition ];

/// IFB_Currency
Property IFBCurrency As User.DHCEQCCurrency [ SqlColumnNumber = 59, SqlFieldName = IFB_Currency ];

/// IFB_DeadlineDate
Property IFBDeadlineDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = IFB_DeadlineDate ];

/// IFB_DeadlineTime
Property IFBDeadlineTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = IFB_DeadlineTime ];

/// IFB_Deposit
Property IFBDeposit As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = IFB_Deposit ];

/// IFB_DeterminationDate
Property IFBDeterminationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = IFB_DeterminationDate ];

/// IFB_DisabuseDate
Property IFBDisabuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = IFB_DisabuseDate ];

/// IFB_EvaluationCommittee
Property IFBEvaluationCommittee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = IFB_EvaluationCommittee ];

/// IFB_Fax
Property IFBFax As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IFB_Fax ];

/// IFB_Hold1
Property IFBHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = IFB_Hold1 ];

/// IFB_Hold2
Property IFBHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = IFB_Hold2 ];

/// IFB_Hold3
Property IFBHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = IFB_Hold3 ];

/// IFB_Hold4
Property IFBHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = IFB_Hold4 ];

/// IFB_Hold5
Property IFBHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = IFB_Hold5 ];

/// IFB_ManageLocDR
Property IFBManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = IFB_ManageLocDR ];

/// IFB_ModeDR
Property IFBModeDR As User.DHCEQCIFBMode [ SqlColumnNumber = 5, SqlFieldName = IFB_ModeDR ];

/// IFB_No
Property IFBNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IFB_No ];

/// IFB_OpenDate
Property IFBOpenDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = IFB_OpenDate ];

/// IFB_OpenPlace
Property IFBOpenPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = IFB_OpenPlace ];

/// IFB_OpenTime
Property IFBOpenTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = IFB_OpenTime ];

/// IFB_PrjIntro
Property IFBPrjIntro As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFB_PrjIntro ];

/// IFB_PrjName
Property IFBPrjName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IFB_PrjName ];

/// IFB_RejectDate
Property IFBRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 57, SqlFieldName = IFB_RejectDate ];

/// IFB_RejectTime
Property IFBRejectTime As %Library.Time [ SqlColumnNumber = 58, SqlFieldName = IFB_RejectTime ];

/// IFB_RejectUserDR
Property IFBRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = IFB_RejectUserDR ];

/// IFB_Remark
Property IFBRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = IFB_Remark ];

/// IFB_ReservePrice
Property IFBReservePrice As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = IFB_ReservePrice ];

/// IFB_Status
Property IFBStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 44, SqlFieldName = IFB_Status ];

/// IFB_SubmissionPlace
Property IFBSubmissionPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = IFB_SubmissionPlace ];

/// IFB_SubmitDate
Property IFBSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = IFB_SubmitDate ];

/// IFB_SubmitTime
Property IFBSubmitTime As %Library.Time [ SqlColumnNumber = 47, SqlFieldName = IFB_SubmitTime ];

/// IFB_SubmitUserDR
Property IFBSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = IFB_SubmitUserDR ];

/// IFB_Tel
Property IFBTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IFB_Tel ];

/// IFB_Tenderee
Property IFBTenderee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IFB_Tenderee ];

/// IFB_TendereeAddress
Property IFBTendereeAddress As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IFB_TendereeAddress ];

/// IFB_UpdateDate
Property IFBUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = IFB_UpdateDate ];

/// IFB_UpdateTime
Property IFBUpdateTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = IFB_UpdateTime ];

/// IFB_UpdateUserDR
Property IFBUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = IFB_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIFB("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFB_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="IFB_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="IFB_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="IFB_AgencyConPerson">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IFB_AgencyDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IFB_AgencyFax">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IFB_AgencyTel">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IFB_AnnouncementDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IFB_AnnouncementMedia">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IFB_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="IFB_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="IFB_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="IFB_BuyFileFromDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IFB_BuyFileFromTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IFB_BuyFilePlace">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IFB_BuyFilePrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IFB_BuyFileToDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IFB_BuyFileToTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IFB_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="IFB_ConPerson">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IFB_Condition">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IFB_Currency">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="IFB_DeadlineDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IFB_DeadlineTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IFB_Deposit">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IFB_DeterminationDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IFB_DisabuseDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IFB_EvaluationCommittee">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IFB_Fax">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IFB_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="IFB_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="IFB_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="IFB_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="IFB_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="IFB_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IFB_ModeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IFB_No">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IFB_OpenDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IFB_OpenPlace">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IFB_OpenTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IFB_PrjIntro">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFB_PrjName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFB_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="IFB_RejectTime">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="IFB_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="IFB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="IFB_ReservePrice">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IFB_Status">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="IFB_SubmissionPlace">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IFB_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="IFB_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="IFB_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="IFB_Tel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IFB_Tenderee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IFB_TendereeAddress">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IFB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="IFB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="IFB_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Global>^DHCEQIFB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IFB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IFB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQIFB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IFB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IFB_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IFB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIFBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
