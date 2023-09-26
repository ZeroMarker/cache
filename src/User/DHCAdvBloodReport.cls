Class User.DHCAdvBloodReport Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BLDRPT_RowID, SqlTableName = DHC_AdvBloodReport, StorageStrategy = NewStorage1 ]
{

/// BLDRPT_RepLoc_Dr	填报科室
Property BLDRPTRepLocDr As %String [ SqlColumnNumber = 2, SqlFieldName = BLDRPT_RepLoc_Dr ];

/// BLDRPT_Creator	填报人
Property BLDRPTCreator As %String [ SqlColumnNumber = 3, SqlFieldName = BLDRPT_Creator ];

/// BLDRPT_RepNo	填报单号
Property BLDRPTRepNo As %String [ SqlColumnNumber = 4, SqlFieldName = BLDRPT_RepNo ];

/// BLDRPT _CreateDate	报告日期
Property BLDRPTCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BLDRPT_CreateDate ];

/// BLDRPT_CreateTime	报告时间
Property BLDRPTCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BLDRPT_CreateTime ];

/// BLDRPT _Ward	病人病区
Property BLDRPTWard As %String [ SqlColumnNumber = 7, SqlFieldName = BLDRPT_Ward ];

/// BLDRPT_AdmNo	就诊ID
Property BLDRPTAdmNo As %String [ SqlColumnNumber = 8, SqlFieldName = BLDRPT_AdmNo ];

/// BLDRPT_PatNo	病案号
Property BLDRPTPatNo As %String [ SqlColumnNumber = 9, SqlFieldName = BLDRPT_PatNo ];

/// BLDRPT _PatID	病人ID/登记号
Property BLDRPTPatID As %String [ SqlColumnNumber = 10, SqlFieldName = BLDRPT_PatID ];

/// BLDRPT _PatName	病人姓名
Property BLDRPTPatName As %String [ SqlColumnNumber = 11, SqlFieldName = BLDRPT_PatName ];

/// BLDRPT _PatSex	病人性别
Property BLDRPTPatSex As User.CTSex [ SqlColumnNumber = 12, SqlFieldName = BLDRPT_PatSex ];

/// BLDRPT _PatAge	病人年龄
Property BLDRPTPatAge As %String [ SqlColumnNumber = 13, SqlFieldName = BLDRPT_PatAge ];

/// BLDRPT _BrithDate	病人出生日期
Property BLDRPTBrithDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BLDRPT_BrithDate ];

/// BLDRPT _PatCardNo	身份证号
Property BLDRPTPatCardNo As %String [ SqlColumnNumber = 15, SqlFieldName = BLDRPT_PatCardNo ];

/// BLDRPT _Gestation	孕产史
Property BLDRPTGestation As %String [ SqlColumnNumber = 16, SqlFieldName = BLDRPT_Gestation ];

/// BLDRPT _Bloodhis 	输血史
Property BLDRPTBloodhis As %String [ SqlColumnNumber = 17, SqlFieldName = BLDRPT_Bloodhis ];

/// BLDRPT _ADVBloodhis	输血不良反应史
Property BLDRPTADVBloodhis As %String [ SqlColumnNumber = 18, SqlFieldName = BLDRPT_ADVBloodhis ];

/// BLDRPT _BloodType	输血前血型检查结果
Property BLDRPTBloodType As %String [ SqlColumnNumber = 19, SqlFieldName = BLDRPT_BloodType ];

/// BLDRPT_BloodAttr	输血前血型检查结果（阴阳性）
Property BLDRPTBloodAttr As %String [ SqlColumnNumber = 20, SqlFieldName = BLDRPT_BloodAttr ];

/// BLDRPT_ Antibody	意外抗体筛查(阳阴性)
Property BLDRPTAntibody As %String [ SqlColumnNumber = 21, SqlFieldName = BLDRPT_Antibody ];

/// BLDRPT_ CurrBloodType	本次输血血型
Property BLDRPTCurrBloodType As %String [ SqlColumnNumber = 22, SqlFieldName = BLDRPT_CurrBloodType ];

/// BLDRPT_CurrBloodAttr	本次输血血型(阴阳性)
Property BLDRPTCurrBloodAttr As %String [ SqlColumnNumber = 23, SqlFieldName = BLDRPT_CurrBloodAttr ];

