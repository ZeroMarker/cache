Class User.DHCOEORIUUSD Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_OEORIUUSD, StorageStrategy = SQLStorage ]
{

/// 就诊ID
Property UUSDPAADMDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = UUSD_PAADM_DR ];

/// 就诊类型(门诊、住院)
Property UUSDAdmType As %String [ SqlColumnNumber = 3, SqlFieldName = UUSD_AdmType ];

/// 操作用户
Property UUSDSSUSRDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = UUSD_SSUSR_DR ];

/// 医嘱项
Property UUSDItmMastDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = UUSD_ItmMast_DR ];

/// 数量
Property UUSDPackQty As %String [ SqlColumnNumber = 6, SqlFieldName = UUSD_PackQty ];

/// 剂量
Property UUSDDoseQty As %String [ SqlColumnNumber = 7, SqlFieldName = UUSD_DoseQty ];

/// 剂量单位
Property UUSDDoseUOM As %String [ SqlColumnNumber = 8, SqlFieldName = UUSD_DoseUOM ];

/// 剂量单位ID
Property UUSDDoseUOMDR As %String [ SqlColumnNumber = 9, SqlFieldName = UUSD_DoseUOMDR ];

/// 接收科室
Property UUSDRecDepDR As %String [ SqlColumnNumber = 10, SqlFieldName = UUSD_RecDepDR ];

/// 跨院标识
Property UUSDOpenForAllHosp As %String [ SqlColumnNumber = 11, SqlFieldName = UUSD_OpenForAllHosp ];

/// 药品频次
Property UUSDPHCFreqDR As %String [ SqlColumnNumber = 12, SqlFieldName = UUSD_PHCFreqDR ];

/// 药品疗程
Property UUSDPHCDUDR As %String [ SqlColumnNumber = 13, SqlFieldName = UUSD_PHCDUDR ];

/// 医嘱类型，医嘱优先级
Property UUSDPriorityDR As %String [ SqlColumnNumber = 14, SqlFieldName = UUSD_PriorityDR ];

/// 基本单位ID
Property UUSDBaseUOMDR As %String [ SqlColumnNumber = 15, SqlFieldName = UUSD_BaseUOMDR ];

/// 用法
Property UUSDInstrDR As %String [ SqlColumnNumber = 16, SqlFieldName = UUSD_InstrDR ];

/// 费别
Property UUSDBillTypeDR As %String [ SqlColumnNumber = 17, SqlFieldName = UUSD_BillTypeDR ];

/// 处方类型
Property UUSDPHPrescType As %String [ SqlColumnNumber = 18, SqlFieldName = UUSD_PHPrescType ];

/// 医嘱项类型(药品、检验检查、处置治疗)
Property UUSDOrderType As %String [ SqlColumnNumber = 19, SqlFieldName = UUSD_OrderType ];

/// 序号
Property UUSDSeqNo As %String [ SqlColumnNumber = 20, SqlFieldName = UUSD_SeqNo ];

/// 关联号
Property UUSDMasterSeqNo As %String [ SqlColumnNumber = 21, SqlFieldName = UUSD_MasterSeqNo ];

/// 单价
Property UUSDUnitPrice As %String [ SqlColumnNumber = 22, SqlFieldName = UUSD_UnitPrice ];

/// 总金额
Property UUSDSum As %String [ SqlColumnNumber = 23, SqlFieldName = UUSD_Sum ];

/// 整包装单位
Property UUSDPackUOM As %String [ SqlColumnNumber = 24, SqlFieldName = UUSD_PackUOM ];

/// 标本
Property UUSDLabSpecDR As %String [ SqlColumnNumber = 25, SqlFieldName = UUSD_LabSpecDR ];

/// 标本号
Property UUSDLabEpisodeNo As %String [ SqlColumnNumber = 26, SqlFieldName = UUSD_LabEpisodeNo ];

/// 医嘱套ID
Property UUSDARCOSDR As %String [ SqlColumnNumber = 27, SqlFieldName = UUSD_ARCOSDR ];

/// 皮试
Property UUSDSkinTest As %String [ SqlColumnNumber = 28, SqlFieldName = UUSD_SkinTest ];

