Class User.DHCEQContract Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CT_RowID, SqlTableName = DHC_EQContract, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index CTContractNoUnqIdx1 On CTUniqueContractNo [ Unique ];

/// CT_ArriveDate
Property CTArriveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CT_ArriveDate ];

/// CT_ArriveItem
Property CTArriveItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = CT_ArriveItem ];

/// CT_ArriveMonthNum
Property CTArriveMonthNum As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = CT_ArriveMonthNum ];

/// CT_AuditDate
Property CTAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = CT_AuditDate ];

/// CT_AuditTime
Property CTAuditTime As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = CT_AuditTime ];

/// CT_AuditUserDR
Property CTAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = CT_AuditUserDR ];

/// CT_BreakItem
Property CTBreakItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CT_BreakItem ];

/// CT_CheckStandard
Property CTCheckStandard As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CT_CheckStandard ];

/// CT_ClaimPeriodNum
Property CTClaimPeriodNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = CT_ClaimPeriodNum ];

/// CT_ContractName
Property CTContractName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CT_ContractName ];

/// CT_ContractNo
Property CTContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CT_ContractNo ];

/// CT_ContractStatus
Property CTContractStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = CT_ContractStatus ];

/// CT_ContractType
Property CTContractType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = CT_ContractType ];

/// CT_CurrencyDR
Property CTCurrencyDR As User.DHCEQCCurrency [ SqlColumnNumber = 48, SqlFieldName = CT_CurrencyDR ];

/// CT_DeliveryDate
Property CTDeliveryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = CT_DeliveryDate ];

/// CT_EndDate
Property CTEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = CT_EndDate ];

/// CT_GuaranteePeriodNum
Property CTGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = CT_GuaranteePeriodNum ];

/// CT_Hold1-->CT_BuyTypeDR
Property CTBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 49, SqlFieldName = CT_BuyTypeDR ];

/// CT_Hold4-->CT_ManageLocDR
Property CTManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = CT_ManageLocDR ];

/// CT_Hold5-->CT_FileNo
Property CTFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = CT_FileNo ];

/// CT_Hold1  合同类型
Property CTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = CT_Hold1 ];

/// CT_Hold2  验收后补录合同
Property CTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = CT_Hold2 ];

/// CT_Hold3
Property CTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = CT_Hold3 ];

/// CT_Hold4
Property CTHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = CT_Hold4 ];

/// CT_Hold5 AuditType
Property CTHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = CT_Hold5 ];

/// CT_TaxItemDR 税目
Property CTTaxItemDR As User.DHCEQCTaxItem [ SqlColumnNumber = 59, SqlFieldName = CT_TaxItemDR ];

/// CT_IsIFB 是否招标
Property CIsIFB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = CT_IsIFB ];

/// CT_IFBAgency 招标代理公司
Property CTIFBAgency As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = CT_IFBAgency ];

/// CT_RequestLocDR 申请科室
Property CTRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = CT_RequestLocDR ];

/// CT_SubmitFile 提交资料
Property CTSubmitFile As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = CT_SubmitFile ];

/// CT_PurchaseType 采购类型
Property CTPurchaseType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = CT_PurchaseType ];

/// CT_BudgetFee 预算金额
Property CTBudgetFee As %Library.Float [ SqlColumnNumber = 65, SqlFieldName = CT_BudgetFee ];

/// CT_Hold6 是否2012年后获得的设备购置项目
Property CTHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = CT_Hold6 ];

/// CT_Hold7 下达设备购置项目文件文号及名称
Property CTHold7 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = CT_Hold7 ];

/// CT_Hold8 获得设备购置项目年份(YYYY)
Property CTHold8 As %Library.Integer [ SqlColumnNumber = 68, SqlFieldName = CT_Hold8 ];

/// CT_Hold9 设备购置项目投入资金数(万元)
Property CTHold9 As %Library.Float [ SqlColumnNumber = 69, SqlFieldName = CT_Hold9 ];

/// CT_UniqueContractNo 唯一合同号
Property CTUniqueContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = CT_UniqueContractNo ];

/// CT_IFBNo 招标编号
Property CTIFBNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = CT_IFBNo ];

