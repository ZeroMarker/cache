/// 名称: 数据统计配置
/// 描述: 数据统计配置
/// 编写者：石萧伟
/// 编写日期: 2022-01-19
Class web.CDSSEntity.Config.StatisticsConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Config.StatisticsConfig";

Property ID As %String;

/// 配置代码(后台自动生成)
Property SCCode As %String;

/// 配置名称
Property SCDesc As %String;

/// 父节点
Property SCParentDr As %String;

/// 统计接口
Property SCInfo As %String;

/// 是否在首页展示
Property SCHomeFlag As %String;

/// 展示名
Property SCShowName As %String;

/// 是否激活（只有激活后才参与展示和计算）
Property SCActiveFlag As %String;

/// 备注
Property SCRemark As %String;

/// 别名接口
Property AliasInfo As %String;

}
