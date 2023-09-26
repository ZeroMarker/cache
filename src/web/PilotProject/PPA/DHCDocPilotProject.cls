Class web.PilotProject.PPA.DHCDocPilotProject Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// PP_Code
Property PPCode As %Library.String(TRUNCATE = 1);

/// PP_Desc
Property PPDesc As %Library.String(TRUNCATE = 1);

/// PP_Order
Property PPOrder As %Library.String(TRUNCATE = 1);

/// PP_Result
Property PPResult As %Library.String(TRUNCATE = 1);

/// PP_Remark
Property PPRemark As %Library.String(TRUNCATE = 1);

/// PP_StartUser_Dr
Property PPStartUserDr As %Library.String(TRUNCATE = 1);

/// PP_StartUser
Property PPStartUser As %Library.String(TRUNCATE = 1);

/// PP_CreateDepartment_Dr
Property PPCreateDepartmentDr As %Library.String(TRUNCATE = 1);

/// PP_CreateDepartment
Property PPCreateDepartment As %Library.String(TRUNCATE = 1);

/// PP_CreateUser_Dr
Property PPCreateUserDr As %Library.String(TRUNCATE = 1);

/// PP_CreateDate
Property PPCreateDate As %Library.String(TRUNCATE = 1);

/// PP_CreateTime
Property PPCreateTime As %Library.String(TRUNCATE = 1);

/// PP_StartDate
Property PPStartDate As %Library.String(TRUNCATE = 1);

/// PP_EndUser_Dr
Property PPEndUserDr As %Library.String(TRUNCATE = 1);

/// PP_EndDate
Property PPEndDate As %Library.String(TRUNCATE = 1);

/// PP_EndTime
Property PPEndTime As %Library.String(TRUNCATE = 1);

/// PP_Budget
Property PPBudget As %Library.String(TRUNCATE = 1);

/// PP_State
Property PPState As %Library.String(TRUNCATE = 1);

/// 已参与者
Property JoinedUser As %Library.String(TRUNCATE = 1);

/// 适应症
Property IndicationDr As %Library.String(TRUNCATE = 1);

Property Indication As %Library.String(TRUNCATE = 1);

/// 类别
Property PilotCategoryDr As %Library.String(TRUNCATE = 1);

Property PilotCategory As %Library.String(TRUNCATE = 1);

/// 伦理资料去向情况
Property EthicsFilesNextStateDr As %Library.String(TRUNCATE = 1);

Property EthicsFilesNextState As %Library.String(TRUNCATE = 1);

/// 伦理委员会档案情况
Property EthicsFilesStateDr As %Library.String(TRUNCATE = 1);

Property EthicsFilesState As %Library.String(TRUNCATE = 1);

/// 试验资料情况
Property ProjectFilesStateDr As %Library.String(TRUNCATE = 1);

Property ProjectFilesState As %Library.String(TRUNCATE = 1);

/// 是否是组长
Property IsHeadmanDr As %Library.String(TRUNCATE = 1);

Property IsHeadman As %Library.String(TRUNCATE = 1);

Property ApplyMatterDr As %Library.String(TRUNCATE = 1);

/// 申请事项
Property ApplyMatter As %Library.String(TRUNCATE = 1);

/// 申请期
Property ApplyStageDr As %Library.String(TRUNCATE = 1);

Property ApplyStage As %Library.String(TRUNCATE = 1);

/// 申请人
Property ApplicationUnit As %Library.String(TRUNCATE = 1);

/// 方案编号
Property PlanNo As %Library.String(TRUNCATE = 1);

/// 方案名称
Property PlanName As %Library.String(TRUNCATE = 1);

/// 批件号
Property ApprovalNo As %Library.String(TRUNCATE = 1);

/// 多研究中心状态
Property Role As %Library.String(TRUNCATE = 1);

/// 检验报告批号 
Property ExamReportNum As %Library.String(TRUNCATE = 1);

/// 资料提交日期
Property FileSubmitDate As %Library.String(TRUNCATE = 1);

/// 伦理委员会上会日期
Property EthicsMeetDate As %Library.String(TRUNCATE = 1);

/// 伦理委员会批准日期
Property EthicsMeetAduitDate As %Library.String(TRUNCATE = 1);

/// 档案文件夹编号
Property ArchivesFilesNo As %Library.String(TRUNCATE = 1);

/// 统计单位
Property CollectCompany As %Library.String(TRUNCATE = 1);

/// 伦理资料销毁(回收)日期
Property EthicsFilesOffDate As %Library.String(TRUNCATE = 1);

/// 签署协议日期
Property SignProtocolDate As %Library.String(TRUNCATE = 1);

/// 组长单位
Property LeaderCompany As %Library.String(TRUNCATE = 1);

/// 组长单位PI
Property LeaderCompanyPI As %Library.String(TRUNCATE = 1);

/// CRO公司
Property CROCompany As %Library.String(TRUNCATE = 1);

/// 亚类别
Property SubPilotCategoryDr As %Library.String(TRUNCATE = 1);

/// 亚类别
Property SubPilotCategory As %Library.String(TRUNCATE = 1);

/// 申办者联系人
Property ApplyContact As %Library.String(TRUNCATE = 1);

/// 申办者联系人电话
Property ApplyContactTel As %Library.String(TRUNCATE = 1);

/// CRO联系人
Property CROContact As %Library.String(TRUNCATE = 1);

/// CRO联系人电话
Property CROContactTel As %Library.String(TRUNCATE = 1);