/// CT_NeedHandlerDR
Property CTNeedHandlerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CT_NeedHandlerDR ];

/// CT_PayItem
Property CTPayItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CT_PayItem ];

/// CT_PayTypeDR
Property CTPayTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CT_PayTypeDR ];

/// CT_PayedTotalFee
Property CTPayedTotalFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = CT_PayedTotalFee ];

/// CT_PreFeeFee
Property CTPreFeeFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = CT_PreFeeFee ];

/// CT_ProviderDR
Property CTProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 19, SqlFieldName = CT_ProviderDR ];

/// CT_ProviderHandler
Property CTProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CT_ProviderHandler ];

/// CT_ProviderTel
Property CTProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CT_ProviderTel ];

/// CT_QualityItem
Property CTQualityItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = CT_QualityItem ];

/// CT_QuantityNum
Property CTQuantityNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = CT_QuantityNum ];

/// CT_RefuseDate
Property CTRefuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = CT_RefuseDate ];

/// CT_RefuseReason
Property CTRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = CT_RefuseReason ];

/// CT_RefuseTime
Property CTRefuseTime As %Library.Time [ SqlColumnNumber = 46, SqlFieldName = CT_RefuseTime ];

/// CT_RefuseUserDR
Property CTRefuseUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = CT_RefuseUserDR ];

/// CT_Remark
Property CTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CT_Remark ];

/// CT_Service
Property CTService As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CT_Service ];

/// CT_ServiceDR
Property CTServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 37, SqlFieldName = CT_ServiceDR ];

/// CT_ServiceHandler
Property CTServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = CT_ServiceHandler ];

/// CT_ServiceTel
Property CTServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = CT_ServiceTel ];

/// CT_SignDate
Property CTSignDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = CT_SignDate ];

/// CT_SignLocDR
Property CTSignLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CT_SignLocDR ];

/// CT_StartDate
Property CTStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CT_StartDate ];

/// CT_Status
Property CTStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 25, SqlFieldName = CT_Status ];

/// CT_SubmitDate
Property CTSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = CT_SubmitDate ];

/// CT_SubmitTime
Property CTSubmitTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = CT_SubmitTime ];

/// CT_SubmitUserDR
Property CTSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = CT_SubmitUserDR ];

/// CT_SubType
Property CTSubType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = CT_SubType ];

/// CT_TotalFee
Property CTTotalFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = CT_TotalFee ];

/// CT_UpdateDate
Property CTUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = CT_UpdateDate ];

/// CT_UpdateTime
Property CTUpdateTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = CT_UpdateTime ];

/// CT_UpdateUserDR
Property CTUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CT_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContract("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CT_ArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CT_ArriveItem">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CT_ArriveMonthNum">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CT_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CT_BreakItem">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CT_BudgetFee">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="CT_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="CT_CheckStandard">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CT_ClaimPeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CT_ContractName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CT_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CT_ContractStatus">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="CT_ContractType">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CT_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="CT_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CT_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="CT_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="CT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="CT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="CT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="CT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="CT_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="CT_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="CT_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="CT_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="CT_IFBAgency">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="CT_IFBNo">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="CT_IsIFB">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="CT_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="CT_NeedHandlerDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CT_PayItem">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CT_PayTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CT_PayedTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CT_PreFeeFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CT_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CT_ProviderHandler">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CT_ProviderTel">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CT_PurchaseType">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="CT_QualityItem">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CT_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CT_RefuseDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CT_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CT_RefuseTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="CT_RefuseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CT_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="CT_Service">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CT_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CT_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CT_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CT_SignDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CT_SignLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CT_Status">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CT_SubType">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="CT_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CT_SubmitFile">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="CT_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CT_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CT_TaxItemDR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="CT_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CT_UniqueContractNo">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="CT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CT_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Global>^DHCEQContract</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContractNo">
<Global>^DHCEQContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ContractNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CT_ContractNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContractType">
<Global>^DHCEQContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_ContractType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFileNo">
<Global>^DHCEQContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FileNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>" "_{CT_FileNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUniqueContractNo">
<Global>^DHCEQContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UniqueContractNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_UniqueContractNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
