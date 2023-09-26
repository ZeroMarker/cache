/// 名称:手术和过程-手术/过程扩展表实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-7-8
Class web.Entity.CT.ORCOperationExtend Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperationExtend";

// RowId

Property OPERERowId As %String;

/// 手术分级表Id：ORC_OperationCategory
Property OPERClassDr As %String;

/// 手术切口类型Id：ORC_BladeType
Property OPERBladeDr As %String;

/// 手术部位表Id：OEC_BodySite
Property OPERBodySiteDr As %String;

/// 手术体位Id：ORC_OperPosition
Property OPEROperPositionDr As %String;

/// 手术清洁类型Id（未用）
Property OPERMRBladeDr As %String;

/// 手术医生科室Id(|分割)
Property OPERSurgeonDeptDr As %String;

/// 手术医生描述(,分割)
Property OPERSurgeonDeptDrDesc As %String;

/// 是否重点手术
Property OPERIsKeyOperation As %String;

/// 器械护士分级
Property OPERScrubNurseClass As %String;

/// 巡回护士分级
Property OPERCirculNurseClass As %String;

/// 默认手术室Id
Property OPERDefaultOperLocDr As %String;

/// 手术操作类别（N常规，D诊断性操作，T治疗性操作）
Property OPERType As %String;

/// 登记类型（标本登记本，特殊病人登记本，手术登记本、结扎手术登记本）
Property OPERRegType As %String;

/// 码表修改用户
Property OPERUpdateUserDr As %String;

/// 码表更新日期
Property OPERUpdateDate As %String;

/// 码表更新时间
Property OPERUpdateTime As %String;

/// 手术分类指针
Property OPERCategoryDr As %String;

/// 是否有上传编码
Property OPERIsUploadCode As %String;

/// 使用技术（普通，介入，内镜，腹镜）
Property OPERTechnique As %String;

/// 医疗技术级别要求
Property OPERMedicalTechniqueLevel As %String;

/// 是否特殊手术
Property OPERIsSpecial As %String;

/// 是否高风险技术
Property OPERIsHighRisk As %String;

/// 是否审批技术
Property OPERIsAudit As %String;

/// 是否有PACS影像
Property OPERIsPacs As %String;

/// 医院Id(|分割)
Property OPERHospitalDr As %String;

/// 医院描述(,分割)
Property OPERHospitalDrDesc As %String;

/// 手术缩写名
Property OPERAbbreviation As %String;

/// 是否供应商备货 
Property OPERIsSupplierPreparation As %String;

/// 是否使用预防性抗菌药物
Property OPERIsProtectiveAntibacterial As %String;

/// 手术应用特性：R必选，C中医必选，O选择性
Property OPERApplyFeature As %String;

/// 是否微创手术 2020-03-02
Property OPERIsMinInvasive As %String;

/// 是否子手术
Property OPERIsSubOperation As %String;

/// 是否限制类技术
Property OPERIsRestrictedTechnology As %String;

/// 是否新项目新技术
Property OPERIsNewItem As %String;

}
