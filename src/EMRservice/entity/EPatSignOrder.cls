/// 名称:EMRservice.entity.EPatSignOrder
/// 描述:患者签名排序表
/// 编写者：yejian
/// 编写日期: 2021-11-3
Class EMRservice.entity.EPatSignOrder Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String;

/// 模板版本
Property VersionNum As %String;

/// 签名数据[{"displayName":"患者","path":"S007_V006_L0011"},{"displayName":"委托人签名","path": "S007_V006_L0012","keyWordType":"同意"}]
Property SignData As %String(MAXLEN = 10000, TRUNCATE = 1);

}
