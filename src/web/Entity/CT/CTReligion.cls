/// 名称: 宗教维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2013-7-1
Class web.Entity.CT.CTReligion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTReligion";

/// RowId号
Property CTRLGRowId As %String;

/// 代码
Property CTRLGCode As %String;

/// 描述
Property CTRLGDesc As %String;

/// 开始日期
Property CTRLGDateFrom As %String;

/// 结束日期
Property CTRLGDateTo As %String;

/// 是否有效(Y/N)
Property CTRLGActivity As %String;

/// 系统创建日期
Property CTRLGCreateDate As %String;

/// 系统创建时间
Property CTRLGCreateTime As %String;

/// 系统创建人
Property CTRLGCreateUser As %String;

/// 系统排序号
Property CTRLGSeqNo As %String;

/// 系统最后更新日期
Property CTRLGLastUpdateDate As %String;

/// 系统最后更新时间
Property CTRLGLastUpdateTime As %String;

/// 系统最新更新人
Property CTRLGLastUpdateUser As %String;

/// 拼音码
Property CTRLGPYCode As %String;

/// 五笔码
Property CTRLGWBCode As %String;

/// 备注
Property CTRLGMark As %String;

}
