Class User.DHCMatAdrReport Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MATADR_RowID, SqlTableName = DHC_MatAdrReport, StorageStrategy = NewStorage1 ]
{

/// MATADR _No	报告单号
Property MATADRNo As %String [ SqlColumnNumber = 2, SqlFieldName = MATADR_No ];

/// MATADR _Sex	性别
Property MATADRSex As User.CTSex [ SqlColumnNumber = 3, SqlFieldName = MATADR_Sex ];

/// MATADR _Age	年龄
Property MATADRAge As %String [ SqlColumnNumber = 4, SqlFieldName = MATADR_Age ];

/// MATADR _Name	姓名
Property MATADRName As %String [ SqlColumnNumber = 5, SqlFieldName = MATADR_Name ];

/// MATADR _PatId	病人ID
Property MATADRPatId As %String [ SqlColumnNumber = 6, SqlFieldName = MATADR_PatId ];

/// MATADR _AdmDate	诊疗日期
Property MATADRAdmDate As %Date [ SqlColumnNumber = 7, SqlFieldName = MATADR_AdmDate ];

/// MATADR _AdmTime	诊疗时间
Property MATADRAdmTime As %Time [ SqlColumnNumber = 8, SqlFieldName = MATADR_AdmTime ];

/// MATADR _MainExp	事件主要表现
Property MATADRMainExp As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = MATADR_MainExp ];

/// MATADR _AdrDate	事件发生日期
Property MATADRAdrDate As %Date [ SqlColumnNumber = 10, SqlFieldName = MATADR_AdrDate ];

/// MATADR _DiscDate	事件发现日期
Property MATADRDiscDate As %Date [ SqlColumnNumber = 11, SqlFieldName = MATADR_DiscDate ];

/// MATADR _UsePlace	事件实际使用场所
Property MATADRUsePlace As %String [ SqlColumnNumber = 12, SqlFieldName = MATADR_UsePlace ];

/// MATADR _UsePlaceOth	事件实际使用场所其它
Property MATADRUsePlaceOth As %String [ SqlColumnNumber = 13, SqlFieldName = MATADR_UsePlaceOth ];

/// MATADR _EventDesc	事件陈述
Property MATADREventDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = MATADR_EventDesc ];

/// MATADR _ProName	产品名称
Property MATADRProName As %String [ SqlColumnNumber = 15, SqlFieldName = MATADR_ProName ];

/// MATADR _InciName	商品名称
Property MATADRInciName As %String [ SqlColumnNumber = 16, SqlFieldName = MATADR_InciName ];

/// MATADR _RegNo	注册证号
Property MATADRRegNo As %String [ SqlColumnNumber = 17, SqlFieldName = MATADR_RegNo ];

/// MATADR_ Manf	生产企业名称
Property MATADRManf As %String [ SqlColumnNumber = 18, SqlFieldName = MATADR_Manf ];

/// MATADR_ManfAddress	生产企业地址
Property MATADRManfAddress As %String [ SqlColumnNumber = 19, SqlFieldName = MATADR_ManfAddress ];

/// MATADR_ManfTel	生产企业电话
Property MATADRManfTel As %String [ SqlColumnNumber = 20, SqlFieldName = MATADR_ManfTel ];

/// MATADR_ Spec	规格
Property MATADRSpec As %String [ SqlColumnNumber = 21, SqlFieldName = MATADR_Spec ];

/// MATADR_ ProCode	产品编号
Property MATADRProCode As %String [ SqlColumnNumber = 22, SqlFieldName = MATADR_ProCode ];

/// MATADR_ProBatNo	产品批号
Property MATADRProBatNo As %String [ SqlColumnNumber = 23, SqlFieldName = MATADR_ProBatNo ];

/// MATADR_Operator	操作人
Property MATADROperator As %String [ SqlColumnNumber = 24, SqlFieldName = MATADR_Operator ];

