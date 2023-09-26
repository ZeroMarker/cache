Class User.DHCIncItmLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCIL_RowId, SqlTableName = DHC_IncItmLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INCIL_LockFlag
Property INCILLockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = INCIL_LockFlag ];

/// INCIL_INCIL_DR
Property INCILINCILDR As User.INCItmLoc [ SqlColumnNumber = 3, SqlFieldName = INCIL_INCIL_DR ];

/// Enforce Ordering
Property INCILEnforceStock As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INCIL_EnforceStock ];

/// Backup Stkbin 
Property INCILSpareStkBin As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INCIL_SpareStkBin ];

/// PIVA Pack Flag
Property INCILPIVAPack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = INCIL_PIVAPack ];

/// INCIL_Load_Flag
Property INCILLoadFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INCIL_LoadFlag ];

/// INCIL_LMGRP_DR
Property INCILLMGRPDR As User.DHCLocManGrp [ SqlColumnNumber = 8, SqlFieldName = INCIL_LMGRP_DR ];

/// INCIL_PLANFLAG
Property INCILPLANFLAG As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = INCIL_PLANFLAG ];

/// INCIL_USEFLAG
Property INCILUSEFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INCIL_USEFLAG ];

/// INCIL_DrugSendFlag
Property INCILDrugSendFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = INCIL_DrugSendFlag ];

/// INCIL_DrugPackFlag
Property INCILDrugPackFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = INCIL_DrugPackFlag ];

/// INCIL_FeeFlag
Property INCILFeeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INCIL_FeeFlag ];

/// INCIL_NegativeFlag
Property INCILNegativeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INCIL_NegativeFlag ];

/// INCIL_TrInQty_Year  - 年度转入数量
Property INCILTrInQtyYear As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INCIL_TrInQty_Year ];

/// INCIL_LockUser_Dr
Property INCILLockUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = INCIL_LockUser_Dr ];

/// INCIL_LockDate
Property INCILLockDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 17, SqlFieldName = INCIL_LockDate ];

/// INCIL_LockTime
Property INCILLockTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INCIL_LockTime ];

/// INCIL_InGdQtyLong  - 入库长期限制数量（按月）
Property INCILInGdQtyLong As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = INCIL_InGdQtyLong ];

/// INCIL_InGdQtyShort  - 入库临时限制数量（按月）
Property INCILInGdQtyShort As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = INCIL_InGdQtyShort ];

/// INCIL_InGdQtyTotal  - 入库临时限制数量（按月）
Property INCILInGdQtyTotal As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = INCIL_InGdQtyTotal ];

/// INCIL_ZeroStk - 零库存标志
Property INCILZeroStk As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = INCIL_ZeroStk ];

/// Consume Standard
Property INCILConQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 23, SqlFieldName = INCIL_ConQty ];

/// INCIL_PIVA - 是否配液
Property INCILPIVA As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = INCIL_PIVA ];

/// INCIL_DEFAULTUOM 申领默认单位
Property INCILDEFAULTUOM As %Library.String [ SqlColumnNumber = 25, SqlFieldName = INCIL_DEFAULTUOM ];

/// INCIL_OEBatQty  - 医嘱跨批次警戒数
Property INCILOEBatQty As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = INCIL_OEBatQty ];

/// INCIL_Remarks
Property INCILRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INCIL_Remarks ];

/// 可替代药品
Property INCILRepINCI As User.INCItm [ SqlColumnNumber = 28, SqlFieldName = INCIL_RepINCI ];

/// 请求频次 
Property INCILReqFre As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 29, SqlFieldName = INCIL_ReqFre ];

/// 当月已经消耗总数 
Property INCILConQtyMonth As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 30, SqlFieldName = INCIL_ConQty_Month ];

/// 加锁原因
Property IncilLockReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INCIL_LockReason ];

/// 配液配置系数 
Property INCILPIVACoefficient As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 32, SqlFieldName = INCIL_PIVACoefficient ];

/// INCIL_InPhPack - 住院发药是否取整,不拆零
Property INCILInPhPack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = INCIL_InPhPack ];

/// 自动加锁标志
Property INCILAutoLock As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INCIL_AutoLock ];

/// 限发金额 
Property INCILLitMoney As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 35, SqlFieldName = INCIL_LitMoney ];

/// 请领数量系数
Property INCILReqQtyCoefficient As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 36, SqlFieldName = INCIL_ReqQtyCoefficient ];

/// 上限策略天数
Property INCILMaxDay As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 37, SqlFieldName = INCIL_MaxDay ];

/// 下限策略天数
Property INCILMinDay As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 38, SqlFieldName = INCIL_MinDay ];

/// 配液中心-配置台
Property INCILPIVAConfTable As User.PIVAConfigTable [ SqlColumnNumber = 39, SqlFieldName = INCIL_PIVAConfTable ];

/// 配液中心-用药说明
Property IncilUseInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INCIL_UseInfo ];

/// 配液中心-储存条件
Property IncilStoreInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INCIL_StoreInfo ];

/// 直配标识
Property INCILPurchaseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = INCIL_PurchaseFlag ];

/// 是否冲减
Property INCILResRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = INCIL_ResRetFlag ];

/// 配液药物多种形态,指向DHC_StkComDictionary,多个","分隔
Property INCILPIVAStats As %Library.String [ SqlColumnNumber = 44, SqlFieldName = INCIL_PIVAStats ];

