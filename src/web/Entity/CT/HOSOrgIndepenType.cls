/// 描述:组织机构专业分类
/// 创建人：基础数据平台 zrf 
/// 创建日期：2022-09-21
Class web.Entity.CT.HOSOrgIndepenType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgIndepenType";

Property ID As %String;

/// 组织机构自主属性代码
Property ORGITCode As %String;

/// 组织机构自主属性名称
Property ORGITDesc As %String;

/// 是否有效(Y/N)
Property ORGITActivity As %String;

/// 开始日期
Property ORGITStartDate As %String;

/// 结束日期
Property ORGITEndDate As %String;

/// 系统创建日期
Property ORGITCreateDate As %String;

/// 系统创建时间
Property ORGITCreateTime As %String;

/// 系统创建人
Property ORGITCreateUser As %String;

/// 系统排序号
Property ORGITSeqNo As %String;

/// 系统最后更新日期
Property ORGITLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGITLastUpdateTime As %String;

/// 系统最新更新人
Property ORGITLastUpdateUser As %String;

/// 拼音码
Property ORGITPYCode As %String;

/// 五笔码
Property ORGITWBCode As %String;

/// 备注
Property ORGITMark As %String;

}
