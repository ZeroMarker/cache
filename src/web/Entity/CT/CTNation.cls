/// 名称: 民族
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTNation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTNation";

/// RowId
Property CTNATRowId As %String;

/// 代码
Property CTNATCode As %String;

/// 描述
Property CTNATDesc As %String;

/// 民族罗马代码
Property CTNATRomanCode As %String;

/// 民族罗马名称
Property CTNATRomanDesc As %String;

/// 民族外国名称
Property CTNATForeignDesc As %String;

/// 是否有效(Y/N)
Property CTNATActivity As %String;

/// 开始日期
Property CTNATStartDate As %String;

/// 结束日期
Property CTNATEndDate As %String;

/// 系统创建日期
Property CTNATCreateDate As %String;

/// 系统创建时间
Property CTNATCreateTime As %String;

/// 系统创建人
Property CTNATCreateUser As %String;

/// 系统排序号
Property CTNATSeqNo As %String;

/// 系统最后更新日期
Property CTNATLastUpdateDate As %String;

/// 系统最后更新时间
Property CTNATLastUpdateTime As %String;

/// 系统最新更新人
Property CTNATLastUpdateUser As %String;

/// 拼音码
Property CTNATPYCode As %String;

/// 五笔码
Property CTNATWBCode As %String;

/// 备注
Property CTNATMark As %String;

}
