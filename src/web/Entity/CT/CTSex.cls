/// 名称: 性别维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-29
Class web.Entity.CT.CTSex Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTSex";

/// RowId
Property CTSEXRowId As %String;

/// 代码
Property CTSEXCode As %String;

/// 描述
Property CTSEXDesc As %String;

/// 开始日期
Property CTSEXDateFrom As %String;

/// 结束日期
Property CTSEXDateTo As %String;

/// 是否有效(Y/N)add@20220923
Property CTSEXActivity As %String;

/// 系统创建日期
Property CTSEXCreateDate As %String;

/// 系统创建时间
Property CTSEXCreateTime As %String;

/// 系统创建人
Property CTSEXCreateUser As %String;

/// 系统排序号
Property CTSEXSeqNo As %String;

/// 系统最后更新日期
Property CTSEXLastUpdateDate As %String;

/// 系统最后更新时间
Property CTSEXLastUpdateTime As %String;

/// 系统最新更新人
Property CTSEXLastUpdateUser As %String;

/// 拼音码
Property CTSEXPYCode As %String;

/// 五笔码
Property CTSEXWBCode As %String;

/// 备注
Property CTSEXMark As %String;

}
