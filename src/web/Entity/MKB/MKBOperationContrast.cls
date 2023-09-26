Class web.Entity.MKB.MKBOperationContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

/// Description：手术对照结构化数据Entity
/// Creator：张云越
/// Date： 2019-10-24
Parameter PersistentClassName = "web.Entity.MKB.MKBOperationContrast";

/// 手术 code
Property MKBOperationConCode As %String;

/// 手术描述
Property MKBOperationConDesc As %String;

/// 手术主要编码
Property MKBOperationConNumber As %String;

/// 手术扩展编码
Property MKBOperationConExtendNumber As %String;

/// 手术来源标识
Property MKBOperationDiaSource As %String;

/// 手术类别
Property MKBOperationConType As %String;

/// 手术录入选项
Property MKBOperationConOption As %String;

/// 匹配到的参考中心词
Property MKBOperationConCenterWordID As %String;

/// 指向Term表
Property MKBOperationTermDr As %String;

/// 国际码标记
Property MKBOperationRemark As %String;

/// 分词结果
Property MKBOperationConSegmentation As %String;

/// 数据处理状态
Property MKBOperationConStatus As %String;

/// 操作时间
Property MKBOperationConDate As %String;

/// 操作人(从Session中取)
Property MKBOperationConUpdateUser As %String;

/// 备用
Property MKBOperationOther As %String;

/// 初始编码
Property MKBOperationInitialICD As %String;

/// 诊断1 2 3之间的关系 AND OR
Property MKBOperationResultRelation As %String;

}
