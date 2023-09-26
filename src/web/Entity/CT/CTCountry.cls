/// 名称:地理信息-国家实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-10
Class web.Entity.CT.CTCountry Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTCountry";

Property CTCOURowId As %String;

// 代码

Property CTCOUCode As %String;

// 国家

Property CTCOUDesc As %String;

// 激活标志

Property CTCOUActive As %String;

// 开始日期

Property CTCOUDateActiveFrom As %String;

// 结束日期

Property CTCOUDateActiveTo As %String;

// 语言

Property CTCOULanguageDR As %String;

/// 英文简称 add@20220923
Property CTCOUENGShortDesc As %String;

/// 中文全称
Property CTCOUCHNFullDesc As %String;

/// 英文全称
Property CTCOUENGFullDesc As %String;

/// 罗马2字符代码
Property CTCOURomanCode2 As %String;

/// 罗马3字符代码
Property CTCOURomanCode3 As %String;

/// 系统创建日期
Property CTCOUCreateDate As %String;

/// 系统创建时间
Property CTCOUCreateTime As %String;

/// 系统创建人
Property CTCOUCreateUser As %String;

/// 系统排序号
Property CTCOUSeqNo As %String;

/// 系统最后更新日期
Property CTCOULastUpdateDate As %String;

/// 系统最后更新时间
Property CTCOULastUpdateTime As %String;

/// 系统最新更新人
Property CTCOULastUpdateUser As %String;

/// 拼音码
Property CTCOUPYCode As %String;

/// 五笔码
Property CTCOUWBCode As %String;

/// 备注
Property CTCOUMark As %String;

}
