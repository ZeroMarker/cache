Class User.DHCAdvDrugReport Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADVDR_RowID, SqlTableName = DHC_AdvDrugReport, StorageStrategy = NewStorage1 ]
{

/// 原患疾病子表
Relationship ChildDHCPHADRREPDIAG As User.DHCAdvDrugRepDiag [ Cardinality = children, Inverse = ADVDRDADRRParref ];

/// 药品表子表	
Relationship ChildDHCPHADRREPDRUGITM As User.DHCAdvDrugRepItm [ Cardinality = children, Inverse = ADRRDIADRRParref ];

/// 事件名称子表
Relationship ChildDHCPHADVDREPEVENT As User.DHCAdvDrugRepEvent [ Cardinality = children, Inverse = ADVDREADRRParref ];

/// ADVDR_Code 报告单号
Property ADVDRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADVDR_Code ];

/// ADVDR_Priority 报告优先级  10-首次报告，11-跟踪报告
Property ADVDRPriority As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 3, SqlFieldName = ADVDR_Priority ];

/// ADVDR_RepType 报告类别  10-严重，11-一般
Property ADVDRRepType As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 4, SqlFieldName = ADVDR_RepType ];

/// ADVDR_DamSit 严重时损害
Property ADVDRDamSit As %Library.String [ SqlColumnNumber = 5, SqlFieldName = ADVDR_DamSit ];

/// ADVDR_DeptType  10医疗机构,11经营企业,12生产企业,13个人,99其它
Property ADVDRDeptType As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 6, SqlFieldName = ADVDR_DeptType ];

/// ADVDR_DeptElse  报告单位其它类型描述   其它
Property ADVDRDeptElse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ADVDR_DeptElse ];

/// ADVDR_Adm     就诊adm号
Property ADVDRAdm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ADVDR_Adm ];

/// ADVDR_PatID  患者ID   PA_PatMas
Property ADVDRPatID As %Library.String [ SqlColumnNumber = 9, SqlFieldName = ADVDR_PatID ];

/// ADVDR_PatName  患者姓名
Property ADVDRPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ADVDR_PatName ];

/// ADVDR_PatSex  性别
Property ADVDRPatSex As User.CTSex [ SqlColumnNumber = 11, SqlFieldName = ADVDR_PatSex ];

/// ADVDR_PatAge  年龄
Property ADVDRPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ADVDR_PatAge ];

/// ADVDR_PatDOB  出生日期
Property ADVDRPatDOB As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = ADVDR_PatDOB ];

/// ADVDR_PatNation  民族
Property ADVDRPatNation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ADVDR_PatNation ];

/// ADVDR_PatWeight  体重
Property ADVDRPatWeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ADVDR_PatWeight ];

/// ADVDR_PatContact   联系方式
Property ADVDRPatContact As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ADVDR_PatContact ];

///  ADVDR_Hosp  医院代码
Property ADVDRHosp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ADVDR_Hosp ];

/// ADVDR_PatMedNo    病历号
Property ADVDRPatMedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ADVDR_PatMedNo ];

/// ADVDR_ImportInfo  相关重要信息  10吸烟史11饮酒史12妊娠期13肝病史14肾病史 15过敏史,16其它(该字段多选用逗号间隔)
Property ADVDRImportInfo As %Library.String [ SqlColumnNumber = 19, SqlFieldName = ADVDR_ImportInfo ];

/// ADVDR_EventHistory  既往药品不良反应事件  10,有11,无,12不详
Property ADVDREventHistory As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 20, SqlFieldName = ADVDR_EventHistory ];

/// ADVDR_EventHistDesc   既往药品不良反应事件[描述]
Property ADVDREventHistDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ADVDR_EventHistDesc ];

/// ADVDR_EventFamily  家族药品不良反应事件  10,有11,无,12不详
Property ADVDREventFamily As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 22, SqlFieldName = ADVDR_EventFamily ];

/// ADVDR_EventFamiDesc   家族药品不良反应事件  家族药品不良反应事件描述
Property ADVDREventFamiDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ADVDR_EventFamiDesc ];

/// ADVDR_ADRE_Dr  事件名称   DHC_AdvDrugEvent
Property ADVDRADREDr As User.DHCAdvDrugEvent [ SqlColumnNumber = 24, SqlFieldName = ADVDR_ADRE_Dr ];

/// ADVDR_DateOccu  事件发生日期
Property ADVDRDateOccu As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = ADVDR_DateOccu ];

/// ADVDR_TimeOccu  事件发生时间
Property ADVDRTimeOccu As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = ADVDR_TimeOccu ];

/// ADVDR_Result  事件的结果   10痊愈、11好转、12未好转、99不详、13有后疑症、14死亡
Property ADVDRResult As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 27, SqlFieldName = ADVDR_Result ];

/// ADVDR_ResultDesc  事件的结果描述  后疑症表现、直接死因
Property ADVDRResultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = ADVDR_ResultDesc ];