/// 预审结果
Property ApproveResult As %Library.String(TRUNCATE = 1);

/// 伦理委员会审查结果 
Property EcResultDr As %Library.String(TRUNCATE = 1);

/// CPRC审查意见
Property CPRCApproveResult As %Library.String(TRUNCATE = 1);

/// CPRC审查日期
Property CPRCApproveDate As %Library.String(TRUNCATE = 1);

/// 汇款账号
Property PayAccount As %Library.String(TRUNCATE = 1);

/// 完成年度
Property EndYear As %Library.String(TRUNCATE = 1);

/// 科室编号
Property DeptCode As %Library.String(TRUNCATE = 1);

/// 项目编号
Property ProjectNo As %Library.String(TRUNCATE = 1);

/// 档案柜编号
Property FileCaseNo As %Library.String(TRUNCATE = 1);

/// 统计单位联系人
Property CountUnitContact As %Library.String(TRUNCATE = 1);

/// 统计单位联系人电话
Property CountUnitContactTel As %Library.String(TRUNCATE = 1);

/// 试验设计总例数
Property DesignCaseNum As %Library.String(TRUNCATE = 1);

/// 本专业组拟承担例数
Property LocalGroupPlanCaseNum As %Library.String(TRUNCATE = 1);

/// 本专业组实际完成例数
Property LocalGroupFactCaseNum As %Library.String(TRUNCATE = 1);

/// 最后一例出组日期
Property LastCaseDate As %Library.String(TRUNCATE = 1);

/// 筛选例数
Property FilterCaseNum As %Library.String(TRUNCATE = 1);

/// 剔除例数
Property RejectCaseNum As %Library.String(TRUNCATE = 1);

/// 脱落例数
Property DropCaseNum As %Library.String(TRUNCATE = 1);

/// SAE例数
Property SAECaseNum As %Library.String(TRUNCATE = 1);

/// 小结日期
Property BriefDate As %Library.String(TRUNCATE = 1);

/// 关中心日期
Property CenterDate As %Library.String(TRUNCATE = 1);

/// 总结日期
Property SumDate As %Library.String(TRUNCATE = 1);

/// 归档情况
Property Filingstatus As %Library.String(TRUNCATE = 1);

Property FilingstatusDr As %Library.String(TRUNCATE = 1);

/// 归档日期
Property FilingDate As %Library.String(TRUNCATE = 1);

/// 保存至
Property SaveLastDate As %Library.String(TRUNCATE = 1);

/// 专业组移交人
Property GroupTransferUser As %Library.String(TRUNCATE = 1);

/// 案卷接收人
Property recipient As %Library.String(TRUNCATE = 1);

/// 档案销毁状态
Property EthicsFilesOffStatus As %Library.String(TRUNCATE = 1);

Property EthicsFilesOffStatusDr As %Library.String(TRUNCATE = 1);

/// 销毁经办人姓名
Property EthicsFilesOffOperator As %Library.String(TRUNCATE = 1);

/// 经办人单位
Property EthicsFilesOffCompany As %Library.String(TRUNCATE = 1);

/// 经办人联系电话
Property EthicsFilesOffTel As %Library.String(TRUNCATE = 1);

/// 影像资料位置
Property ImageDataLocation As %Library.String(TRUNCATE = 1);

/// 影像资料份数
Property ImageDataNum As %Library.String(TRUNCATE = 1);

/// 文件夹数目
Property FileNum As %Library.String(TRUNCATE = 1);

/// 知情同意书数目
Property FormConsentNum As %Library.String(TRUNCATE = 1);

/// 病例报告表数目
Property CaseReportNum As %Library.String(TRUNCATE = 1);

/// 伦理资料数目
Property EthicsFilesNum As %Library.String(TRUNCATE = 1);

/// 原始记录数目
Property OrigRecordNum As %Library.String(TRUNCATE = 1);

/// 总份数
Property TotalFileNum As %Library.String(TRUNCATE = 1);

/// 其他科室
Property OtherDepStr As %Library.String(TRUNCATE = 1);

/// 其他科室
Property OtherDepartment As %Library.String(TRUNCATE = 1);

Property PPFileRemark As %Library.String(TRUNCATE = 1);

Property FirstPatDate As %Library.String(TRUNCATE = 1);

/// 分中心小结
Property Brief As %Library.String(TRUNCATE = 1);

Property BriefDr As %Library.String(TRUNCATE = 1);

Property BriefRemark As %Library.String(TRUNCATE = 1);

/// 总结报告
Property Conclusion As %Library.String(TRUNCATE = 1);

Property ConclusionDr As %Library.String(TRUNCATE = 1);

Property ConclusionRemark As %Library.String(TRUNCATE = 1);

/// 关闭中心函
Property Center As %Library.String(TRUNCATE = 1);

Property CenterDr As %Library.String(TRUNCATE = 1);

Property CenterRemark As %Library.String(TRUNCATE = 1);

Property RegNo As %Library.String(TRUNCATE = 1);

Property EndQualityCtrlFlag As %Library.String(TRUNCATE = 1);

Property EndQualityCtrlDate As %Library.String(TRUNCATE = 1);

Property OpenOrdEntryLimit As %Library.String(TRUNCATE = 1);

Property PPNum As %Library.String(TRUNCATE = 1);

Property PPInterFlag As %Library.String(TRUNCATE = 1);

Property StudyType As %Library.String(TRUNCATE = 1);

}
