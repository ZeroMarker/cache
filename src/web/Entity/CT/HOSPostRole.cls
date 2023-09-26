/// Function: HOS 岗位角色字典=岗位关联角色
/// CreateDate:2022-11-16
/// Creator:gaoshanshan
Class web.Entity.CT.HOSPostRole Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPostRole";

Property ID As %String;

/// 岗位代码-外键
Property POROPOSTCode As %String;

/// 角色代码-外键=安全组
Property POROROLECode As %String;

/// 是否有效(Y/N)
Property POROActivity As %String;

/// 开始日期
Property POROStartDate As %String;

/// 结束日期
Property POROEndDate As %String;

/// 系统创建日期
Property POROCreateDate As %String;

/// 系统创建时间
Property POROCreateTime As %String;

/// 系统创建人
Property POROCreateUser As %String;

/// 系统排序号
Property POROSeqNo As %String;

/// 系统最后更新日期
Property POROLastUpdateDate As %String;

/// 系统最后更新时间
Property POROLastUpdateTime As %String;

/// 系统最新更新人
Property POROLastUpdateUser As %String;

/// 拼音码
Property POROPYCode As %String;

/// 五笔码
Property POROWBCode As %String;

/// 备注
Property POROMark As %String;

}