/// 皮试备注
Property UUSDActionDR As %String [ SqlColumnNumber = 29, SqlFieldName = UUSD_ActionDR ];

/// 医保标识
Property UUSDCoverMainIns As %String [ SqlColumnNumber = 30, SqlFieldName = UUSD_CoverMainIns ];

/// 备注
Property UUSDDepProcNote As %String [ SqlColumnNumber = 31, SqlFieldName = UUSD_DepProcNote ];

/// 医生
Property UUSDDocDR As %String [ SqlColumnNumber = 32, SqlFieldName = UUSD_DocDR ];

/// 录入人
Property UUSDUserAdd As %String [ SqlColumnNumber = 33, SqlFieldName = UUSD_UserAdd ];

/// 开医嘱科室
Property UUSDUserDep As %String [ SqlColumnNumber = 34, SqlFieldName = UUSD_UserDep ];

/// 开始日期
Property UUSDStartDate As %String [ SqlColumnNumber = 35, SqlFieldName = UUSD_StartDate ];

/// 开始时间
Property UUSDStartTime As %String [ SqlColumnNumber = 36, SqlFieldName = UUSD_StartTime ];

/// 首日用药次数
Property UUSDFirstDayTimes As %String [ SqlColumnNumber = 37, SqlFieldName = UUSD_FirstDayTimes ];

/// 是否紧急
Property UUSDNotifyClinician As %String [ SqlColumnNumber = 38, SqlFieldName = UUSD_NotifyClinician ];

/// 特殊病种ID
Property UUSDDIACatDR As %String [ SqlColumnNumber = 39, SqlFieldName = UUSD_DIACatDR ];

/// 适应症
Property UUSDInsuSignSymptom As %String [ SqlColumnNumber = 40, SqlFieldName = UUSD_InsuSignSymptom ];

/// 适应症Code
Property UUSDInsuSignSymptomCode As %String [ SqlColumnNumber = 41, SqlFieldName = UUSD_InsuSignSymptomCode ];

/// 医保分类
Property UUSDInsuCat As %String [ SqlColumnNumber = 42, SqlFieldName = UUSD_InsuCat ];

/// 部位说明
Property UUSDBodyPart As %String [ SqlColumnNumber = 43, SqlFieldName = UUSD_BodyPart ];

/// 医嘱阶段
Property UUSDStageCode As %String [ SqlColumnNumber = 44, SqlFieldName = UUSD_StageCode ];

/// 审批类型
Property UUSDInsuApproveType As %String [ SqlColumnNumber = 45, SqlFieldName = UUSD_InsuApproveType ];

/// 高值材料条码
Property UUSDMaterialBarcode As %String [ SqlColumnNumber = 46, SqlFieldName = UUSD_MaterialBarcode ];

/// 高值条码隐藏
Property UUSDMaterialBarcodeHidden As %String [ SqlColumnNumber = 47, SqlFieldName = UUSD_MaterialBarcodeHidden ];

/// 附加说明
Property UUSDPriorRemarks As %String [ SqlColumnNumber = 48, SqlFieldName = UUSD_PriorRemarks ];

/// 是否需要配液
Property UUSDNeedPIVAFlag As %String [ SqlColumnNumber = 49, SqlFieldName = UUSD_NeedPIVAFlag ];

/// 超量原因
Property UUSDExceedReasonDR As %String [ SqlColumnNumber = 50, SqlFieldName = UUSD_ExceedReasonDR ];

/// 病人自备标识
Property UUSDBySelfOMFlag As %String [ SqlColumnNumber = 51, SqlFieldName = UUSD_BySelfOMFlag ];

/// 使用目的
Property UUSDUseReasonDR As %String [ SqlColumnNumber = 52, SqlFieldName = UUSD_UseReasonDR ];

/// 抗生素用药原因
Property UUSDAntiUseReason As %String [ SqlColumnNumber = 53, SqlFieldName = UUSD_AntiUseReason ];

/// 可用天数
Property UUSDUseableDays As %String [ SqlColumnNumber = 54, SqlFieldName = UUSD_UseableDays ];

/// 临床路径步骤
Property UUSDCPWStepItemDR As %String [ SqlColumnNumber = 55, SqlFieldName = UUSD_CPWStepItemDR ];

