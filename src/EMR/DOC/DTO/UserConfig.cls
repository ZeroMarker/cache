/// 名称:	EMR.DOC.DTO.UserConfig
/// 描述:	用户个性配置对象
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.UserConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property LocID As %String(TRUNCATE = 1);

/// 个性配置值
Property Config As %String(TRUNCATE = 1);

/// 配置类型
Property Type As %String(TRUNCATE = 1);

}
