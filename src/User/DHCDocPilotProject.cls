/// PH-PilotProject
Class User.DHCDocPilotProject Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PP_RowId, SqlTableName = DHC_DocPilotProject, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocPilotProState As User.DHCDocPilotProState [ Cardinality = children, Inverse = PPSPPParRef ];

Relationship ChildDHCDocPilotProRem As User.DHCDocPilotProRem [ Cardinality = children, Inverse = PPRPPParRef ];

Relationship ChildDHCDocPilotProCare As User.DHCDocPilotProCare [ Cardinality = children, Inverse = PPCPPPParRef ];

Relationship ChildDHCDocPilotProPat As User.DHCDocPilotProPat [ Cardinality = children, Inverse = PPPPPParRef ];

Relationship ChildDHCDocPilotProDept As User.DHCDocPilotProDept [ Cardinality = children, Inverse = PPDPPParRef ];

Relationship ChildDHCDocPilotProSAE As User.DHCDocPilotProSAE [ Cardinality = children, Inverse = PPSAEPPParRef ];

Relationship ChildDHCDocPilotProSettle As User.DHCDocPilotProSettle [ Cardinality = children, Inverse = PPSETPPParRef ];

Relationship ChildDHCDocPilotProYearCheck As User.DHCDocPilotProYearCheck [ Cardinality = children, Inverse = PPYKPPParRef ];

Relationship ChildDHCDocPilotProQCZYZ As User.DHCDocPilotProQCZYZ [ Cardinality = children, Inverse = PPQCZYZPPParRef ];

Relationship ChildDHCDocPilotProFreeOrd As User.DHCDocPilotProFreeOrd [ Cardinality = children, Inverse = PPFPPPParRef ];

/// 项目代码
Property PPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PP_Code ];

/// 项目名称
Property PPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PP_Desc ];

/// 项目目的
Property PPOrder As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PP_Order ];

/// 项目结果
Property PPResult As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PP_Result ];

/// 项目备注
Property PPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PP_Remark ];

/// 立项科室
Property PPCreateDepartmentDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = PP_CreateDepartment_Dr ];

/// 创建人
Property PPCreateUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PP_CreateUser_Dr ];

/// 创建日期
Property PPCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PP_CreateDate ];

/// 创建时间
Property PPCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PP_CreateTime ];

/// 主要研究者
Property PPStartUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PP_StartUser_Dr ];

/// 项目开始日期
Property PPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PP_StartDate ];

/// 项目结束操作人
Property PPEndUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PP_EndUser_Dr ];

/// 项目结束日期
Property PPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PP_EndDate ];

/// 项目结束时间
Property PPEndTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PP_EndTime ];

/// 项目预算
Property PPBudget As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PP_Budget ];

/// 项目状态 Normal立项,Abort暂停,Strike终止,Verify在研,UnApproved未批准,InApprove审批中,Finish已完成,Hang未进行，Break中止,Excep非大表数据，C发布后在研，didnotpass上会未通过只有财务用到
Property PPState As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike,Verify,UnApproved,InApprove,Finish,Hang,Break,NotPass,Didnotpass,Public", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,V,U,I,F,H,B,E,D,P") [ SqlColumnNumber = 17, SqlFieldName = PP_State ];

/// 适应证
Property Indication As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PP_Indication ];

/// 类别
Property PilotCategoryDr As User.DHCDocCTDefineData [ SqlColumnNumber = 19, SqlFieldName = PP_PilotCategory_Dr ];

/// 伦理资料去向情况
Property EthicsFilesNextStateDr As User.DHCDocCTDefineData [ SqlColumnNumber = 20, SqlFieldName = PP_EthicsFilesNextState_Dr ];

/// 伦理委员会档案情况
Property EthicsFilesStateDr As User.DHCDocCTDefineData [ SqlColumnNumber = 21, SqlFieldName = PP_EthicsFilesState_Dr ];

