Class User.DHCEmPatCheckLev Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCL_RowID, SqlTableName = DHC_EmPatCheckLev, StorageStrategy = SQLStorage ]
{

/// 来诊病人 PCL_PAPMI_Dr
Property PCLPAPMIDr As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PCL_PAPMI_Dr ];

/// 急诊登记 PCL_Reg_Dr
Property PCLRegDr As User.DHCDocEmReg [ SqlColumnNumber = 3, SqlFieldName = PCL_Reg_Dr ];

/// 分诊护士 PCL_Creator_Dr
Property PCLCreatorDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PCL_Creator_Dr ];

/// 分诊创建日期 PCL_CreateDate
Property PCLCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PCL_CreateDate ];

/// 分诊创建时间 PCL_CreateTime
Property PCLCreateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PCL_CreateTime ];

/// 推荐分级 PCL_RecLevel
Property PCLRecLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PCL_RecLevel ];

/// 护士分级 PCL_NurseLevel
Property PCLNurseLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PCL_NurseLevel ];

/// 护士分级原因 PCL_NurRea_Dr
Property PCLNurReaDr As User.DHCEmDocUpdReason [ SqlColumnNumber = 9, SqlFieldName = PCL_NurRea_Dr ];

/// 去向分区 PCL_Area
Property PCLArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PCL_Area ];

/// 分诊科室 PCL_Loc_Dr
Property PCLLocDr As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = PCL_Loc_Dr ];

/// 重返标识 PCL_AgainFlag
Property PCLAgainFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PCL_AgainFlag ];

/// 成批就诊 PCL_BatchFlag
Property PCLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PCL_BatchFlag ];

/// 成批就诊人数 PCL_BatchNum
Property PCLBatchNum As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 14, SqlFieldName = PCL_BatchNum ];

/// 既往史 PCL_His_Dr
Property PCLHisDr As User.DHCEmPatChkHis [ SqlColumnNumber = 15, SqlFieldName = PCL_His_Dr ];

/// 病人来源 PCL_Sou_Dr
Property PCLSouDr As User.DHCEmPatSource [ SqlColumnNumber = 16, SqlFieldName = PCL_Sou_Dr ];

/// 来诊方式 PCL_AdmWay_Dr
Property PCLAdmWayDr As User.DHCEmPatAdmWay [ SqlColumnNumber = 17, SqlFieldName = PCL_AdmWay_Dr ];

/// 意识状态 PCL_Aw_Dr
Property PCLAwDr As User.DHCEmPatAware [ SqlColumnNumber = 18, SqlFieldName = PCL_Aw_Dr ];

/// 筛查 PCL_ScreenFlag
Property PCLScreenFlag As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PCL_ScreenFlag ];

/// 用药情况 PCL_HisDrug
Property PCLHisDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PCL_HisDrug ];

/// 用药情况描述 PCL_HisDrugDesc
Property PCLHisDrugDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PCL_HisDrugDesc ];

/// 辅助物 PCL_Material
Property PCLMaterial As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = PCL_Material ];

/// 辅助物描述 PCL_MaterialDesc
Property PCLMaterialDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PCL_MaterialDesc ];

/// 生命体征 PCL_Sign_Dr
Property PCLSignDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PCL_Sign_Dr ];

/// 症状表 PCL_Sym_Dr
Property PCLSymDr As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PCL_Sym_Dr ];

/// 症状描述 PCL_SymDesc
Property PCLSymDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PCL_SymDesc ];

/// 复合伤 PCL_CombFlag
Property PCLCombFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PCL_CombFlag ];

/// ECG PCL_ECGFlag
Property PCLECGFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = PCL_ECGFlag ];

/// 中毒 PCL_PoisonFlag
Property PCLPoisonFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = PCL_PoisonFlag ];

/// 疼痛 PCL_PainFlag
Property PCLPainFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = PCL_PainFlag ];

/// 疼痛分级 PCL_PainLev
Property PCLPainLev As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 31, SqlFieldName = PCL_PainLev ];

/// 疼痛范围 PCL_PainRange
Property PCLPainRange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PCL_PainRange ];

/// 疼痛日期 PCL_PainDate
Property PCLPainDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = PCL_PainDate ];

/// 疼痛时间 PCL_PainTime
Property PCLPainTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = PCL_PainTime ];

/// 吸氧 PCL_OxygenFlag
Property PCLOxygenFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = PCL_OxygenFlag ];

/// 请假 PCL_PatAskFlag
Property PCLPatAskFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PCL_PatAskFlag ];

/// 其它 PCL_Other
Property PCLOther As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PCL_Other ];

/// 就诊ID PCL_Adm_Dr
Property PCLAdmDr As User.PAAdm [ SqlColumnNumber = 38, SqlFieldName = PCL_Adm_Dr ];