/// BLDRPT_DiscNum	本次发现时输注血量
Property BLDRPTDiscNum As %String [ SqlColumnNumber = 24, SqlFieldName = BLDRPT_DiscNum ];

/// BLDRPT_Temp	基本生命体征(体温)
Property BLDRPTTemp As %String [ SqlColumnNumber = 25, SqlFieldName = BLDRPT_Temp ];

/// BLDRPT_BloodPress	基本生命体征(血压)
Property BLDRPTBloodPress As %String [ SqlColumnNumber = 26, SqlFieldName = BLDRPT_BloodPress ];

/// BLDRPT_Sphygmus	基本生命体征(脉博)
Property BLDRPTSphygmus As %String [ SqlColumnNumber = 27, SqlFieldName = BLDRPT_Sphygmus ];

/// BLDRPT_ Breathes	基本生命体征呼吸次数)
Property BLDRPTBreathes As %String [ SqlColumnNumber = 28, SqlFieldName = BLDRPT_Breathes ];

/// BLDRPT_ DrugDesc	输血前预防用药
Property BLDRPTDrugDesc As %String [ SqlColumnNumber = 29, SqlFieldName = BLDRPT_DrugDesc ];

/// BLDRPT_ DrugRemark	输血前预防用药（详细说明）
Property BLDRPTDrugRemark As %String [ SqlColumnNumber = 30, SqlFieldName = BLDRPT_DrugRemark ];

/// BLDRPT_StartDate	本次输血开始日期
Property BLDRPTStartDate As %Date [ SqlColumnNumber = 31, SqlFieldName = BLDRPT_StartDate ];

/// BLDRPT_StartTime	本次输血开始时间
Property BLDRPTStartTime As %Time [ SqlColumnNumber = 32, SqlFieldName = BLDRPT_StartTime ];

/// BLDRPT_Operator	本次输血操作人工号
Property BLDRPTOperator As %String [ SqlColumnNumber = 33, SqlFieldName = BLDRPT_Operator ];

/// BLDRPT_OccDate	输血反应发现开始日期
Property BLDRPTOccDate As %Date [ SqlColumnNumber = 34, SqlFieldName = BLDRPT_OccDate ];

/// BLDRPT_OccTime	输血反应发现开始时间
Property BLDRPTOccTime As %Time [ SqlColumnNumber = 35, SqlFieldName = BLDRPT_OccTime ];

/// BLDRPT_DisUser	输血反应发现操作人工号
Property BLDRPTDisUser As %String [ SqlColumnNumber = 36, SqlFieldName = BLDRPT_DisUser ];

/// BLDRPT_Manf	输血器厂家/批号
Property BLDRPTManf As %String [ SqlColumnNumber = 37, SqlFieldName = BLDRPT_Manf ];

/// BLDRPT_Remain	剩余血量
Property BLDRPTRemain As %String [ SqlColumnNumber = 38, SqlFieldName = BLDRPT_Remain ];

/// BLDRPT_Analyze	不良反应拟诊
Property BLDRPTAnalyze As %String [ SqlColumnNumber = 39, SqlFieldName = BLDRPT_Analyze ];

/// BLDRPT_SerLevel	严重程度
Property BLDRPTSerLevel As %String [ SqlColumnNumber = 40, SqlFieldName = BLDRPT_SerLevel ];

/// BLDRPT_Relation	相关性
Property BLDRPTRelation As %String [ SqlColumnNumber = 41, SqlFieldName = BLDRPT_Relation ];

/// BLDRPT_WardOp	临床处置
Property BLDRPTWardOp As %String [ SqlColumnNumber = 42, SqlFieldName = BLDRPT_WardOp ];

/// BLDRPT_PatInfo	患者转归
Property BLDRPTPatInfo As %String [ SqlColumnNumber = 43, SqlFieldName = BLDRPT_PatInfo ];

/// BLDRPT_DeathDate	死亡日期
Property BLDRPTDeathDate As %Date [ SqlColumnNumber = 44, SqlFieldName = BLDRPT_DeathDate ];

/// BLDRPT_DeathTime	死亡时间
Property BLDRPTDeathTime As %Time [ SqlColumnNumber = 45, SqlFieldName = BLDRPT_DeathTime ];

