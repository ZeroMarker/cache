/// 名称: 婚姻状况维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTMarital Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTMarital";

/// RowId号
Property CTMARRowId As %String;

/// 代码
Property CTMARCode As %String;

/// 描述
Property CTMARDesc As %String;

/// 开始日期
Property CTMARDateFrom As %String;

/// 结束日期
Property CTMARDateTo As %String;

/// 是否有效(Y/N)
Property CTMARActivity As %String;

/// 系统创建日期
Property CTMARCreateDate As %String;

/// 系统创建时间
Property CTMARCreateTime As %String;

/// 系统创建人
Property CTMARCreateUser As %String;

/// 系统排序号
Property CTMARSeqNo As %String;

/// 系统最后更新日期
Property CTMARLastUpdateDate As %String;

/// 系统最后更新时间
Property CTMARLastUpdateTime As %String;

/// 系统最新更新人
Property CTMARLastUpdateUser As %String;

/// 拼音码
Property CTMARPYCode As %String;

/// 五笔码
Property CTMARWBCode As %String;

/// 备注
Property CTMARMark As %String;

}
