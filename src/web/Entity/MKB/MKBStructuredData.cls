Class web.Entity.MKB.MKBStructuredData Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

/// Description：结构化数据Entity
/// Creator：李得原
/// Date： 2018-11-27
Parameter PersistentClassName = "web.Entity.MKB.MKBStructuredData";

/// 
/// 诊断名
Property MKBSDDiag As %String;

/// 科室名
Property MKBSDLoc As %String;

/// 诊断出现频次
Property MKBSDFrequency As %String;

/// 数据处理状态
Property MKBSDStatus As %String;

/// 参考中心词
Property MKBSDCenterWordID As %String;

/// 操作时间
Property MKBSDDate As %String;

/// 操作人(从Session中取)
Property MKBSDUpdateUser As %String;

/// rowid
Property MKBSDRowid As %String;

/// 分词结果
Property MKBSDSegmentation As %String;

/// 诊断来源
Property MKBSDDiaSource As %String;

/// MRCDr
Property MKBSDICDTermDr As %String;

/// ICD编码
Property MKBSDICD As %String;

/// ICD中文描述
Property MKBSDICDDesc As %String;

/// 总频次
Property MKBSDTotalFreq As %String;

/// 结构化标记
Property MKBSDChildStructFlag As %String;

/// 合并标记
Property MKBSDMergeFlag As %String;

/// 备注
Property MKBSDNote As %String;

/// 上报理由
Property MKBSDReson As %String;

/// 最优ICD
Property MKBSDInitialICD As %String;

/// 诊断名拼音码
Property MKBSDDiagPYCode As %String;

/// 工厂指向
Property MKBSDBaseDr As %String;

/// 诊断1 2 3之间的关系 AND OR
Property MKBSDResultRelation As %String;

/// 中医诊断
Property MKBSDTCMDiagFlag As %String;

/// 中医证型
Property MKBSDTCMSynFlag As %String;

/// 肿瘤形态学编码
Property MKBSDTumourFlag As %String;

/// 损伤中毒外部原因
Property MKBSDInjuryFlag As %String;

/// 开始日期
Property MKBSDDateActiveFrom As %String;

/// 截止日期
Property MKBSDDateActiveTo As %String;

/// his诊断ID 2021-06-15 -》MKBSDHisRowID
Property MKBSDHisRowID As %String;

/// HIS诊断代码 2021-06-15 -》MKBSDHisCode
Property MKBSDHisCode As %String;

/// 副编码 2021-06-15 -》MKBSDDeputyCode
Property MKBSDDeputyCode As %String;

/// 就诊类型 2021-06-15 -》MKBSDClinicType	（门诊O。急诊E。住院I。体检H。新生儿N）
Property MKBSDClinicType As %String;

/// icd诊断分类 2021-06-15 -》MKBSDClassification	
Property MKBSDClassification As %String;

/// 限制性别 2021-06-15 -》MKBSDLimitSex
Property MKBSDLimitSex As %String;

/// 注释2021-06-15 -》MKBSDHisRemark
Property MKBSDHisRemark As %String;

/// 从年龄 2021-06-15 -》MKBSDAgeFrom
Property MKBSDAgeFrom As %String;

/// 到年龄 2021-06-15 -》MKBSDAgeTo
Property MKBSDAgeTo As %String;

/// icd9代码 2021-06-15 -》MKBSDICDCode9
Property MKBSDICD9Code As %String;

/// 国家标准名称 2021-06-15 -》MKBSDNationalDesc
Property MKBSDNationalDesc As %String;

/// 是否能匹配全局化词表标志 2021-08-6   钟荣枫
Property MKBSDMatchGlobalFlag As %String;

}