/// 试验资料情况
Property ProjectFilesStateDr As User.DHCDocCTDefineData [ SqlColumnNumber = 22, SqlFieldName = PP_ProjectFilesState_Dr ];

/// 是否是组长
Property IsHeadmanDr As User.DHCDocCTDefineData [ SqlColumnNumber = 23, SqlFieldName = PP_IsHeadman_Dr ];

/// 申请事项
Property ApplyMatterDr As User.DHCDocCTDefineData [ SqlColumnNumber = 24, SqlFieldName = PP_ApplyMatter_Dr ];

/// 申请期
Property ApplyStageDr As User.DHCDocCTDefineData [ SqlColumnNumber = 25, SqlFieldName = PP_ApplyStage_Dr ];

/// 申请人
Property ApplicationUnit As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PP_ApplicationUnit ];

/// 方案编号
Property PlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PP_PlanNo ];

/// 方案名称
Property PlanName As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PP_PlanName ];

/// 批件号
Property ApprovalNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PP_ApprovalNo ];

/// 多研究中心状态
Property Role As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PP_Role ];

/// 检验报告批号 
Property ExamReportNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PP_ExamReportNum ];

/// 资料提交日期
Property FileSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = PP_FileSubmitDate ];

/// 伦理委员会上会日期（最早）
Property EthicsMeetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = PP_EthicsMeetDate ];

/// 伦理委员会批准日期
Property EthicsMeetAduitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = PP_EthicsMeetAduitDate ];

/// 档案文件夹编号
Property ArchivesFilesNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PP_ArchivesFilesNo ];

/// 统计单位
Property CollectCompany As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PP_CollectCompany ];

/// 伦理资料销毁(回收)日期
Property EthicsFilesOffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = PP_EthicsFilesOffDate ];

/// 签署协议日期
Property SignProtocolDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = PP_SignProtocolDate ];

/// 组长单位
Property LeaderCompany As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PP_LeaderCompany ];

/// 组长单位PI
Property LeaderCompanyPI As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = PP_LeaderCompanyPI ];

/// CRO公司
Property CROCompany As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PP_CROCompany ];

/// 亚类别
Property SubPilotCategoryDr As User.DHCDocCTDefineData [ SqlColumnNumber = 42, SqlFieldName = PP_SubPilotCategory_Dr ];

/// 申办方联系人
Property ApplyContact As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PP_ApplyContact ];

/// 申办方联系人电话
Property ApplyContactTel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PP_ApplyContactTel ];

/// CRO联系人
Property CROContact As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = PP_CROContact ];

/// CRO联系人电话
Property CROContactTel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = PP_CROContactTel ];

/// 预审结果
Property ApproveResult As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = PP_ApproveResult ];

/// 伦理委员会审查结果 
Property EcResultDr As User.DHCDocCTDefineData [ SqlColumnNumber = 48, SqlFieldName = PP_EcResultDr_Dr ];

/// CPRC审查意见
Property CPRCApproveResult As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = PP_CPRCApproveResult ];

/// CPRC审查日期
Property CPRCApproveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 50, SqlFieldName = PP_CPRCApproveDate ];

/// 汇款账号
Property PayAccount As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = PP_PayAccount ];

/// 到账金额
Property TotalPayment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = PP_TotalPayment ];

/// 完成年度
Property EndYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = PP_EndYear ];

/// 科室编号
Property DeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = PP_DeptCode ];

/// 项目编号
Property ProjectNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = PP_ProjectNo ];

/// 档案柜编号
Property FileCaseNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = PP_FileCaseNo ];

/// 统计单位联系人
Property CountUnitContact As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = PP_CountUnitContact ];

/// 统计单位联系人电话
Property CountUnitContactTel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = PP_CountUnitContactTel ];

/// 试验设计总例数
Property DesignCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = PP_DesignCaseNum ];

/// 本专业组拟承担例数
Property LocalGroupPlanCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = PP_LocalGroupPlanCaseNum ];

