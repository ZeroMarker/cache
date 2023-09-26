/// Function: 岗位字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSPostDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPositionDict";

Property ID As %String;

/// 岗位代码
Property POSTCCode As %String;

/// 岗位名称
Property POSTCDesc As %String;

/// 业务域代码
Property POSTCDomainCode As %String;

/// 职位字典代码
Property POSTCPOSCCode As %String;

/// 职务字典代码
Property POSTCPROFTCode As %String;

/// 岗位中心词
Property POSTCPHWCode As %String;

/// 流程中心词
Property POSTCFHWCode As %String;

/// 岗位简称
Property POSTCShortDesc As %String;

/// 岗位类型
Property POSTCType As %String;

/// 是否有效(Y/N)
Property POSTCActivity As %String;

/// 开始日期
Property POSTCStartDate As %String;

/// 结束日期
Property POSTCEndDate As %String;

/// 系统创建日期
Property POSTCCreateDate As %String;

/// 系统创建时间
Property POSTCCreateTime As %String;

/// 系统创建人
Property POSTCCreateUser As %String;

/// 系统排序号
Property POSTCSeqNo As %String;

/// 系统最后更新日期
Property POSTCLastUpdateDate As %String;

/// 系统最后更新时间
Property POSTCLastUpdateTime As %String;

/// 系统最新更新人
Property POSTCLastUpdateUser As %String;

/// 拼音码
Property POSTCPYCode As %String;

/// 五笔码
Property POSTCWBCode As %String;

/// 备注
Property POSTCMark As %String;

}
