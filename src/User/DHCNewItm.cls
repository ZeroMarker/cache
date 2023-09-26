/// 库存项目待审批立项表
Class User.DHCNewItm Extends (%Library.Persistent, %XML.Adaptor) [ SqlRowIdName = NI_RowId, SqlTableName = DHC_NewItm, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCNewItmAduRec As User.DHCNewItmAduRec [ Cardinality = children, Inverse = NIARNIParref ];

/// 建立项目后指向inci
Property NIInciDr As %String [ SqlColumnNumber = 2, SqlFieldName = NI_InciDR ];

/// 申请科室
Property NILocDr As %String [ SqlColumnNumber = 3, SqlFieldName = NI_LocDR ];

/// 申请人
Property NIUserDr As %String [ SqlColumnNumber = 4, SqlFieldName = NI_UserDR ];

/// 日期
Property NIDate As %Date [ SqlColumnNumber = 5, SqlFieldName = NI_Date ];

/// 时间
Property NITime As %Time [ SqlColumnNumber = 6, SqlFieldName = NI_Time ];

/// 审批人
Property NIAckUserDr As %String [ SqlColumnNumber = 7, SqlFieldName = NI_AckUserDR ];

/// 审批日期
Property NIAckDate As %Date [ SqlColumnNumber = 8, SqlFieldName = NI_AckDate ];

/// 审批时间
Property NIAckTime As %Time [ SqlColumnNumber = 9, SqlFieldName = NI_AckTime ];

/// 审批完成标志
Property NIAckFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = NI_AckFlag ];

/// 物资描述
Property NIDesc As %String(MAXLEN = 220) [ SqlColumnNumber = 11, SqlFieldName = NI_Desc ];

/// 规格
Property NISpec As %String [ SqlColumnNumber = 12, SqlFieldName = NI_Spec ];

/// 型号
Property NIModel As %String [ SqlColumnNumber = 13, SqlFieldName = NI_Model ];

/// 品牌
Property NIBrand As %String [ SqlColumnNumber = 14, SqlFieldName = NI_Brand ];

/// 基本单位描述
Property NIBUom As %String [ SqlColumnNumber = 15, SqlFieldName = NI_BUom ];

/// 购买单位描述
Property NIPUom As %String [ SqlColumnNumber = 16, SqlFieldName = NI_PUom ];

/// 别名
Property NIAlias As %String [ SqlColumnNumber = 17, SqlFieldName = NI_Alias ];

/// 进价
Property NIPRp As %Float [ SqlColumnNumber = 18, SqlFieldName = NI_PRp ];

/// 售价
Property NIPSp As %Float [ SqlColumnNumber = 19, SqlFieldName = NI_PSp ];

/// 备注
Property NIRemark As %String [ SqlColumnNumber = 20, SqlFieldName = NI_Remark ];

/// 供应商描述
Property NIVendor As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = NI_Vendor ];

/// 生产厂家描述
Property NIManf As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = NI_Manf ];

/// 进口标志
Property NIImportFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = NI_ImportFlag ];

/// 注册证号
Property NIRegNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = NI_RegNo ];

/// 注册证号有效期
Property NIRegCertExpDate As %Date [ SqlColumnNumber = 25, SqlFieldName = NI_RegCertExpDate ];

/// 高值标记
Property NIHighPrice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = NI_HighPrice ];

/// 一次性标志
Property NIBAFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = NI_BAFlag ];

/// 有效期长度（月）
Property NIExpireLen As %String [ SqlColumnNumber = 28, SqlFieldName = NI_ExpireLen ];

/// 高危标志
Property NIHighRiskFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = NI_HighRiskFlag ];

/// 收费标志
Property NIChargeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = NI_ChargeFlag ];

/// 简称
Property NIAbbrev As %String [ SqlColumnNumber = 31, SqlFieldName = NI_Abbrev ];

/// 植入标志
Property NIImplantationMat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = NI_ImplantationMat ];

/// 灭菌时间长度
Property NISterileDateLen As %Float [ SqlColumnNumber = 33, SqlFieldName = NI_SterileDateLen ];

/// 零库存标志
Property NIZeroStk As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = NI_ZeroStk ];

/// SCI表的唯一值
Property NISciId As %String [ SqlColumnNumber = 35, SqlFieldName = NI_SciId ];

/// 供应商唯一标识
Property NIVendorCode As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = NI_VendorCode ];

/// 申请单号
Property NINo As %String(MAXLEN = 220) [ SqlColumnNumber = 37, SqlFieldName = NI_No ];

