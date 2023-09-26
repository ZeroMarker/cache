Class web.Entity.MKB.MKBICDContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

/// Description：结构化数据Entity
/// Creator：石萧伟
/// Date： 2018-11-27
Parameter PersistentClassName = "web.Entity.MKB.MKBICDContrast";

/// ICD code
Property MKBICDConCode As %String;

/// ICD描述
Property MKBICDConDesc As %String;

/// ICD主要编码
Property MKBICDConNumber As %String;

/// ICD扩展编码
Property MKBICDConExtendNumber As %String;

/// ICD来源标识
Property MKBICDDiaSource As %String;

/// ICD类别
Property MKBICDConType As %String;

/// ICD录入选项
Property MKBICDConOption As %String;

/// 匹配到的参考中心词
Property MKBICDConCenterWordID As %String;

/// 指向Term表
Property MKBICDTermDr As %String;

/// 国际码标记
Property MKBICDRemark As %String;

/// 分词结果
Property MKBICDConSegmentation As %String;

/// 数据处理状态
Property MKBICDConStatus As %String;

/// 操作时间
Property MKBICDConDate As %String;

/// 操作人(从Session中取)
Property MKBICDConUpdateUser As %String;

/// 备用
Property MKBICDOther As %String;

/// 初始icd
Property MKBICDInitialICD As %String;

/// 诊断1 2 3之间的关系 AND OR
Property MKBICDResultRelation As %String;

}
