/// 名称: 就诊子类型维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.PACEpisodeSubType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACEpisodeSubType";

/// RowId号
Property SUBTRowId As %String;

/// 代码
Property SUBTCode As %String;

/// 描述
Property SUBTDesc As %String;

/// 就诊类型
Property SUBTAdmType As %String;

/// 开始日期
Property SUBTDateFrom As %String;

/// 结束日期
Property SUBTDateTo As %String;

/// SUBTDaySurgery 
Property SUBTDaySurgery As %String;

/// / SUBTFirstRegDayNight
Property SUBTFirstRegDayNight As %String;

}