/// 配液医嘱顺序
Property INCILPIVAOrdCode As %Library.String [ SqlColumnNumber = 45, SqlFieldName = INCIL_PIVAOrdCode ];

/// 连续配液配置系数 
Property INCILPIVAConCoef As %Library.Float(MINVAL = 0) [ SqlColumnNumber = 46, SqlFieldName = INCIL_PIVAConCoef ];

/// 同组相同配液配置系数 
Property INCILPIVASameCoef As %Library.Float(MINVAL = 0) [ SqlColumnNumber = 47, SqlFieldName = INCIL_PIVASameCoef ];

/// Minimum ArcQuantity医嘱库存下限
Property INCILArcMinQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 48, SqlFieldName = INCIL_ArcMinQty ];

/// 配送周期
Property INCILCarryCycleDay As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 49, SqlFieldName = INCIL_CarryCycleDay ];

/// 采购周期
Property INCILPurCircleDay As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 50, SqlFieldName = INCIL_PurCircleDay ];

/// 呆滞线
Property INCILSluggishQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 51, SqlFieldName = INCIL_SluggishQty ];

/// 门诊自动发药
Property INCILAutoDispFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = INCIL_AutoDispFlag ];

/// 开医嘱时出院带药可以按基本单位打包
Property INCILOutPhPack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = INCIL_OutPhPack ];

Property INCILInLock As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = INCIL_InLock ];

Property INCILABC As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = INCIL_ABC ];

/// 可调整数量
Property INCILAdjustableQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 56, SqlFieldName = INCIL_AdjustableQty ];

/// 已调整数量
Property INCILAdjustedQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 57, SqlFieldName = INCIL_AdjustedQty ];

Property INCILOutMedLock As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = INCIL_OutMedLock ];

Property INCILRefRetReasonDr As User.DHCStkRefuseRetReason [ SqlColumnNumber = 59, SqlFieldName = INCIL_RefRetReason_Dr ];

Property INCILClearDate As %Date [ SqlColumnNumber = 60, SqlFieldName = INCIL_ClearDate ];

Property INCILClearTime As %Time [ SqlColumnNumber = 61, SqlFieldName = INCIL_ClearTime ];

Property INCILDueDate As %Date [ SqlColumnNumber = 62, SqlFieldName = INCIL_DueDate ];

Property INCILManuMaxMix As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = INCIL_ManuMaxMix ];

Property INCILPIVAPrtOrd As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = INCIL_PIVAPrtOrd ];

Property INCILExpressFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = INCIL_ExpressFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINCIL)</SqlIdExpression>
<SQLMap name="datamastermap">
<Data name="INCIL_ABC">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INCIL_AdjustableQty">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INCIL_AdjustedQty">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INCIL_ArcMinQty">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INCIL_AutoDispFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INCIL_AutoLock">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INCIL_CarryCycleDay">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INCIL_ClearDate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INCIL_ClearTime">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INCIL_ConQty">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INCIL_ConQty_Month">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INCIL_DEFAULTUOM">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INCIL_DrugPackFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCIL_DrugSendFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCIL_DueDate">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INCIL_EnforceStock">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCIL_ExpressFlag">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INCIL_FeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCIL_INCIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCIL_InGdQtyLong">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INCIL_InGdQtyShort">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INCIL_InGdQtyTotal">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INCIL_InLock">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INCIL_InPhPack">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INCIL_LMGRP_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCIL_LitMoney">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INCIL_LoadFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCIL_LockDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCIL_LockFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCIL_LockReason">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INCIL_LockTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INCIL_LockUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCIL_ManuMaxMix">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INCIL_MaxDay">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INCIL_MinDay">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INCIL_NegativeFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCIL_OEBatQty">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INCIL_OutMedLock">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INCIL_OutPhPack">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INCIL_PIVA">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INCIL_PIVACoefficient">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INCIL_PIVAConCoef">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>5</Piece>
</Data>
<Data name="INCIL_PIVAConfTable">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INCIL_PIVAOrdCode">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>4</Piece>
</Data>
<Data name="INCIL_PIVAPack">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCIL_PIVAPrtOrd">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>7</Piece>
</Data>
<Data name="INCIL_PIVASameCoef">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>6</Piece>
</Data>
<Data name="INCIL_PIVAStats">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>3</Piece>
</Data>
<Data name="INCIL_PLANFLAG">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCIL_PurCircleDay">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INCIL_PurchaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INCIL_RefRetReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INCIL_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INCIL_RepINCI">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INCIL_ReqFre">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INCIL_ReqQtyCoefficient">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INCIL_ResRetFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INCIL_SluggishQty">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INCIL_SpareStkBin">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCIL_StoreInfo">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>2</Piece>
</Data>
<Data name="INCIL_TrInQty_Year">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCIL_USEFLAG">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCIL_UseInfo">
<Delimiter>"^"</Delimiter>
<Node>"PIVAS"</Node>
<Piece>1</Piece>
</Data>
<Data name="INCIL_ZeroStk">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCINCIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INCIL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexManGrp">
<Global>^DHCINCIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LMG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIL_LMGRP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIL_INCIL_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexincil">
<Global>^DHCINCIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCIL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCIL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIL_INCIL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIncItmLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINCIL)
	s oldI = +$g(^mdata("DHCINCITMLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINCIL = maxI
	s ^mdata("DHCINCITMLOC") = maxI
}

}
