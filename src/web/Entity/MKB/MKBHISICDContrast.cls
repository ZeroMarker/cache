Class web.Entity.MKB.MKBHISICDContrast Extends %RegisteredObject
{

/// Description：hisicd数据Entity
/// Creator：石萧伟
/// Date： 2019-03-01
Parameter PersistentClassName = "web.Entity.MKB.MKBHISICDContrast";

/// HISICD DR
Property MKBHISICDDr As %String;

/// ICD
Property MKBHISICD As %String;

/// ICD中文描述
Property MKBHISICDDesc As %String;

/// 数据处理状态
Property MKBHISICDConStatus As %String;

/// 指向Term表
Property MKBHISICDTermDr As %String;

/// 国际码标记
Property MKBHISICDRemark As %String;

/// 分词结果
Property MKBHISICDConSegmentation As %String;

/// 参考中心词
Property MKBHISICDConCenterWordID As %String;

/// 操作时间
Property MKBHISICDConDate As %String;

/// 操作人(从Session中取)
Property MKBHISICDConUpdateUser As %String;

/// 初始icd
Property MKBHISICDInitialICD As %String;

}
