Class User.DHCMedAdrReport Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDADR_RowID, SqlTableName = DHC_MedAdrReport, StorageStrategy = NewStorage1 ]
{

/// MEDADR_No	报告单号
Property MEDADRNo As %String [ SqlColumnNumber = 2, SqlFieldName = MEDADR_No ];

/// MEDADR_Sex	性别
Property MEDADRSex As User.CTSex [ SqlColumnNumber = 3, SqlFieldName = MEDADR_Sex ];

/// MEDADR_Age	年龄
Property MEDADRAge As %String [ SqlColumnNumber = 4, SqlFieldName = MEDADR_Age ];

/// MEDADR_Job	职别
Property MEDADRJob As %String [ SqlColumnNumber = 5, SqlFieldName = MEDADR_Job ];

/// MEDADR_AdmDate	诊疗日期
Property MEDADRAdmDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MEDADR_AdmDate ];

/// MEDADR_AdmTime	诊疗时间
Property MEDADRAdmTime As %Time [ SqlColumnNumber = 7, SqlFieldName = MEDADR_AdmTime ];

/// MEDADR_LiveLoc	现场相关科室
Property MEDADRLiveLoc As %String [ SqlColumnNumber = 8, SqlFieldName = MEDADR_LiveLoc ];

/// MEDADR_Result	不良后果
Property MEDADRResult As %String [ SqlColumnNumber = 9, SqlFieldName = MEDADR_Result ];

/// MEDADR_ResultDesc	不良后果描述
Property MEDADRResultDesc As %String [ SqlColumnNumber = 10, SqlFieldName = MEDADR_ResultDesc ];

/// MEDADR_ProcDesc	过程描述
Property MEDADRProcDesc As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MEDADR_ProcDesc ];

/// MEDADR_Level	等级
Property MEDADRLevel As %String [ SqlColumnNumber = 12, SqlFieldName = MEDADR_Level ];

/// MEDADR_Reason	原因
Property MEDADRReason As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MEDADR_Reason ];

/// MEDADR_HandInfo	处理情况
Property MEDADRHandInfo As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MEDADR_HandInfo ];

/// MEDADR_Advice	处理意见
Property MEDADRAdvice As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MEDADR_Advice ];

/// MEDADR_Improvie	改进情况
Property MEDADRImprovie As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MEDADR_Improvie ];

/// MEDADR_RepUserCareer	报告人职业
Property MEDADRRepUserCareer As %String [ SqlColumnNumber = 17, SqlFieldName = MEDADR_RepUserCareer ];

/// MEDADR_PartyType	当事人类别
Property MEDADRPartyType As %String [ SqlColumnNumber = 18, SqlFieldName = MEDADR_PartyType ];

/// MEDADR_ CarPrvTp	报告人职称
Property MEDADRCarPrvTp As %String [ SqlColumnNumber = 19, SqlFieldName = MEDADR_CarPrvTp ];

/// MEDADR_ RepName	报告人
Property MEDADRRepName As %String [ SqlColumnNumber = 20, SqlFieldName = MEDADR_RepName ];

/// MEDADR_ RepLocDr	报告人科室
Property MEDADRRepLocDr As %String [ SqlColumnNumber = 21, SqlFieldName = MEDADR_RepLocDr ];

/// MEDADR_ RepTel	报告人联系电话
Property MEDADRRepTel As %String [ SqlColumnNumber = 22, SqlFieldName = MEDADR_RepTel ];

/// MEDADR_ Email	报告人邮件
Property MEDADREmail As %String [ SqlColumnNumber = 23, SqlFieldName = MEDADR_Email ];

/// MEDADR_PatID	病人ID
Property MEDADRPatID As %String [ SqlColumnNumber = 24, SqlFieldName = MEDADR_PatID ];

/// MEDADR_AdrPlace	不良事件场所
Property MEDADRAdrPlace As %String [ SqlColumnNumber = 25, SqlFieldName = MEDADR_AdrPlace ];

/// MEDADR_CreateDate	创建日期
Property MEDADRCreateDate As %Date [ SqlColumnNumber = 26, SqlFieldName = MEDADR_CreateDate ];

/// MEDADR_CreateTime	创建时间
Property MEDADRCreateTime As %Time [ SqlColumnNumber = 27, SqlFieldName = MEDADR_CreateTime ];

