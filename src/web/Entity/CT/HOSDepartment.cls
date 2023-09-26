/// Function: HOS 组织部门
/// CreateDate:2023-2-2
/// Creator:钟荣枫
Class web.Entity.CT.HOSDepartment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSDepartment";

Property ID As %String;

/// 部门代码
Property DEPTCode As %String;

/// 部门名称
Property DEPTDesc As %String;

/// 部门简称
Property DEPTAbbrev As %String;

/// 部门简介
Property DEPTIntro As %String;

/// 上级部门
Property DEPTDeptCode As %String;

/// 所属机构
Property DEPTORGCode As %String;

/// 行政类型
Property DEPTORGACCode As %String;

/// 部门地址（位置）
Property DEPTAddress As %String;

/// 联系电话	
Property DEPTTel As %String;

/// 传真
Property DEPTFax As %String;

/// 邮件
Property DEPTEmail As %String;

/// 建立日期
Property DEPTFoundDate As %String;

/// 注销日期
Property DEPTCancelDate As %String;

/// 是否有效(Y/N)
Property DEPTActivity As %String;

/// 开始日期
Property DEPTStartDate As %String;

/// 结束日期
Property DEPTEndDate As %String;

/// 系统创建日期
Property DEPTCreateDate As %String;

/// 系统创建时间
Property DEPTCreateTime As %String;

/// 系统创建人
Property DEPTCreateUser As %String;

/// 系统排序号
Property DEPTSeqNo As %String;

/// 系统最后更新日期
Property DEPTLastUpdateDate As %String;

/// 系统最后更新时间
Property DEPTLastUpdateTime As %String;

/// 系统最新更新人
Property DEPTLastUpdateUser As %String;

/// 拼音码
Property DEPTPYCode As %String;

/// 五笔码
Property DEPTWBCode As %String;

/// 备注
Property DEPTMark As %String;

}