/// 伤口：
Property PCLWound As %Library.String [ SqlColumnNumber = 39, SqlFieldName = PCL_Wound ];

/// 部位
Property PCLPart As %Library.String [ SqlColumnNumber = 40, SqlFieldName = PCL_Part ];

/// 特殊人群ID PCL_PatType_Dr
Property PCLPatTypeDr As User.DHCEmPatType [ SqlColumnNumber = 41, SqlFieldName = PCL_PatType_Dr ];

/// 指向科室ID PCL_ToLoc_Dr
Property PCLToLocDr As User.CTLoc [ SqlColumnNumber = 42, SqlFieldName = PCL_ToLoc_Dr ];

/// 陪送人员ID PCL_Partners_Dr
Property PCLPartnersDr As User.DHCEmPartners [ SqlColumnNumber = 43, SqlFieldName = PCL_Partners_Dr ];

/// 陪送人员备注 PCL_PartnersInfo
Property PCLPartnersInfo As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PCL_PartnersInfo ];

///  序列号
Property PCLSeqNo As %Float [ SqlColumnNumber = 45, SqlFieldName = PCL_SeqNo ];

/// 格拉斯哥
Property PCLGcsFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = PCL_GcsFlag ];

/// 创伤评分
Property PCLAisFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = PCL_AisFlag ];

/// 抢救病区
Property PCLWardDr As User.PACWard [ SqlColumnNumber = 48, SqlFieldName = PCL_Ward_Dr ];

/// 多发伤
Property PCLMutipleFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = PCL_MutipleFlag ];

/// 转院名称
Property PCLToOtherHosp As %Library.String [ SqlColumnNumber = 50, SqlFieldName = PCL_ToOtherHosp ];

/// 群伤管理ID  PCL_GroupHurt_Dr
Property PCLGroupHurtDr As User.DHCEmGroupHurt [ SqlColumnNumber = 51, SqlFieldName = PCL_GroupHurt_Dr ];

/// 诊断证明 PCL_DiagFlag
Property PCLDiagFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = PCL_DiagFlag ];

/// 死亡证明 PCL_DieFlag
Property PCLDieFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = PCL_DieFlag ];

/// 遵医嘱 
Property PCLObeyOrd As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = PCL_ObeyOrd ];

/// 坠跌评分 PCL_FallFlag
Property PCLFallFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = PCL_FallFlag ];

/// 方便急诊 PCL_ConEmFlag
Property PCLConEmFlag As %Library.String [ SqlColumnNumber = 56, SqlFieldName = PCL_ConEmFlag ];

/// 备注 PCL_Notes
Property PCLNotes As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 57, SqlFieldName = PCL_Notes ];

/// 发病日期 PCL_AttackDate
Property PCLAttackDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 58, SqlFieldName = PCL_AttackDate ];

/// 发病时间 PCL_AttackTime
Property PCLAttackTime As %Library.Time [ SqlColumnNumber = 59, SqlFieldName = PCL_AttackTime ];

/// 来诊日期 PCL_Date
Property PCLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 60, SqlFieldName = PCL_Date ];

/// 来诊时间 PCL_Time
Property PCLTime As %Library.Time [ SqlColumnNumber = 61, SqlFieldName = PCL_Time ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCL_AdmWay_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PCL_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PCL_AgainFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCL_AisFlag">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="PCL_Area">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCL_AttackDate">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="PCL_AttackTime">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="PCL_Aw_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PCL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCL_BatchNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCL_CombFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PCL_ConEmFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="PCL_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCL_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PCL_Creator_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCL_Date">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="PCL_DiagFlag">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="PCL_DieFlag">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="PCL_ECGFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PCL_FallFlag">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="PCL_GcsFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PCL_GroupHurt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="PCL_HisDrug">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PCL_HisDrugDesc">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PCL_His_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCL_Material">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PCL_MaterialDesc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PCL_MutipleFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="PCL_Notes">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="PCL_NurRea_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCL_NurseLevel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCL_ObeyOrd">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="PCL_Other">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PCL_OxygenFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PCL_PAPMI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCL_PainDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PCL_PainFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PCL_PainLev">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PCL_PainRange">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PCL_PainTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PCL_Part">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PCL_PartnersInfo">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PCL_Partners_Dr">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PCL_PatAskFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PCL_PatType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PCL_PoisonFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PCL_RecLevel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCL_Reg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCL_ScreenFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PCL_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PCL_Sign_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PCL_Sou_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PCL_SymDesc">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PCL_Sym_Dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PCL_Time">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="PCL_ToLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PCL_ToOtherHosp">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="PCL_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="PCL_Wound">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Global>^DHCEMPCL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMPCL</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PCL_CreateDate</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCL_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEmPatReg">
<Global>^DHCEMPCL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EmPatReg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCL_PAPMI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCL_Reg_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatCheckLevS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