/// MEDADR_CurStatus_DR	当前状态
Property MEDADRCurStatusDR As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 28, SqlFieldName = MEDADR_CurStatus_DR ];

/// MEDADR_Remark	备注
Property MEDADRRemark As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MEDADR_Remark ];

/// MEDADR_AdrPlaceOth	不良事件场所其它
Property MEDADRAdrPlaceOth As %String [ SqlColumnNumber = 30, SqlFieldName = MEDADR_AdrPlaceOth ];

/// MEDADR_ReportType	报告类型
Property MEDADRReportType As %String [ SqlColumnNumber = 31, SqlFieldName = MEDADR_ReportType ];

/// MEDADR_AnonymFlag	匿名标志
Property MEDADRAnonymFlag As %String [ SqlColumnNumber = 32, SqlFieldName = MEDADR_AnonymFlag ];

/// MEDADR_RepImpFlag 重点标记  Y N
Property MEDADRRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = MEDADR_RepImpFlag ];

/// MEDADR_AdmNo 就诊ID
Property MEDADRAdmNo As %String [ SqlColumnNumber = 34, SqlFieldName = MEDADR_AdmNo ];

/// MEDADR_DateOccu  事件发生日期
Property MEDADRDateOccu As %Library.Date [ SqlColumnNumber = 35, SqlFieldName = MEDADR_DateOccu ];

/// MEDADR_TimeOccu  事件发生时间
Property MEDADRTimeOccu As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = MEDADR_TimeOccu ];

/// MEDADR_PatType 病人职别
Property MEDADRPatType As %String [ SqlColumnNumber = 37, SqlFieldName = MEDADR_PatType ];

/// MEDADR_PatMedType 病人医疗类别
Property MEDADRPatMedType As %String [ SqlColumnNumber = 38, SqlFieldName = MEDADR_PatMedType ];

/// MEDADR_PatStatus 事件发生前病人所处状态
Property MEDADRPatStatus As %String [ SqlColumnNumber = 39, SqlFieldName = MEDADR_PatStatus ];

/// MEDADR_PatImpairment 给病人造成的功能损害
Property MEDADRPatImpairment As %String [ SqlColumnNumber = 40, SqlFieldName = MEDADR_PatImpairment ];

/// MEDADR_ServiceType 提供何种服务时发生
Property MEDADRServiceType As User.DHCAdvServiceType [ SqlColumnNumber = 41, SqlFieldName = MEDADR_ServiceType ];

/// MEDADR_PartyFactors 与当事人可能相关因素
Property MEDADRPartyFactors As %String [ SqlColumnNumber = 42, SqlFieldName = MEDADR_PartyFactors ];

/// MEDADR_HospDesc	医院名称
Property MEDADRHospDesc As %String [ SqlColumnNumber = 43, SqlFieldName = MEDADR_HospDesc ];

/// MEDADR_PDescDate 事件过程描述日期
Property MEDADRPDescDate As %Library.Date [ SqlColumnNumber = 44, SqlFieldName = MEDADR_PDescDate ];

/// MEDADR_PDescTime	事件过程描述时间
Property MEDADRPDescTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = MEDADR_PDescTime ];

/// MEDADR_PDescUser	事件过程描述签名
Property MEDADRPDescUser As User.SSUser [ SqlColumnNumber = 46, SqlFieldName = MEDADR_PDescUser ];

/// ADVDR_ReasonDate	存在隐患日期
Property ADVDRReasonDate As %Library.Date [ SqlColumnNumber = 47, SqlFieldName = ADVDR_ReasonDate ];

/// ADVDR_ReasonTime	存在隐患时间
Property ADVDRReasonTime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = ADVDR_ReasonTime ];

/// ADVDR_ReasonUser	存在隐患签名
Property ADVDRReasonUser As User.SSUser [ SqlColumnNumber = 49, SqlFieldName = ADVDR_ReasonUser ];

/// ADVDR_HInfoDate	改进建议日期
Property ADVDRHInfoDate As %Library.Date [ SqlColumnNumber = 50, SqlFieldName = ADVDR_HInfoDate ];

/// ADVDR_HInfoTime	改进建议时间
Property ADVDRHInfoTime As %Library.Time [ SqlColumnNumber = 51, SqlFieldName = ADVDR_HInfoTime ];

/// ADVDR_HInfoUser	改进建议签名
Property ADVDRHInfoUser As User.SSUser [ SqlColumnNumber = 52, SqlFieldName = ADVDR_HInfoUser ];