/// ADVDR_DateResult  好转(死亡)日期
Property ADVDRDateResult As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = ADVDR_DateResult ];

/// ADVDR_TimeResult  好转(死亡)时间
Property ADVDRTimeResult As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = ADVDR_TimeResult ];

/// ADVDR_StopResultt  停药后是否减轻  10是、11否、99不详、12未停药或未减量
Property ADVDRStopResultt As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 31, SqlFieldName = ADVDR_StopResultt ];

/// ADVDR_TakingAgain  再次使用时是否再次出现同样反应
Property ADVDRTakingAgain As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 32, SqlFieldName = ADVDR_TakingAgain ];

/// ADVDR_EffectOfTreatment  对原疾病的影响   10不明显、11病程延长、12病情加重、13导致后疑症、14导致死亡
Property ADVDREffectOfTreatment As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 33, SqlFieldName = ADVDR_EffectOfTreatment ];

/// ADVDR_CommentOfUser  关联性评价之报告人评价  10肯定、11很可能、12可能、13可能无关、14待评价、15无法评价
Property ADVDRCommentOfUser As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 34, SqlFieldName = ADVDR_CommentOfUser ];

/// ADVDR_UserOfReport  报告人评价签字
Property ADVDRUserOfReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = ADVDR_UserOfReport ];

/// ADVDR_CommentOfDept  关联性评价之报告单位评价  10肯定、11很可能、12可能、13可能无关、14待评价、15无法评价
Property ADVDRCommentOfDept As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 36, SqlFieldName = ADVDR_CommentOfDept ];

/// ADVDR_DeptOfReport  报告单位评价签字  单位名或负责人名
Property ADVDRDeptOfReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = ADVDR_DeptOfReport ];

/// ADVDR_Telephone  报告人联系电话
Property ADVDRTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = ADVDR_Telephone ];

/// ADVDR_CareerOfRepUser  报告人职业  10医生、11药师、12护士、99其它
Property ADVDRCareerOfRepUser As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 39, SqlFieldName = ADVDR_CareerOfRepUser ];

/// ADVDR_CareerOfRepElse  报告人职业  其它职业描述
Property ADVDRCareerOfRepElse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = ADVDR_CareerOfRepElse ];

/// ADVDR_EmailOfRepUser  报告人邮箱
Property ADVDREmailOfRepUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = ADVDR_EmailOfRepUser ];

/// ADVDR_RepUser  报告人  用户工号
Property ADVDRRepUser As %Library.String [ SqlColumnNumber = 42, SqlFieldName = ADVDR_RepUser ];

/// ADVDR_LocOfReporter  报告人所属科室
Property ADVDRLocOfReporter As %Library.String [ SqlColumnNumber = 43, SqlFieldName = ADVDR_LocOfReporter ];

/// ADVDR_ProTitleOfReporter  报告人职称	CT_CarPrvTp职称代码
Property ADVDRProTitleOfReporter As User.CTCarPrvTp [ SqlColumnNumber = 44, SqlFieldName = ADVDR_ProTitleOfReporter ];

/// ADVDR_DeptName  报告单位名称  医院代码
Property ADVDRDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = ADVDR_DeptName ];

/// ADVDR_DeptContacts  报告单位联系人  工号
Property ADVDRDeptContacts As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = ADVDR_DeptContacts ];

/// ADVDR_DeptTel  报告单位联系电话
Property ADVDRDeptTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = ADVDR_DeptTel ];

/// ADVDR_Remark  备注
Property ADVDRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = ADVDR_Remark ];

/// ADVDR_CurStatus_DR  当前状态
Property ADVDRCurStatusDR As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 49, SqlFieldName = ADVDR_CurStatus_DR ];

/// ADVDR_ReportType  报告类型
Property ADVDRReportType As User.DHCMedAdrRepEvent [ SqlColumnNumber = 50, SqlFieldName = ADVDR_ReportType ];

/// ADVDR_ImportInfoOth 重要信息其他
Property ADVDRImportInfoOth As %Library.String [ SqlColumnNumber = 51, SqlFieldName = ADVDR_ImportInfoOth ];

/// ADVDR_RepDate 报告日期
Property ADVDRRepDate As %Library.Date [ SqlColumnNumber = 52, SqlFieldName = ADVDR_RepDate ];

/// ADVDR_RepTime 报告时间
Property ADVDRRepTime As %Library.Time [ SqlColumnNumber = 53, SqlFieldName = ADVDR_RepTime ];

/// ADVDR_RepProc 过程描述
Property ADVDRRepProc As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = ADVDR_RepProc ];

/// ADVDR_RepNew  报告类型新的 Y  N
Property ADVDRRepNew As %Library.String [ SqlColumnNumber = 55, SqlFieldName = ADVDR_RepNew ];

/// ADVDR_RepImpFlag 重点标记  Y N
Property ADVDRRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = ADVDR_RepImpFlag ];

