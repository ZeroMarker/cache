Class User.DHCProContract Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCMPCT_RowId, SqlTableName = DHC_ProContract, StorageStrategy = SQLStorage ]
{

/// $i(^DHCMPCT(0))
Relationship ChildDHCProContractSpeclist As User.DHCProContractSpeclist [ Cardinality = children, Inverse = PCListParRef ];

/// 医疗机构账号
Property DHCPCTHospId As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DHC_PCT_HospId ];

/// 医院名称
Property DHCPCThospitalName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DHC_PCT_hospitalName ];

/// 合同编号
Property DHCPCTcontractId As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHC_PCT_contractId ];

/// 医疗机构签订状态
Property DHCPCThospitalSignStatus As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHC_PCT_hospitalSignStatus ];

/// 医疗机构签订日期
Property DHCPCThospitalSignDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DHC_PCT_hospitalSignDate ];

/// 医疗机构签订时间
Property DHCPCThospitalSignTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHC_PCT_hospitalSignTime ];

/// 生产企业编号
Property DHCPCTCompanyIdSc As %Library.String [ SqlColumnNumber = 8, SqlFieldName = DHC_PCT_CompanyIdSc ];

/// 生产企业名称 
Property DHCPCTCompanyNameSc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DHC_PCT_CompanyNameSc ];

/// 生产企业签订状态
Property DHCPCTcompanyScSignStatus As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DHC_PCT_companyScSignStatus ];

/// 生产企业签订日期
Property DHCPCTcompanyScSignDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DHC_PCT_companyScSignDate ];

/// 生产企业签订时间
Property DHCPCTcompanyScSignTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHC_PCT_companyScSignTime ];

/// 配送方编号
Property DHCPCTcompanyIdPs As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHC_PCT_companyIdPs ];

/// 配送方名称 
Property DHCPCTcompanyNamePs As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DHC_PCT_companyNamePs ];

/// 配送方签订状态
Property DHCPCTcompanyPsSignStatus As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DHC_PCT_companyPsSignStatus ];

/// 配送方签订日期
Property DHCPCTcompanyPsSignDate As %Library.Date [ SqlColumnNumber = 16, SqlFieldName = DHC_PCT_companyPsSignDate ];

/// 配送方签订时间
Property DHCPCTcompanyPsSignTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = DHC_PCT_companyPsSignTime ];

/// 合同状态 合同签约状态 0未提交 1医院已签约 2生产企业已签约
Property DHCPCTcontractStatus As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = DHC_PCT_contractStatus ];

/// 是否国家带量采购
Property DHCPCTisWithAmount As %Library.String [ SqlColumnNumber = 19, SqlFieldName = DHC_PCT_isWithAmount ];

/// 合同明细编号
Property DHCPCTdetailId As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DHC_PCT_detailId ];

/// 商品编号
Property DHCPCTprocurecatalogId As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = DHC_PCT_procurecatalogId ];

/// 产品ID
Property DHCPCTGoodsId As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DHC_PCT_GoodsId ];

/// 合同量（包装单位）合同采购量
Property DHCPCTcontractNumber As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = DHC_PCT_contractNumber ];

/// 合同价（包装单位）中选价格
Property DHCPCTcontractPrice As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = DHC_PCT_contractPrice ];

/// 合同配送时限
Property DHCPCTdisTime As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DHC_PCT_disTime ];

/// 合同周期（以月份为单位）
Property DHCPCTcontractCycle As %Library.String [ SqlColumnNumber = 26, SqlFieldName = DHC_PCT_contractCycle ];

/// 合同回款时间（以月份为单位）
Property DHCPCTcontractPayTime As %Library.String [ SqlColumnNumber = 27, SqlFieldName = DHC_PCT_contractPayTime ];

/// 当前合同执行量 合同完成量
Property DHCPCTcurrentContractExecuteNumber As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = DHC_PCT_currentContractExecuteNumber ];

/// 是否带量明细
Property DHCPCTisAgreement As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = DHC_PCT_isAgreement ];

/// 添加日期
Property DHCPCTAddDate As %Library.Date [ SqlColumnNumber = 30, SqlFieldName = DHC_PCT_AddDate ];

/// 添加时间
Property DHCPCTAddTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = DHC_PCT_AddTime ];

/// 变更日期
Property DHCPCTLastUpdateDate As %Library.Date [ SqlColumnNumber = 32, SqlFieldName = DHC_PCT_LastUpdateDate ];

/// 变更时间
Property DHCPCTLastUpdateTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = DHC_PCT_LastUpdateTime ];