/// BLDRPT_BloodRelat	与输血相关性
Property BLDRPTBloodRelat As %String [ SqlColumnNumber = 46, SqlFieldName = BLDRPT_BloodRelat ];

/// BLDRPT_ CurStatus_DR	当前状态
Property BLDRPTCurStatusDR As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 47, SqlFieldName = BLDRPT_CurStatus_DR ];

/// BLDRPT_ReportType	报告分类
Property BLDRPTReportType As %String [ SqlColumnNumber = 48, SqlFieldName = BLDRPT_ReportType ];

/// BLDRPT_RepImpFlag 重点标记  Y N
Property BLDRPTRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = BLDRPT_RepImpFlag ];

/// BLDRPT_SignOther	体征其它描述
Property BLDRPTSignOther As %String [ SqlColumnNumber = 50, SqlFieldName = BLDRPT_SignOther ];

/// BLDRPT_SymOther	症状其它症状其它
Property BLDRPTSymOther As %String [ SqlColumnNumber = 51, SqlFieldName = BLDRPT_SymOther ];

/// BLDRPT_AuditDate	审核日期
Property BLDRPTAuditDate As %Date [ SqlColumnNumber = 52, SqlFieldName = BLDRPT_AuditDate ];

/// BLDRPT_BldReaType	输血反应类别
Property BLDRPTBldReaType As %String [ SqlColumnNumber = 53, SqlFieldName = BLDRPT_BldReaType ];

/// BLDRPT_DonorRelate	献血者与受血者关系
Property BLDRPTDonorRelate As %String [ SqlColumnNumber = 54, SqlFieldName = BLDRPT_DonorRelate ];

/// BLDRPT_IntervalTime	输血后间隔时间
Property BLDRPTIntervalTime As %String [ SqlColumnNumber = 55, SqlFieldName = BLDRPT_IntervalTime ];

/// BLDRPT_PatLoc_DR	病人所在科室
Property BLDRPTPatLocDR As %String [ SqlColumnNumber = 56, SqlFieldName = BLDRPT_PatLoc_DR ];

/// BLDRPT_Telephone  报告人联系电话
Property BLDRPTTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = BLDRPT_Telephone ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCBLDADVRPT)</SqlIdExpression>
<SQLMap name="IndexCreateDate">
<Global>^DHCBLDADVRPT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDRPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDRPT_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepNo">
<Global>^DHCBLDADVRPT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BLDRPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLDRPT_RepNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLDRPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BLDRPT_ADVBloodhis">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BLDRPT_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BLDRPT_Analyze">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BLDRPT_Antibody">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BLDRPT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="BLDRPT_BldReaType">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="BLDRPT_BloodAttr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BLDRPT_BloodPress">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BLDRPT_BloodRelat">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="BLDRPT_BloodType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BLDRPT_Bloodhis">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BLDRPT_Breathes">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BLDRPT_BrithDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BLDRPT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLDRPT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BLDRPT_Creator">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLDRPT_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="BLDRPT_CurrBloodAttr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BLDRPT_CurrBloodType">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BLDRPT_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="BLDRPT_DeathTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="BLDRPT_DisUser">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BLDRPT_DiscNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BLDRPT_DonorRelate">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="BLDRPT_DrugDesc">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BLDRPT_DrugRemark">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BLDRPT_Gestation">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BLDRPT_IntervalTime">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="BLDRPT_Manf">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BLDRPT_OccDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BLDRPT_OccTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BLDRPT_Operator">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BLDRPT_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BLDRPT_PatCardNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BLDRPT_PatID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BLDRPT_PatInfo">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BLDRPT_PatLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="BLDRPT_PatName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BLDRPT_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BLDRPT_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BLDRPT_Relation">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BLDRPT_Remain">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BLDRPT_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="BLDRPT_RepLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLDRPT_RepNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLDRPT_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="BLDRPT_SerLevel">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BLDRPT_SignOther">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="BLDRPT_Sphygmus">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BLDRPT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BLDRPT_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BLDRPT_SymOther">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="BLDRPT_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="BLDRPT_Temp">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BLDRPT_Ward">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BLDRPT_WardOp">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Global>^DHCBLDADVRPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLDRPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BLDRPT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBloodReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