/// MATADR_OperatorOth	操作人其它
Property MATADROperatorOth As %String [ SqlColumnNumber = 25, SqlFieldName = MATADR_OperatorOth ];

/// MATADR_ExpDate	有效期
Property MATADRExpDate As %Date [ SqlColumnNumber = 26, SqlFieldName = MATADR_ExpDate ];

/// MATADR_ProDate	生产日期
Property MATADRProDate As %Date [ SqlColumnNumber = 27, SqlFieldName = MATADR_ProDate ];

/// MATADR_DisDate	停用日期
Property MATADRDisDate As %Date [ SqlColumnNumber = 28, SqlFieldName = MATADR_DisDate ];

/// MATADR_UseDate	植入日期
Property MATADRUseDate As %Date [ SqlColumnNumber = 29, SqlFieldName = MATADR_UseDate ];

/// MATADR_ReasonDesc	原因分析
Property MATADRReasonDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 30, SqlFieldName = MATADR_ReasonDesc ];

/// MATADR_HandInfo	处理情况
Property MATADRHandInfo As %String(MAXLEN = 1000) [ SqlColumnNumber = 31, SqlFieldName = MATADR_HandInfo ];

/// MATADR_HandStatus	报告处理状态
Property MATADRHandStatus As %String [ SqlColumnNumber = 32, SqlFieldName = MATADR_HandStatus ];

/// MATADR_ProAdvice	省评价意见
Property MATADRProAdvice As %String(MAXLEN = 1000) [ SqlColumnNumber = 33, SqlFieldName = MATADR_ProAdvice ];

/// MATADR_CountryAdvice	国家意见
Property MATADRCountryAdvice As %String(MAXLEN = 1000) [ SqlColumnNumber = 34, SqlFieldName = MATADR_CountryAdvice ];

/// MATADR _ CarPrvTp	报告人职称
Property MATADRCarPrvTp As %String [ SqlColumnNumber = 35, SqlFieldName = MATADR_CarPrvTp ];

/// MATADR _ RepName	报告人
Property MATADRRepName As %String [ SqlColumnNumber = 36, SqlFieldName = MATADR_RepName ];

/// MATADR _ RepLocDr	报告人科室
Property MATADRRepLocDr As %String [ SqlColumnNumber = 37, SqlFieldName = MATADR_RepLocDr ];

/// MATADR _ RepTel	报告人联系电话
Property MATADRRepTel As %String [ SqlColumnNumber = 38, SqlFieldName = MATADR_RepTel ];

/// MATADR _RepEmail	报告人邮件
Property MATADRRepEmail As %String [ SqlColumnNumber = 39, SqlFieldName = MATADR_RepEmail ];

/// MATADR_CreateDate	报告创建日期
Property MATADRCreateDate As %Date [ SqlColumnNumber = 40, SqlFieldName = MATADR_CreateDate ];

/// MATADR_CreateTime	报告创建时间
Property MATADRCreateTime As %Time [ SqlColumnNumber = 41, SqlFieldName = MATADR_CreateTime ];

/// MATADR_CurStatus_DR	报告当前状态
Property MATADRCurStatusDR As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 42, SqlFieldName = MATADR_CurStatus_DR ];

/// MATADR_ExpectEff	预期治疗疾病或作用
Property MATADRExpectEff As %String [ SqlColumnNumber = 43, SqlFieldName = MATADR_ExpectEff ];

/// MATADR_AdrResult	不良后果
Property MATADRAdrResult As %String [ SqlColumnNumber = 44, SqlFieldName = MATADR_AdrResult ];

/// MATADR_DeathDate	死亡日期
Property MATADRDeathDate As %Date [ SqlColumnNumber = 45, SqlFieldName = MATADR_DeathDate ];

/// MATADR_DeathTime	死亡时间
Property MATADRDeathTime As %Time [ SqlColumnNumber = 46, SqlFieldName = MATADR_DeathTime ];

