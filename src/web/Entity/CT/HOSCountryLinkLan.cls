/// 名称:国家关联语言信息
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-10-11
Class web.Entity.CT.HOSCountryLinkLan Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.HOSCountryLinkLan";

// ID

Property ID As %String;

// 国家

Property CLLCountryCode As %String;

// 语言

Property CLLLANCode As %String;

// 是否有效

Property CLLActivity As %String;

// 是否默认

Property CLLIsDefault As %String;

// 开始日期

Property CLLStartDate As %Date;

// 结束日期

Property CLLEndDate As %Date;

// 系统创建日期

Property CLLCreateDate As %Date;

// 系统创建时间

Property CLLCreateTime As %Time;

// 系统创建人

Property CLLCreateUser As %String;

// 系统排序号

Property CLLSeqNo As %Float;

// 系统最后更新日期

Property CLLLastUpdateDate As %Date;

// 系统最后更新时间

Property CLLLastUpdateTime As %Time;

// 系统最新更新人

Property CLLLastUpdateUser As %String;

// 拼音码

Property CLLPYCode As %String;

// 五笔码

Property CLLWBCode As %String;

// 备注

Property CLLMark As %String;

}