/// OrderConFac
Property UUSDOrderConFac As %String [ SqlColumnNumber = 56, SqlFieldName = UUSD_OrderConFac ];

/// 通用名
Property UUSDGenericName As %String [ SqlColumnNumber = 57, SqlFieldName = UUSD_GenericName ];

/// 输液滴速
Property UUSDSpeedFlowRate As %String [ SqlColumnNumber = 58, SqlFieldName = UUSD_SpeedFlowRate ];

/// 输液滴速单位
Property UUSDFlowRateUnit As %String [ SqlColumnNumber = 59, SqlFieldName = UUSD_FlowRateUnit ];

/// 输液次数
Property UUSDLocalInfusionQty As %String [ SqlColumnNumber = 60, SqlFieldName = UUSD_LocalInfusionQty ];

/// ShowTabStr
Property UUSDShowTabStr As %String [ SqlColumnNumber = 61, SqlFieldName = UUSD_ShowTabStr ];

/// 管制药品申请
Property UUSDAntibApplyDR As %String [ SqlColumnNumber = 62, SqlFieldName = UUSD_AntibApplyDR ];

/// OrderHiddenPara
Property UUSDHiddenPara As %String [ SqlColumnNumber = 63, SqlFieldName = UUSD_HiddenPara ];

/// OrderMultiDate
Property UUSDMultiDate As %String [ SqlColumnNumber = 64, SqlFieldName = UUSD_MultiDate ];

/// OrderFile2
Property UUSDFile2 As %String [ SqlColumnNumber = 65, SqlFieldName = UUSD_File2 ];

/// 此表非特殊情况不再增加属性,以后新增的需要刷新继续展示的值都存在此字段上,以$C(1)分割,不可以^分割
/// add by guorongyong 2014-12-31
Property UUSDOtherExpStr As %String(MAXLEN = 5000) [ SqlColumnNumber = 66, SqlFieldName = UUSD_OtherExpStr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCOEORDUUSD("UUSD"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UUSD_ARCOSDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UUSD_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="UUSD_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UUSD_AntiUseReason">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="UUSD_AntibApplyDR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="UUSD_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UUSD_BillTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UUSD_BodyPart">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="UUSD_BySelfOMFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="UUSD_CPWStepItemDR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="UUSD_CoverMainIns">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="UUSD_DIACatDR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="UUSD_DepProcNote">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="UUSD_DocDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="UUSD_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UUSD_DoseUOM">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UUSD_DoseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UUSD_ExceedReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="UUSD_File2">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="UUSD_FirstDayTimes">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="UUSD_FlowRateUnit">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="UUSD_GenericName">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="UUSD_HiddenPara">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="UUSD_InstrDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UUSD_InsuApproveType">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="UUSD_InsuCat">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="UUSD_InsuSignSymptom">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="UUSD_InsuSignSymptomCode">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="UUSD_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UUSD_LabEpisodeNo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UUSD_LabSpecDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UUSD_LocalInfusionQty">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="UUSD_MasterSeqNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UUSD_MaterialBarcode">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="UUSD_MaterialBarcodeHidden">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="UUSD_MultiDate">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="UUSD_NeedPIVAFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="UUSD_NotifyClinician">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="UUSD_OpenForAllHosp">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UUSD_OrderConFac">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="UUSD_OrderType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UUSD_OtherExpStr">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="UUSD_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UUSD_PHCDUDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UUSD_PHCFreqDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UUSD_PHPrescType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UUSD_PackQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UUSD_PackUOM">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UUSD_PriorRemarks">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="UUSD_PriorityDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UUSD_RecDepDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UUSD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UUSD_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UUSD_ShowTabStr">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="UUSD_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UUSD_SpeedFlowRate">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="UUSD_StageCode">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="UUSD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="UUSD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="UUSD_Sum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UUSD_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UUSD_UseReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="UUSD_UseableDays">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="UUSD_UserAdd">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="UUSD_UserDep">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCOEORDUUSD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UUSD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UUSD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UUSD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofUUSD">
<Global>^DHCOEORDUUSD</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UUSD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{UUSD_AdmType}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UUSDPAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UUSD_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"UUSDSSUSR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UUSD_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UUSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UUSD_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCOEORIUUSDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