/// 本专业组实际完成例数
Property LocalGroupFactCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = PP_LocalGroupFactCaseNum ];

/// 最后一例出组日期
Property LastCaseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 62, SqlFieldName = PP_LastCaseDate ];

/// 筛选例数
Property FilterCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = PP_FilterCaseNum ];

/// 剔除例数
Property RejectCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = PP_RejectCaseNum ];

/// 脱落例数
Property DropCaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = PP_DropCaseNum ];

/// SAE例数
Property SAECaseNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = PP_SAECaseNum ];

/// 小结日期
Property BriefDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 67, SqlFieldName = PP_BriefDate ];

/// 关中心日期
Property CenterDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 68, SqlFieldName = PP_CenterDate ];

/// 总结日期
Property SumDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 69, SqlFieldName = PP_SumDate ];

/// 归档情况
Property FilingstatusDr As User.DHCDocCTDefineData [ SqlColumnNumber = 70, SqlFieldName = PP_Filingstatus_Dr ];

/// 归档日期
Property FilingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 71, SqlFieldName = PP_FilingDate ];

/// 保存至
Property SaveLastDate As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = PP_SaveLastDate ];

/// 专业组移交人
Property GroupTransferUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = PP_GroupTransferUser ];

/// 案卷接收人
Property recipient As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = PP_recipient ];

/// 档案销毁状态
Property EthicsFilesOffStatusDr As User.DHCDocCTDefineData [ SqlColumnNumber = 75, SqlFieldName = PP_EthicsFilesOffStatus_Dr ];

/// 销毁经办人姓名
Property EthicsFilesOffOperator As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = PP_EthicsFilesOffOperator ];

/// 经办人单位
Property EthicsFilesOffCompany As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = PP_EthicsFilesOffCompany ];

/// 经办人联系电话
Property EthicsFilesOffTel As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = PP_EthicsFilesOffTel ];

/// 影像资料位置
Property ImageDataLocation As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = PP_ImageDataLocation ];

/// 影像资料份数
Property ImageDataNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = PP_ImageDataNum ];

/// 文件夹数目
Property FileNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = PP_FileNum ];

/// 知情同意书数目
Property FormConsentNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = PP_FormConsentNum ];

/// 病例报告表数目
Property CaseReportNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = PP_CaseReportNum ];

/// 伦理资料数目
Property EthicsFilesNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = PP_EthicsFilesNum ];

/// 原始记录数目
Property OrigRecordNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 85, SqlFieldName = PP_OrigRecordNum ];

/// 总份数
Property TotalFileNum As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = PP_TotalFileNum ];

/// 合同总额
Property ToalAgree As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = PP_ToalAgree ];

/// SFDA现场核查时间
Property DrugExamCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 88, SqlFieldName = PP_DrugExamCheckDate ];

/// SFDA现场核查备注
Property DrugExamCheckFlag As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = PP_DrugExamCheckFlag ];

/// 资格认定复核抽查时间
Property DrugExamSelectCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 90, SqlFieldName = PP_DrugExamSelectCheckDate ];

/// 资格认定复核抽查备注
Property DrugExamSelectCheckFlag As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = PP_DrugExamSelectCheckFlag ];

/// FDA视察时间
Property DrugExamInspectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 92, SqlFieldName = PP_DrugExamInspectDate ];

/// FDA视察时间备注
Property DrugExamInspectFlag As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = PP_DrugExamInspectFlag ];

/// 结账分配次数
Property DistributionCount As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = PP_DistributionCount ];

/// 是否需要跟踪审查
Property IsNeedCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 95, SqlFieldName = PP_IsNeedCheck ];

/// 跟踪审查频率
Property CheckFreqDr As User.DHCDocCTDefineData [ SqlColumnNumber = 96, SqlFieldName = PP_CheckFreq_Dr ];

/// 第一例受试病人签署合同日期
Property FirstPatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 97, SqlFieldName = PP_FirstPatDate ];