/// ADVDR_AnonymFlag 匿名标记
Property ADVDRAnonymFlag As %String [ SqlColumnNumber = 57, SqlFieldName = ADVDR_AnonymFlag ];

///    ADVDR_PatOriginalDis 原患疾病
///    Property ADVDRPatOriginalDis As %Library.String [ SqlColumnNumber = 57, SqlFieldName = ADVDR_PatOriginalDis ];
///    ADVDR_PosOfReporter  报告人职务
///    Property ADVDRPosOfReporter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = ADVDR_PosOfReporter ];
///    ADVDR_Wishes  报告人意愿
///    Property ADVDRWishes As %Library.String [ SqlColumnNumber = 57, SqlFieldName = ADVDR_Wishes ];
/// ADVDR_ManfSource	生产企业请填写信息来源
Property ADVDRManfSource As %String [ SqlColumnNumber = 58, SqlFieldName = ADVDR_ManfSource ];

/// ADVDR_ManfSourOth	其他
Property ADVDRManfSourOth As %String [ SqlColumnNumber = 59, SqlFieldName = ADVDR_ManfSourOth ];

/// ADVDR_AuditDate	审核日期
Property ADVDRAuditDate As %Library.Date [ SqlColumnNumber = 60, SqlFieldName = ADVDR_AuditDate ];

/// ADVDR_PatLoc_DR	病人所在科室
Property ADVDRPatLocDR As %String [ SqlColumnNumber = 61, SqlFieldName = ADVDR_PatLoc_DR ];

/// ADVDR_EventSimilIn  国内无类似不良反应（包括文献报道）  10,有11,无,12不详
Property ADVDREventSimilIn As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 62, SqlFieldName = ADVDR_EventSimilIn ];

/// ADVDR_EventSimilOut  国外无类似不良反应（包括文献报道）  10,有11,无,12不详
Property ADVDREventSimilOut As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 63, SqlFieldName = ADVDR_EventSimilOut ];

/// ADVDR_CommentProvincial  关联性评价之省级药品不良反应监测机构  10肯定、11很可能、12可能、13可能无关、14待评价、15无法评价
Property ADVDRCommentProvincial As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 64, SqlFieldName = ADVDR_CommentProvincial ];

/// ADVDR_ProvincialReport  省级药品不良反应监测机构签字  
Property ADVDRProvincialReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = ADVDR_ProvincialReport ];

/// ADVDR_CommentNation  关联性评价之国家药品不良反应监测中心  10肯定、11很可能、12可能、13可能无关、14待评价、15无法评价
Property ADVDRCommentNation As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 66, SqlFieldName = ADVDR_CommentNation ];

/// ADVDR_NationReport  国家药品不良反应监测中心签字
Property ADVDRNationReport As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = ADVDR_NationReport ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVDRUGREP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADVDR_ADRE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ADVDR_Adm">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADVDR_AnonymFlag">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ADVDR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="ADVDR_CareerOfRepElse">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ADVDR_CareerOfRepUser">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ADVDR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVDR_CommentNation">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="ADVDR_CommentOfDept">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ADVDR_CommentOfUser">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ADVDR_CommentProvincial">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="ADVDR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ADVDR_DamSit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADVDR_DateOccu">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ADVDR_DateResult">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ADVDR_DeptContacts">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ADVDR_DeptElse">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADVDR_DeptName">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ADVDR_DeptOfReport">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ADVDR_DeptTel">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ADVDR_DeptType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADVDR_EffectOfTreatment">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ADVDR_EmailOfRepUser">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ADVDR_EventFamiDesc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADVDR_EventFamily">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADVDR_EventHistDesc">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADVDR_EventHistory">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADVDR_EventSimilIn">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="ADVDR_EventSimilOut">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="ADVDR_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADVDR_ImportInfo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADVDR_ImportInfoOth">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ADVDR_LocOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ADVDR_ManfSourOth">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ADVDR_ManfSource">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ADVDR_NationReport">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="ADVDR_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADVDR_PatContact">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADVDR_PatDOB">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADVDR_PatID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADVDR_PatLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ADVDR_PatMedNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADVDR_PatName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADVDR_PatNation">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADVDR_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADVDR_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADVDR_Priority">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADVDR_ProTitleOfReporter">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ADVDR_ProvincialReport">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="ADVDR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ADVDR_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ADVDR_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ADVDR_RepNew">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="ADVDR_RepProc">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ADVDR_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ADVDR_RepType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADVDR_RepUser">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ADVDR_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ADVDR_Result">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ADVDR_ResultDesc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ADVDR_StopResultt">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ADVDR_TakingAgain">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ADVDR_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ADVDR_TimeOccu">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ADVDR_TimeResult">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ADVDR_UserOfReport">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVDR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVDR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVDR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVDR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVDR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDR_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVDR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepNo">
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVDR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDR_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVDR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDrugReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