/// MEDADR_AuditDate    	审核日期
Property MEDADRAuditDate As %Library.Date [ SqlColumnNumber = 53, SqlFieldName = MEDADR_AuditDate ];

/// MEDADR_StaffName 医院职工姓名(保存没有就诊号的人员）
Property MEDADRStaffName As %String [ SqlColumnNumber = 54, SqlFieldName = MEDADR_StaffName ];

/// MEDADR_PatLoc_DR 病人所在科室
Property MEDADRPatLocDR As %String [ SqlColumnNumber = 55, SqlFieldName = MEDADR_PatLoc_DR ];

/// MEDADR_Litigand 当事人
Property MEDADRLitigand As %String [ SqlColumnNumber = 56, SqlFieldName = MEDADR_Litigand ];

/// MEDADR_LitigandPost 当事人职位
Property MEDADRLitigandPost As %String [ SqlColumnNumber = 57, SqlFieldName = MEDADR_LitigandPost ];

/// MEDADR_LitigandJobYea 当事人工作年限
Property MEDADRLitigandJobYea As %String [ SqlColumnNumber = 58, SqlFieldName = MEDADR_LitigandJobYea ];

/// MEDADR_EventLevel   医疗安全事件类别 add lp
Property MEDADREventLevel As %String [ SqlColumnNumber = 59, SqlFieldName = MEDADR_EventLevel ];

/// MEDADR_InjuryLevel  损害轻重程度 add lp
Property MEDADRInjuryLevel As %String [ SqlColumnNumber = 60, SqlFieldName = MEDADR_InjuryLevel ];

/// MEDADR_PatName  病人姓名 add lp
Property MEDADRPatName As %String [ SqlColumnNumber = 61, SqlFieldName = MEDADR_PatName ];

/// MEDADR_TimePer	发生时间段
Property MEDADRTimePer As %String [ SqlColumnNumber = 62, SqlFieldName = MEDADR_TimePer ];

/// MEDADR_RepTypeOth	不良事件类型其他
Property MEDADRRepTypeOth As %String [ SqlColumnNumber = 63, SqlFieldName = MEDADR_RepTypeOth ];

/// MEDADR_PartyTel	当事人电话
Property MEDADRPartyTel As %String [ SqlColumnNumber = 64, SqlFieldName = MEDADR_PartyTel ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMEDADRR)</SqlIdExpression>
<SQLMap name="IndexAuditDate">
<Global>^DHCMEDADRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCMEDADRR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADVDR_HInfoDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ADVDR_HInfoTime">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ADVDR_HInfoUser">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ADVDR_ReasonDate">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ADVDR_ReasonTime">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ADVDR_ReasonUser">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MEDADR_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDADR_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MEDADR_AdmTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEDADR_AdrPlace">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MEDADR_AdrPlaceOth">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MEDADR_Advice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEDADR_Age">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDADR_AnonymFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MEDADR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MEDADR_CarPrvTp">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MEDADR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MEDADR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MEDADR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MEDADR_DateOccu">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MEDADR_Email">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MEDADR_EventLevel">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MEDADR_HandInfo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEDADR_HospDesc">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MEDADR_Improvie">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEDADR_InjuryLevel">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="MEDADR_Job">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDADR_Level">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEDADR_Litigand">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MEDADR_LitigandJobYea">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MEDADR_LitigandPost">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MEDADR_LiveLoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEDADR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDADR_PDescDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MEDADR_PDescTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MEDADR_PDescUser">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MEDADR_PartyFactors">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MEDADR_PartyTel">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="MEDADR_PartyType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MEDADR_PatID">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MEDADR_PatImpairment">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MEDADR_PatLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MEDADR_PatMedType">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MEDADR_PatName">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="MEDADR_PatStatus">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MEDADR_PatType">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MEDADR_ProcDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEDADR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEDADR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MEDADR_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MEDADR_RepLocDr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MEDADR_RepName">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MEDADR_RepTel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MEDADR_RepTypeOth">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="MEDADR_RepUserCareer">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEDADR_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MEDADR_Result">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEDADR_ResultDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEDADR_ServiceType">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MEDADR_Sex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDADR_StaffName">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MEDADR_TimeOccu">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MEDADR_TimePer">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Global>^DHCMEDADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDADR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDADR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