/// MATADR_Type_Dr	类别
Property MATADRTypeDr As User.DHCMedAdrRepEvent [ SqlColumnNumber = 47, SqlFieldName = MATADR_Type_Dr ];

/// MATADR_RepImpFlag 重点标记  Y N
Property MATADRRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = MATADR_RepImpFlag ];

/// MATADR_AdmNo 就诊ID
Property MATADRAdmNo As %String [ SqlColumnNumber = 49, SqlFieldName = MATADR_AdmNo ];

/// MATADR_IfReaOrder 发生事件是否有合理顺序
Property MATADRIfReaOrder As %String [ SqlColumnNumber = 50, SqlFieldName = MATADR_IfReaOrder ];

/// MATADR_IfDamageType 发生事件是否属于所使用医疗器械可能导致的伤害类型
Property MATADRIfDamageType As %String [ SqlColumnNumber = 51, SqlFieldName = MATADR_IfDamageType ];

/// MATADR_IfReasonable 发生事件是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
Property MATADRIfReasonable As %String [ SqlColumnNumber = 52, SqlFieldName = MATADR_IfReasonable ];

/// MATADR_RelEvaluation 关联性评价结果
Property MATADRRelEvaluation As %String [ SqlColumnNumber = 53, SqlFieldName = MATADR_RelEvaluation ];

/// MATADR_PatMedNo	病案号/住院号
Property MATADRPatMedNo As %String [ SqlColumnNumber = 54, SqlFieldName = MATADR_PatMedNo ];

/// MATADR_PatDOB	出生日期
Property MATADRPatDOB As %Date [ SqlColumnNumber = 55, SqlFieldName = MATADR_PatDOB ];

/// MATADR_PatContact	联系方式
Property MATADRPatContact As %String [ SqlColumnNumber = 56, SqlFieldName = MATADR_PatContact ];

/// MATADR_AuditDate    审核日期
Property MATADRAuditDate As %Date [ SqlColumnNumber = 57, SqlFieldName = MATADR_AuditDate ];

/// MATADR_PatLoc_DR	病人所在科室
Property MATADRPatLocDR As %String [ SqlColumnNumber = 58, SqlFieldName = MATADR_PatLoc_DR ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMATADRR)</SqlIdExpression>
<SQLMap name="IndexAuditDate">
<Global>^DHCMATADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MATADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MATADR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MATADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCMATADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MATADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MATADR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MATADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepNo">
<Global>^DHCMATADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MATADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MATADR_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MATADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MATADR_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MATADR_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MATADR_AdmTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MATADR_AdrDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MATADR_AdrResult">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MATADR_Age">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MATADR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MATADR_CarPrvTp">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MATADR_CountryAdvice">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MATADR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MATADR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MATADR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MATADR_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MATADR_DeathTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MATADR_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MATADR_DiscDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MATADR_EventDesc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MATADR_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MATADR_ExpectEff">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MATADR_HandInfo">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MATADR_HandStatus">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MATADR_IfDamageType">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MATADR_IfReaOrder">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MATADR_IfReasonable">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MATADR_InciName">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MATADR_MainExp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MATADR_Manf">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MATADR_ManfAddress">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MATADR_ManfTel">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MATADR_Name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MATADR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MATADR_Operator">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MATADR_OperatorOth">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MATADR_PatContact">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MATADR_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MATADR_PatId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MATADR_PatLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MATADR_PatMedNo">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MATADR_ProAdvice">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MATADR_ProBatNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MATADR_ProCode">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MATADR_ProDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MATADR_ProName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MATADR_ReasonDesc">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MATADR_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MATADR_RelEvaluation">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MATADR_RepEmail">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MATADR_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MATADR_RepLocDr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MATADR_RepName">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MATADR_RepTel">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MATADR_Sex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MATADR_Spec">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MATADR_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MATADR_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MATADR_UsePlace">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MATADR_UsePlaceOth">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCMATADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MATADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MATADR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMatAdrReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