/// 预估年用量
Property NIConsumeQty As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = NI_ConsumeQty ];

/// 库存项备注
Property NIInciRemarks As %String(MAXLEN = 500) [ SqlColumnNumber = 39, SqlFieldName = NI_InciRemarks ];

/// 省集采流水号
Property NIPbNo As %String(MAXLEN = 100) [ SqlColumnNumber = 40, SqlFieldName = NI_PbNo ];

/// 两票制标志
Property NIDoubleFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = NI_DoubleFlag ];

/// 请求人
Property NIReqUser As %String [ SqlColumnNumber = 42, SqlFieldName = NI_ReqUser ];

/// 请求科室Id
Property NIReqLoc As %String [ SqlColumnNumber = 43, SqlFieldName = NI_ReqLoc ];

/// 专家审批意见: (评审专家(同意|不同意|暂缓)&院使用专家&评审委员会&办公室)
Property NIProfessorInfo As %String(MAXLEN = 100) [ SqlColumnNumber = 44, SqlFieldName = NI_ProfessorInfo ];

/// 收费依据
Property NIChargeBasis As %String(MAXLEN = 100) [ SqlColumnNumber = 45, SqlFieldName = NI_ChargeBasis ];

/// 申请人联系方式
Property NIReqPhone As %String [ SqlColumnNumber = 46, SqlFieldName = NI_ReqPhone ];

/// 申请人职称/职务
Property NIReqDuty As %String [ SqlColumnNumber = 47, SqlFieldName = NI_ReqDuty ];

/// 立项结果:通过/不通过/暂缓(Yes/No/Wait)
Property NIResult As %String [ SqlColumnNumber = 48, SqlFieldName = NI_Result ];

/// 药品/物资标志  G/M
Property NIStkType As %String [ SqlColumnNumber = 49, SqlFieldName = NI_StkType ];

/// 库存分类描述
Property NIStkCat As %String [ SqlColumnNumber = 50, SqlFieldName = NI_StkCat ];

/// 招标名称描述
Property NIPbWay As %String [ SqlColumnNumber = 51, SqlFieldName = NI_PbWay ];

/// 配送方式描述
Property NIDeliverWay As %String [ SqlColumnNumber = 52, SqlFieldName = NI_DeliverWay ];

/// 临时采购标志
Property NITemPurchase As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = NI_TemPurchase ];

/// 集中采购标志
Property NICentralPurFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = NI_CentralPurFlag ];

/// 批号必填标志
Property NIBatchReq As %String [ SqlColumnNumber = 55, SqlFieldName = NI_BatchReq ];

/// 效期必填标志
Property NIExpReq As %String [ SqlColumnNumber = 56, SqlFieldName = NI_ExpReq ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCNEWITM)</SqlIdExpression>
<SQLMap name="IndexINCI">
<Global>^DHCNEWITM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NI_InciDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCNEWITM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NI_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSciCode">
<Global>^DHCNEWITM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCICODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NI_SciId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MastetData">
<Data name="NI_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="NI_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NI_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NI_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NI_AckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NI_Alias">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NI_BAFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="NI_BUom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NI_BatchReq">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="NI_Brand">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NI_CentralPurFlag">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="NI_ChargeBasis">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="NI_ChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="NI_ConsumeQty">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="NI_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NI_DeliverWay">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="NI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NI_DoubleFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="NI_ExpReq">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="NI_ExpireLen">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="NI_HighPrice">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="NI_HighRiskFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="NI_ImplantationMat">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="NI_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="NI_InciDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NI_InciRemarks">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="NI_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NI_Manf">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="NI_Model">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NI_No">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="NI_PRp">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="NI_PSp">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="NI_PUom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NI_PbNo">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="NI_PbWay">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="NI_ProfessorInfo">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="NI_RegCertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="NI_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="NI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="NI_ReqDuty">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="NI_ReqLoc">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="NI_ReqPhone">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="NI_ReqUser">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="NI_Result">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="NI_SciId">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="NI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NI_SterileDateLen">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="NI_StkCat">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="NI_StkType">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="NI_TemPurchase">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="NI_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NI_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NI_Vendor">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="NI_VendorCode">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="NI_ZeroStk">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCNEWITM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{NI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCNewItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCNEWITM)
	s oldI = +$g(^mdata("DHCNEWITM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCNEWITM = maxI
	s ^mdata("DHCNEWITM") = maxI
}

}