/// 下载日期
Property DHCPCTDownDate As %Library.Date [ SqlColumnNumber = 34, SqlFieldName = DHC_PCT_DownDate ];

/// 下载时间
Property DHCPCTDownTime As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = DHC_PCT_DownTime ];

/// 下载人
Property DHCPCTDownUser As User.SSUser [ SqlColumnNumber = 36, SqlFieldName = DHC_PCT_DownUser ];

/// 医院负责人
Property DHCPCTlawerHospital As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = DHC_PCT_lawerHospital ];

/// 医院联系电话
Property DHCPCTphoneHospital As %Library.String [ SqlColumnNumber = 38, SqlFieldName = DHC_PCT_phoneHospital ];

/// 医院注册地址
Property DHCPCTregisterAddressHosp As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = DHC_PCT_registerAddressHosp ];

/// 生产企业法定代表人
Property DHCPCTlawerCompanyName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = DHC_PCT_lawerCompanyName ];

/// 生产企业联系电话
Property DHCPCTphoneCompsc As %Library.String [ SqlColumnNumber = 41, SqlFieldName = DHC_PCT_phoneCompsc ];

/// 生产企业注册地址
Property DHCPCTregisterAddressCompsc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = DHC_PCT_registerAddressCompsc ];

/// 配送企业联系电话
Property DHCPCTphoneCompPs As %Library.String [ SqlColumnNumber = 43, SqlFieldName = DHC_PCT_phoneCompPs ];

/// 配送企业注册地址
Property DHCPCTadressCompPs As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = DHC_PCT_adressCompPs ];

/// 注册证名称
Property DHCPCTregCername As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = DHC_PCT_regCername ];

/// 注册证ID
Property DHCPCTregCerno As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = DHC_PCT_regCerno ];

/// 合同明细采购总价 金额
Property DHCPCTamount As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = DHC_PCT_amount ];

/// 医院是否跳过签章 0：未签（初始化状态），1：跳过，2，未跳过
Property DHCPCTisSkipHospital As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = DHC_PCT_isSkipHospital ];

/// 签章状态 0.未签章，1.医院已签章，2.生产企业已签章，3.配送企业已签章
Property DHCPCTsignatureState As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = DHC_PCT_signatureState ];

/// 配送企业法定代表人
Property DHCPCTlawerCompPs As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = DHC_PCT_lawerCompPs ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMPCT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHC_PCT_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PCT_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_PCT_CompanyIdSc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHC_PCT_CompanyNameSc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHC_PCT_DownDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHC_PCT_DownTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHC_PCT_DownUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHC_PCT_GoodsId">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHC_PCT_HospId">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHC_PCT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHC_PCT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHC_PCT_adressCompPs">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="DHC_PCT_amount">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="DHC_PCT_companyIdPs">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHC_PCT_companyNamePs">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHC_PCT_companyPsSignDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHC_PCT_companyPsSignStatus">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHC_PCT_companyPsSignTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHC_PCT_companyScSignDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHC_PCT_companyScSignStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHC_PCT_companyScSignTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHC_PCT_contractCycle">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHC_PCT_contractId">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHC_PCT_contractNumber">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHC_PCT_contractPayTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHC_PCT_contractPrice">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHC_PCT_contractStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHC_PCT_currentContractExecuteNumber">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHC_PCT_detailId">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHC_PCT_disTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHC_PCT_hospitalName">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHC_PCT_hospitalSignDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHC_PCT_hospitalSignStatus">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHC_PCT_hospitalSignTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DHC_PCT_isAgreement">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHC_PCT_isSkipHospital">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="DHC_PCT_isWithAmount">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHC_PCT_lawerCompPs">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="DHC_PCT_lawerCompanyName">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DHC_PCT_lawerHospital">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DHC_PCT_phoneCompPs">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="DHC_PCT_phoneCompsc">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DHC_PCT_phoneHospital">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DHC_PCT_procurecatalogId">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHC_PCT_regCername">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="DHC_PCT_regCerno">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="DHC_PCT_registerAddressCompsc">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="DHC_PCT_registerAddressHosp">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DHC_PCT_signatureState">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Global>^DHCMPCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCMPCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDowndate">
<Global>^DHCMPCT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DOWNDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PCT_DownDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCMPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcontractgoodid">
<Global>^DHCMPCT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCMPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CONTRACTDETAILID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PCT_contractId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PCT_detailId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCMPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexprologid">
<Global>^DHCMPCT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCMPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PROLOGID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PCT_procurecatalogId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCMPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexgoodsconstatus">
<Global>^DHCMPCT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCMPCT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GOODSIDCSTATUS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PCT_GoodsId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PCT_contractStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCMPCT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCProContractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