/// 年度报告调查日期
Property YearCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 98, SqlFieldName = PP_YearCheckDate ];

/// /核对人
Property CheckPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = PP_CheckPerson ];

/// 入组人数
Property InGroupNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = PP_InGroupNum ];

/// 第一例知情同意书日期 （暂不用）跟第一例受试病人签署合同日期应该是同一日期
Property FirstFormConsentDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 101, SqlFieldName = PP_FirstFormConsentDate ];

/// 委托研究者
Property UserUserDr As User.SSUser [ SqlColumnNumber = 102, SqlFieldName = PP_UserUser_Dr ];

/// 预审修改意见
Property ApproveOpinion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 103, SqlFieldName = PP_ApproveOpinion ];

/// 档案备注
Property PPFileRemark As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 104, SqlFieldName = PP_FileRemark ];

/// 分中心小结
Property Brief As User.DHCDocCTDefineData [ SqlColumnNumber = 105, SqlFieldName = PP_Brief ];

Property BriefRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 106, SqlFieldName = PP_BriefRemark ];

/// 总结报告
Property Conclusion As User.DHCDocCTDefineData [ SqlColumnNumber = 107, SqlFieldName = PP_Conclusion ];

Property ConclusionRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = PP_ConclusionRemark ];

/// 关闭中心函
Property Center As User.DHCDocCTDefineData [ SqlColumnNumber = 109, SqlFieldName = PP_Center ];

Property CenterRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 110, SqlFieldName = PP_CenterRemark ];

/// 账号余额
Property AccountSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 111, SqlFieldName = PP_AccountSum ];

/// 临床试验信息登记注册编号
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 112, SqlFieldName = PP_RegNo ];

/// 余额提醒值
Property WarnSum As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 113, SqlFieldName = PP_WarnSum ];

/// 上会日期备注
Property EthicsMeetDateRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 114, SqlFieldName = PP_EthicsMeetDateRemark ];

/// 是否结束质控标识
Property EndQualityCtrlFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 115, SqlFieldName = PP_EndQualityCtrlFlag ];

/// 结束质控日期
Property EndQualityCtrlDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 116, SqlFieldName = PP_EndQualityCtrlDate ];

/// 项目质控日期
Property ProQualityCtrlDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 117, SqlFieldName = PP_ProQualityCtrlDate ];

/// 开启医嘱录入限制
Property OpenOrdEntryLimit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 118, SqlFieldName = PP_OpenOrdEntryLimit ];

/// 项目人数
Property PPNum As %String [ SqlColumnNumber = 119, SqlFieldName = PP_Num ];

/// 国际国内标识【1国内，2国际】
Property PPInterFlag As %String [ SqlColumnNumber = 120, SqlFieldName = PP_InterFlag ];

/// CRA：临床项目监察员(第三方公司派人检查) 联系电话。
Property PPCRAContactTel As %String [ SqlColumnNumber = 121, SqlFieldName = PP_CRAContactTel ];

/// CRA：临床项目监察员(第三方公司派人检查) 项目联系人
Property PPCRAContacter As %String [ SqlColumnNumber = 122, SqlFieldName = PP_CRAContacter ];

/// CRC：临床项目协调员(第三方公司常驻)联系电话
Property PPCRCContactTel As %String [ SqlColumnNumber = 123, SqlFieldName = PP_CRCContactTel ];

/// 临床项目协调员(第三方公司常驻) 项目联系人
Property PPCRCContacter As %String [ SqlColumnNumber = 124, SqlFieldName = PP_CRCContacter ];

