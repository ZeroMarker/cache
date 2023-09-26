/// 名称: 教育水平
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTEducation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTEducation";

/// RowId
Property EDURowId As %String;

/// 代码
Property EDUCode As %String;

/// 描述
Property EDUDesc As %String;

/// 学历层级
Property EDUClass As %String;

/// 状态
Property EDUStatus As %String;

/// 是否有效(Y/N)
Property EDUActivity As %String;

/// 开始日期
Property EDUStartDate As %String;

/// 结束日期
Property EDUEndDate As %String;

/// 系统创建日期
Property EDUCreateDate As %String;

/// 系统创建时间
Property EDUCreateTime As %String;

/// 系统创建人
Property EDUCreateUser As %String;

/// 系统排序号
Property EDUSeqNo As %String;

/// 系统最后更新日期
Property EDULastUpdateDate As %String;

/// 系统最后更新时间
Property EDULastUpdateTime As %String;

/// 系统最新更新人
Property EDULastUpdateUser As %String;

/// 拼音码
Property EDUPYCode As %String;

/// 五笔码
Property EDUWBCode As %String;

/// 备注
Property EDUMark As %String;

}
