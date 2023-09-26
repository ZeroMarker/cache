/// 名称:组织职务
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-16
Class web.Entity.CT.HOSProfTitle Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfTitle";

/// RowId
Property ID As %String;

/// 职务代码
Property PROFTCode As %String;

/// 职务名称
Property PROFTDesc As %String;

/// 所属部门
Property PROFTDeptCode As %String;

/// 职务字典编码
Property PROFTPROFTCCode As %String;

/// 额定人数
Property PROFTLimitedNum As %String;

/// 是否有效(Y/N)
Property PROFTActivity As %String;

/// 开始日期
Property PROFTStartDate As %String;

/// 结束日期
Property PROFTEndDate As %String;

/// 系统创建日期
Property PROFTCreateDate As %String;

/// 系统创建时间
Property PROFTCreateTime As %String;

/// 系统创建人
Property PROFTCreateUser As %String;

/// 系统排序号
Property PROFTSeqNo As %String;

/// 系统最后更新日期
Property PROFTLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFTLastUpdateTime As %String;

/// 系统最新更新人
Property PROFTLastUpdateUser As %String;

/// 拼音码
Property PROFTPYCode As %String;

/// 五笔码
Property PROFTWBCode As %String;

/// 备注
Property PROFTMark As %String;

}