/// 关闭中心函
Property StudyType As User.DHCDocCTDefineData [ SqlColumnNumber = 125, SqlFieldName = PP_StudyType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocPP)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PP_AccountSum">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="PP_ApplicationUnit">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PP_ApplyContact">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PP_ApplyContactTel">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PP_ApplyMatter_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PP_ApplyStage_Dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PP_ApprovalNo">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PP_ApproveOpinion">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="PP_ApproveResult">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="PP_ArchivesFilesNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PP_Brief">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="PP_BriefDate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="PP_BriefRemark">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="PP_Budget">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PP_CPRCApproveDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="PP_CPRCApproveResult">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="PP_CRAContactTel">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="PP_CRAContacter">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Data name="PP_CRCContactTel">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="PP_CRCContacter">
<Delimiter>"^"</Delimiter>
<Piece>123</Piece>
</Data>
<Data name="PP_CROCompany">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PP_CROContact">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PP_CROContactTel">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PP_CaseReportNum">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="PP_Center">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="PP_CenterDate">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="PP_CenterRemark">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="PP_CheckFreq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="PP_CheckPerson">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="PP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PP_CollectCompany">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PP_Conclusion">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="PP_ConclusionRemark">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="PP_CountUnitContact">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="PP_CountUnitContactTel">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="PP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PP_CreateDepartment_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PP_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PP_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="PP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PP_DesignCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="PP_DistributionCount">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="PP_DropCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="PP_DrugExamCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="PP_DrugExamCheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="PP_DrugExamInspectDate">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="PP_DrugExamInspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="PP_DrugExamSelectCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="PP_DrugExamSelectCheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="PP_EcResultDr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="PP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PP_EndQualityCtrlDate">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="PP_EndQualityCtrlFlag">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="PP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PP_EndUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PP_EndYear">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="PP_EthicsFilesNextState_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PP_EthicsFilesNum">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="PP_EthicsFilesOffCompany">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="PP_EthicsFilesOffDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PP_EthicsFilesOffOperator">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="PP_EthicsFilesOffStatus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="PP_EthicsFilesOffTel">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="PP_EthicsFilesState_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PP_EthicsMeetAduitDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PP_EthicsMeetDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PP_EthicsMeetDateRemark">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="PP_ExamReportNum">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PP_FileCaseNo">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="PP_FileNum">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="PP_FileRemark">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="PP_FileSubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PP_FilingDate">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="PP_Filingstatus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="PP_FilterCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="PP_FirstFormConsentDate">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="PP_FirstPatDate">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="PP_FormConsentNum">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="PP_GroupTransferUser">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="PP_ImageDataLocation">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="PP_ImageDataNum">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="PP_InGroupNum">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="PP_Indication">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PP_InterFlag">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="PP_IsHeadman_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PP_IsNeedCheck">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="PP_LastCaseDate">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="PP_LeaderCompany">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PP_LeaderCompanyPI">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PP_LocalGroupFactCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="PP_LocalGroupPlanCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="PP_Num">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="PP_OpenOrdEntryLimit">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="PP_Order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PP_OrigRecordNum">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="PP_PayAccount">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="PP_PilotCategory_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PP_PlanName">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PP_PlanNo">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PP_ProQualityCtrlDate">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="PP_ProjectFilesState_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PP_ProjectNo">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="PP_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="PP_RejectCaseNum">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="PP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PP_Result">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PP_Role">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PP_SAECaseNum">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="PP_SaveLastDate">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="PP_SignProtocolDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PP_StartUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PP_State">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PP_StudyType">
<Delimiter>"^"</Delimiter>
<Piece>124</Piece>
</Data>
<Data name="PP_SubPilotCategory_Dr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PP_SumDate">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="PP_ToalAgree">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="PP_TotalFileNum">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="PP_TotalPayment">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="PP_UserUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="PP_WarnSum">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="PP_YearCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="PP_recipient">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Global>^DHCDocPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDepartmentDr">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CreateDepartmentDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_CreateDepartment_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateUserDr">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CreateUserDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_CreateUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndDate">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PP_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndUserDr">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EndUserDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_EndUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPState">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PP_State}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartUserDr">
<Global>^DHCDocPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StartUserDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PP_StartUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
